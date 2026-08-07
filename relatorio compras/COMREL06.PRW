#include 'protheus.ch'
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ FISMIS06 บ Autor ณ  Reginaldo Pereira บ Data ณ 03/02/21    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Imprimir espelho nota de entrada                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Data     ณ            Modifica็๕es / Autor                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  /  /    ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COMREL06

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aAreaS := Getarea()
Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := "Espelho de Documento"
Local titulo := "Espelho de Documento"
Local nLin := 200

Local Cabec1 := ""
Local Cabec2 := ""
Local aOrd := {}
Private lEnd := .F.
Private lAbortPrint := .F.
Private CbTxt := ""
Private limite := 80
//Private limite       := 132
Private tamanho := "G"
//Private tamanho      := "M"
Private nomeprog := "COMREL06" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo := 18
Private aReturn := {"Zebrado" , 1 , "Administracao", 2 , 2 , 1 , "" , 1}
Private nLastKey := 0
Private cPerg := "COMREL06"
Private _lTp  := "U"
Private cbcont := 00
Private m_pag := 01
Private wnrel := "COMREL06" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SE2"

DbSelectArea("SE2")
DbSetOrder(1)

//AjustaSX1(cPerg)
//Pergunte(cPerg,.f.)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| ImpDoc(Cabec1,Cabec2,Titulo,nLin,_lTp)},Titulo)

RestArea(_aAreaS)

Return .t.


Static Function ImpDoc(Cabec1,Cabec2,Titulo,nLin,_lTp)
**************************************************************
LOCAL cRodaTxt := oemtoansi("Origem: sigacom ")
Local cUserName:= UsrRetName(RetCodUsr())

		If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Return
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			
			/*
			1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
			01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			Codigo Fornecedor Prf Documento Valor Emissao Digita็ใo Vencto Natureza C. Custo Cta Cred Conta Deb
			xxxxxx xxxxxxxxxxxxxxxxxxxx xxx 123456789 9.999.999,99 99/99/99 99/99/99 99/99/99 1234567890 xxxxxxxxx 210100001 xxxxxxxxx
			*/
			Titulo := 'Espelho de Lan็amento de Doc. de Entrada'
			Cabec1 := ""//'Codigo      Fornecedor      Prf Documento    Valor     Emissao        Digita็ใo      Vencto'
			//Cabec1 :='Codigo      Fornecedor      Prf   Titulo     Valor     Emissao   Vencto  Digita็ใo  Natureza  C. Custo  Cta Cred  Conta Deb '
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,00 PSAY "Fornecedor   - "+ SF1->F1_FORNECE//SE2->E2_FORNECE
		nLin := nLin + 1
		@nLin,00 PSAY "Razใo Social - "+ Posicione( 'SA2' ,1, xFilial( 'SA2' )+SF1->F1_FORNECE, 'A2_NOME' )//SE2->E2_NOMFOR
		nLin := nLin + 1
		@nLin,00 PSAY "Serie        - "+SF1->F1_SERIE
		nLin := nLin + 1
		@nLin,00 PSAY "Nota fiscal  - "+SF1->F1_DOC//SE2->E2_NUM
		nLin := nLin + 1
		@nLin,00 PSAY "Valor        - "+TRANSFORM(SF1->F1_VALBRUT,"@E 9,999,999.99")
		nLin := nLin + 1
		@nLin,00 PSAY "Emisใo       - "+Dtoc(SF1->F1_EMISSAO)
		nLin := nLin + 1
		@nLin,00 PSAY "Digita็ใo    - "+Dtoc(SF1->F1_DTDIGIT)
		nLin := nLin + 5
		
		
		
		
		@nLin,00 PSAY "Dados Financeiro "
		nLin := nLin + 1

		@nLin,00 PSAY "Parcela"
		@nLin,08 PSAY "Vencimento"
		@nLin,19 PSAY "Natureza"
		@nLin,70 PSAY "Valor"


		nLin := nLin + 1

		_cQuery := " Select E2_PREFIXO AS Prefixo, E2_NUM AS Doc, E2_PARCELA AS Parc, E2_TIPO AS Tipo, E2_FORNECE AS Fornecedor, E2_LOJA AS Loja, * "
		_cQuery += " From "+RETSQLNAME( 'SE2' )+ " SE2 "
		_cQuery += " Where E2_FILIAL = '"+xFilial("SF1")+"'
		_cQuery += " AND E2_NUM = '"+SF1->F1_DOC+"' AND E2_FORNECE = '"+SF1->F1_FORNECE+"' AND E2_LOJA = '"+SF1->F1_LOJA+"' "
		_cQuery += " AND D_E_L_E_T_ = ' ' "
		DbUseArea(.T., 'TOPCONN' ,TCGenQry(,,_cQuery), 'TRB' ,.F.,.T.)
		DBSelectArea("TRB")
		While !TRB->(Eof())       
			_cCta := Posicione( 'SED' ,1, xFilial( 'SED' )+TRB->E2_NATUREZ, 'ED_CONTA' )				
		
			@nLin,00 PSAY TRB->E2_PARCELA
			@nLin,08 PSAY Stod(TRB->E2_VENCTO)
			@nLin,19 PSAY Posicione( 'SED' ,1, xFilial( 'SED' )+TRB->E2_NATUREZ, 'ED_DESCRIC' )
			@nLin,68 PSAY TRANSFORM(TRB->E2_VALOR,"@E 9,999,999.99")
			nLin := nLin + 1
			TRB->(Dbskip())
		Enddo
		TRB->(DbcloseArea())
		
		nLin := nLin + 4

		@nLin,00 PSAY "Itens da Nota"
		nLin := nLin + 1
		
		@nLin,00 PSAY "Produto"
		@nLin,50 PSAY "C.Custo"
		@nLin,99 PSAY "Grp.CTB"
		@nLin,110 PSAY "Ct. Credito"
		@nLin,135 PSAY "Ct. Debito"
		nLin := nLin + 1
		
		_cQuery:= ""
		_cQuery:= " SELECT * FROM "+RETSQLNAME( 'SD1' )+ " SD1  WHERE D1_DOC = '"+SF1->F1_DOC+"' " 
		_cQuery+= " AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' " 
		_cQuery+= " AND D1_FILIAL  = '"+xFilial("SF1")+"' AND D_E_L_E_T_ <> '*'"
		DbUseArea(.T., 'TOPCONN' ,TCGenQry(,,_cQuery), 'TRB' ,.F.,.T.)

		DBSelectArea ('TRB')
		while !TRB->(eof())
			@nLin,00 PSAY Alltrim(TRB->D1_COD) +'-'+Posicione( 'SB1' ,1, xFilial( 'SB1' )+TRB->D1_COD, 'B1_DESC' )
			@nLin,50 PSAY TRB->D1_CC  +'-'+Posicione( 'CTT' ,1, xFilial( 'CTT' )+TRB->D1_CC, 'CTT_DESC01' )
			@nLin,99 PSAY  Posicione( 'SB1' ,1, xFilial( 'SB1' )+TRB->D1_COD, 'B1_GRPCTB' )
			@nLin,110 PSAY  Alltrim('211010001') +'-'+ Posicione('CT1',1, xFilial( 'CT1' )+ '211010001','CT1_DESC01' )
		
			_cGrpTrib:= Posicione( 'SB1' ,1, xFilial( 'SB1' )+TRB->D1_COD,'B1_GRPCTB' )
			_cCtCus  := Posicione( 'SZ3' ,1, xFilial( 'SZ3' )+_cGrpTrib, 'Z3_CTCUSTO' )
			_cCtDes  := Posicione( 'SZ3' ,1, xFilial( 'SZ3' )+_cGrpTrib, 'Z3_CTDESP' )
			_cPedido := TRB->D1_PEDIDO
		
			If Substr(_cCtCus,1,3) $ "101/303" .AND. SM0->M0_CODIGO <> '08'
		  		@nLin,135 PSAY  Alltrim(_cCtDes)+"-"+Posicione( 'CT1' ,1, xFilial( 'CT1' )+_cCtDes , 'CT1_DESC01' )
		  		else
		  		@nLin,135 PSAY  Alltrim(_cCtCus)+"-"+Posicione( 'CT1' ,1, xFilial( 'CT1' )+_cCtCus , 'CT1_DESC01' )	
            Endif
		    If SM0->M0_CODIGO $ "08/09"
		  		@nLin,135 PSAY  Alltrim(_cCtCus)+"-"+Posicione( 'CT1' ,1, xFilial( 'CT1' )+_cCtDes , 'CT1_DESC01' )
			Endif		
			nLin := nLin + 1
			TRB->(dbSkip())
		Enddo
		TRB->(DbcloseArea())
		
		nLin := nLin + 2

		_cQuery:= ""
		_cQuery:= "SELECT TOP(1) C7_OBS FROM SC7010 WHERE C7_NUM ='"+_cPedido+"' AND C7_FILIAL = '"+xFilial("SF1")+"' AND  D_E_L_E_T_ <> '*'"  "
		DbUseArea(.T., 'TOPCONN' ,TCGenQry(,,_cQuery), 'TRB' ,.F.,.T.)

        DbSelectArea("TRB")
		while !TRB->(Eof())
			@nLin,00 PSAY 'Historico : ' +Substr(TRB->C7_OBS,1,70)
	    	TRB->(dbSkip())
		end
		TRB->(DbcloseArea())
    
		nLin := nLin + 5
		
		
		
		@nLin,08 PSAY     cUserName+'--------------------  --------------------'
		nLin := nLin + 1
		@nLin,08 PSAY '   Lan็ado por           Aprovado por          Recebido por     '
		
		nLin := nLin + 1
		
	
	
	
	   @nLin+3,00 PSAY cRodaTxt
	
	   Roda(0, ' ' ,Tamanho)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif


MS_FLUSH()

Return


