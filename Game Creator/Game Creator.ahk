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
IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
IniRead, hk4, Config.ini, Exit Hotkey, hotkey
IniRead, hktp1, Config.ini, TP Up Hotkey, hotkey
IniRead, hktp2, Config.ini, TP Hot Hotkey, hotkey
IniRead, hktp3, Config.ini, TP Safe Hotkey, hotkey
IniRead, value, Config.ini, Transparent, value

Hotkey %hk1%, Difficulty
Hotkey %hk2%, Coordinates
Hotkey %hk3%, Config
Hotkey %hk4%, Exit
Hotkey %hktp1%, Up
Hotkey %hktp2%, Hot
Hotkey %hktp3%, Safe

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
	IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	IniRead, hktp1, Config.ini, TP Up Hotkey, hotkey
	IniRead, hktp2, Config.ini, TP Hot Hotkey, hotkey
	IniRead, hktp3, Config.ini, TP Safe Hotkey, hotkey
	Hotkey, %hk1%, off	
	Hotkey, %hk2%, off
	Hotkey, %hk3%, off
	Hotkey, %hk4%, off
	Hotkey %hktp1%, off
	Hotkey %hktp2%, off
	Hotkey %hktp3%, off
}

EnableHotkey(enable := true) {
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	IniRead, hktp1, Config.ini, TP Up Hotkey, hotkey
	IniRead, hktp2, Config.ini, TP Hot Hotkey, hotkey
	IniRead, hktp3, Config.ini, TP Safe Hotkey, hotkey
	Hotkey, %hk1%, on	
	Hotkey, %hk2%, on
	Hotkey, %hk3%, on
	Hotkey, %hk4%, on
	Hotkey %hktp1%, on
	Hotkey %hktp2%, on
	Hotkey %hktp3%, on
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

ConfigCheck:
{
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
}

return

Coordinates:
Gui 1: Hide
Gui 2: +LastFound +OwnDialogs +AlwaysOnTop
Gui 2: Font, s11 Bold
DisableHotkey()

IniRead, allContents, Config.ini
excludedSections := "|start hotkey|exit hotkey|hotkey hotkey|coordinates/reload hotkey|gui pos|transparent|TP Up Hotkey|TP Hot Hotkey|TP Safe Hotkey|autoattack hotkey|call to arms buff hotkey|battle orders hotkey|battle commands hotkey|"

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
Else IfWinActive, Difficulty
	GoSub, close3
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
Gui, 4: Add, Hotkey, x100 y60 w75 vChosenHotkey gHotkeyChanged, None
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

Gui 13: +AlwaysOnTop +OwnDialogs
Gui 13: Color, Green
Gui 13: Font, cWhite
Gui 13: Font, s16 bold
Gui 13: Add, Text, vTthree , Hotkey has been updated in the Config.ini file
Gui 13: -caption
Gui 13: Show, NoActivate xcenter y5 w495 h45

Sleep 3000

IniRead, hk1, Config.ini, Start Hotkey, hotkey
IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
IniRead, hk4, Config.ini, Exit Hotkey, hotkey
IniRead, hktp1, Config.ini, TP Up Hotkey, hotkey
IniRead, hktp2, Config.ini, TP Hot Hotkey, hotkey
IniRead, hktp3, Config.ini, TP Safe Hotkey, hotkey

Hotkey %hk1%, Difficulty
Hotkey %hk2%, Coordinates
Hotkey %hk3%, Config
Hotkey %hk4%, Exit
Hotkey %hktp1%, Up
Hotkey %hktp2%, Hot
Hotkey %hktp3%, Safe

Gui 13: Destroy
Gui 1: Show
return

Reload:
reload

Exit:
guiclose:
exitapp

Difficulty:
DisableHotkey()
hotkey %hk4%, Exit, on
hotkey 1, normal
hotkey 2, nightmare
hotkey 3, hell

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
	IniRead, value, Config.ini, Transparent, value
	
	Hotkey %hk1%, Normal
	Hotkey %hk2%, Reload
	Hotkey %hk4%, Exit
	Hotkey %hkauto%, AutoAttack
	Hotkey %hkcta%, CTA	
	
	inputbox, GN,Game Name,Please enter your desired game/lobby name.`nName should be 12 characters or less.`nThere is no need to enter a game number.,,300,160
	if (gn = "")
	{
		MsgBox, 48, Name Too Short, Please enter a valid game name between 1-12 characters in length.
		reload
	}
	else if (StrLen(GN) >= 13)
	{
		MsgBox, 48, Name Too Long, Game name should be 12 characters or less.
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
	
	WinActivate, Diablo II: Resurrected
	
	info=3
	
	return
}
if firstrun=1
{
	WinActivate, Diablo II: Resurrected
	
	settimer ctawarn, off
	settimer, ctatt, Off
	Gui 10: destroy
	
	Gui 3: font, cBlack
	GuiControl 3: Font, GameName
	
	++firstrun
	
	CoordMode, Mouse, Screen
	IniRead, x1, Config.ini, Create Game Tab, xmin
	IniRead, x2, Config.ini, Create Game Tab, xmax
	IniRead, y1, Config.ini, Create Game Tab, ymin
	IniRead, y2, Config.ini, Create Game Tab, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
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
	
	CoordMode, Mouse, Screen
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
	WinActivate, Diablo II: Resurrected
	
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
	IniRead, value, Config.ini, Transparent, value
	
	Hotkey %hk1%, Nightmare
	Hotkey %hk2%, Reload
	Hotkey %hk4%, Exit
	Hotkey %hkauto%, AutoAttack
	Hotkey %hkcta%, CTA	
	
	inputbox, GN,Game Name,Please enter your desired game/lobby name.`nName should be 12 characters or less.`nThere is no need to enter a game number.,,300,160
	if (gn = "")
	{
		MsgBox, 48, Name Too Short, Please enter a valid game name between 1-12 characters in length.
		reload
	}
	else if (StrLen(GN) >= 13)
	{
		MsgBox, 48, Name Too Long, Game name should be 12 characters or less.
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
	WinSet, Transparent, %value% vGameName, *** Game Name Not Set ***
	WinSet, Transparent, %value%
	Gui 3: Show, x0 y0 w225 h100, Nightmare
	
	IniRead, x, Config.ini, GUI POS, guix
	IniRead, y, Config.ini, GUI POS, guiy
	WinMove A, ,%X%, %y%
	
	GuiControl 3: , GameName,%gn% %gamenumber%
	
	WinActivate, Diablo II: Resurrected
	
	info=3
	
	return
}
if firstrun=1
{
	WinActivate, Diablo II: Resurrected
	
	settimer ctawarn, off
	settimer, ctatt, Off
	Gui 10: destroy
	
	Gui 3: font, cBlack
	GuiControl 3: Font, GameName
	
	++firstrun
	
	CoordMode, Mouse, Screen
	IniRead, x1, Config.ini, Create Game Tab, xmin
	IniRead, x2, Config.ini, Create Game Tab, xmax
	IniRead, y1, Config.ini, Create Game Tab, ymin
	IniRead, y2, Config.ini, Create Game Tab, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
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
	
	CoordMode, Mouse, Screen
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
	WinActivate, Diablo II: Resurrected
	
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
	IniRead, value, Config.ini, Transparent, value
	
	Hotkey %hk1%, Hell
	Hotkey %hk2%, Reload
	Hotkey %hk4%, Exit
	Hotkey %hkauto%, AutoAttack
	Hotkey %hkcta%, CTA	
	
	inputbox, GN,Game Name,Please enter your desired game/lobby name.`nName should be 12 characters or less.`nThere is no need to enter a game number.,,300,160
	if (gn = "")
	{
		MsgBox, 48, Name Too Short, Please enter a valid game name between 1-12 characters in length.
		reload
	}
	else if (StrLen(GN) >= 13)
	{
		MsgBox, 48, Name Too Long, Game name should be 12 characters or less.
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
	
	WinActivate, Diablo II: Resurrected
	
	info=3
	
	return
}
if firstrun=1
{
	WinActivate, Diablo II: Resurrected
	
	settimer ctawarn, off
	settimer, ctatt, Off
	Gui 10: destroy
	
	Gui 3: font, cBlack
	GuiControl 3: Font, GameName
	
	++firstrun
	
	CoordMode, Mouse, Screen
	IniRead, x1, Config.ini, Create Game Tab, xmin
	IniRead, x2, Config.ini, Create Game Tab, xmax
	IniRead, y1, Config.ini, Create Game Tab, ymin
	IniRead, y2, Config.ini, Create Game Tab, ymax
	Random, x, %x1%, %x2%
	Random, y, %y1%, %y2%
	Click, %x%, %y%
	
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
	
	CoordMode, Mouse, Screen
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
	WinActivate, Diablo II: Resurrected
	
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

AutoAttack:
toggle	:= !toggle
if (toggle = 1)
{	
	Gui 7: +AlwaysOnTop +OwnDialogs
	Gui 7: Color, Green
	Gui 7: Font, cWhite
	Gui 7: Font, s16 bold
	Gui 7: Add, Text,vMyText , AutoAttack enabled
	Gui 7: -caption
	Gui 7: Show, NoActivate xcenter y5 w235 h45
	SendInput, {RButton Down}
}
else
{	
	Gui 7: Destroy
	Gui 8: +AlwaysOnTop +OwnDialogs
	Gui 8: Color, Red
	Gui 8: Font, cWhite
	Gui 8: Font, s16 bold
	Gui 8: Add, Text,vMyText , AutoAttack disabled
	Gui 8: -caption
	Gui 8: Show, NoActivate xcenter y5 w240 h45
	SendInput, {RButton Up}
	Sleep 3000
	Gui 8: Destroy
}
return

CTA:
WinActivate, Diablo II: Resurrected

IniRead, time, Config.ini, Call to Arms Buff Hotkey, timer
TimerTime := time - 30000
SetTimer, CTAWarn, %TimerTime%
SetTimer, ctatt, %time%

Gui 7: hide
Gui 10: destroy

Gui 6: +AlwaysOnTop +OwnDialogs
Gui 6: Color, Green
Gui 6: Font, cWhite
Gui 6: Font, s16 bold
Gui 6: Add, Text,vMyText , Casting Call to Arms
Gui 6: -caption
Gui 6: Show, NoActivate xcenter y5 w245 h45

WinActivate, Diablo II: Resurrected

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
			WinActivate, Diablo II: Resurrected
			Gui 10: +AlwaysOnTop +OwnDialogs
			Gui 10: Color, Red
			Gui 10: Font, cWhite
			Gui 10: Font, s16 bold
			Gui 10: Add, Text,vMyText , Call to Arms has faded...recast now!!
			Gui 10: -caption
			Gui 10: Show, NoActivate xcenter y5 w410 h45
			Sleep, 500
			Gui 10: destroy
			WinActivate, Diablo II: Resurrected
			if (toggle = 1)
			{
				SendInput, {RButton Down}
			}
			Gui 10: +AlwaysOnTop +OwnDialogs
			Gui 10: Color, white
			Gui 10: Font, cRed
			Gui 10: Font, s16 bold
			Gui 10: Add, Text,vMyText , Call to Arms has faded...recast now!!
			Gui 10:-caption
			Gui 10: Show, NoActivate xcenter y5 w410 h45
			Sleep, 500
			Gui 10: destroy
			WinActivate, Diablo II: Resurrected
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
			WinActivate, Diablo II: Resurrected
			Gui 15: +AlwaysOnTop +OwnDialogs
			Gui 15: Color, Red
			Gui 15: Font, cWhite
			Gui 15: Font, s16 bold
			Gui 15: Add, Text,vMyText , 30 seconds until Call to Arms fades
			Gui 15: -caption
			Gui 15: Show, NoActivate xcenter y5 w410 h45
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
if (info=1){
		Gui 1: hide
		MsgBox, 4160, Information, 
(
|| Script Hotkeys ||
Start: %hk1%
Coordinates/Reload: %hk2%
Hotkey: %hk3%
Exit: %hk4%

|| Chat Hotkeys ||
TP Up: %hktp1%
TP Hot: %hktp2%
TP Safe: %hktp3%

|| Combat Hotkeys ||
AutoAttack: %hkauto%

CTA Buff: %hkcta%
Battle Commands: %hkbc%
Battle Orders: %hkbo%

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

|| Chat Hotkeys ||
TP Up: %hktp1%
TP Hot: %hktp2%
TP Safe: %hktp3%

|| Combat Hotkeys ||
AutoAttack: %hkauto%

CTA Buff: %hkcta%
Battle Commands: %hkbc%
Battle Orders: %hkbo%

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
        	WinActivate, Diablo II: Resurrected
	}
	return