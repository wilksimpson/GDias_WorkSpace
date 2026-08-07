//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} RCOM003
Relatório - Mapa de Cotação
@author Wilk Lima
@since 24/03/2025
@version 1.0
	@example
	RCOM003()
/*/

User Function RCOM003()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""


	//Definições da pergunta
	cPerg := "RCOM003"



	If FunName()=="MATA094"

		IF 	SCR->CR_TIPO$'PC/IP'
			DbSelectArea("SC7")
			DbSetOrder(1)
			MsSeek(XFILIAL("SC7")+ALLTRIM(SCR->CR_NUM))
			If !Empty(SC7->C7_MEDICAO)
				MsgInfo("Pedido de Compra Gerado a partir do Contrato "+alltrim(SC7->C7_CONTRA), "Mapa de Cotação Indisponível")
				Return
			elseif !Empty(SC7->C7_NUMCOT)
				MV_PAR01=SC7->C7_NUMCOT
			Else
				MsgInfo("Não foi localizado o mapa de cotação para o Pedido de Compra", "Mapa de Cotação")
				Return
			Endif

		Else
			MsgInfo("Impressão Disponível apenas para Pedido de Compra.", "Mapa de Cotação")
			Return
		EndIf
	else
		ValidPerg()
		If !Pergunte(cPerg, .t.)
			Return .f.
		EndIf
	Endif


	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf

	//Cria as definições do relatório
	oReport := fReportDef()

	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 1 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.T.)
		oReport:Print(.F., "", .T.)
		//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	//
	RestArea(aArea)
Return

/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad1 := Nil
	Local oSectDad2 := Nil
	Local oFunTot1 := nil
//	Local oBreak := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"RCOM003",;		//Nome do Relatório
								"Mapa de Cotação nº "+MV_PAR01+" ",;	//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape() // modo paisagem
	//oReport:SetPortrait() // modo retrato
	oReport:nFontBody := 9 
	oReport:SetDevice(6)
	
	// Definindo se faz a quebra por cliente no relatório.
	
	//Criando a seção de dados
	oSectDad1 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Produto/Serviço",;		//Descrição da seção
									{"QRY_AUX"})	//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad1:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad1, "C8_PRODUTO", "QRY_AUX", "Codigo", /*Picture*/, 06, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "C8_ITEM", "QRY_AUX", "item", /*Picture*/, 04, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "B1_DESC", "QRY_AUX", "Descricao", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,.T./*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "C7_QUANT", "QRY_AUX", "Qtd. Ped", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "C8_UM", "QRY_AUX", "Unid.", /*Picture*/, 05, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "C7_PRECO", "QRY_AUX", "preço", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "C7_TOTAL", "QRY_AUX", "Total", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "C7_VLDESC", "QRY_AUX", "Desconto", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "FRETE", "QRY_AUX", "Frete/Desp", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "OBS", "QRY_AUX", "Justificativa", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,.T./*lLineBreak*/,/*cHeaderAlign */,.T./*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		
		//Criando a seção de dados
	oSectDad2 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Fornecedores",;	//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad2:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad2, "FORNECEDOR", "QRY_AUX", "Cod.Fornec", /*Picture*/, 06, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "A2_NOME", "QRY_AUX", "Nome Fornecedor", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "C8_QTDISP", "QRY_AUX", "Qtd. Disponivel", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "C8_PRECO", "QRY_AUX", "Vlr. Unit.", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "C8_TOTAL", "QRY_AUX", "Total", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "C8_VLDESC", "QRY_AUX", "Desconto", "@E 999,999,999.99", 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "C8_PRAZO", "QRY_AUX", "Entrega", "@E 999", 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CONDICAO", "QRY_AUX", "Condição", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "Status", "QRY_AUX", "Status", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Definindo a quebra
	//oBreak := TRBreak():New(oSectDad2,{|| QRY_AUX->(CR_NUM) },{|| "Total Documento" })
	oSectDad2:SetHeaderBreak(.T.)
	oSectDad2:SetHeaderSection(.T.)
	
		//Totalizadores
	//oFunTot1 := TRFunction():New(oSectDad1:Cell("CR_NUM"),,"COUNT",,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad1:Cell("C7_QUANT") ,,"SUM",,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad1:Cell("C7_TOTAL") ,,"SUM",,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad1:Cell("FRETE")    ,,"SUM",,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad1:Cell("C7_VLDESC"),,"SUM",,,"@E 99,999,999,999.99")
	

	oFunTot1:SetEndReport(.T.)
	
	
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad1 := Nil
	Local oSectDad2 := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	Local cNum     := ""
	//Local _Fornece := ""
	//Local _User    := ""
	

	//Pegando as seções do relatório
	oSectDad1 := oReport:Section(1)
	oSectDad2 := oReport:Section(2)
	
	//Montando consulta de dados
	// VENDAS
cQryAux := ""

cQryAux += " Select * FROM ( " + STR_PULA

cQryAux += " Select C8_NUM, C8_NUMPRO, C8_PRODUTO,B1_DESC, C8_ITEM,C8_QUANT,C8_QTDISP,C8_UM, C8_PRECO, " + STR_PULA
cQryAux += " C8_TOTAL,C8_VLDESC, C8_PRAZO, E4_DESCRI CONDICAO, CONCAT(C8_FORNECE, C8_LOJA) FORNECEDOR, C8_TOTFRE,  " + STR_PULA
cQryAux += " A2_NOME, C7_QUANT,C7_PRECO,C7_TOTAL, (C7_VALFRE+C7_DESPESA) FRETE, C7_VLDESC, " + STR_PULA
cQryAux += " '1 - Vencedor' Status ,  " + STR_PULA
// cQryAux += " UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(C8_MOTVENC, 2000, 1)) AS OBS " + STR_PULA banco ORACLE
cQryAux += " ISNULL(CAST(CAST(C8_MOTVENC AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS " + STR_PULA // BANCO SQL SERVER
cQryAux += " From "+RetSqlName("SC8")+" C8 INNER JOIN  " + STR_PULA
cQryAux +=  RetSqlName("SA2")+" A2 ON A2.D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"' AND A2_COD=C8_FORNECE AND A2_LOJA=C8_LOJA INNER JOIN " + STR_PULA
cQryAux +=  RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_<>'*' AND B1_FILIAL='"+XFILIAL("SB1")+"' AND B1_COD=C8_PRODUTO INNER JOIN  " + STR_PULA
cQryAux +=  RetSqlName("SE4")+" E4 ON E4.D_E_L_E_T_<>'*' AND E4_FILIAL='"+XFILIAL("SE4")+"' AND E4_CODIGO=C8_COND LEFT JOIN " + STR_PULA
cQryAux +=  RetSqlName("SC7")+" C7 ON C7.D_E_L_E_T_<>'*' AND C7_FILIAL=C8_FILIAL AND C7_NUM=C8_NUMPED AND C7_ITEM=C8_ITEMPED " + STR_PULA
cQryAux += " WHERE C8.D_E_L_E_T_<>'*' " + STR_PULA
cQryAux += " AND C8_FILIAL = '"+XFILIAL("SC8")+"' " + STR_PULA
cQryAux += " AND C8_NUM = '"+MV_PAR01+"' " + STR_PULA
cQryAux += " AND (C8_NUMPED>'' AND C8_NUMPED<>'XXXXXX') " + STR_PULA

cQryAux += " UNION ALL " + STR_PULA


cQryAux += " Select C8_NUM, C8_NUMPRO, C8_PRODUTO,B1_DESC, C8_ITEM,C8_QUANT,C8_QTDISP,C8_UM, C8_PRECO, " + STR_PULA
cQryAux += " C8_TOTAL,C8_VLDESC, C8_PRAZO, E4_DESCRI CONDICAO, CONCAT(C8_FORNECE, C8_LOJA) FORNECEDOR, C8_TOTFRE,  " + STR_PULA
cQryAux += " A2_NOME, C7_QUANT,C7_PRECO,C7_TOTAL, (C7_VALFRE+C7_DESPESA) FRETE, C7_VLDESC, " + STR_PULA
cQryAux += " CASE C8_SITUAC " + STR_PULA
cQryAux += " WHEN '2' THEN '4 - Sem Estoque' " + STR_PULA
cQryAux += " WHEN '3' THEN '3 - Não Vende'  " + STR_PULA
cQryAux += " WHEN '4' THEN '9 - Rejeitada'  " + STR_PULA
cQryAux += " WHEN '5' THEN '5 - Desqualificada' " + STR_PULA
cQryAux += " WHEN '6' THEN '6 - Parcial'  " + STR_PULA
cQryAux += " WHEN '7' THEN '7 - Completa'  " + STR_PULA
cQryAux += " WHEN '8' THEN '8 - Portal Forncedor' " + STR_PULA
cQryAux += " Else '2 - Não Vencedor' end Status , " + STR_PULA
// cQryAux += " UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(C8_MOTVENC, 2000, 1)) AS OBS " + STR_PULA // ORACLE
cQryAux += " ISNULL(CAST(CAST(C8_MOTVENC AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS  " + STR_PULA // ORACLE
cQryAux += " From "+RetSqlName("SC8")+" C8 INNER JOIN  " + STR_PULA
cQryAux +=  RetSqlName("SA2")+" A2 ON A2.D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"' AND A2_COD=C8_FORNECE AND A2_LOJA=C8_LOJA INNER JOIN " + STR_PULA
cQryAux +=  RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_<>'*' AND B1_FILIAL='"+XFILIAL("SB1")+"' AND B1_COD=C8_PRODUTO INNER JOIN  " + STR_PULA
cQryAux +=  RetSqlName("SE4")+" E4 ON E4.D_E_L_E_T_<>'*' AND E4_FILIAL='"+XFILIAL("SE4")+"' AND E4_CODIGO=C8_COND LEFT JOIN " + STR_PULA
cQryAux +=  RetSqlName("SC7")+" C7 ON C7.D_E_L_E_T_<>'*' AND C7_FILIAL=C8_FILIAL AND C7_NUM=C8_NUMPED AND C7_ITEM=C8_ITEMPED " + STR_PULA
cQryAux += " WHERE C8.D_E_L_E_T_<>'*' " + STR_PULA
cQryAux += " AND C8_FILIAL = '"+XFILIAL("SC8")+"' " + STR_PULA
cQryAux += " AND C8_NUM = '"+MV_PAR01+"'  " + STR_PULA
cQryAux += " AND (C8_NUMPED='      ' OR C8_NUMPED='XXXXXX') " + STR_PULA

cQryAux += " ) TMP " + STR_PULA
cQryAux += " ORDER BY C8_NUM, C8_PRODUTO,C8_ITEM, Status " + STR_PULA

cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	//TCSetField("QRY_AUX", "CR_EMISSAO", "D")
	//TCSetField("QRY_AUX", "PREV_INICIO", "D")
	
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
	
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSectDad1:Init()
			
		cNum 	:= QRY_AUX->(C8_PRODUTO)+QRY_AUX->(C8_ITEM)
		
		//Imprimindo a linha atual
		oSectDad1:PrintLine()
		
		//inicializo a segunda seção
		oSectDad2:Init()

			while cNum == QRY_AUX->(C8_PRODUTO)+QRY_AUX->(C8_ITEM) 

				//Incrementando a régua
				nAtual++
				oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
				oReport:IncMeter()


				//oSectDad2:Cell("FORNECE"):SetValue(_Fornece)
				//oSectDad2:Cell("FORNECE"):Show()

				//oSectDad2:Cell("USUARIO"):SetValue(_User)
				//oSectDad2:Cell("USUARIO"):Show()


				//Imprimindo a linha atual
				oSectDad2:PrintLine()

				QRY_AUX->(DbSkip())
			EndDo
		oSectDad2:Finish()
		oSectDad1:Finish()
		
	EndDo
	
	QRY_AUX->(DbCloseArea())
	

	RestArea(aArea)
Return

Static Function ValidPerg()
	Local aArea:= GetArea()                                                                                                                          
	Local aRegs
	Local i, j
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	cPerg:= Padr(cPerg, 10)
	
	aRegs:= {}
	aAdd(aRegs, {cPerg,"01","Numero da Cotação    ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC8","","","","",""})
	//aAdd(aRegs, {cPerg,"02","Emissão Até       ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//aAdd(aRegs, {cPerg,"03","Status             ","","","mv_ch9","N",01,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		
	For i:= 1 To Len(aRegs)
		If !DbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .t.)
			For j:= 1 To fCount()
				FieldPut(j, aRegs[i,j])
			Next j
			MsUnlock()
			DbCommit()
		Endif
	Next i
		
	RestArea(aArea)		
Return
