////////////////////////////////////////////////////////////////////////////////////////////////
// Relatorio GTR004 - Mostra os pedidos de compra com suas alocações nos centros de custo.    //
//                    Por indice por Data de Emissão                                          //
// Criado em 27-11-2008 por Luiz Jorge                                                        //
// Alterado em 13-01-2009 por Luiz Jorge                                                      //
////////////////////////////////////////////////////////////////////////////////////////////////

#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function GTR004()

//=======================================================================
//= Declaracao de Variaveis                                             =
//=======================================================================

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação de Pedido de Compras x Centro de Custo"
Local cPict          := ""
Local titulo         := "Relação de Compras x Centro de Custo (Por Ordem de Data de Emissao)"
Local nLin           := 80
Local Cabec1         := " Periodo: "
Local Cabec2         := " Dt.Emissao Nr. PC Produto                                                      Un     Quant.   Pc. Unitario      Vl. Total"
//                        99/99/9999 XXXXXX aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa XX 999,999.99 999,999,999.99 999,999,999.99
//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                 1         2         3         4         5         6         7         8         9         100       110       120
Local imprime        := .T.
Local aOrd           := {} //{"Por C.Custo","Por Produto"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "GTR004" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "GTR004"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "GTR004" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SD1"

criaperg(cPerg)
pergunte(cPerg,.T.)

//=======================================================================
//= Monta a interface padrao com o usuario...                           =
//=======================================================================

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//=======================================================================
//= Processamento. RPTSTATUS monta janela com a regua de processamento. =
//=======================================================================

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _cDtInic := DTOC(mv_par01)
Local _cDtFim  := DTOC(mv_par02)
Local _nVlTot  := 0
Local _nVlTCC  := 0
Local _cCodCC  := ""
Local _lCC     := .T.
Local _lImpCC  := .T.
Local _lImpDE  := .T.
Local _cCCusto :=  ""

Cabec1 := Cabec1 + _cDtInic + " a " + _cDtFim

If Select("TBTMP") > 0
	TBTMP->(dbCloseArea())
EndIf

_cQry := " SELECT SD1.* FROM "+RetSqlName("SD1")+" SD1 "
_cQry += " WHERE SD1.D_E_L_E_T_ <> '*' "
_cQry += " AND SD1.D1_FILIAL = '"+xfilial("SD1")+"'"
_cQry += " AND SD1.D1_EMISSAO  >= '"+DTOS(mv_par01)+"' "
_cQry += " AND SD1.D1_EMISSAO  <= '"+DTOS(mv_par02)+"' "
_cQry += " ORDER BY SD1.D1_EMISSAO, SD1.D1_CC "

//alert(_cQry)

TCQuery _cQry ALIAS "TBTMP" NEW

_aStruSD1:= SD1->(dbStruct())

For _nX := 1 To Len(_aStruSD1)  //--> trata os campos tipo data e numerico
	If _aStruSD1[_nX,2] $ "DN"
		TcSetField("TBTMP",_aStruSD1[_nX,1],_aStruSD1[_nX,2],_aStruSD1[_nX,3],_aStruSD1[_nX,4])
	EndIf
Next nX

_cArqTmp := CriaTrab(NIL,.F.)
_cArqDbf := _cArqTmp+".DBF"
_cArqInd := _cArqTmp+".CDX"

Copy To &_cArqTmp VIA "DBFCDXADS"

dbselectarea("TBTMP")
dbCloseArea()

dbUseArea(.T.,"DBFCDXADS",_cArqTMP,"TBTMP",.T.)
//index on &_cOrdInd TO &_cArqInd
//SET INDEX TO &_cArqInd
dbgotop()

_cCodCC     := TBTMP->D1_CC
_dDtEmissao := TBTMP->D1_EMISSAO

if reccount() > 0
	
	SetRegua(RecCount())
	dbGoTop()
	
	While !EOF()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		procregua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
				
		IF _lCC = .T.
			//==========================================================================
			dbselectarea("CTT")   //--> Captura a descrição do Centro de Custo
			dbsetorder(1)
			dbgotop()
			
			_cCCusto :=  ""
			
			if dbseek(xfilial("CTT")+TBTMP->D1_CC,.f.)
				_cCCusto := CTT_DESC01
				_lCC = .F.
			Endif
			//==========================================================================
		ENDIF
		
		//==========================================================================
		dbselectarea("SB1")   //--> Captura a descrição do Produto
		dbsetorder(1)
		dbgotop()
		
		_cProduto :=  ""
		
		if dbseek(xfilial("SB1")+TBTMP->D1_COD,.f.)
			_cProduto := B1_DESC
		Endif
		
		dbselectarea("TBTMP")  //--> seleciona a area temporaria.
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		//                      " Dt.Emissao Nr. PC Produto                                                      Un     Quant.   Pc. Unitario      Vl. Total"
		//                        99/99/9999 XXXXXX aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa XX 999,999.99 999,999,999.99 999,999,999.99
		//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//                                 1         2         3         4         5         6         7         8         9         100       110       120
		//                                                                                                                  __________________________________
		//                                                                                                                   TOTAL DO PERIODO: 999,999,999.99
		  
		IF _lImpCC = .T.
		  @ nLin,0 PSAY "Centro de Custo: " + ALLTRIM(_cCodCC) + " - " +_cCCusto
		  _lImpCC := .F.
		  nLin := nLin + 1 // Avanca a linha de impressao
		ENDIF
		
		IF _lImpDE = .T.
		  @ nLin,001 PSAY D1_EMISSAO
		  _lImpDE := .F.
		ENDIF
		@ nLin,012 PSAY D1_PEDIDO
		@ nLin,019 PSAY _cProduto
		@ nLin,080 PSAY D1_UM
		@ nLin,083 PSAY D1_QUANT PICTURE "@E 999,999.99"
		@ nLin,094 PSAY D1_VUNIT PICTURE "@E 999,999,999.99"
		@ nLin,109 PSAY D1_TOTAL PICTURE "@E 999,999,999.99"
		
		_nVlTCC  := _nVlTCC + D1_TOTAL
		_nVlTot  := _nVlTot + D1_TOTAL
		
		dbselectarea("TBTMP")
		dbSkip() 		// Avanca o ponteiro do registro no arquivo
		
		IF TBTMP->D1_CC <> _cCodCC 
          @ nLin+1,091 PSAY "__________________________________"
	      @ nLin+2,092 PSAY "TOTAL DO C.CUSTO:"
	      @ nLin+2,109 PSAY _nVlTCC PICTURE "@E 999,999,999.99"
		  nLin := nLin + 2 // Avanca a linha de impressao
		  _cCodCC := TBTMP->D1_CC
		  _lCC    := .T.   
		  _lImpCC := .T.
		  _lImpDE := .T.
		  _nVlTCC := 0
		ENDIF    
		
		IF TBTMP->D1_EMISSAO <> _dDtEmissao 
		  _dDtEmissao := TBTMP->D1_EMISSAO
		  _lImpDE := .T.
		ENDIF    
		
		
	EndDo
	
	@ nLin+1,091 PSAY "__________________________________"
	@ nLin+2,092 PSAY "TOTAL DO PERIODO:"
	@ nLin+2,109 PSAY _nVlTot PICTURE "@E 999,999,999.99"
	
Else
	
	alert("!! Nao existe dados para imprimir !!")
	
Endif

If select("TBTMP") > 0
	TBTMP->(dbCloseArea())
	DELE FILE &_cArqDbf
	DELE FILE &_cArqInd
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

setpgeject(.F.)

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return



///////////////////////////////
///////////////////////////////
Static Function CriaPerg(cPerg)
///////////////////////////////
///////////////////////////////
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0

if alltrim(upper(cVersao)) == "P10"
	cPerg := PADR(cPerg,10)
Else
	cPerg := PADR(cPerg,6)
Endif

aRegistros:={}
//                                                                          1                                                                    2                                               3                                      4
//               1     2    3                      4   5   6        7   8 9 0 1   2  3          4                5  6  7  8  9                   0  1  2  3  4         5  6  7  8  9             0  1  2  3  4         5  6  7  8    9  0  1  2  3
AADD(aRegistros,{cPerg,"01","Da Data            ?",".",".","mv_ch1","D",08,0,0,"G","","mv_par01","              ","","","","",""                 ,"","","","",""       ,"","","","",""           ,"","","","",""       ,"","","","  ","","","","",""})
AADD(aRegistros,{cPerg,"02","Ate a Data         ?",".",".","mv_ch2","D",08,0,0,"G","","mv_par02","              ","","","","",""                 ,"","","","",""       ,"","","","",""           ,"","","","",""       ,"","","","  ","","","","",""})
//AADD(aRegistros,{cPerg,"01","Data Inicio        ?",".",".","mv_ch1","D",08,0,0,"G","","mv_par01","              ","","","","",""                 ,"","","","",""       ,"","","","",""           ,"","","","",""       ,"","","","  ","","","","",""})
//AADD(aRegistros,{cPerg,"02","Data Fim           ?",".",".","mv_ch2","D",08,0,0,"G","","mv_par02","              ","","","","",""                 ,"","","","",""       ,"","","","",""           ,"","","","",""       ,"","","","  ","","","","",""})
//AADD(aRegistros,{cPerg,"03","Modulo             ?",".",".","mv_ch3","N",01,0,0,"C",""                      ,"mv_par03","Modulo Atual   ","","","","","Todos Modulos   ","","","","","DATABASE Compl." ,"","","","",""             ,"","","","","","","","","  ","","","",""})
//AADD(aRegistros,{cPerg,"04","Operacao           ?",".",".","mv_ch4","N",01,0,0,"C",""                      ,"mv_par04","Exportar"       ,"","","","","Importar"        ,"","","","","Informacao"      ,"","","","","Corrigir Num.","","","","","","","","","  ","","","",""})
//AADD(aRegistros,{cPerg,"05","Considera arq. vazio",".",".","mv_ch5","N",01,0,0,"C",""                      ,"mv_par05","Sim    "        ,"","","","","Nao"             ,"","","","","       "         ,"","","","",""             ,"","","","","","","","","  ","","","",""})


dbSelectArea("SX1")
dbsetorder(1)

For i := 1 to Len(aRegistros)
	dbgotop()
	dbSeek(aRegistros[i,1]+aRegistros[i,2])
	if eof()
		if RecLock("SX1",.T.)
			For j:=1 to 42
				FieldPut(j,aRegistros[i,j])
			Next
			MsUnlock()
		Endif
	Endif
Next i

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

Return(nil)
