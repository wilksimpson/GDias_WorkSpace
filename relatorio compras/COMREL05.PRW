#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMREL05 º Autor ³ Aguiar             º Data ³  01/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de tempo de vida de um pedido de compra. De com- º±±
±±º          ³pras até o financeiro                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   /  /   ³                                                            º±±
±±º          ³                                                            º±±
±±º**********³************************************************************º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COMREL05
**********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local titulo         := "Follow Up de Compras"
/*
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "A situação dos pedidos e compras"
Local cPict          := ""
Private nLastKey     := 0
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "COMREL05" 
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}

Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMREL05" // Coloque aqui o nome do arquivo usado para impressao em disco
*/
Private cPerg        := "COMREL05"+Space(2)
Private cString      := ""

dbSelectArea("SC7")
dbSetOrder(1)

VerSX1(cPerg) 
                      
If !Pergunte(cPerg,.t.)

	Return
Endif

If Select("QrySC7") > 0  

   QrySC7->(DbCloseArea()) 
Endif


cQuery := " "                                     
cQuery += " SELECT C7_FILIAL, C7_NUM, C7_EMISSAO, C7_INCUSUA, C7_COND, SUM(C7_TOTAL)"
cQuery += " FROM "+RetSqlName('SC7') + ' SC7 '
cQuery += " WHERE D_E_L_E_T_ =' '"  
cQuery += "   AND C7_FILIAL   BETWEEN '"+MV_PAR03+"' AND '" + MV_PAR04 + "'"   
cQuery += "   AND C7_EMISSAO  BETWEEN '"+Dtos(MV_PAR01)+"' AND '" + DTOS(MV_PAR02) + "'"   
cQuery += " GROUP BY C7_FILIAL, C7_NUM, C7_EMISSAO, C7_INCUSUA, C7_COND"
cQuery += " ORDER BY C7_FILIAL, C7_NUM, C7_EMISSAO, C7_INCUSUA, C7_COND"
dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),'QrySC7',.F.,.T.) 

Memowrite ("c:\spool\comrel05.txt" ,cQuery )
    
Titulo := Alltrim(Titulo) + " Data de Criação "+Dtoc(MV_PAR01)+" a "+ Dtoc(MV_PAR02)

Processa( {|| RunProc(Titulo) } )

QrySC7->(DbCloseArea()) 
   
Return


Static Function RunProc(cTitulo)
*********************************
Local cQuery := ''
Local cArq   := 'COMREL05' 
Local cLib   := ''   
Local dLib   := ''
Local cNum   := ''
Local dFin   := Ctod('  /  /  ')
Local aExcel := {}


cAux := AllTrim(cGetFile('CSV (*.csv)|*.csv', 'Selecione o diretório onde será salvo o relatório', 1, 'C:\', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE, GETF_RETDIRECTORY ), .F., .T.))
If cAux <> '' 
	cAux := SubStr(cAux, 1, RAt('\', cAux)) + cArq
	cAux := cAux + '-' + DTOS(Date()) + '-' + StrTran(Time(), ':', '') + '.csv'
Endif

cArq := cAux


aAdd(aExcel, {cTitulo})
aAdd(aExcel, {' Programa: COMREL05 Relatório emitido em '+DTOC(Date())+' por '+AllTrim(cUsername) })
aAdd(aExcel, {'Período: '+DTOC(MV_PAR01)+' até '+DTOC(MV_PAR02)})    
aAdd(aExcel, {'Filial de: '+MV_PAR03+' até '+MV_PAR04})
//aAdd(aExcel, {'Notas de: Entrada'})

aAdd(aExcel, {''})  

aAdd(aExcel,{'Filial','Num Pedido','Data Criação','Usuário','Cond Pgto','Fornecedor','Aprovador','Dta Aprovação','Data Ent NF','Data Lib Financeiro',;
	'Liberado por','Data Emissão','Documento','Vencimento Real','Valor Real','Descrição','Data Baixa'} )

DbSelectArea("QrySC7")
DbGotop()

Do While !EOF()  

   cLib   := ''   
   dLib   := '' 
   cNum   := ''
   dFin   := ''

   LJMSGRUN('Verificando Ligações do Pedido '+QrySC7->C7_NUM )

   //Ver Liverações do PC

   If Select("QryScr") > 0  

   	  QryScr->(DbCloseArea()) 
   Endif

   cQuery := " "                                     
   cQuery += " SELECT CR_FILIAL, CR_USERLIB, CR_DATALIB,CR_NIVEL"
   cQuery += " FROM "+RetSqlName('SCR') + ' SCR '
   cQuery += " WHERE  SCR.CR_FILIAL  = '" + QrySC7->C7_FILIAL +"'"  
   cQuery += "   AND SCR.D_E_L_E_T_ = ' ' " 
   cQuery += "   AND SCR.CR_NUM = '" + QrySC7->C7_NUM +"'"           
   //cQuery += "   AND (SCR.CR_NIVEL = '01' OR SCR.CR_NIVEL = '02' OR SCR.CR_NIVEL = '03')"
   cQuery += "   AND SCR.CR_STATUS = '03'"
   cQuery += "   ORDER BY CR_NIVEL"    
	
   DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"QryScr",.F.,.T.)  
  
   DbSelectArea('QryScr')
   DbGotop()

   If !Eof()
       
      Do While !eof()
        
         cLib := cLib + ' '+ Posicione('SAK',2,QryScr->CR_FILIAL+QryScr->CR_USERLIB,'AK_NOME')     
         
         //dLib := dLib + ' '+ Dtoc(Stod(QryScr->CR_DATALIB))
         dLib := Stod(QryScr->CR_DATALIB)
           
         DbSkip()   
      Enddo
   Endif  
   
   QryScr->(DbCloseArea()) 

   //Pegar o Numero da NF
   
   DbSelectArea('SD1')
   //DbSetOrder(18)  
   DbOrderNickName('SD1PED')
   DbGotop()
   
   If DbSeek(QrySC7->C7_FILIAL+QrySC7->C7_NUM)
   
      cNum := SD1->D1_SERIE+SD1->D1_DOC
      
      dFin := SD1->D1_DTDIGIT
      
      
      // Pegar dados do Financeiro
      
      DbSelectArea('SE2')
      DbSetOrder(6)
      DbGotop()

      _cFornS:= SE2->E2_FORNECE+"-"+SE2->E2_NOMFOR
      _cFornC:=Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"SA2->A2_NREDUZ")     
      
      If DbSeek(QrySC7->C7_FILIAL+SD1->D1_FORNECE+SD1->D1_LOJA+cNum)
      
         aAdd(aExcel, {;     
              QrySC7->C7_FILIAL,QrySC7->C7_NUM,Stod(QrySC7->C7_EMISSAO),QrySC7->C7_INCUSUA,QrySC7->C7_COND,_cFornC,cLib,dLib,dFin, ;
              SE2->E2_DATALIB,SE2->E2_USUALIB,SE2->E2_EMISSAO,cNum,SE2->E2_VENCREA, SE2->E2_VALOR, SE2->E2_HIST, SE2->E2_BAIXA; 
          })  
        
      Else
      
         aAdd(aExcel, {;     
              QrySC7->C7_FILIAL,QrySC7->C7_NUM,Stod(QrySC7->C7_EMISSAO),QrySC7->C7_INCUSUA,QrySC7->C7_COND,_cFornC,cLib,dLib,dFin,'','','','','','','' ;
          })  
      Endif  
   Else
       
      aAdd(aExcel, {;     
           QrySC7->C7_FILIAL,QrySC7->C7_NUM,Stod(QrySC7->C7_EMISSAO),QrySC7->C7_INCUSUA,QrySC7->C7_COND,_cFornC,'','','','','','','','','','','' ;
          })
   Endif            
   
   DbSelectArea("QrySC7")
   
   DbSkip() // Avanca o ponteiro do registro no arquivo
Enddo      

If Len(aExcel) >= 2   

	cRet := U_MyArrCsv(aExcel, cArq, Nil, cTitulo)  

	If !Empty(cRet)
		
		Alert(cRet)
	EndIf
Else

   Alert("Dados dos parametros não encontrados")  
Endif

Return Nil










Static Function RunReport(Cabec1,Cabec2,cTitulo,nLin,_cTp)
*********************************************************
Local _nValTot := 0      //Tot Geral Depreciado
Local _nValFil := 0      //Tot Fil Depreciado
Local _nValTor := 0      //Tot Geral Original  
Local _nValFor := 0      //Tot Fil Original  
Local _nVl     := 0      //Valor Original     
Local _nVlGro  := 0      //Valor Original por Grupo
Local _nVlGrd  := 0      //Valor da Depreciacao porGrupo
Local _cFil    := Space(2) 
Local _cGrp    := Space(2)  

DbSelectArea("QrySn4")
DbGotop()

SetRegua(RecCount())      

_cFil := QrySn4->FILIAL

Do While !EOF()

   If lAbortPrint
   
  	   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
     	Exit
   Endif

  	If nLin > 71 .or. _cFil <> QrySn4->FILIAL
   
     	If _cFil <>  QrySn4->FILIAL    
         
        	nLin := nLin + 1
         @nLin,014 PSAY 'Total da Filial '+_cFil
  	      @nLin,082 PSAY Transform(_nValFor,"@E ,999,999,999.99")  
     	   @nLin,105 PSAY Transform(_nValFil,"@E 99,999,999.99")   
        	@nLin,119 PSAY Transform((_nValFor - _nValFil),"@E 99,999,999.99")  
   
         _cFil := QrySn4->FILIAL 
         
  	      _nValFil := 0
     	   _nValFor := 0
      Endif   
/*
          1         2         3         4         5         6         7         8         9        10        11        12        13
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Fl  Cod Bem   Item           Descrição            Data Aquis        Conta           Valor Ori    Tx Depr  Depr Acumu.  Valor Contab    
xx XXXXXXXXXX ZZZZ YYYYYYYYYYYYYYYYYYYYYYYYYYYYYY 99/99/9999 XXXXXXXXXXXXXXXXXXXX 999,999,999.99 99.9999 99,999,999.99 999,999,999.99

Fl  Cod Bem   Item           Descrição            Data Aquis        Conta              Valor Ori       Tx Depr     Depr Acumu.       
xx XXXXXXXXXX ZZZZ YYYYYYYYYYYYYYYYYYYYYYYYYYYYYY 99/99/9999 XXXXXXXXXXXXXXXXXXXX 9,999,999,999,999.99 999.9999 9,999,999,999,999.99
                                   30
*/   
      //Cabec1 := 'Fl  Cod Bem   Item           Descrição            Data Aquis        Conta              Valor Ori       Tx Depr     Depr Acumu.       '  
  	   Cabec1 := 'Fl  Cod Bem   Item           Descrição            Data Aquis        Conta           Valor Ori    Tx Depr Depr Acumu.   Valor Contab '
      
     	Cabec(cTitulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
  	Endif
                            
   _nVl := Posicione("SN3",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM+"01","N3_VORIG1")
                                   
  	@nLin,000 PSAY QrySn4->FILIAL
   @nLin,003 PSAY QrySn4->CODIGO
  	@nLin,014 PSAY QrySn4->ITEM 
   @nLin,019 PSAY Substr(Posicione("SN1",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM,"N1_DESCRIC"),1,30)
  	@nLin,050 PSAY Posicione("SN1",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM,"N1_AQUISIC") 
   @nLin,061 PSAY Posicione("SN3",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM+"01","N3_CDEPREC") 
  	/*
   @nLin,082 PSAY Transform(_nVl,"@E 9,999,999,999,999.99")  
  	@nLin,103 PSAY Transform(Posicione("SN3",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM+"01","N3_TXDEPR1"),"@E 999.9999")  
   @nLin,112 PSAY Transform(VAL_DEP,"@E 9,999,999,999,999.99")  
  	*/
                                                               
   @nLin,082 PSAY Transform(_nVl,"@E 999,999,999.99")  
  	@nLin,097 PSAY Transform(Posicione("SN3",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM+"01","N3_TXDEPR1"),"@E 99.9999")  
   @nLin,105 PSAY Transform(VAL_DEP,"@E 99,999,999.99")
  	@nLin,119 PSAY Transform((_nVl - VAL_DEP),"@E 99,999,999.99")
                                                                    
   nLin := nLin + 1 // Avanca a linha de impressao

  	_nValTot := _nValTot + VAL_DEP
   _nValFil := _nValFil + VAL_DEP
  	_nVlGrd  := _nVlGrd  + VAL_DEP
   
   _nValTor := _nValTor + _nVl 
  	_nValFor := _nValFor + _nVl 
   _nVlGro  := _nVlGro  + _nVl

  	_cGrp := Substr(QrySn4->CODIGO,1,2) + ' - ' + Posicione('SNG',1,xFilial("SNG") + Substr(QrySn4->CODIGO,1,2)+Space(2),'NG_DESCRIC')

  	DbSkip() // Avanca o ponteiro do registro no arquivo
   
   If _cGrp <> Substr(QrySn4->CODIGO,1,2)
   
  	   nLin := nLin + 1
     	@nLin,014 PSAY 'Total do Grupo '+_cGrp
		@nLin,082 PSAY Transform(_nVlGro,"@E 999,999,999.99")  
		@nLin,105 PSAY Transform(_nVlGrd,"@E 99,999,999.99")   
		@nLin,119 PSAY Transform((_nVlGro - _nVlGrd),"@E 99,999,999.99")  
		nLin := nLin + 2                
		
		_nVlGro  := 0     
  	   _nVlGrd  := 0
	Endif
EndDo

nLin := nLin + 1
@nLin,014 PSAY 'Total da Filial '+_cFil
@nLin,082 PSAY Transform(_nValFor,"@E 999,999,999.99")  
@nLin,105 PSAY Transform(_nValFil,"@E 99,999,999.99")  
@nLin,119 PSAY Transform((_nValFor - _nValFil),"@E 99,999,999.99")  
nLin := nLin + 2

@nLin,014 PSAY 'Total da Geral '      
@nLin,082 PSAY Transform(_nValTor,"@E 999,999,999.99")  
@nLin,105 PSAY Transform(_nValTot,"@E 99,999,999.99")  
@nLin,119 PSAY Transform((_nValTor - _nValTot),"@E 99,999,999.99")


SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return 

Static Function VerSX1(_cPer) 
*****************************

Local j := 0
Local aRegs:=[]
Local i:= 0


Private cAlias:=Alias(),aPerg := {}

aRegs := {}

AADD(aRegs,{_cPer,"01","Emissao de ?   " ,"Emissao de            ?","Emissao de            ?","mv_ch1","D",08,0,0,"G",'naovazio',"mv_par01","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"02","Emissao Ate ?  " ,"Emissao ate           ?","Emissao ate           ?","mv_ch2","D",08,0,0,"G",'naovazio',"mv_par02","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"03","Filial de  ?   " ,"Filial de             ?","Filial de             ?","mv_ch3","C",02,0,0,"G",'        ',"mv_par03","   ","","","","","   ","","","","","","","","","","","","","","","","","","","XM0",""})
AADD(aRegs,{_cPer,"04","Filial Ate ?   " ,"Filial Ate            ?","Filial Ate            ?","mv_ch4","C",02,0,0,"G",'naovazio',"mv_par04","   ","","","","","   ","","","","","","","","","","","","","","","","","","","XM0",""})
//AADD(aRegs,{_cPer,"05","Status ?       " ,"Status                ?","Status                ?","mv_ch5","N",01,0,0,"C",'        ',"mv_par05","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})

DbSelectArea("SX1")         
DbSetOrder(1)
DbGotop()

For I:=1 to Len(aRegs)
    If !DBSeek(cPerg+aRegs[i,2])
     
       RecLock("SX1",.T.)
      
       For j:=1 to Len(aRegs[i]) //(FCount(), Len(aRegs[i]))
         
           FieldPut(j,aRegs[i,j])
      Next
      MsUnlock()
   Endif
Next

Return


   
   
