#INCLUDE "PROTHEUS.CH"

/* -----------------------------------------------------
Programa      Resta 1 - objetos
Autor         Flavio Luiz Vicco
Data          11/2016
----------------------------------------------------- */

//-----------------------------------------
// Define que o FwBalloon será informativo
//-----------------------------------------
#Define FW_BALLOON_WARNING 1
#Define FW_BALLOON_ERROR 2
#Define FW_BALLOON_INFORMATION 3 
#Define FW_BALLOON_CONTAINER 4
//---------------------------------------------------------
// Define o layout do FwBalloon de acordo com sua posição
//---------------------------------------------------------
#Define BALLOON_POS_NONE          00
#Define BALLOON_POS_TOP_LEFT      01
#Define BALLOON_POS_TOP_MIDDLE    02
#Define BALLOON_POS_TOP_RIGTH     03
#Define BALLOON_POS_BOTTOM_LEFT   04
#Define BALLOON_POS_BOTTOM_MIDDLE 05
#Define BALLOON_POS_BOTTOM_RIGTH  06
#Define BALLOON_POS_LEFT_TOP      07
#Define BALLOON_POS_LEFT_MIDDLE   08
#Define BALLOON_POS_LEFT_BOTTOM   09
#Define BALLOON_POS_RIGTH_TOP     10
#Define BALLOON_POS_RIGTH_MIDDLE  11
#Define BALLOON_POS_RIGTH_BOTTOM  12

Class TResta1
	Data nId     AS INTEGER
	Data nOrigem AS INTEGER
	Data aShape  AS ARRAY INIT {}
	DATA oTPanel AS OBJECT
	Method New(oTPanel) CONSTRUCTOR
	Method Activate()
	Method NewGame()
	Method Create()
	Method Click( x, y, oTPanel )
	Method Change( oTPanel, nItem, nStatus )
	Method SetId()
	Method DirectoryImg()
	Method ExportImage()
	Method Help()
EndClass

Method New(oDlg) Class TResta1
	::nId     := 0
	::nOrigem := 0
	::aShape  := {}
	::oTPanel:= TPaintPanel():new(0,0,0,0,oDlg,.f.)
	::oTPanel:Align := CONTROL_ALIGN_ALLCLIENT
	::oTPanel:bLClicked := {|x,y| ::Click()}
	::ExportImage()
Return Self

Method Activate() Class TResta1
	Local nX   := 0
	Local nY   := 0
	Local nZ   := 0
	Local cImg := "backg.png"
	Local cId  := ""
	//-- Tamanho da tabuleiro
	cTabLarg := cValToChar(400)
	cTabAlt  := cValToChar(450)
	//-- Ajusta tela conforme tabuleiro
	::oTPanel:oWnd:nHeight := Val(cTabAlt)
	::oTPanel:oWnd:nWidth  := Val(cTabLarg)
	//-- Altura largura do tabuleiro
	cAltura  := '0'
	cLargura := '0'
	//-- Cria Container
	::oTPanel:addShape(	"id="+::SetId()+";type=1;left=0;top=0;width="+cValToChar(Val(cTabLarg))+;
										 	";height="+cValToChar(Val(cTabAlt))+";"+;
											"gradient=1,0,0,0,0,0.0,#FFFFFF;pen-width=0;pen-color=#FFFFFF"+;
											";can-move=0;can-mark=0;is-container=1;")
	//-- Cria shape com imagem do tabuleiro
	cId := ::SetId()
	::oTPanel:addShape(	"id="+cId+";type=8;left="+cLargura+";top="+cAltura+";width="+cTabLarg+;
											";height="+cTabAlt+";image-file="+::DirectoryImg()+cImg+";tooltip=Resta1"+;
											";can-move=0;can-deform=0;can-mark=0;is-container=1")
	For nX := 1 To 7
		For nY := 1 To 7
			nZ ++
			If !StrZero(nZ,2) $ "01|02|06|07|08|09|13|14|36|37|41|42|43|44|48|49"
				::Create( ::oTPanel, nX, nY, "P"+StrZero(nZ,2), IIf(nZ==25,0,1) )
			EndIf
		Next nY
	Next nX
Return

Method NewGame() Class TResta1
	Local nX   := 0
	Local nY   := 0
	Local nZ   := 0
	For nZ := 1 To Len(::aShape)
		nX := ::aShape[nZ,3]
		nY := ::aShape[nZ,4]
		If	::aShape[nZ,5] <> IIf(nX==4.And.nY==4,0,1)
			::Change( ::oTPanel, nZ, IIf(nX==4.And.nY==4,0,1 ) )
		EndIf
	Next nZ
Return

Method Create( oPanel, nImgX, nImgY, cCodigo, nStatus, nShape, cImgId ) Class TResta1
	Local cWidth   := "30"
	Local cHeight  := "30"
	Local cImg     := ""
	Local cToolTip := AllTrim(cCodigo)+" X= "+AllTrim(Str(nImgX))+" Y= "+AllTrim(Str(nImgY))
	Default nShape := 0
	Default cImgId := ::SetId()
	//-- Define imagem
	Do Case
		Case nStatus == 0
			cImg := "empty.png"
		Case nStatus == 1
  			cImg := "full.png"
  		Case nStatus == 2
	  		cImg := "select.png"
	EndCase
	//-- criacao do obj
	If	nShape == 0
		aAdd(::aShape,Array(5))
		nShape := Len(::aShape)
	EndIf
	//-- config. do obj
	::aShape[nShape,1] := Val(cImgId) //CODIGO DO SHAPE
	::aShape[nShape,2] := cCodigo     //CODIGO
	::aShape[nShape,3] := nImgX       //POSICAO X
	::aShape[nShape,4] := nImgY       //POSICAO Y
	::aShape[nShape,5] := nStatus     //STATUS

	oPanel:addShape("id="+cImgId+";type=8;left="+Str(nImgY*45)+;
									";top="+Str(nImgX*45)+";width="+cWidth+";height="+cHeight+;
									";image-file="+::DirectoryImg()+cImg+";tooltip="+cToolTip+;
									";can-move=0;can-deform=1;can-mark=0;is-container=0")
Return

Method Click() Class TResta1
	Local nDestino := 0
	Local nSalto   := 0
	Local nIdImg   := 0
	Local nX       := 0
	Local nY       := 0
	Local nIdClk   := 0
	Local nStatus  := 0
	Local lOk      := .F.

	//-- Identifica obj. shape clicado.
	nDestino := aScan(::aShape,{ |x|(x[1] == ::oTPanel:ShapeAtu)})
	If	nDestino > 0
		nStatus := ::aShape[nDestino,5]
		Do Case
			Case nStatus == 0
				If	::nOrigem > 0
					nX0 := ::aShape[::nOrigem ,3]
					nY0 := ::aShape[::nOrigem ,4]
					nX1 := ::aShape[  nDestino,3]
					nY1 := ::aShape[  nDestino,4]
					//-- Verifica se movimento horizontal valido...
					If	(nX0 == nX1 .And. Abs(nDif := nY0 - nY1) == 2)
						If	nDif == 2
							nDif := -1
						Else
							nDif := 1
						EndIf
						lOk := (nSalto:=aScan(::aShape,{|x| x[3]==nX0 .And. x[4]==nY0+nDif .And. x[5]==1})) > 0
					EndIf
					//-- Verifica se movimento vertical valido...
					If	(nY0 == nY1 .And. Abs(nDif := nX0 - nX1) == 2)
						If	nDif == 2
							nDif := -1
						Else
							nDif := 1
						EndIf
						lOk := (nSalto:=aScan(::aShape,{|x| x[3]==nX0+nDif .And. x[4]==nY0 .And. x[5]==1})) > 0
					EndIf
					If	lOk
						nStatus := 1
						//-- Retira da posicao saltada
						::Change( ::oTPanel, nSalto, 0 )
						//-- Retira da posicao anterior
						::Change( ::oTPanel, ::nOrigem, 0 )
						::nOrigem := 0
					EndIf
				EndIf
			Case nStatus == 1
				If	::nOrigem > 0
					//-- Retira da posicao anterior
					::Change( ::oTPanel, ::nOrigem, 1 )
				EndIf
				nStatus  := 2
				::nOrigem:= nDestino
				lOk      := .T.
			Case nStatus == 2
				nStatus  := 1
				::nOrigem:= 0
				lOk      := .T.
		EndCase
		//-- Troca figura da posicao atual
		If	lOk
			::Change( ::oTPanel, nDestino, nStatus )
		EndIf
	EndIf
Return

//-- Realiza uma mudança de status de um elemento ( pedra ) do jogo 
Method Change( oTPanel, nItem, nStatus ) Class TResta1
	Local nIdImg  := 0
	Local cCodigo := ""
	Local nX      := 0
	Local nY      := 0
	nIdImg  := ::aShape[nItem,1]
	cCodigo := ::aShape[nItem,2]
	nX      := ::aShape[nItem,3]
	nY      := ::aShape[nItem,4]
	//-- Excluir shape com status anterior
	::oTPanel:DeleteItem(nIdImg)
	//-- Recriar shape com status atual
	::Create( ::oTPanel, nX, nY, cCodigo, nStatus, nItem, Str(nIdImg) )
Return

//-- CRia identificador sequencial para objetos
Method SetId() Class TResta1
Return cValToChar(++::nId)

//-- Define que as imagens estarão na pasta temporária do usuário
Method DirectoryImg() Class TResta1
Return GetTempPath()

//-- Exporta as imagens do RPO para o temporario %TEMP%
Method ExportImage() Class TResta1
	Local aImage := { "backg.png" , "empty.png" , "full.png" , "select.png" }
	Local nImage, cImageTo
	For nImage := 1 To Len(aImage)
		cImageTo := ::DirectoryImg()+aImage[nImage]
		If !Resource2File(aImage[nImage],cImageTo)
			MsgStop("Image not found: " + aImage[nImage])
			__QUIT()
		EndIf
	Next nImage
Return

Method Help() Class TResta1
	MsgInfo( "Resta1 em ADVPL.","Bem Vindo!")
Return
