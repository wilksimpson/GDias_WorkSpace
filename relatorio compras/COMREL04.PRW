#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMREL04 º Autor ³ Aguiar             º Data ³  23/01/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de manifestação de notas fiscais de entrada.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 15/02/18 ³ Ajuste de layout do relatorio                              º±±
±±º  Aguiar  ³                                                            º±±
±±º**********³************************************************************º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COMREL04
**********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "A situação das NF-e"
Local cPict          := ""
Local titulo         := "Manifestação de NF-e"
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
Private nomeprog     := "COMREL04" 
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMREL04" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "COMREL04"+Space(2)
Private cString      := ""

dbSelectArea("C00")
dbSetOrder(1)

VerSX1(cPerg) 
                      
pergunte(cPerg,.f.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27

   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

If Select("QryC00") > 0  

   QryC00->(DbCloseArea()) 
Endif


cQuery := " "                                     
cQuery += " SELECT C00_FILIAL,C00_STATUS, C00_CHVNFE,C00_SERNFE, C00_NUMNFE,C00_VLDOC, C00_CNPJEM, C00_NOEMIT,C00_DTEMI, C00_CODRET,C00_DESRES "
cQuery += " FROM "+RetSqlName('C00') + ' C00 '
cQuery += " WHERE D_E_L_E_T_ =' '"  
cQuery += "   AND C00_FILIAL BETWEEN '"+MV_PAR03+"' AND '" + MV_PAR04 + "'"   
cQuery += "   AND C00_DTEMI  BETWEEN '"+Dtos(MV_PAR01)+"' AND '" + DTOS(MV_PAR02) + "'"   
cQuery += " ORDER BY C00_FILIAL, C00_STATUS, C00_DTEMI,C00_CHVNFE "
dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),'QryC00',.F.,.T.) 

//Memowrite ("c:\spool\comrel04.txt" ,cQuery )
    
Titulo := Alltrim(Titulo) + " Data de Emissao "+Dtoc(MV_PAR01)+" a "+ Dtoc(MV_PAR02)

/*
If Mv_par04 = 2
   
   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, mv_par04) },Titulo)  
Else
*/   
   Processa( {|| RunProc(Titulo) } )
//Endif                                                                       
   
Return


Static Function RunProc(cTitulo)
*******************************  
Local _nValFil := 0     //Valor da Filial
Local _nValTot := 0     //Valor Total   
Local _cDes
Local _cFil    := Space(2)
Local cPasta
Local cArq := 'COMREL04.csv'    
Local aExcel := {}

aAdd(aExcel, {cTitulo})
aAdd(aExcel, {'Relatório emitido em '+DTOC(Date())+' por '+AllTrim(cUsername)})
aAdd(aExcel, {'Período: '+DTOC(MV_PAR01)+' até '+DTOC(MV_PAR02)})    
aAdd(aExcel, {'Filial de: '+MV_PAR03+' até '+MV_PAR04})
aAdd(aExcel, {'Notas de: Entrada'})
/*
aAdd(aExcel, {'Considera: Data de '+Iif(MV_PAR04==1,'Entrada','Emissão')})
aAdd(aExcel, {'CC Administrativo: '+StrTran(MV_PAR05,';',',')})
aAdd(aExcel, {'CC Operacional: '+StrTran(MV_PAR06,';',',')})
aAdd(aExcel, {'CC Operacional: '+StrTran(MV_PAR06,';',',')})
aAdd(aExcel, {'Grupo : '+ Alltrim(SM0->M0_NOMECOM) + " Filial: " + Alltrim(SM0->M0_FILIAL) })
*/

aAdd(aExcel, {''})  

//aAdd(aExcel,{'Filial','Chave NFe','Serie','Num Nf-e','Valor Nfe','CNPJ Emitente','Nome Do Emitente','Data Emis','Cod Processo SEFA','Desc Processo Sefa','Status'} )
aAdd(aExcel,{'Filial','Status','Data Emis','Num Nf-e','Serie','CNPJ Emitente','Nome Do Emitente','Valor Nfe','Cod Processo SEFA','Desc Processo Sefa','Chave NFe'} )

PswOrder(1)

If PswSeek(__cUserId, .T.)
	
	cPasta := AllTrim(PswRet()[2][3])
EndIf
	
If !MontaDir(cPasta)
	
	cPasta := 'C:\SPOOL'

	If !MontaDir(cPasta)
		
		Alert('Impossível gerar o arquivo destino.' + chr(13) + chr(10) +;
					'Contate o suporte técnico.')
		Return Nil
	EndIf
Endif
	
cArq := cPasta + '\' + cArq

DbSelectArea("QryC00")
DbGotop()

_cFil := QryC00->C00_FILIAL

Do While !EOF()

   If _cFil <>  QryC00->C00_FILIAL    
   
      aAdd(aExcel, {;  
        'Total da Filial '+_cFil,'','','',_nValFil,'','','','','',''})
         
      _cFil := QryC00->C00_FILIAL 
         
  	  _nValFil := 0
   Endif 

   Do Case
   
      Case  QryC00->C00_STATUS = '0'  
            
            _cDes := 'Sem Status'  
            
      Case  QryC00->C00_STATUS = '1'  
            
            _cDes := 'Operação Confirmada'
            
	  Case  QryC00->C00_STATUS = '2'  
            
            _cDes := 'Desconhecimento da Operação'
      
      Case  QryC00->C00_STATUS = '3'  
            
            _cDes := 'Operação não Realizada'
            
      Case  QryC00->C00_STATUS = '4'  
            
            _cDes := 'Ciencia da Operação' 
      
      OtherWise 
      
           _cDes := 'Status Ignorado'
   EndCase                                             
      
   aAdd(aExcel, {;     
        QryC00->C00_FILIAL,QryC00->C00_STATUS+' '+_cDes,Stod(QryC00->C00_DTEMI),;
        QryC00->C00_SERNFE,QryC00->C00_NUMNFE,QryC00->C00_CNPJEM,QryC00->C00_NOEMIT,;
        QryC00->C00_VLDOC,QryC00->C00_CODRET,QryC00->C00_DESRES,QryC00->C00_CHVNFE;
        })  
        
   _nValTot := _nValTot + QryC00->C00_VLDOC
   _nValFil := _nValFil + QryC00->C00_VLDOC
  
  DbSkip() // Avanca o ponteiro do registro no arquivo
Enddo      

aAdd(aExcel, {;  
        'Total da Filial '+_cFil,'','','',_nValFil,'','','','','',''})
aAdd(aExcel, {;  
        'Total da Geral '       ,'','','',_nValTot,'','','','','',''})

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

DBSelectArea(cAlias)

Return


   
   
