#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ATVREL01 º Autor ³ Aguiar             º Data ³  02/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de valorização do ativo por data e filial. Pega  º±±
±±º          ³o valor da depreciação inicial até a data pedida.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 01/12/14 ³ Colocar a data de referencia no cabeçalho do relatorio.    º±±
±±º          ³ Colocar total geral para o valor original                  º±±
±±º          ³ Colocar total por filial do valor original                 º±±
±±º Aguiar   ³ Colocar os totais existentes por grupo de ativos           º±±
±±º**********³************************************************************º±±
±±º 25/10/16 ³ Colocada coluna do Valor Contabil. Ajustes nas colunas do  º±±
±±º  Aguiar  ³relatorio.                                                  º±±
±±º**********³************************************************************º±±
±±º 26/10/16 ³ Colocada a opção para gerar o relatorio em excel           º±±
±±º  Aguiar  ³                                                            º±±
±±º**********³************************************************************º±±
±±º 29/11/18 ³ Colocada a validação do fim de da data de depreciação(3)   º±±
±±º  Aguiar  ³                                                            º±±
±±º**********³************************************************************º±±
±±º 20/02/19 ³ Colocada a validação do fim de da depreciação por valor    º±±
±±º  Aguiar  ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ATVREL01
**********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Os valores do bem depr. é ate a data pedida."
//Local cPict          := ""
Local titulo         := "Valorização de Bens"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
//Local imprime        := .T.
Local aOrd           := {}

//Private lEnd         := .F.
Private lAbortPrint  := .F.
//Private CbTxt        := ""
//Private limite       := 132
Private Tamanho      := "M"
Private NomeProg     := "ATVREL01" 
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
//Private cbtxt        := Space(10)
//Private cbcont       := 00
//Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ATVREL01" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "ATVREL01"+Space(2)
Private cString      := ""

dbSelectArea("SN1")
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

If Select("QrySn4") > 0  

   QrySn4->(DbCloseArea()) 
Endif

cQuery := " "                                     
cQuery += " SELECT N4_FILIAL AS FILIAL,N4_CBASE AS CODIGO, N4_ITEM AS ITEM,SUM(N4_VLROC1) AS VAL_DEP "
cQuery += " FROM "+RetSqlName('SN4') + ' SN4 '

If MV_PAR04 = 2
   
   cQuery += " INNER JOIN "+RetSqlName('SN1') + " SN1 ON (N1_CBASE = N4_CBASE AND N1_ITEM = N4_ITEM AND N1_FILIAL = N4_FILIAL AND SN1.D_E_L_E_T_ = ' '  AND (N1_BAIXA = ' ' OR N1_BAIXA > '"+DTOS(MV_PAR01)+"'))"
Else
   
   cQuery += " INNER JOIN "+RetSqlName('SN3') + " SN3 ON (N3_CBASE = N4_CBASE AND N3_ITEM = N4_ITEM AND N3_FILIAL = N4_FILIAL AND SN3.D_E_L_E_T_ = ' '  AND  N3_VORIG1 <> N3_VRDACM1 AND N3_DTBAIXA <> '') "
Endif  

//cQuery += " WHERE N4_FILIAL = '"+xFilial('SN4')+"'"
cQuery += " WHERE N4_FILIAL BETWEEN ' "+MV_PAR02+ "' AND '"+MV_PAR03+"'"
cQuery += "   AND N4_DATA <=  '"+DTOS(MV_PAR01)+"'"
cQuery += "   AND N4_TIPOCNT = '3' "   
cQuery += "   AND SN4.D_E_L_E_T_ = ' ' "
//cQuery += "   AND SN1.D_E_L_E_T_ = ' ' "   
cQuery += " GROUP BY N4_FILIAL,N4_CBASE,N4_ITEM  "
cQuery += " ORDER BY N4_FILIAL,N4_CBASE ,N4_ITEM "
dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),'QrySn4',.F.,.T.)  

Memowrite ("c:\spool\c_query.txt" ,cQuery )
    
Titulo := Titulo + " Data de Referencia "+Dtoc(MV_PAR01) 

If Mv_par05 = 2
   
   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, mv_par05) },Titulo)  
Else
   
   Processa( {|| RunProc(Titulo) } )
Endif                                                                       

QrySn4->(DbCloseArea()) 
   
Return



Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,_cTp)
*********************************************************
Local _nValTot := 0        //Tot Geral Depreciado
Local _nValFil := 0        //Tot Fil Depreciado
Local _nValTor := 0        //Tot Geral Original  
Local _nValFor := 0        //Tot Fil Original  
Local _nVl     := 0        //Valor Original     
Local _nVlGro  := 0        //Valor Original por Grupo
Local _nVlGrd  := 0        //Valor da Depreciacao porGrupo
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

	//If Empty(Posicione("SN3",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM+"01","N3_FIMDEPR"))
   
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
      
     	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
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

   If (_nVl - VAL_DEP) > 0
    
  		_nValTot := _nValTot + VAL_DEP
    	_nValFil := _nValFil + VAL_DEP
  		_nVlGrd  := _nVlGrd  + VAL_DEP
   
    	_nValTor := _nValTor + _nVl 
  		_nValFor := _nValFor + _nVl 
    	_nVlGro  := _nVlGro  + _nVl
   Endif
  	
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
	/*
	Else
		DbSkip()
	Endif
	*/				
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
Local aRegs := {}  
Local j:= i := 0

Private cAlias:=Alias()



AADD(aRegs,{_cPer,"01","Ate a Data ?   " ,"Data Inicial          ?","Data Inicial          ?","mv_ch1","D",08,0,0,"G",'naovazio',"mv_par01","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"02","Filial de  ?   " ,"Data Final            ?","Data Final            ?","mv_ch2","C",02,0,0,"G",'        ',"mv_par02","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"03","Filial ate ?   " ,"Data Final            ?","Data Final            ?","mv_ch3","C",02,0,0,"G",'naovazio',"mv_par03","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"04","Imp. Bx. Depr ?" ,"Data Final            ?","Data Final            ?","mv_ch4","N",01,0,0,"C",'        ',"mv_par04","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"05","Imprime Excel ?" ,"Data Final            ?","Data Final            ?","mv_ch5","N",01,0,0,"C",'        ',"mv_par05","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})

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


Static Function RunProc(Titulo)
******************************* 
Local _nValTot := 0      //Tot Geral Depreciado
Local _nValFil := 0      //Tot Fil Depreciado
Local _nValTor := 0      //Tot Geral Original  
Local _nValFor := 0      //Tot Fil Original  
Local _nVl     := 0      //Valor Original     
Local _nVlGro  := 0      //Valor Original por Grupo
Local _nVlGrd  := 0      //Valor da Depreciacao porGrupo
Local _cFil    := Space(2) 
Local _cGrp    := Space(2)  

Local cPasta
Local cArq := 'ATVREL01.csv'
Local aExcel := {;
      {'Filial','Codigo do Bem','Item','Descrição','Data Aquisição',;
      'Conta Contabil','Valor Original','Taxa de Deprecição',;
      'Depreciação Acumulada','Valor Contabil'}}


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


DbSelectArea("QrySn4")
DbGotop()

_cFil := QrySn4->FILIAL

Do While !EOF()


   If _cFil <>  QrySn4->FILIAL    
   
      aAdd(aExcel, {;  
        'Total da Filial '+_cFil,'','','','','',_nValFor,'',_nValFil,(_nValFor - _nValFil)})
         
         _cFil := QrySn4->FILIAL 
         
  	      _nValFil := 0
     	   _nValFor := 0
      Endif 

   _nVl := Posicione("SN3",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM+"01","N3_VORIG1")
      
   aAdd(aExcel, {;  
        QrySn4->FILIAL,QrySn4->CODIGO,QrySn4->ITEM,;
        Substr(Posicione("SN1",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM,"N1_DESCRIC"),1,30),;
        Posicione("SN1",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM,"N1_AQUISIC"),; 
        Posicione("SN3",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM+"01","N3_CDEPREC"),;
        _nVl,Posicione("SN3",1,QrySn4->FILIAL+QrySn4->CODIGO+QrySn4->ITEM+"01","N3_TXDEPR1"),;
        VAL_DEP,(_nVl - VAL_DEP)})  
        
   If (_nVl - VAL_DEP) > 0 //Não levar valores de bens já depre3ciados 
      
   		_nValTot := _nValTot + VAL_DEP
   		_nValFil := _nValFil + VAL_DEP
   		_nVlGrd  := _nVlGrd  + VAL_DEP     
           
   		_nValTor := _nValTor + _nVl 
   		_nValFor := _nValFor + _nVl 
   		_nVlGro  := _nVlGro  + _nVl
   Endif
   
   _cGrp := Substr(QrySn4->CODIGO,1,2) + ' - ' + Posicione('SNG',1,xFilial("SNG") + Substr(QrySn4->CODIGO,1,2)+Space(2),'NG_DESCRIC')

  	DbSkip() // Avanca o ponteiro do registro no arquivo
   
   If _cGrp <> Substr(QrySn4->CODIGO,1,2)
   
  	   aAdd(aExcel, {;  
        'Total do Grupo '+_cGrp,'','','','','',_nVlGro,'',_nVlGrd,(_nVlGro - _nVlGrd)})
  	   
		_nVlGro  := 0     
  	   _nVlGrd  := 0
	Endif
Enddo      

aAdd(aExcel, {;  
        'Total da Filial '+_cFil,'','','','','',_nValFor,'',_nValFil,(_nValFor - _nValFil)})

aAdd(aExcel, {;  
        'Total da Geral ','','','','','',_nValTor,'',_nValTot,(_nValTor - _nValTot)})

If Len(aExcel) >= 2   

	cRet := U_MyArrCsv(aExcel, cArq, Nil, Titulo)  

	If !Empty(cRet)
		
		Alert(cRet)
	EndIf
Else

   Alert("Dados dos parametros não encontrados")  
Endif

Return Nil
   
   
