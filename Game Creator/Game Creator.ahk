#SingleInstance Force
#Persistent
SetBatchLines, -1

DetectHiddenWindows, On

SetNumLockState, On

CloseOtherScript()

if !FileExist("Config.ini")
{
	Gui Error: +LastFound +OwnDialogs +AlwaysOnTo
	Gui Error: Font, S13 bold underline cRed
	Gui Error: Add, Text, Center w220 x5,ERROR
	Gui Error: Add, Text, center x5 w220,
	Gui Error: Font, s12 norm bold
	Gui Error: Add, Text, Center w220 x5, Config.ini not found
	Gui Error: Add, Text, center x5 w220,
	Gui Error: Font, cBlack
	Gui Error: Add, Text, Center w220 x5, Please ensure that you have all the original files from:
	Gui Error: Font, underline s12
	Gui Error: Add, Text, cBlue gGitLink center w220 x5, Gubna-Tech Github
	Gui Error: Font, s11 norm Bold c0x152039
	Gui Error: Add, Text, center x5 w220,
	Gui Error: Add, Text, Center w220 x5,Created by Gubna
	Gui Error: Add, Button, gDiscordError w150 x40 center,Discord
	Gui Error: add, button, gCloseError w150 x40 center,Close Error
	WinSet, ExStyle, ^0x80
	Gui Error: -caption
	Gui Error: Show, center w230, Config Error
	return
}

IniRead, hk1, Config.ini, Start Hotkey, hotkey
IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
IniRead, hk4, Config.ini, Exit Hotkey, hotkey
IniRead, value, Config.ini, Transparent, value

Hotkey %hk1%, Difficulty
Hotkey %hk2%, Coordinates
Hotkey %hk3%, Config
Hotkey %hk4%, Exit

FirstRun=0
RunCount=0
GameNumber=1
info=1

Gui 1: +LastFound +OwnDialogs +AlwaysOnTop
Gui 1: Font, s11
Gui 1: font, bold
Gui 1: Add, Button, x5 w210 gDifficulty, Start Game Creator
Gui 1: Add, Button, x5 y42 w100 gCoordinates, Coordinates
Gui 1: Add, Button, x115 y42 w100 gConfig, Hotkeys
Gui 1: Add, Button, x5 y72 w100 gInfo, Information
Gui 1: Add, Button, x115 y72 w100 gExit, Exit
if FileExist("D2R.ico")
{
	Menu, Tray, Icon, %A_ScriptDir%\D2R.ico
}
WinSet, Transparent, %value%
Gui 1: Show, w225 h110, Main Menu

IniRead, x, Config.ini, GUI POS, guix
IniRead, y, Config.ini, GUI POS, guiy
WinMove A, ,%X%, %y%

if FileExist("D2R.ico")
{
	hIcon := DllCall("LoadImage", uint, 0, str, "D2R.ico"
   	, uint, 1, int, 0, int, 0, uint, 0x10)
	SendMessage, 0x80, 0, hIcon
	SendMessage, 0x80, 1, hIcon
}

OnMessage(0x0047, "WM_WINDOWPOSCHANGED")
OnMessage(0x0201, "WM_LBUTTONDOWN")
WM_LBUTTONDOWN() {
	If (A_Gui)
		PostMessage, 0xA1, 2
}
return

WM_WINDOWPOSCHANGED() {
	If (A_Gui) {
		checkpos()
	}
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
	allowedWindows := "|Main Menu|Game Follow|Normal|Nightmare|Hell|difficulty|information|hotkeys|coordinates|"
	
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

DisableHotkey(disable := true) {
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	
	Hotkey, %hk1%, off	
	Hotkey, %hk2%, off
	Hotkey, %hk3%, off
	Hotkey, %hk4%, off
}

EnableHotkey(enable := true) {
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey

	Hotkey, %hk1%, on	
	Hotkey, %hk2%, on
	Hotkey, %hk3%, on
	Hotkey, %hk4%, on
}

DisableHotkey2(disable := true) {
	Control, Disable,, start
	IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
	Hotkey, %hk3%, off
}

EnableHotkey2(enable := true) {
	Control, Enable,, start
	IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
	Hotkey, %hk3%, on
}

ConfigError(){	
	IniRead, x1, Config.ini, Normal, xmin
	IniRead, x2, Config.ini, Normal, xmax
	IniRead, y1, Config.ini, Normal, ymin
	IniRead, y2, Config.ini, Normal, ymax
	if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
	{
		Run %A_ScriptDir%\Config.ini
		GuiControl,,ScriptRed, CONFIG		
		GuiControl,,State2, ERROR
		MsgBox, 4112, Config Error, Please enter valid coordinates in the Config for [Normal].
		reload
	}
	
	IniRead, x1, Config.ini, Nightmare, xmin
	IniRead, x2, Config.ini, Nightmare, xmax
	IniRead, y1, Config.ini, Nightmare, ymin
	IniRead, y2, Config.ini, Nightmare, ymax
	if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
	{
		Run %A_ScriptDir%\Config.ini
		GuiControl,,ScriptRed, CONFIG		
		GuiControl,,State2, ERROR
		MsgBox, 4112, Config Error, Please enter valid coordinates in the Config for [Nightmare].
		reload
	}
	
	IniRead, x1, Config.ini, Hell, xmin
	IniRead, x2, Config.ini, Hell, xmax
	IniRead, y1, Config.ini, Hell, ymin
	IniRead, y2, Config.ini, Hell, ymax
	if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
	{
		Run %A_ScriptDir%\Config.ini
		GuiControl,,ScriptRed, CONFIG		
		GuiControl,,State2, ERROR
		MsgBox, 4112, Config Error, Please enter valid coordinates in the Config for [Hell].
		reload
	}
	
	IniRead, x1, Config.ini, Create Game Tab, xmin
	IniRead, x2, Config.ini, Create Game Tab, xmax
	IniRead, y1, Config.ini, Create Game Tab, ymin
	IniRead, y2, Config.ini, Create Game Tab, ymax
	if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
	{
		Run %A_ScriptDir%\Config.ini
		GuiControl,,ScriptRed, CONFIG		
		GuiControl,,State2, ERROR
		MsgBox, 4112, Config Error, Please enter valid coordinates in the Config for [Create Game Tab].
		reload
	}
	
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
return

Coordinates:
WinGetPos, GUIxc, GUIyc,,,,Information
IniWrite, %GUIxc%, Config.ini, GUI POS, guix
IniWrite, %GUIyc%, Config.ini, GUI POS, guiy

Gui 1: Hide
Gui 2: +LastFound +OwnDialogs +AlwaysOnTop
Gui 2: Font, s11 Bold
DisableHotkey()

IniRead, allContents, Config.ini
excludedSections := "|start hotkey|exit hotkey|hotkey hotkey|coordinates/reload hotkey|gui pos|transparent|TP Up Hotkey|TP Hot Hotkey|TP Safe Hotkey|autoattack hotkey|call to arms buff hotkey|battle orders hotkey|battle commands hotkey|last game message|thank you message|custom message|"

sectionList := " ***** Make a Selection ***** "

Loop, Parse, allContents, `n
{
    currentSection := A_LoopField

    if !InStr(excludedSections, "|" currentSection "|")
        sectionList .= "|" currentSection
}

Gui, 2: Add, DropDownList, w230 vSectionList Choose1 gDropDownChanged, % sectionList
Gui, 2: Add, Button, x52 w150 gClose, Close Coordinates
WinSet, ExStyle, ^0x80
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

Gui 11u: +LastFound +AlwaysOnTop +OwnDialogs +Disabled
Gui 11u: Color, Red
Gui 11u: Font, cRed
Gui 11u: Font, s16 bold
Gui 11u: Add, Text, valertlabel center,----Right-click the item's top-left corner for its coordinates`n----
WinSet, ExStyle, ^0x80
Gui 11u: -caption
Gui 11u: Show, NoActivate xcenter y0, BottomGUI

Gui 11: +LastFound +AlwaysOnTop +OwnDialogs +Disabled
Gui 11: Font, s16 bold
Gui 11: Add, Text, vTone center,Right-click the item's top-left corner for its coordinates
WinSet, ExStyle, ^0x80
Gui 11: -caption
Gui 11: Show, NoActivate xcenter y9999, TopGUI

wingetpos,,,,bottomH, BottomGUI
wingetpos,,,,topH, TopGUI

topPOS := (bottomH - topH) / 2

Gui, TopGUI: +LabelTopGUI
WinMove, TopGUI,, , %topPOS%
return

CheckClicks:
if GetKeyState("RButton", "P")
{	
	MouseGetPos, MouseX, MouseY
	ClickCount++
	if (ClickCount = 1)
	{
		Gui 11: destroy
		Gui 11u: destroy
		
		Gui 12u: +LastFound +AlwaysOnTop +OwnDialogs +Disabled
		Gui 12u: Color, Red
		Gui 12u: Font, cRed
		Gui 12u: Font, s16 bold
		Gui 12u: Add, Text, valertlabel center,----Right-click the item's bottom-right corner for its coordinates`n----
		WinSet, ExStyle, ^0x80
		Gui 12u: -caption
		Gui 12u: Show, NoActivate xcenter y0, BottomGUI
		
		Gui 12: +LastFound +AlwaysOnTop +OwnDialogs +Disabled
		Gui 12: Font, s16 bold
		Gui 12: Add, Text, vTtwo center,Right-click the item's bottom-right corner for its coordinates
		WinSet, ExStyle, ^0x80
		Gui 12: -caption
		Gui 12: Show, NoActivate xcenter y9999, TopGUI
		
		Gui, TopGUI: +LabelTopGUI
		WinMove, TopGUI,, , %topPOS%
		
		xmin := MouseX
		ymin := MouseY
		
		xmin := MouseX
		ymin := MouseY
	}
	else if (ClickCount = 2)
	{
		Gui 12: destroy
		Gui 12u: destroy
		
		Gui 13u: +LastFound +AlwaysOnTop +OwnDialogs +Disabled
		Gui 13u: Color, Green
		Gui 13u: Font, cGreen
		Gui 13u: Font, s16 bold
		Gui 13u: Add, Text, valertlabel center,----Coordinates have been updated in the Config.ini file`n----
		WinSet, ExStyle, ^0x80
		Gui 13u: -caption
		Gui 13u: Show, NoActivate xcenter y0, BottomGUI
		
		Gui 13: +LastFound +AlwaysOnTop +OwnDialogs +Disabled
		Gui 13: Color, White
		Gui 13: Font, cGreen
		Gui 13: Font, s16 bold
		Gui 13: Add, Text, vTthree center,Coordinates have been updated in the Config.ini file
		WinSet, ExStyle, ^0x80
		Gui 13: -caption
		Gui 13: Show, NoActivate xcenter y9999, TopGUI
		
		Gui, TopGUI: +LabelTopGUI
		WinMove, TopGUI,, , %topPOS%
		
		xmin := MouseX
		ymin := MouseY
		
		xmax := MouseX
		ymax := MouseY
		SetTimer, CheckClicks, Off
		
		IniWrite, %xmin%, Config.ini, %ButtonText%, xmin
		IniWrite, %xmax%, Config.ini, %ButtonText%, xmax
		IniWrite, %ymin%, Config.ini, %ButtonText%, ymin
		IniWrite, %ymax%, Config.ini, %ButtonText%, ymax
		
		Sleep, 1500
		
		Gui 13: destroy
		Gui 13u: Destroy
		Gui, 2: Destroy
		Gui, 1: Show
		
		EnableHotkey()	
	}
	
	Sleep, 250
}
return

~Esc::
IfWinActive, Coordinates
{EnableHotkey()
GoSub, close
}
IfWinActive, Hotkeys
{EnableHotkey()	
GoSub, close2
}
IfWinActive, Difficulty
{
EnableHotkey()
GoSub, close3
}
IfWinActive, Information
{	
EnableHotkey()	
GoSub, CloseInfo
}
Return

Config:
WinGetPos, GUIxc, GUIyc,,,,Information
IniWrite, %GUIxc%, Config.ini, GUI POS, guix
IniWrite, %GUIyc%, Config.ini, GUI POS, guiy

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
Gui, 4: Add, Hotkey, x97 y60 w60 vChosenHotkey gHotkeyChanged Center, ** NONE **
Gui, 4: Add, Button, x64 y90 w125 gClose2, Close Hotkeys
WinSet, Transparent, %value%
WinSet, ExStyle, ^0x80
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

Gui 13u: +LastFound +AlwaysOnTop +OwnDialogs +Disabled
Gui 13u: Color, Green
Gui 13u: Font, cGreen
Gui 13u: Font, s16 bold
Gui 13u: Add, Text, valertlabel center,----Hotkey has been updated in the Config.ini file`n----
WinSet, ExStyle, ^0x80
Gui 13u: -caption
Gui 13u: Show, NoActivate xcenter y0, BottomGUI

Gui 13: +LastFound +AlwaysOnTop +OwnDialogs +Disabled
Gui 13: Color, White
Gui 13: Font, cGreen
Gui 13: Font, s16 bold
Gui 13: Add, Text, vTthree center, Hotkey has been updated in the Config.ini file
WinSet, ExStyle, ^0x80
Gui 13: -caption
Gui 13: Show, NoActivate xcenter y9999, TopGUI

wingetpos,,,,bottomH, BottomGUI
wingetpos,,,,topH, TopGUI

topPOS := (bottomH - topH) / 2

Gui, TopGUI: +LabelTopGUI
WinMove, TopGUI,, , %topPOS%

Sleep 1500

IniRead, hk1, Config.ini, Start Hotkey, hotkey
IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
IniRead, hk4, Config.ini, Exit Hotkey, hotkey

Hotkey %hk1%, Difficulty
Hotkey %hk2%, Coordinates
Hotkey %hk3%, Config
Hotkey %hk4%, Exit

Gui 13u: Destroy
Gui 13: Destroy
Gui 1: Show
EnableHotkey()
return

Exit:
guiclose:
3guiclose:
WinGetPos, GUIxc, GUIyc,,,,Information
IniWrite, %GUIxc%, Config.ini, GUI POS, guix
IniWrite, %GUIyc%, Config.ini, GUI POS, guiy
exitapp

Reload:
WinGetPos, GUIxc, GUIyc,,,,Information
IniWrite, %GUIxc%, Config.ini, GUI POS, guix
IniWrite, %GUIyc%, Config.ini, GUI POS, guiy
reload

Difficulty:
DisableHotkey()
hotkey %hk4%, Exit, on
hotkey 1, normal
hotkey 2, nightmare
hotkey 3, hell

WinGetPos, GUIxc, GUIyc,,,,Information
IniWrite, %GUIxc%, Config.ini, GUI POS, guix
IniWrite, %GUIyc%, Config.ini, GUI POS, guiy

Gui 1: hide
Gui 2: +LastFound +OwnDialogs +AlwaysOnTop
Gui 2: Font, s11
Gui 2: font, bold
Gui 2: Add, Button, x5 w100 gNormal, Normal
Gui 2: Add, Button, x5 w100 gNightmare, Nightmare
Gui 2: Add, Button, x5 w100 gHell, Hell 
Gui 2: Add, Button, x5 w100 gExit, Exit
WinSet, Transparent, %value%
Gui 2: Show,w105 h115, Difficulty
Gui 2: -caption
return

Close3:
Gui 2: Destroy
Gui 1: Show
EnableHotkey()
return

normal:
if firstrun=0
{		
	Gui 1: Destroy
	Gui 2: Destroy
	
	DisableHotkey2()
	ConfigError()
	
	hotkey 1, normal, off
	hotkey 2, nightmare, off
	hotkey 3, hell, off
	
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, hkauto, Config.ini, AutoAttack Hotkey, hotkey
	IniRead, hkcta, Config.ini, Call to Arms Buff Hotkey, hotkey
	IniRead, hkty, Config.ini, Thank You Message, hotkey
	IniRead, hklg, Config.ini, Last Game Message, hotkey
	IniRead, hktp1, Config.ini, TP Up Hotkey, hotkey
	IniRead, hktp2, Config.ini, TP Hot Hotkey, hotkey
	IniRead, hktp3, Config.ini, TP Safe Hotkey, hotkey
	IniRead, hkcm, Config.ini, Custom Message, hotkey
	IniRead, value, Config.ini, Transparent, value
	
	Hotkey %hk1%, Normal
	Hotkey %hk2%, Reload
	Hotkey %hk4%, Exit
	Hotkey %hkauto%, AutoAttack
	Hotkey %hkcta%, CTA
	Hotkey, %hkty%,ThankYou
	Hotkey, %hklg%,LastGame
	Hotkey %hktp1%, Up
	Hotkey %hktp2%, Hot
	Hotkey %hktp3%, Safe
	Hotkey, %hkcm%, CustomMessage
	
	inputbox, GN,Game Name,Please enter your desired game/lobby name.`nName should be 11 characters or less.`nThere is no need to enter a game number.,,300,160
	if (gn = "")
	{
		MsgBox, 48, Name Too Short, Please enter a valid game name between 1-11 characters in length.
		reload
	}
	else if (StrLen(GN) >= 13)
	{
		MsgBox, 48, Name Too Long, Game name should be 11 characters or less.
		reload
	}
	
	inputbox, Pass,Password,Please enter your lobby password.`nLeave blank for no password.,,300,150
	
	EnableHotkey()
	
	++firstrun	
	Gui 3: +LastFound +OwnDialogs +AlwaysOnTop
	Gui 3: Font, s11
	Gui 3: font, bold
	Gui 3: Add, Button, x5 y5 w105 gNormal, Create Game
	Gui 3: Add, Button, x115 y5 w105 gReload, Reload Script
	Gui 3: Add, Button, x5 y42 w105 gInfo, Information
	Gui 3: Add, Button, x115 y42 w105 gExit, Exit Script
	Gui 3: font, cRed
	Gui 3: Add, Text, x5 Center w210 vGameName, *** Game Name Not Set ***
	WinSet, Transparent, %value%
	Gui 3: Show, x0 y0 w225 h100, Normal
	
	IniRead, x, Config.ini, GUI POS, guix
	IniRead, y, Config.ini, GUI POS, guiy
	WinMove A, ,%X%, %y%
	
	GuiControl 3: , GameName,%gn% %gamenumber%
	
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	info=3
	
	return
}
if firstrun=1
{
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	settimer ctawarn, off
	settimer, ctatt, Off
	Gui 10: destroy
	
	Gui 3: font, cBlack
	GuiControl 3: Font, GameName
	
	++firstrun
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Create Game Tab, xmin
	IniRead, x2, Config.ini, Create Game Tab, xmax
	IniRead, y1, Config.ini, Create Game Tab, ymin
	IniRead, y2, Config.ini, Create Game Tab, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 250
	
	CoordMode, Mouse, Window
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
	
	send %gn% %gamenumber%{tab}
	
	sleep 250
	
	send ^{a}
	
	sleep 100
	
	send {delete}
	
	sleep 250
	
	send %pass%
	
	sleep 250
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Normal, xmin
	IniRead, x2, Config.ini, Normal, xmax
	IniRead, y1, Config.ini, Normal, ymin
	IniRead, y2, Config.ini, Normal, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 250
	
	send {enter}
	
	return
}
if firstrun=2
{
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	settimer ctawarn, off
	settimer ctatt, off
	Gui 10: destroy
	
	++gamenumber
	
	GuiControl 3: , GameName, %gn% %gamenumber%
	
	send {enter}
	
	sleep 250
	
	Send Next game will be: %gn% %gamenumber%{enter}
	
	sleep 250
	
	send {esc}
	
	sleep 1000
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Save & Exit, xmin
	IniRead, x2, Config.ini, Save & Exit, xmax
	IniRead, y1, Config.ini, Save & Exit, ymin
	IniRead, y2, Config.ini, Save & Exit, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 2500
	
	CoordMode, Mouse, Window
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
	
	send %gn% %gamenumber%{enter}
	
	return
}
return

nightmare:
if firstrun=0
{
	Gui 1: Destroy
	Gui 2: Destroy
	
	DisableHotkey2()	
	ConfigError()
	
	hotkey 1, normal, off
	hotkey 2, nightmare, off
	hotkey 3, hell, off
	
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, hkauto, Config.ini, AutoAttack Hotkey, hotkey
	IniRead, hkcta, Config.ini, Call to Arms Buff Hotkey, hotkey
	IniRead, hkty, Config.ini, Thank You Message, hotkey
	IniRead, hklg, Config.ini, Last Game Message, hotkey
	IniRead, hktp1, Config.ini, TP Up Hotkey, hotkey
	IniRead, hktp2, Config.ini, TP Hot Hotkey, hotkey
	IniRead, hktp3, Config.ini, TP Safe Hotkey, hotkey
	IniRead, hkcm, Config.ini, Custom Message, hotkey
	IniRead, value, Config.ini, Transparent, value
	
	Hotkey %hk1%, Nightmare
	Hotkey %hk2%, Reload
	Hotkey %hk4%, Exit
	Hotkey %hkauto%, AutoAttack
	Hotkey %hkcta%, CTA
	Hotkey, %hkty%,ThankYou
	Hotkey, %hklg%,LastGame
	Hotkey %hktp1%, Up
	Hotkey %hktp2%, Hot
	Hotkey %hktp3%, Safe
	Hotkey, %hkcm%, CustomMessage
	
	inputbox, GN,Game Name,Please enter your desired game/lobby name.`nName should be 11 characters or less.`nThere is no need to enter a game number.,,300,160
	if (gn = "")
	{
		MsgBox, 48, Name Too Short, Please enter a valid game name between 1-11 characters in length.
		reload
	}
	else if (StrLen(GN) >= 13)
	{
		MsgBox, 48, Name Too Long, Game name should be 11 characters or less.
		reload
	}
	
	inputbox, Pass,Password,Please enter your lobby password.`nLeave blank for no password.,,300,150
	
	EnableHotkey()
	
	++firstrun	
	Gui 3: +LastFound +OwnDialogs +AlwaysOnTop
	Gui 3: Font, s11
	Gui 3: font, bold
	Gui 3: Add, Button, x5 y5 w105 gNightmare, Create Game
	Gui 3: Add, Button, x115 y5 w105 gReload, Reload Script
	Gui 3: Add, Button, x5 y42 w105 gInfo, Information
	Gui 3: Add, Button, x115 y42 w105 gExit, Exit Script
	Gui 3: font, cRed
	Gui 3: Add, Text, x5 Center w210 vGameName, *** Game Name Not Set ***
	WinSet, Transparent, %value%
	Gui 3: Show, x0 y0 w225 h100, Nightmare
	
	IniRead, x, Config.ini, GUI POS, guix
	IniRead, y, Config.ini, GUI POS, guiy
	WinMove A, ,%X%, %y%
	
	GuiControl 3: , GameName,%gn% %gamenumber%
	
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	info=3
	
	return
}
if firstrun=1
{
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	settimer ctawarn, off
	settimer, ctatt, Off
	Gui 10: destroy
	
	Gui 3: font, cBlack
	GuiControl 3: Font, GameName
	
	++firstrun
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Create Game Tab, xmin
	IniRead, x2, Config.ini, Create Game Tab, xmax
	IniRead, y1, Config.ini, Create Game Tab, ymin
	IniRead, y2, Config.ini, Create Game Tab, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 250
	
	CoordMode, Mouse, Window
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
	
	send %gn% %gamenumber%{tab}
	
	sleep 250
	
	send ^{a}
	
	sleep 100
	
	send {delete}
	
	sleep 250
	
	send %pass%
	
	sleep 250
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Nightmare, xmin
	IniRead, x2, Config.ini, Nightmare, xmax
	IniRead, y1, Config.ini, Nightmare, ymin
	IniRead, y2, Config.ini, Nightmare, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 250
	
	send {enter}
	
	return
}
if firstrun=2
{
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	settimer ctawarn, off
	settimer ctatt, off
	Gui 10: destroy
	
	++gamenumber
	
	GuiControl 3: , GameName, %gn% %gamenumber%
	
	send {enter}
	
	sleep 250
	
	Send Next game will be: %gn% %gamenumber%{enter}
	
	sleep 250
	
	send {esc}
	
	sleep 1000
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Save & Exit, xmin
	IniRead, x2, Config.ini, Save & Exit, xmax
	IniRead, y1, Config.ini, Save & Exit, ymin
	IniRead, y2, Config.ini, Save & Exit, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 2500
	
	CoordMode, Mouse, Window
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
	
	send %gn% %gamenumber%{enter}
	
	return
}
return

hell:
if firstrun=0
{
	Gui 1: Destroy
	Gui 2: Destroy
	
	DisableHotkey2()
	ConfigError()
	
	hotkey 1, normal, off
	hotkey 2, nightmare, off
	hotkey 3, hell, off
	
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, hkauto, Config.ini, AutoAttack Hotkey, hotkey
	IniRead, hkcta, Config.ini, Call to Arms Buff Hotkey, hotkey
	IniRead, hkty, Config.ini, Thank You Message, hotkey
	IniRead, hklg, Config.ini, Last Game Message, hotkey
	IniRead, hktp1, Config.ini, TP Up Hotkey, hotkey
	IniRead, hktp2, Config.ini, TP Hot Hotkey, hotkey
	IniRead, hktp3, Config.ini, TP Safe Hotkey, hotkey
	IniRead, hkcm, Config.ini, Custom Message, hotkey
	IniRead, value, Config.ini, Transparent, value
	
	Hotkey %hk1%, Hell
	Hotkey %hk2%, Reload
	Hotkey %hk4%, Exit
	Hotkey %hkauto%, AutoAttack
	Hotkey %hkcta%, CTA
	Hotkey, %hkty%,ThankYou
	Hotkey, %hklg%,LastGame
	Hotkey %hktp1%, Up
	Hotkey %hktp2%, Hot
	Hotkey %hktp3%, Safe
	Hotkey, %hkcm%, CustomMessage
	
	inputbox, GN,Game Name,Please enter your desired game/lobby name.`nName should be 11 characters or less.`nThere is no need to enter a game number.,,300,160
	if (gn = "")
	{
		MsgBox, 48, Name Too Short, Please enter a valid game name between 1-11 characters in length.
		reload
	}
	else if (StrLen(GN) >= 13)
	{
		MsgBox, 48, Name Too Long, Game name should be 11 characters or less.
		reload
	}
	
	inputbox, Pass,Password,Please enter your lobby password.`nLeave blank for no password.,,300,150
	
	EnableHotkey()
	
	++firstrun	
	Gui 3: +LastFound +OwnDialogs +AlwaysOnTop
	Gui 3: Font, s11
	Gui 3: font, bold
	Gui 3: Add, Button, x5 y5 w105 gHell, Create Game
	Gui 3: Add, Button, x115 y5 w105 gReload, Reload Script
	Gui 3: Add, Button, x5 y42 w105 gInfo, Information
	Gui 3: Add, Button, x115 y42 w105 gExit, Exit Script
	Gui 3: font, cRed
	Gui 3: Add, Text, x5 Center w210 vGameName, *** Game Name Not Set ***
	WinSet, Transparent, %value%
	Gui 3: Show, x0 y0 w225 h100, Hell
	
	IniRead, x, Config.ini, GUI POS, guix
	IniRead, y, Config.ini, GUI POS, guiy
	WinMove A, ,%X%, %y%
	
	GuiControl 3: , GameName,%gn% %gamenumber%
	
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	info=3
	
	return
}
if firstrun=1
{
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	settimer ctawarn, off
	settimer, ctatt, Off
	Gui 10: destroy
	
	Gui 3: font, cBlack
	GuiControl 3: Font, GameName
	
	++firstrun
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Create Game Tab, xmin
	IniRead, x2, Config.ini, Create Game Tab, xmax
	IniRead, y1, Config.ini, Create Game Tab, ymin
	IniRead, y2, Config.ini, Create Game Tab, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 250
	
	CoordMode, Mouse, Window
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
	
	send %gn% %gamenumber%{tab}
	
	sleep 250
	
	send ^{a}
	
	sleep 100
	
	send {delete}
	
	sleep 250
	
	send %pass%
	
	sleep 250
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Hell, xmin
	IniRead, x2, Config.ini, Hell, xmax
	IniRead, y1, Config.ini, Hell, ymin
	IniRead, y2, Config.ini, Hell, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 250
	
	send {enter}
	
	return
}
if firstrun=2
{
	IfWinNotActive, Diablo II: Resurrected
	{
		WinActivate, Diablo II: Resurrected
	}
	
	settimer ctawarn, off
	settimer ctatt, off
	Gui 10: destroy
	
	++gamenumber
	
	GuiControl 3: , GameName, %gn% %gamenumber%
	
	send {enter}
	
	sleep 250
	
	Send Next game will be: %gn% %gamenumber%{enter}
	
	sleep 250
	
	send {esc}
	
	sleep 1000
	
	CoordMode, Mouse, Window
	IniRead, x1, Config.ini, Save & Exit, xmin
	IniRead, x2, Config.ini, Save & Exit, xmax
	IniRead, y1, Config.ini, Save & Exit, ymin
	IniRead, y2, Config.ini, Save & Exit, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
	sleep 2500
	
	CoordMode, Mouse, Window
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
	
	send %gn% %gamenumber%{enter}
	
	return
}
return

Up:
send {enter}
sleep 250
Send TP is Up{enter}
Return

Hot:
send {enter}
sleep 250
Send TP is HOT{enter}
Return

Safe:
send {enter}
sleep 250
Send TP is Safe{enter}
Return

ThankYou:
send {enter}
sleep 250
iniread, message, Config.ini, Thank You Message, message
Send %message%{enter}
Return

LastGame:
send {enter}
sleep 250
iniread, message, Config.ini, Last Game Message, message
Send %message%{enter}
Return

CustomMessage:
send {enter}
sleep 250
IniRead, message, Config.ini, Custom Message, message
Send %message%{enter}
Return

AutoAttack:
toggle	:= !toggle
if (toggle = 1)
{	
	Gui 7: +AlwaysOnTop +OwnDialogs +LastFound +Disabled
	Gui 7: Color, Green
	Gui 7: Font, cWhite
	Gui 7: Font, s16 bold
	Gui 7: Add, Text,vMyText Center,AutoAttack enabled
	WinSet, ExStyle, ^0x80
	Gui 7: -caption
	Gui 7: Show, NoActivate xcenter y5
	SendInput, {RButton Down}
}
else
{	
	Gui 7: Destroy
	Gui 8: +AlwaysOnTop +OwnDialogs +LastFound +Disabled
	Gui 8: Color, Red
	Gui 8: Font, cWhite
	Gui 8: Font, s16 bold
	Gui 8: Add, Text,vMyText center,AutoAttack disabled
	WinSet, ExStyle, ^0x80
	Gui 8: -caption
	Gui 8: Show, NoActivate xcenter y5
	SendInput, {RButton Up}
	Sleep 3000
	Gui 8: Destroy
}
return

CTA:
IfWinNotActive, Diablo II: Resurrected
{
	WinActivate, Diablo II: Resurrected
}

IniRead, time, Config.ini, Call to Arms Buff Hotkey, timer
IniRead, warntime, Config.ini, Call to Arms Buff Hotkey, warning timer
WarningTime := Floor(warntime / 1000)
TimerTime := time - warntime
SetTimer, CTAWarn, %TimerTime%
SetTimer, ctatt, %time%

Gui 15: hide
Gui 7: hide
Gui 10: destroy

Gui 6: +AlwaysOnTop +OwnDialogs +LastFound +Disabled
Gui 6: Color, Green
Gui 6: Font, cWhite
Gui 6: Font, s16 bold
Gui 6: Add, Text,vMyText center, Casting Call to Arms
WinSet, ExStyle, ^0x80
Gui 6: -caption
Gui 6: Show, NoActivate xcenter y5

IfWinNotActive, Diablo II: Resurrected
{
	WinActivate, Diablo II: Resurrected
}

IniRead, hkbc, Config.ini, Battle Commands Hotkey, hotkey    
IniRead, hkbo, Config.ini, Battle Orders Hotkey, hotkey    

WinGetPos, WinX, WinY, WinWidth, WinHeight, Diablo II: Resurrected
MouseGetPos, curX, curY

MiddleX := WinX + (WinWidth // 2)
MiddleY := WinY + (WinHeight // 2)

Sleep 50
Send {w down}
Sleep 25
Send {w up}
Sleep 150

Send %hkbc%
Sleep 25
MouseMove %MiddleX%, %MiddleY%
Sleep 50
Send {rbutton down}
Sleep 1250
Send {rbutton up}

Send %hkbo%
Sleep 25
MouseMove %MiddleX%, %MiddleY%
Sleep 50
Send {rbutton down}
Sleep 1250
Send {rbutton up}

Sleep 450
Send {w down}
Sleep 25
Send {w up}
MouseMove %curX%, %curY%

Gui 6: destroy

if (toggle = 1)
{
	gui 7: show
	SendInput, {RButton Down}
}
return

		ctatt:
		settimer ctatt, off
		gui 7: hide
		Loop 5
		{
			IfWinNotActive, Diablo II: Resurrected
			{
				WinActivate, Diablo II: Resurrected
			}
			Gui 10: +AlwaysOnTop +OwnDialogs +LastFound +Disabled
			Gui 10: Color, Red
			Gui 10: Font, cWhite
			Gui 10: Font, s16 bold
			Gui 10: Add, Text,vMyText center,Call to Arms has faded...recast now!!
			WinSet, ExStyle, ^0x80
			Gui 10: -caption
			Gui 10: Show, NoActivate xcenter y5
			Sleep, 500
			Gui 10: destroy
			IfWinNotActive, Diablo II: Resurrected
			{
				WinActivate, Diablo II: Resurrected
			}
			if (toggle = 1)
			{
				SendInput, {RButton Down}
			}
			Gui 10: +AlwaysOnTop +OwnDialogs +LastFound +Disabled
			Gui 10: Color, white
			Gui 10: Font, cRed
			Gui 10: Font, s16 bold
			Gui 10: Add, Text,vMyText center,Call to Arms has faded...recast now!!
			WinSet, ExStyle, ^0x80
			Gui 10:-caption
			Gui 10: Show, NoActivate xcenter y5
			Sleep, 500
			Gui 10: destroy
			IfWinNotActive, Diablo II: Resurrected
			{
				WinActivate, Diablo II: Resurrected
			}
			if (toggle = 1)
			{
				SendInput, {RButton Down}
			}
		}
		if (toggle = 1)
		{
			gui 7: show
			SendInput, {RButton Down}
		}
		return
		
	ctawarn:
		settimer ctawarn, off
		gui 7: hide
IfWinNotActive, Diablo II: Resurrected
{
	WinActivate, Diablo II: Resurrected
}
Gui 15: +AlwaysOnTop +OwnDialogs +LastFound +Disabled
Gui 15: Color, Teal
Gui 15: Font, cWhite
Gui 15: Font, s16 bold
Gui 15: Add, Text,vMyText center,%warningtime% seconds until Call to Arms fades
WinSet, ExStyle, ^0x80
Gui 15: -caption
Gui 15: Show, NoActivate xcenter y5
Sleep, 3000
Gui 15: destroy
WinActivate, Diablo II: Resurrected
if (toggle = 1)
{
			gui 7: show
			SendInput, {RButton Down}
}
return

info:
DisableHotkey()
IniRead, hk1, Config.ini, Start Hotkey, hotkey
IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
IniRead, hk4, Config.ini, Exit Hotkey, hotkey
IniRead, hktp1, Config.ini, TP Up Hotkey, hotkey
IniRead, hktp2, Config.ini, TP Hot Hotkey, hotkey
IniRead, hktp3, Config.ini, TP Safe Hotkey, hotkey
IniRead, hkauto, Config.ini, AutoAttack Hotkey, hotkey
IniRead, hkcta, Config.ini, Call to Arms Buff Hotkey, hotkey
IniRead, hkbc, Config.ini, Battle Commands Hotkey, hotkey
IniRead, hkbo, Config.ini, Battle Orders Hotkey, hotkey
IniRead, hkty, Config.ini, Thank You Message, hotkey
IniRead, hklg, Config.ini, Last Game Message, hotkey
IniRead, hkcm, Config.ini, Custom Message, hotkey

WinGetPos, GUIxc, GUIyc,,,,Information
IniWrite, %GUIxc%, Config.ini, GUI POS, guix
IniWrite, %GUIyc%, Config.ini, GUI POS, guiy

Gui 1: hide
Gui 3: hide	
Gui 20: +AlwaysOnTop +OwnDialogs +LastFound
Gui 20: Font, s11 Bold underline cPurple
Gui 20: Add, Text, Center w220 x5,[ Script Hotkeys ]
Gui 20: Font, Norm
Gui 20: Add, Text, Center w220 x5,Start: %hk1%`nCoordinates/Reload: %hk2%`nHotkey: %hk3%`nExit: %hk4%
Gui 20: Add, Text, center x5 w220,
Gui 20: Font, Bold underline cTeal
Gui 20: Add, Text, Center w220 x5,[ Chat Hotkeys ]
Gui 20: Font, Norm
Gui 20: Add, Text, Center w220 x5,TP Up: %hktp1%`nTP Hot: %hktp2%`nTP Safe: %hktp3%`nThank You: %hkty%`nLast Game: %hklg%`nCustom Message: %hkcm%
Gui 20: Add, Text, center x5 w220,
Gui 20: Font, Bold underline cMaroon
Gui 20: Add, Text, Center w220 x5,[ Combat Hotkeys ]
Gui 20: Font, Norm
Gui 20: Add, Text, Center w220 x5,AutoAttack: %hkauto%`nCTA Buff: %hkcta%`nBattle Commands: %hkbc%`nBattle Orders: %hkbo%
Gui 20: Font, s11 Bold c0x152039
Gui 20: Add, Text, center x5 w220,
Gui 20: Add, Text, Center w220 x5,Created by Gubna
Gui 20: Add, Button, gInfoConfig w150 x40 center,Script Config
Gui 20: Add, Button, gDiscord w150 x40 center,Discord
Gui 20: add, button, gCloseInfo w150 x40 center,Close Information
WinSet, ExStyle, ^0x80
Gui 20: -caption
Gui 20: Show, center w230, Information
return

CloseInfo:
EnableHotkey()
gui 20: destroy
if (info=1){		
	gui 1: show
}
if (info=3){
	gui 3: show
}			
return

discord:
EnableHotkey()
Gui 20: destroy
Run, https://discord.gg/2zRRJbdYff
if (info=1){		
	gui 1: show
}
if (info=3){
	gui 3: show
}			
return

InfoConfig:
EnableHotkey()
Run %A_ScriptDir%\Config.ini
return

GitLink:
run, https://github.com/Gubna-Tech/Diablo-2-Resurrected
Exitapp

DiscordError:
Run, https://discord.gg/2zRRJbdYff
Exitapp

CloseError:	
ExitApp

!F4::
MsgBox, 36,Exit D2R?, Do you want to close Diablo II: Resurrected

IfMsgBox Yes
{
				winclose, Diablo II: Resurrected
			}
			Else
			{
				WinActivate, Diablo II: Resurrected
			}
			return