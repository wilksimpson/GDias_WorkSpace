#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMREL03  º Autor ³ Aguiar             º Data ³  06/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o Resumo de Compras, referente a uma Solicitação deº±±
±±º          ³Compras.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COMREL03
**********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Resumo de Compras (RC)"
Local cPict          := ""
Local titulo         := "Resumo de Compras (RC)"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "COMREL03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMREL03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "COMREL03"+Space(2)
Private cString      := ""

dbSelectArea("SC1")
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

If Select("QrySc1") > 0  

   QrySc1->(DbCloseArea()) 
Endif

cQuery := " "                                     
cQuery += " SELECT C1_NUM, C1_INCSTAT, C1_SOLICIT, C1_EMISSAO,C1_DATPRF,C1_OS,C1_PEDIDO,C1_CC,C1_TPREQ,C1_DESCRI,C1_OBS, C1_NOMAPRO,C1_COTACAO"
cQuery += " FROM "+RetSqlName('SC1') + ' SC1 '
cQuery += " WHERE  SC1.C1_FILIAL   = '"+XFILIAL('SC1')+"'" 
cQuery += "   AND SC1.D_E_L_E_T_ = ' ' " 
cQuery += "   AND SC1.C1_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"          
cQuery += "   AND SC1.C1_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"          

dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"QrySc1",.F.,.T.)

//memowrite('c:\xml\Aguiquery.txt',cQuery) 

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

 QrySc1->(DbCloseArea())
 
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
****************************************************
Local cStatus  
Local cTpAq
Local cCota  
Local cPed
Local mPed := {}

DbSelectArea("QrySc1")
DbGotop()

SetRegua(RecCount())

Do While !Eof()               

   cCota := QrySc1->C1_COTACAO
   cPed  := Iif(!Empty(QrySc1->C1_PEDIDO),U_Pedidos(QrySc1->C1_NUM,.T.),' ')
	
	If QrySc1->C1_INCSTAT = '1'
      
   	cStatus := 'Compra Regular'
	ElseIf QrySc1->C1_INCSTAT = '2'  
      
	   cStatus := 'Compra Urgente'   	
	ElseIf QrySc1->C1_INCSTAT = '3'  
      
   	cStatus := 'Compra Emergencial' 
	Else 
      
	   cStatus := 'Material Exclusivo' 
	Endif  
    
   cTpAq := ' '
      
	If QrySc1->C1_TPREQ = '1'           
      
   	cTpAq := 'Suprimento'
	ElseIf QrySc1->C1_TPREQ = '2'           
      
   	cTpAq := 'Preventivo' 
	ElseIf QrySc1->C1_TPREQ = '3'           
      
   	cTpAq := 'Corretivo'
	ElseIf QrySc1->C1_TPREQ = '4'           
      
   	cTpAq := 'Rancho' 
	Endif           
         
	Cabec1 := 'Solicitação de Compra : '+QrySc1->C1_NUM
	Cabec2 := 'Compra de Material - '+ cStatus +' '+'Tipo Aquisic: '+ cTpAq
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
  
	@nLin,01 PSAY 'Solicitante: '+QrySc1->C1_SOLICIT
	nLin := nLin + 1 //9
   
	@nLin,01 PSAY 'Data da Requisição: '+Dtoc(Stod(QrySc1->C1_EMISSAO))
	nLin := nLin + 1 //10                                     
   
	@nLin,01 PSAY 'Previsão de Necessidade: '+Dtoc(Stod(QrySc1->C1_DATPRF))
	nLin := nLin + 1 //11                                                
   
	@nLin,01 PSAY 'Unidade/Filial: '+Alltrim(SM0->M0_NOME)+'/'+Alltrim(SM0->M0_FILIAL)
	nLin := nLin + 1 //12
   
	@nLin,01 PSAY 'OS: '+QrySc1->C1_OS
	nLin := nLin + 1 //13
   
	@nLin,01 PSAY 'Pedido de Compra: '+cPed
	nLin := nLin + 1 //14
   
	@nLin,01 PSAY 'Centro de Custo: '+QrySc1->C1_CC + '- '+ Posicione('CTT',1,xFilial('CTT')+QrySc1->C1_CC,'CTT_DESC01')
	nLin := nLin + 1 //15                             
   
	@nLin,01 PSAY 'Gestor Responsavel: '+QrySc1->C1_NOMAPRO
	nLin := nLin + 1 //16
   
	@nLin,01 PSAY Replicate('_',80)
	nLin := nLin + 1//17
   
	@nLin,01 PSAY 'Aplicação / Justificativa da Demanda'
	nLin := nLin + 1 //18
   
	DbSelectArea("SZH")
	DbSetOrder(1)
	DbGotop()
   
	If DbSeek(xFilial('SZH')+QrySc1->C1_NUM)  
      
      nLinhasMemo := MLCOUNT(SZH->ZH_APLIC,80) 
      
      For c:= 1 To nLinhasMemo
      
   	    @nLin,01 PSAY Memoline(SZH->ZH_APLIC,80,c)
   	    nLin := nLin + 1
   	Next    
	Endif

	//nLin := nLin + c

	@nLin,01 PSAY Replicate('_',80)
	nLin := nLin + 1  

	@nLin,01 PSAY 'Material / Serviços Necessários'
	nLin := nLin + 1

  	DbSelectArea("QrySc1")
                            
   xList := QrySc1->C1_NUM   
   z:= 1  
         
	Do While !EOF() .and. xList = QrySc1->C1_NUM 
	   
	   If QrySc1->C1_TPREQ <> '4'
		   
		   If nLin >= 60
      
      	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         	nLin := 9
      
         	@nLin,01 PSAY 'Material / Serviços Necessários'
         	nLin := nLin + 1
      	Endif
      
	      @nLin,01 PSAY QrySc1->C1_DESCRI+' '+Substr(QrySc1->C1_OBS,1,60)
   	   nLin := nLin + 1 
      ElseIf z = 1
   
         @nLin,01 PSAY 'Essa é uma solicitação de RANCHO, por isso seus itens não serão impressos'
         nLin := nLin + 1 
         z+=1
      Endif
      
      DbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo

	@nLin,01 PSAY Replicate('_',80)
	nLin := nLin + 1  

	If Empty(cCota)

      @nLin,01 PSAY 'Observações sobre renegociação'
    	nLin := nLin + 1 
   	@nLin,01 PSAY 'Essa solicitação não tem cotação'
   	nLin := nLin + 1 
	Else
   
   	DbSelectArea("SZG")
   	DbSetOrder(1)
   	DbGotop()
   
   	If DbSeek(xFilial("SZG")+cCota)
        
         @nLin,01 PSAY 'Observações sobre renegociação da cotação '+SZG->ZG_COTACAO
      	nLin := nLin + 1
      	      
      	Do While !Eof() .And. (SZG->ZG_FILIAL+SZG->ZG_COTACAO) = (xFilial("SZG")+cCota)
         
         	If nLin >= 60
      
         		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	         	nLin := 9
      
   	      	@nLin,01 PSAY 'Observações sobre renegociação da cotação '+SZG->ZG_COTACAO
      	      nLin := nLin + 1
         	Endif
         
	         @nLin,01 PSAY DTOC(SZG->ZG_DATA)
   	      @nLin,10 PSAY SZG->ZG_HORA
      	   @nLin,19 PSAY SZG->ZG_USUARIO
         	@nLin,40 PSAY Posicione('SA2',1,xFilial('SA2')+Substr(SZG->ZG_CHAVE,7,8),'A2_NOME') 
	         nLin := nLin + 1
   	      @nLin,40 PSAY SZG->ZG_MOTIVO
      	   
         	nLin := nLin + 1
         
	         DbSkip()
   	   Enddo
	   Else
   
   	   @nLin,01 PSAY 'Observações sobre renegociação da cotação '+cCota
      	nLin := nLin + 1
      
	      @nLin,01 PSAY 'NAO POSSUI RENEGOCIAÇÃO'
   	   nLin := nLin + 1
   	Endif   
   
	   If !Empty(cPed)             
	   
	      @nLin,01 PSAY Replicate('_',80)
	      nLin := nLin + 1
         
         mPed  := Iif(!Empty(cPed),U_Pedidos(xList,.F.),' ')
         
			DbSelectArea("SC7")
			DbSetOrder(1)
			DbGotop()

			For r := 1 To Len(mPed)
			
				 If DbSeek(xFilial('SC7')+mPed[r])
	
	      	    @nLin,01 PSAY 'Cotação Vencedora: '+Alltrim(Posicione('SA2',1,xFilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA,'A2_NOME') )+ ' Pedido: '+mPed[r]
	             nLin := nLin + 1
         
   	          nVl := 0
                  
      	       Do While !Eof() .and. (SC7->C7_FILIAL+SC7->C7_NUM) =  (xFilial('SC7')+mPed[r])
                   
                   If nLin >= 60
      
         				 Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	                   nLin := 9
                   Endif
                   
         	       @nLin,01 PSAY SC7->C7_DESCRI
         	       @nLin,Pcol()+1 PSAY Transform(SC7->C7_QUANT, "@E 99,999.99")
         	       @nLin,Pcol()+1 PSAY Transform(SC7->C7_PRECO,'@E 999,999.99')
         	         
         	       nLin := nLin + 1
         	       
         	       nVl += SC7->C7_TOTAL
            
            	    DbSkip()
	             Enddo   
         
   	          @nLin,01 PSAY 'Valor Fechado: '+ Transform(nVl,'@E 999,999.99')
      	       nLin := nLin + 1   
      	       
      	       @nLin,01 PSAY Replicate('_',80)
	             nLin := nLin + 1
	          Endif
	      Next      
         
         r := 0
         
         For r := 1 To Len(mPed)
      
      		 If Select("QryScr") > 0  

   				 QryScr->(DbCloseArea()) 
				 Endif

				 cQuery := " "                                     
				 cQuery += " SELECT CR_USERLIB, CR_DATALIB"
				 cQuery += " FROM "+RetSqlName('SCR') + ' SCR '
				 cQuery += " WHERE  SCR.CR_FILIAL   = '"+XFILIAL('SCR')+"'" 
				 cQuery += "   AND SCR.D_E_L_E_T_ = ' ' " 
		       cQuery += "   AND SCR.CR_NUM = '" + mPed[r]+"'"           
		       cQuery += "   AND SCR.CR_NIVEL = '01'"
		       cQuery += "   AND SCR.CR_STATUS = '03'"    
		       
		       //Memowrite ("C:\xml\c_query1.txt" , cQuery)

	   	    dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"QryScr",.F.,.T.)

             If !Eof()
                  
	             If nLin >= 60
      
         		    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	         	    nLin := 9
                Endif
   	      	 
   	      	 @nLin,01 PSAY 'Aprov Nivel 01 Por: '+ QryScr->CR_USERLIB + ' '+Posicione('SAK',2,xFilial('SAK')+QryScr->CR_USERLIB,'AK_NOME')
   	      	 @nLin,Pcol()+1 PSAY 'Em '+Dtoc(Stod(QryScr->CR_DATALIB))+' Ped: '+ mPed[r]
      	       nLin := nLin + 1
                
                DbSkip()
	          Endif
	      Next 
	      	            
	      If r > 0
	      
	         @nLin,01 PSAY Replicate('_',80)
	         nLin := nLin + 1
	      Endif
	      
	      For r := 1 To Len(mPed)
      
      		 If Select("QryScr") > 0  

   				 QryScr->(DbCloseArea()) 
				 Endif

				 cQuery := " "                                     
				 cQuery += " SELECT CR_USERLIB, CR_DATALIB"
				 cQuery += " FROM "+RetSqlName('SCR') + ' SCR '
				 cQuery += " WHERE  SCR.CR_FILIAL   = '"+XFILIAL('SCR')+"'" 
				 cQuery += "   AND SCR.D_E_L_E_T_ = ' ' " 
		       cQuery += "   AND SCR.CR_NUM = '" + mPed[r]+"'"           
		       cQuery += "   AND SCR.CR_NIVEL = '02'"
		       cQuery += "   AND SCR.CR_STATUS = '03'"   
		       
		       //Memowrite ("C:\xml\c_query2.txt" , cQuery)

	   	    dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"QryScr",.F.,.T.)

             If !Eof()
                  
	             If nLin >= 60
      
         		    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	         	    nLin := 9
                Endif
   	      	 
   	      	 @nLin,01 PSAY 'Aprov Nivel 02 Por: '+ QryScr->CR_USERLIB + ' '+Posicione('SAK',2,xFilial('SAK')+QryScr->CR_USERLIB,'AK_NOME')
   	      	 @nLin,Pcol()+1 PSAY 'Em '+Dtoc(Stod(QryScr->CR_DATALIB))+' Ped: '+ mPed[r]
      	       nLin := nLin + 1
                
                DbSkip()
	          Endif
	      Next   
	   Endif
	Endif

	If Select("QryScr") > 0  

      QryScr->(DbCloseArea()) 
   Endif

   DbSelectArea("QrySc1")
//   DbSkip()
Enddo   
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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


//AADD(aRegs,{_cPer,"01","Filial     ?   " ,"Data Final            ?","Data Final            ?","mv_ch2","C",02,0,0,"G",'        ',"mv_par02","   ","","","","","   ","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"01","Data de    ?   " ,"Data Final            ?","Data Final            ?","mv_ch1","D",08,0,0,"G",'naovazio',"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"02","Data ate   ?   " ,"Data Inicial          ?","Data Inicial          ?","mv_ch2","D",08,0,0,"G",'naovazio',"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_cPer,"03","Solicitação de?" ,"Data Final            ?","Data Final            ?","mv_ch3","C",06,0,0,"G",'        ',"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SC1",""})
AADD(aRegs,{_cPer,"04","Solicitação de?" ,"Data Final            ?","Data Final            ?","mv_ch4","C",06,0,0,"G",'        ',"mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SC1",""})


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


User Function Pedidos(cReq,n)
*****************************
Local aAreaPed := GetArea() 
Local aPed     := {} 
Local cPed     := {}

DbSelectArea("SC1")
DbSetOrder(1)
DbGotop()

DbSeek(xFilial('SC1')+cReq)    

Do While !Eof() .and. cReq = SC1->C1_NUM  
  
   If aScan(aPed,SC1->C1_PEDIDO) = 0
      
      aAdd(aPed, SC1->C1_PEDIDO)
   Endif
   
   DbSkip()
Enddo   

If n 

	cPed     := ''

	For x := 1 to Len(aPed)

   	 If x = 1
   	    
   	    cPed :=  aPed[x]
       Else
    	  
       	 cPed := Alltrim(cPed) + '/' +aPed[x]
       Endif
	Next
Else	
	 
	cPed := Aclone(aPed)      
Endif

RestArea(aAreaPed)

Return cPed
