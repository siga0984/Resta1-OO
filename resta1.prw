#INCLUDE "PROTHEUS.CH"

/* -----------------------------------------------------
Programa      Resta 1 - executor
Autor         Flavio Luiz Vicco
Data          11/2016
----------------------------------------------------- */

User Function Resta1()
	Local oDlg
	Local oResta1
	DEFINE DIALOG oDlg TITLE "Resta1" From 180,180 TO 550,700 PIXEL COLOR CLR_BLACK,CLR_WHITE
		oDlg:lEscClose := .F.
		//-- Inicia Resta1
		oResta1:= TResta1():New(oDlg)
		//-- Cria Menu superior
		CreateMenuBar(oDlg,oResta1)
		//-- Cria Barra de Status inferior
		CreateMsgBar(oDlg)
	ACTIVATE DIALOG oDlg CENTERED ON INIT oResta1:Activate()
Return Nil

Static Function CreateMenuBar(oDlg,oResta1)
	oTMenuBar:= TMenuBar():New(oDlg)
	oTMenuBar:SetCss("QMenuBar{background-color:#eeeddd;}")
	oTMenuBar:Align     := CONTROL_ALIGN_TOP
	oTMenuBar:nClrPane  := RGB(238,237,221)
	oTMenuBar:bRClicked := {||}
	oFile:= TMenu():New(0,0,0,0,.T.,,oDlg)
	oHelp:= TMenu():New(0,0,0,0,.T.,,oDlg)
	oTMenuBar:AddItem("&Arquivo",oFile,.T.)
	oTMenuBar:AddItem("Aj&uda"  ,oHelp,.T.)
	oFile:Add(TMenuItem():New(oDlg,"&Novo Jogo",,,,{|| oResta1:NewGame()},,"",,,,,,,.T.))
	oFile:Add(TMenuItem():New(oDlg,"Sai&r",,,,{|| If(MsgYesNo("Deseja realmente sair do jogo?"),oDlg:End(),)},,"FINAL",,,,,,,.T.))
	oHelp:Add(TMenuItem():New(oDlg,"&Sobre...        F1",,,,{|| oResta1:Help() },,"RPMPERG",,,,,,,.T.))
Return

Static Function CreateMsgBar(oDlg)
  oTMsgBar := TMsgBar():New(oDlg, "Resta1",.F.,.F.,.F.,.F., RGB(116,116,116),,,.F.) 
  oTMsgItem1 := TMsgItem():New( oTMsgBar,"2014", 100,,,,.T., {||} )       
  oTMsgItem2 := TMsgItem():New( oTMsgBar,"V.1.00", 100,,,,.T., {||MSgStop("Click na barra de status")} )
Return


//----------------------------------------------------------------------------

