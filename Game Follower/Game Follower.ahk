#SingleInstance Force
#Persistent
SetBatchLines, -1

DetectHiddenWindows, On
settimer, configcheck, 250
settimer, guicheck

SetNumLockState, On

CloseOtherScript()

IniRead, hk1, Config.ini, Start Hotkey, hotkey
IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
IniRead, hk3, Config.ini, Hotkey/Retry Hotkey, hotkey
IniRead, hk4, Config.ini, Exit Hotkey, hotkey
IniRead, value, Config.ini, Transparent, value

Hotkey %hk1%, Follow
Hotkey %hk2%, Coordinates
Hotkey %hk3%, Config
Hotkey %hk4%, Exit

FirstRun=0
RunCount=0
info=1

Gui 1: +LastFound +OwnDialogs +AlwaysOnTop
Gui 1: Font, s11
Gui 1: font, bold
Gui 1: Add, Button, x5 w210 gFollow, Start Game Follower
Gui 1: Add, Button, x5 y42 w100 gCoordinates, Coordinates
Gui 1: Add, Button, x115 y42 w100 gConfig, Hotkeys 
Gui 1: Add, Button, x5 y72 w100 gInfo, Information
Gui 1: Add, Button, x115 y72 w100 gExit, Exit
Menu, Tray, Icon, %A_ScriptDir%\D2R.ico
WinSet, Transparent, %value%
Gui 1: Show, w225 h110, Main Menu

hIcon := DllCall("LoadImage", uint, 0, str, "D2R.ico"
   	, uint, 1, int, 0, int, 0, uint, 0x10)
SendMessage, 0x80, 0, hIcon
SendMessage, 0x80, 1, hIcon

OnMessage(0x0201, "WM_LBUTTONDOWN")
WM_LBUTTONDOWN() {
	If (A_Gui)
		PostMessage, 0xA1, 2
}
return

CloseOtherScript()
{
	WinGet, hWndList, List, Main Menu
	
	Loop, %hWndList%
	{
		hWnd := hWndList%A_Index%
		WinClose, % "ahk_id " hWnd
	}
}

CheckPOS() {
	allowedWindows := "|Main Menu|Game Follow|Normal|Nightmare|Hell|"
	
	WinGetTitle, activeWindowTitle, A
	
	if (InStr(allowedWindows, "|" activeWindowTitle "|") <= 0) {
		return
	}

	WinGetPos, GUIx, GUIy, GUIw, GUIh, A
	xmin := GUIx
	xmax := GUIw + GUIx
	ymin := GUIy
	ymax := GUIh + GUIy
	xadj := A_ScreenWidth - GUIw
	yadj := A_ScreenHeight - GUIh
	WinGetPos, X, Y,,, A    
	
	if (xmin < 0) {
		WinMove, A,, 0
	}
	if (ymin < 0) {
		WinMove, A,,, 0
	}
	if (xmax > A_ScreenWidth) {
		WinMove, A,, xadj    
	}
	if (ymax > A_ScreenHeight) {
		WinMove, A,,, yadj
	}
}	
		
	guicheck:
	checkpos()
	return
	
	DisableHotkey(disable := true) {
		IniRead, hk1, Config.ini, Start Hotkey, hotkey
		IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
		IniRead, hk3, Config.ini, Hotkey/Retry Hotkey, hotkey
		IniRead, hk4, Config.ini, Exit Hotkey, hotkey
		Hotkey, %hk1%, off	
		Hotkey, %hk2%, off
		Hotkey, %hk3%, off
		Hotkey, %hk4%, off
	}
	
	EnableHotkey(enable := true) {
		IniRead, hk1, Config.ini, Start Hotkey, hotkey
		IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
		IniRead, hk3, Config.ini, Hotkey/Retry Hotkey, hotkey
		IniRead, hk4, Config.ini, Exit Hotkey, hotkey
		Hotkey, %hk1%, on	
		Hotkey, %hk2%, on
		Hotkey, %hk3%, on
		Hotkey, %hk4%, on
	}
	
	ConfigError(){		
		IniRead, x1, Config.ini, Game Name, xmin
		IniRead, x2, Config.ini, Game Name, xmax
		IniRead, y1, Config.ini, Game Name, ymin
		IniRead, y2, Config.ini, Game Name, ymax
		if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
		{
			Run %A_ScriptDir%\Config.ini
			GuiControl,,ScriptRed, CONFIG		
			GuiControl,,State2, ERROR
			MsgBox, 4112, Config Error, Please enter valid coordinates in the Config for [Game Name].
			reload
		}
		
		IniRead, x1, Config.ini, Save & Exit, xmin
		IniRead, x2, Config.ini, Save & Exit, xmax
		IniRead, y1, Config.ini, Save & Exit, ymin
		IniRead, y2, Config.ini, Save & Exit, ymax
		if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
		{
			Run %A_ScriptDir%\Config.ini
			GuiControl,,ScriptRed, CONFIG		
			GuiControl,,State2, ERROR
			MsgBox, 4112, Config Error, Please enter valid coordinates in the Config for [Save & Exit].
			reload
		}
	}
	
	ConfigCheck:
	{
		IniRead, hk1, Config.ini, Start Hotkey, hotkey
		IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
		IniRead, hk3, Config.ini, Hotkey/Retry Hotkey, hotkey
		IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	}
	
	return
	Coordinates:
	Gui 1: Hide
	Gui 2: +LastFound +OwnDialogs +AlwaysOnTop
	Gui 2: Font, s11 Bold
	DisableHotkey()
	
	IniRead, allContents, Config.ini
	excludedSections := "|start hotkey|exit hotkey|hotkey/retry hotkey|coordinates/reload hotkey|gui pos|transparent|"
	
	sectionList := " ***** Make a Selection ***** "
	
	Loop, Parse, allContents, `n
	{
		currentSection := A_LoopField
		
		if !InStr(excludedSections, "|" currentSection "|")
			sectionList .= "|" currentSection
	}
	
	Gui, 2: Add, DropDownList, w230 vSectionList Choose1 gDropDownChanged, % sectionList
	Gui, 2: Add, Button, w230 gClose, Close
	WinSet, Transparent, %value%
	Gui, 2: Show, w250 h45 Center, Coordinates
	Gui 2: -Caption
	return
	
	Close:
	Gui 2: Destroy
	Gui 1: Show
	EnableHotkey()
	return
	
	DropDownChanged:
	GuiControlGet, selectedSection,, SectionList
	
	if (selectedSection != " ***** Make a Selection ***** ")
		GoSub, ButtonClicked
	
	return
	
	ButtonClicked:
Gui, 2: Hide

WinActivate, Diablo II: Resurrected

ClickCount := 0
xmin := ""
ymin := ""
xmax := ""
ymax := ""

ButtonText := selectedSection

SetTimer, CheckClicks, 10

Gui 11: +AlwaysOnTop +OwnDialogs
Gui 11: Font, s16 bold
Gui 11: Add, Text, vTone , Right-click the top-left of the item you need the coordinates for
Gui 11: -caption
Gui 11: Show, NoActivate xcenter y5 w665 h45

return

CheckClicks:
if GetKeyState("RButton", "P")
{	
	MouseGetPos, MouseX, MouseY
	ClickCount++
	if (ClickCount = 1)
	{
		Gui 11: destroy
		Gui 12: +AlwaysOnTop +OwnDialogs
		Gui 12: Font, s16 bold
		Gui 12: Add, Text, vTtwo , Right-click the bottom-right of the item you need the coordinates for
		Gui 12: -caption
		Gui 12: Show, NoActivate xcenter y5 w720 h45	
		
		xmin := MouseX
		ymin := MouseY
	}
	else if (ClickCount = 2)
	{
		Gui 12: destroy
		
		Gui 13: +AlwaysOnTop +OwnDialogs
		Gui 13: Color, Green
		Gui 13: Font, cWhite
		Gui 13: Font, s16 bold
		Gui 13: Add, Text, vTthree , Coordinates have been updated in the Config.ini file
		Gui 13: -caption
		Gui 13: Show, NoActivate xcenter y5 w565 h45
		
		xmax := MouseX
		ymax := MouseY
		SetTimer, CheckClicks, Off
		
		IniWrite, %xmin%, Config.ini, %ButtonText%, xmin
		IniWrite, %xmax%, Config.ini, %ButtonText%, xmax
		IniWrite, %ymin%, Config.ini, %ButtonText%, ymin
		IniWrite, %ymax%, Config.ini, %ButtonText%, ymax
		
		Sleep, 3000
		
		Gui 13: destroy
		Gui, 2: Destroy
		Gui, 1: Show
		
		EnableHotkey()	
	}
	
	Sleep, 250
}
return

~Esc::
IfWinActive, Coordinates
	GoSub, close
Else IfWinActive, Hotkeys
	GoSub, close2
Else
	Return
Return

Config:
Gui 1: Hide
Gui 4: +LastFound +OwnDialogs +AlwaysOnTop
Gui 4: Font, s11 Bold
DisableHotkey()

IniRead, allContents, Config.ini
excludedSections := "|Game name|Password|Create Game Tab|Save & Exit|Nightmare|Normal|Hell|gui pos|transparent|"

sectionList := " ***** Make a Selection ***** "

Loop, Parse, allContents, `n
{
		currentSection := A_LoopField
		
		if !InStr(excludedSections, "|" currentSection "|")
			sectionList .= "|" currentSection
	}
	
	Gui, 4: Add, DropDownList, w230 vSectionList Choose1 gDropDownChanged2, % sectionList
	Gui, 4: Add, Text, w230 vHotkeysText, Hotkeys will be displayed here
	Gui, 4: Add, Hotkey, x100 y60 w75 vChosenHotkey gHotkeyChanged Center, ** NONE **
	Gui, 4: Add, Button, x10 y90 w230 gClose2, Close
	WinSet, Transparent, %value%
	Gui, 4: Show, w250 h100 Center, Hotkeys
	Gui 4: -Caption
	return
	
	Close2:
	Gui 4: Destroy
	Gui 1: Show
	EnableHotkey()
	return
	
	DropDownChanged2:
	GuiControlGet, selectedSection,, SectionList
	
	if (selectedSection != " ***** Make a Selection ***** ") {
		IniRead, existingHotkey, Config.ini, %selectedSection%, Hotkey
		GuiControl,, ChosenHotkey, %existingHotkey%
		GoSub, ButtonClicked2
	}
	
	return
	
	ButtonClicked2:
	GuiControl,, HotkeysText, Enter new hotkey
	GuiControl, Focus, ChosenHotkey
	return
	
HotkeyChanged:
IniWrite, %ChosenHotkey%, Config.ini, %selectedSection%, Hotkey
Gui, 4: Destroy

Loop, 50
{
	MouseGetPos, xm, ym
	Tooltip, Hotkey has been updated in the config file., %xm%+15, %ym%+15, 1
	Sleep, 25
}
Tooltip
Reload
return

Reload:
reload

Exit:
guiclose:
exitapp

Retry:
WinActivate, Diablo II: Resurrected

sleep 250

CoordMode, Mouse, Screen
IniRead, x1, Config.ini, Game Name, xmin
IniRead, x2, Config.ini, Game Name, xmax
IniRead, y1, Config.ini, Game Name, ymin
IniRead, y2, Config.ini, Game Name, ymax
Random, x, %x1%, %x2%
Random, y, %y1%, %y2%
Click, %x%, %y%

sleep 250

send {enter}

return

Follow:
if firstrun=0
{		
	Gui 1: Destroy
	Gui 2: Destroy
	
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, hk3, Config.ini, Hotkey/Retry Hotkey, hotkey
	IniRead, value, Config.ini, Transparent, value
	
	Hotkey %hk1%, Follow
	Hotkey %hk2%, Reload
	Hotkey %hk3%, Retry
	Hotkey %hk4%, Exit	
	
	++firstrun	
	ConfigError()
	DisableHotkey()
	
	InputBox, GN, Game Name, Please enter the current game/lobby name.`nName should be 15 characters or less.,,300,150
	
	if (GN = "")
	{
		MsgBox, 48, Name Too Short, Please enter a valid game name between 1-15 characters in length.
		reload
	}
	else if (StrLen(GN) >= 16)
	{
		MsgBox, 48, Name Too Long, Game name should be 15 characters or less.
		reload
	}
	
	if (!RegExMatch(GN, "\d"))
	{
		MsgBox, 48, Missing Game Number, Game name must contain at least one number.
		reload
	}
	
	RegExMatch(GN, "i)(.*?[^0-9]?)(\d+)$", match)
	
	if (ErrorLevel)
	{
		MsgBox, 48, Invalid Input, Unable to parse the game name.
		return
	}
	
	inputbox, Pass,Password,Please enter your lobby password.`nLeave blank for no password.,,300,150
	
	EnableHotkey()
	
	Gui 3: +LastFound +OwnDialogs +AlwaysOnTop
	Gui 3: Font, s11
	Gui 3: font, bold
	Gui 3: Add, Button, x5 y5 w210 gFollow, Join Next Game
	Gui 3: Add, Button, x5 y42 w100 gReload, Reload
	Gui 3: Add, Button, x115 y42 w100 gRetry, Retry
	Gui 3: Add, Button, x5 y72 w100 gInfo, Information
	Gui 3: Add, Button, x115 y72 w100 gExit, Exit
	Gui 3: font, cRed
	Gui 3: Add, Text, x5 y102 Center w210 vGameName, *** Game Name Not Set ***
	WinSet, Transparent, %value%
	Gui 3: Show, x0 y0 w225 h125, Game Follow
	
	IniRead, x, Config.ini, GUI POS, guix
	IniRead, y, Config.ini, GUI POS, guiy
	WinMove A, ,%X%, %y%
	
	baseName := match1
	numberPart := match2
	
	newNumber := numberPart + 1
	
	formattedNumber := Format("{:0" StrLen(numberPart) "}", newNumber)
	
	newGameName := baseName . formattedNumber
	
	GuiControl 3: , GameName,%gn%
	
	info=3
	
	return
}
	if firstrun=1
	{
		WinActivate, Diablo II: Resurrected
		
		++firstrun
		
		Gui 3: font, cBlack
		GuiControl 3: Font, GameName
		
		WinActivate, Diablo II: Resurrected
		
		GuiControl 3: , GameName, %newGameName%
		
		send {esc}
		
		sleep 1000
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Save & Exit, xmin
		IniRead, x2, Config.ini, Save & Exit, xmax
		IniRead, y1, Config.ini, Save & Exit, ymin
		IniRead, y2, Config.ini, Save & Exit, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
		
		sleep 2500
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Game Name, xmin
		IniRead, x2, Config.ini, Game Name, xmax
		IniRead, y1, Config.ini, Game Name, ymin
		IniRead, y2, Config.ini, Game Name, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
		
		sleep 250
		
		send ^{a}
		
		sleep 100
		
		send {delete}
		
		sleep 250
		
		send %newGameName%{tab}
		
		sleep 250
		
		send %pass%{enter}
		
		return
	}
	if firstrun=2
	{
		WinActivate, Diablo II: Resurrected
		
		RegExMatch(newgamename, "i)(.*?[^0-9]?)(\d+)$", match)
		
		if (ErrorLevel)
		{
			MsgBox, 48, Invalid Input, Unable to parse the game name.
			return
		}
		
		baseName := match1
		numberPart := match2
		
		newNumber := numberPart + 1
		
		formattedNumber := Format("{:0" StrLen(numberPart) "}", newNumber)
		
		newGameName := baseName . formattedNumber
		
		Gui 3: font, cBlack
		GuiControl 3: Font, GameName
		
		WinActivate, Diablo II: Resurrected
		
		GuiControl 3: , GameName, %newGameName%
		
		send {esc}
		
		sleep 1000
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Save & Exit, xmin
		IniRead, x2, Config.ini, Save & Exit, xmax
		IniRead, y1, Config.ini, Save & Exit, ymin
		IniRead, y2, Config.ini, Save & Exit, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
		
		sleep 2500
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Game Name, xmin
		IniRead, x2, Config.ini, Game Name, xmax
		IniRead, y1, Config.ini, Game Name, ymin
		IniRead, y2, Config.ini, Game Name, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
		
		sleep 250
		
		send ^{a}
		
		sleep 100
		
		send {delete}
		
		sleep 250
		
		send %newGameName%{enter}
		
		return
}
return

info:
IniRead, hk1, Config.ini, Start Hotkey, hotkey
IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
IniRead, hk3, Config.ini, Hotkey/Retry Hotkey, hotkey
IniRead, hk4, Config.ini, Exit Hotkey, hotkey
if (info=1){
	Gui 1: hide
	MsgBox, 4160, Information, 
(
|| Script Hotkeys ||
Start: %hk1%
Coordinates/Reload: %hk2%
Hotkey: %hk3%
Exit: %hk4%

Thank you for using my Diablo II: Resurrected AutoHotKey scripts, and for supporting free and open-source software. Reach out to Gubna on Discord if you are needing help with setup. - Gubna
)
	Gui 1: show
}
if (info=3){
	Gui 3: hide
	MsgBox, 4160, Information, 
(
|| Script Hotkeys ||
Start: %hk1%
Coordinates/Reload: %hk2%
Hotkey: %hk3%
Exit: %hk4%

Thank you for using my Diablo II: Resurrected AutoHotKey scripts, and for supporting free and open-source software. Reach out to Gubna on Discord if you are needing help with setup. - Gubna
)
	Gui 3: Show
}
return

!F4::
MsgBox, 36,Exit D2R?, Do you want to close Diablo II: Resurrected

IfMsgBox Yes
{
	winclose, Diablo II: Resurrected
}
    Else
    {
        return
}
return