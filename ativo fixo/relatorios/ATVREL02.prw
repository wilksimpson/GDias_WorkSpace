#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ATVREL02 º Autor ³ Aguiar             º Data ³  05/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio que irá verificar se um bem foi ou não deprecia- º±±
±±º          ³do na data dada.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   /  /   ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ATVREL02
**********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir itens que "
Local cDesc2         := "nao foram depreciados em determinada data de calcu-."
Local cDesc3         := "lo. Data da depreciação é sempre ultimo dia do mes."
//Local cPict          := ""
Local titulo         := "Checagem de Depreciação de Bens"
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
Private NomeProg     := "ATVREL02" 
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
//Private cbtxt        := Space(10)
//Private cbcont       := 00
//Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ATVREL02" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "ATVREL02"+Space(2)
Private cString      := ""

dbSelectArea("SN3")
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

If Select("QrySn3") > 0  

   QrySn3->(DbCloseArea()) 
Endif

cQuery := " "                                     
cQuery += " SELECT N3_FILIAL AS FILIAL,N3_CBASE AS CODIGO, N3_ITEM AS ITEM "
cQuery += " FROM "+RetSqlName('SN3') + ' SN3 '
//cQuery += " INNER JOIN "+RetSqlName('SN1') + " SN1 ON (N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N3_FILIAL = N1_FILIAL AND (N1_BAIXA = ' ' OR N1_BAIXA > '"+DTOS(MV_PAR01)+"'))"
cQuery += " WHERE SN3.D_E_L_E_T_ = '' "
cQuery += "   AND N3_FIMDEPR ='' "
cQuery += "   AND N3_DTBAIXA = '' "
//cQuery += "   AND SN1.D_E_L_E_T_ = ' ' "   
cQuery += " GROUP BY N3_FILIAL,N3_CBASE,N3_ITEM  "
cQuery += " ORDER BY N3_FILIAL,N3_CBASE,N3_ITEM "
dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),'QrySn3',.F.,.T.)  

Memowrite ("c:\spool\c_query.txt" ,cQuery )
    
Titulo := Titulo + " Data da Depreciação "+Dtoc(MV_PAR01) 
  
Processa( {|| RunProc(Titulo) } )

QrySn3->(DbCloseArea()) 
   
Return


Static Function VerSX1(_cPer) 
*****************************
Local aRegs := {}  
Local j:= i := 0

Private cAlias:=Alias()

AADD(aRegs,{_cPer,"01","Data da Depre. ?   " ,"Data Inicial          ?","Data Inicial          ?","mv_ch1","D",08,0,0,"G",'naovazio',"mv_par01","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{_cPer,"02","Filial de  ?   " ,"Data Final            ?","Data Final            ?","mv_ch2","C",02,0,0,"G",'        ',"mv_par02","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{_cPer,"03","Filial ate ?   " ,"Data Final            ?","Data Final            ?","mv_ch3","C",02,0,0,"G",'naovazio',"mv_par03","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{_cPer,"04","Imprime Excel ?" ,"Data Final            ?","Data Final            ?","mv_ch4","N",01,0,0,"C",'        ',"mv_par04","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})

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
Local _dData   := Ctod('  /  /  ') 
Local cQuery   := " "

Local cPasta
Local cArq := 'ATVREL02.csv'
Local aExcel := {;
      {'Filial','Codigo do Bem','Item','Descrição','Ult. Depreciação'}}


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


DbSelectArea("QrySn3")
DbGotop()

//_cFil := QrySn3->FILIAL

Do While !EOF()  // N4_FILIAL+N4_CBASE+N4_ITEM+N4_TIPO+DTOS(N4_DATA)

   If Select("QrySn4") > 0  

      QrySn4->(DbCloseArea()) 
   Endif

                                     
   cQuery += " SELECT N4_DATA "
   cQuery += " FROM "+RetSqlName('SN4') + ' SN4 '
   cQuery += " WHERE D_E_L_E_T_ = ' ' "
   cQuery += "   AND N4_FILIAL = '"+QrySn3->FILIAL+"'"  
   cQuery += "   AND N4_CBASE = '"+QrySn3->CODIGO+"'"
   cQuery += "   AND N4_ITEM ='" +QrySn3->ITEM+"'"
   cQuery += "   AND N4_DATA =  '"+DTOS(MV_PAR01)+"'"
   cQuery += "   AND N4_TIPOCNT = '3' "   
    
   dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),'QrySn4',.F.,.T.)  

Memowrite ("c:\spool\c_query.txt" ,cQuery )


   DbSelectArea('QrySn4')
   DbGotop()
   
   If !Eof()
   
      _dData := Stod(QrySn4->N4_DATA)
   Endif
   
   QrySn4->(DbCloseArea())
   
   DbSelectArea("QrySn3")
   
   aAdd(aExcel, {;  
        QrySn3->FILIAL,QrySn3->CODIGO,QrySn3->ITEM,;
        Substr(Posicione("SN1",1,QrySn3->FILIAL+QrySn3->CODIGO+QrySn3->ITEM,"N1_DESCRIC"),1,30),_dData })  
        
   _dData   := Ctod('  /  /  ')
   
   DbSkip() // Avanca o ponteiro do registro no arquivo 
Enddo      

If Len(aExcel) >= 2   

	cRet := U_MyArrCsv(aExcel, cArq, Nil, Titulo)  

	If !Empty(cRet)
		
		Alert(cRet)
	EndIf
Else

   Alert("Dados dos parametros não encontrados")  
Endif

Return Nil
   
   
