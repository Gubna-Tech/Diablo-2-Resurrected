#SingleInstance Force
#Persistent
SetBatchLines, -1

DetectHiddenWindows, On
settimer, configcheck, 250
settimer, guicheck

IniRead, hk1, Config.ini, Start Hotkey, hotkey
IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
IniRead, hk3, Config.ini, Hotkey Hotkey, hotkey
IniRead, hk4, Config.ini, Exit Hotkey, hotkey
IniRead, value, Config.ini, Transparent, value

Hotkey %hk1%, Follow
Hotkey %hk2%, Coordinates
Hotkey %hk3%, Config
Hotkey %hk4%, Exit

FirstRun=0
RunCount=0

Gui 1: +LastFound +OwnDialogs +AlwaysOnTop
Gui 1: Font, s11
Gui 1: font, bold
Gui 1: Add, Button, x5 w210 gFollow, Start Game Follower
Gui 1: Add, Button, x5 w100 gCoordinates, Coordinates
Gui 1: Add, Button, x115 y42 w100 gConfig, Hotkeys 
Gui 1: Add, Button, x5 w210 gExit, Exit Game Follower
WinSet, Transparent, %value%
Gui 1: Show, w225 h110, Main Menu

OnMessage(0x0201, "WM_LBUTTONDOWN")
WM_LBUTTONDOWN() {
	If (A_Gui)
		PostMessage, 0xA1, 2
}
return

CheckPOS(){
	WinGetPos, GUIx, GUIy, GUIw, GUIh, A
	xmin := GUIx
	xmax :=GUIw + GUIx
	ymin :=GUIy
	ymax :=GUIh + GUIy
	xadj :=A_ScreenWidth-GUIw
	yadj :=A_ScreenHeight-GUIh
	WinGetPos, X, Y,,, A	
 	
	if (xmin<0)
	{
		WinMove, A,,0
	}
	if (ymin<0)
	{
		WinMove, A,,,0
	}
	if (xmax>A_ScreenWidth)
	{
		WinMove, A,,xadj	
	}
	if (ymax>A_ScreenHeight)
	{
		WinMove, A,,,yadj
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
excludedSections := "|start hotkey|exit hotkey|hotkey hotkey|coordinates/reload hotkey|gui pos|transparent|"

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
settimer, coordtt1, 10
return

CheckClicks:
if GetKeyState("RButton", "P")
{
	MouseGetPos, MouseX, MouseY
	settimer, coordtt1, off
	settimer, coordtt2, 10
	ClickCount++
	if (ClickCount = 1)
	{
		xmin := MouseX
		ymin := MouseY
	}
	else if (ClickCount = 2)
	{
		xmax := MouseX
		ymax := MouseY
		SetTimer, CheckClicks, Off
		
		IniWrite, %xmin%, Config.ini, %ButtonText%, xmin
		IniWrite, %xmax%, Config.ini, %ButtonText%, xmax
		IniWrite, %ymin%, Config.ini, %ButtonText%, ymin
		IniWrite, %ymax%, Config.ini, %ButtonText%, ymax
		
		Gui, 2: Destroy
		Gui, 1: Show
		
		Loop, 100
		{
			MouseGetPos, xm, ym
			settimer, coordtt2, off
			Tooltip, Coordinates have been updated in the config., (xm+30), (ym+75), 1
			Sleep, 25
			EnableHotkey()
		}
		Tooltip
	}
	
	Sleep, 250
}
return

coordtt1:
mousegetpos xn, yn
ToolTip,Right-click the top-left of the item you need the coordinates for., (xn+30), (yn+75),1
return

coordtt2:
mousegetpos xn, yn
ToolTip,Right-click the bottom-right of the item you need the coordinates for., (xn+30), (yn+75),1
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
Gui, 1: Show
Loop, 100
{
	MouseGetPos, xm, ym
	Tooltip, Hotkey has been updated in the config file., %xm%+15, %ym%+15, 1
	Sleep, 25
	EnableHotkey()
}
Tooltip
return

Reload:
reload

Exit:
guiclose:
exitapp

Follow:
if firstrun=0
{
	EnableHotkey()
	DisableHotkey2()
	
	IniRead, hk1, Config.ini, Start Hotkey, hotkey
	IniRead, hk4, Config.ini, Exit Hotkey, hotkey
	IniRead, hk2, Config.ini, Coordinates/Reload Hotkey, hotkey
	IniRead, value, Config.ini, Transparent, value
	
	Hotkey %hk1%, Follow
	Hotkey %hk2%, Reload
	Hotkey %hk4%, Exit	
	
	++firstrun	
	ConfigError()
	
	Gui 1: Destroy
	Gui 2: Destroy
	Gui 3: +LastFound +OwnDialogs +AlwaysOnTop
	Gui 3: Font, s11
	Gui 3: font, bold
	Gui 3: Add, Button, x5 w210 gFollow, Join Next Game
	Gui 3: Add, Button, x5 w105 gReload, Reload Script
	Gui 3: Add, Button, x115 y42 w105 gExit, Exit Script
	Gui 3: font, cRed
	Gui 3: Add, Text, x5 Center w210 vGameName, *** Game Name Not Set ***
	WinSet, Transparent, %value%
	Gui 3: Show, x0 y0 w225 h100, Game Follow
	
	IniRead, x, Config.ini, GUI POS, guix
	IniRead, y, Config.ini, GUI POS, guiy
	WinMove A, ,%X%, %y%
	
	InputBox, GN, Game Name, Please enter the current game/lobby name.`nName should be 11 characters or less.,,300,150
	
	if (GN = "" or GN = 0)
	{
		MsgBox, 48, Invalid Input, Please enter a valid game name between 1-11 characters in length.
		return
	}
	
	RegExMatch(GN, "i)(.*?[^0-9]?)(\d+)$", match)
	
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
	
	inputbox, Pass,Password,Please enter your lobby password.`nLeave blank for no password.,,300,150
	
	GuiControl 3: , GameName,%gn%
	
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