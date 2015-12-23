#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_Icon=..\MLP Icons\mlp_icon___league_of_legends_by_gefey-d4y3ijd.ico
#AutoIt3Wrapper_Icon=League_Of_Legends_by_DKman.ico
#AutoIt3Wrapper_Outfile=LeagueofLogin.exe
#AutoIt3Wrapper_Res_Fileversion=1.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Copyright ShadyShell 2015
#include <GuiComboBox.au3>
#include <GuiButton.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <ComboConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPI.au3>
#include <Crypt.au3>
#include <EditConstants.au3>
$accountNumber = 0
$tPoint = DllStructCreate("int X;int Y")

dim $usernames[3]
dim $passwords[3]
dim $changeLog
dim $empty[3]
dim $username
dim $password
dim $sList
dim $default
dim $iIndex
dim $var
dim $encryption
dim $key
dim $path

;Check for updates
$update = InetRead("https://raw.githubusercontent.com/ShadyShell/LeagueofLogin/master/Changelog")
$update = BinaryToString($update)
$changeLog = StringSplit($update,@CRLF)
If $changeLog[4] > FileGetVersion(@AutoItExe) Then
	$ans = MsgBox(4, "New version available!", "An update is available, do you wish to download it now?")
	If $ans = "6" Then
		Run("https://github.com/ShadyShell/LeagueofLogin")
		Exit
	EndIf
EndIf

; Create a GUI
#Region ### START Koda GUI section ### Form=c:\users\dschneider\dropbox\other stuff\autoit projects\frmloaconfig.kxf
$frmLOAConfig = GUICreate("LeagueofLogin Config", 395, 300, -1, -1, 0)
$txtPath = GUICtrlCreateInput("", 80, 32, 233, 21)
$btnBrowse = GUICtrlCreateButton("Browse", 320, 32, 65, 21)
$rdYes = GUICtrlCreateRadio("Yes", 8, 88, 41, 17)
$rdNo = GUICtrlCreateRadio("No", 56, 88, 41, 17)
$txtKey = GUICtrlCreateInput("", 184, 87, 129, 21)
GUICtrlSetLimit(-1, 15)
GUICtrlSetState(-1, $GUI_HIDE)
$cmAccounts = GUICtrlCreateCombo("", 8, 144, 161, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
$btnNew = GUICtrlCreateButton("New", 176, 144, 65, 21)
$btnEdit = GUICtrlCreateButton("Edit", 248, 144, 65, 21)
$btnDelete = GUICtrlCreateButton("Delete", 320, 144, 65, 21)
$cmDefault = GUICtrlCreateCombo("", 8, 200, 161, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
$btnSave = GUICtrlCreateButton("Save", 112, 232, 81, 33)
$btnCancel = GUICtrlCreateButton("Cancel", 200, 232, 81, 33)
$Label1 = GUICtrlCreateLabel("Game Info", 8, 8, 80, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Game Path", 8, 32, 71, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("Password Encryption", 8, 64, 152, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel("Account Configuration", 8, 120, 162, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label5 = GUICtrlCreateLabel("Leave blank if path is 'C:\Riot Games\League of Legends'", 88, 12, 279, 17)
$lblKey = GUICtrlCreateLabel("Encryption Key:", 104, 90, 78, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$Label6 = GUICtrlCreateLabel("Default Account", 8, 176, 119, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
#EndRegion ### END Koda GUI section ###
#Region ### START Koda GUI section ### Form=C:\Users\dschneider\Dropbox\Other Stuff\AutoIt Projects\frmLOAAccounts.kxf
$frmLOAAccount = GUICreate("Edit account info", 393, 124, -1, -1, 0)
$Label1 = GUICtrlCreateLabel("Account Name", 8, 8, 75, 17)
$Label2 = GUICtrlCreateLabel("Username", 136, 8, 52, 17)
$Label3 = GUICtrlCreateLabel("Password", 264, 8, 50, 17)
$txtAccount = GUICtrlCreateInput("", 8, 32, 121, 21)
$txtUsername = GUICtrlCreateInput("", 136, 32, 121, 21)
$txtPassword = GUICtrlCreateInput("", 264, 32, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
$btnOK = GUICtrlCreateButton("Ok", 112, 64, 81, 25)
$btnEditCancel = GUICtrlCreateButton("Cancel", 200, 64, 81, 25)
#EndRegion ### END Koda GUI section ###
#Region ### START Koda GUI section ### Form=c:\users\dschneider\dropbox\other stuff\autoit projects\frmloanewaccount.kxf
$frmLOANewAccount = GUICreate("Add new account", 393, 125, -1, -1, 0)
$lblNewAccount = GUICtrlCreateLabel("Account Name", 8, 8, 75, 17)
$lblNewUsername = GUICtrlCreateLabel("Username", 136, 8, 52, 17)
$lblNewPassword = GUICtrlCreateLabel("Password", 264, 8, 50, 17)
$txtNewAccount = GUICtrlCreateInput("", 8, 32, 121, 21)
$txtNewUsername = GUICtrlCreateInput("", 136, 32, 121, 21)
$txtNewPassword = GUICtrlCreateInput("", 264, 32, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
$btnAdd = GUICtrlCreateButton("Add", 112, 64, 81, 25)
$btnNewCancel = GUICtrlCreateButton("Cancel", 200, 64, 81, 25)
#EndRegion ### END Koda GUI section ###
#Region ### START Koda GUI section ### Form=c:\users\dschneider\dropbox\other stuff\autoit projects\frmaccounts.kxf
$frmLogin = GUICreate("League of Login", 281, 40, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
;GUISetIcon("C:\Users\ShadyShell\Dropbox\Other Stuff\MLP Icons\mlp_icon___league_of_legends_by_gefey-d4y3ijd.ico", -1)
GUISetIcon("C:\Users\ShadyShell\Dropbox\Other Stuff\AutoIt Projects\League_Of_Legends_by_DKman.ico", -1)
$cmList = GUICtrlCreateCombo("", 8, 8, 185, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
$btnLogin = GUICtrlCreateButton("Login", 200, 8, 73, 22)
#EndRegion ### END Koda GUI section ###

GUIRegisterMsg($WM_NCLBUTTONDBLCLK, "TitleBarClicked")

;Generate ini file is it does not exist
If Not FileExists("accountConfig.ini") Then
	_FileCreate("accountConfig.ini")
	Local $file = FileOpen("accountConfig.ini", 1)
	FileWrite($file, "[GameInfo]" & @CRLF)
	FileWrite($file, "#Leave path blank if League is installed at ""C:\Riot Games\League of Legends""" & @CRLF)
	FileWrite($file, "path=" & @CRLF & @CRLF)
	FileWrite($file, "[Default]" & @CRLF)
	FileWrite($file, "#Put the account name (name in brackets) that you want to be selected by default. Leave this blank if you don't want anything selected." & @CRLF)
	FileWrite($file, "account=" & @CRLF& @CRLF)
	FileWrite($file, "[Encryption]" & @CRLF)
	FileWrite($file, "#Change to yes to enable encryption. Encrypted passwords must be generated from the Encrpt Passwords program" & @CRLF)
	FileWrite($file, "enabled=no" & @CRLF)
	FileWrite($file, "key=" & @CRLF & @CRLF)
	FileClose($file)
	MsgBox(64, "Config File Created", "An ini file was not detected and created. This file must remain in the same directory as the executable." & @CRLF & "Please add some accounts in the config screen!")

	GUISwitch($frmLOAConfig)
	GUISetState(@SW_SHOW)
EndIf

refresh()

If $default <> "" Then
	GUICtrlSetState($btnLogin, $GUI_FOCUS)
EndIf
GUISetState()
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnLogin
			$sName = GUICtrlRead($cmList)
			$iIndex = _ArraySearch($var, $sName)
			If Not @error Then
				$username = $usernames[$iIndex-2]
				$password = $passwords[$iIndex-2]
			EndIf
			If $username = "" Then
				MsgBox(16,"Go back to bot games","Please select an account")
			Else
				If $encryption = "yes" Then
					$password = StringEncrypt(False, $password, $key)
					_Start($username, $password)
				Else
					_Start($username, $password)
				EndIf
			EndIf
		Case $btnCancel
			GUISwitch($frmLOAConfig)
			GUISetState(@SW_HIDE)
			GUISwitch($frmLogin)
			GUISetState(@SW_ENABLE)
			GUISetState(@SW_SHOW)
			WinActivate("League of Login")
		Case $rdYes
			GUICtrlSetData($txtKey, $key)
			GUICtrlSetState($lblKey, $GUI_SHOW)
			GUICtrlSetState($txtKey, $GUI_SHOW)
		Case $rdNo
			GUICtrlSetState($lblKey, $GUI_HIDE)
			GUICtrlSetState($txtKey, $GUI_HIDE)
			GUICtrlSetData($txtKey, "")
		Case $cmAccounts
			$sName = GUICtrlRead($cmAccounts)
			$iIndex = _ArraySearch($var, $sName)
			If Not @error Then
				$username = $usernames[$iIndex-2]
				$password = $passwords[$iIndex-2]
			EndIf
			If $encryption = "yes" Then
				$password = StringEncrypt(False, $password, $key)
			EndIf
		Case $btnBrowse
			$temp = GUICtrlRead($txtPath)
			GUICtrlSetData($txtPath, FileSelectFolder ( "Select League of Legends folder", "C:\"))
			If GUICtrlRead($txtPath) = "" Then
				GUICtrlSetData($txtPath, $temp)
			EndIf
		Case $btnEdit
			If GUICtrlRead($cmAccounts) = "" Then
				MsgBox(16,"Go back to bot games","Please select an account")
			Else
				GUISwitch($frmLOAConfig)
				GUISetState(@SW_DISABLE)
				GUISwitch($frmLOAAccount)
				GUISetState(@SW_SHOW)
				$temp = GUICtrlRead($cmAccounts)
				GUICtrlSetData($txtAccount,$temp)
				GUICtrlSetData($txtUsername,$username)
				GUICtrlSetData($txtPassword,$password)
			EndIf
		Case $btnOK
			If GUICtrlRead($txtAccount)  = "" Or GUICtrlRead($txtUsername) = "" Or GUICtrlRead($txtPassword) = "" Then
				MsgBox(16,"Error","Please fill out all fields")
			Else
				IniRenameSection("accountConfig.ini",$temp,GUICtrlRead($txtAccount))
				IniWrite("accountConfig.ini",GUICtrlRead($txtAccount),"username",GUICtrlRead($txtUsername))
				If $encryption = "yes" Then
					IniWrite("accountConfig.ini",GUICtrlRead($txtAccount),"password",StringEncrypt(True, GUICtrlRead($txtPassword), $key))
				Else
					IniWrite("accountConfig.ini",GUICtrlRead($txtAccount),"password",GUICtrlRead($txtPassword))
				EndIf
				refresh()
				GUISwitch($frmLOAAccount)
				GUISetState(@SW_HIDE)
				GUISwitch($frmLOAConfig)
				GUISetState(@SW_ENABLE)
				WinActivate("LeagueofLogin Config")
			EndIf
		Case $btnNew
			GUISwitch($frmLOAConfig)
			GUISetState(@SW_DISABLE)
			GUISwitch($frmLOANewAccount)
			GUISetState(@SW_SHOW)
		Case $btnNewCancel
			GUISwitch($frmLOANewAccount)
			GUISetState(@SW_HIDE)
			GUISwitch($frmLOAConfig)
			GUISetState(@SW_ENABLE)
			GUICtrlSetData($txtNewAccount, "")
			GUICtrlSetData($txtNewUsername, "")
			GUICtrlSetData($txtNewPassword, "")
			WinActivate("LeagueofLogin Config")
		Case $btnEditCancel
			GUISwitch($frmLOAAccount)
			GUISetState(@SW_HIDE)
			GUISwitch($frmLOAConfig)
			GUISetState(@SW_ENABLE)
			GUICtrlSetData($txtAccount, "")
			GUICtrlSetData($txtUsername, "")
			GUICtrlSetData($txtPassword, "")
			WinActivate("LeagueofLogin Config")
		Case $btnAdd
			If GUICtrlRead($txtNewAccount)  = "" Or GUICtrlRead($txtNewUsername) = "" Or GUICtrlRead($txtNewPassword) = "" Then
				MsgBox(16,"Error","Please fill out all fields")
			Else
				IniWriteSection("accountConfig.ini", GUICtrlRead($txtNewAccount),"username=" & @CR & "password=")
				IniWrite("accountConfig.ini", GUICtrlRead($txtNewAccount), "username", GUICtrlRead($txtNewUsername))
				If $encryption = "yes" Then
					IniWrite("accountConfig.ini", GUICtrlRead($txtNewAccount), "password", StringEncrypt(True, GUICtrlRead($txtNewPassword), $key))
				Else
					IniWrite("accountConfig.ini", GUICtrlRead($txtNewAccount), "password", GUICtrlRead($txtNewPassword))
				EndIf
				refresh()
				GUISwitch($frmLOANewAccount)
				GUISetState(@SW_HIDE)
				GUISwitch($frmLOAConfig)
				GUISetState(@SW_ENABLE)
				GUICtrlSetData($txtNewAccount, "")
				GUICtrlSetData($txtNewUsername, "")
				GUICtrlSetData($txtNewPassword, "")
				WinActivate("LeagueofLogin Config")
			EndIf
		Case $btnSave
			$temp = _GUICtrlButton_GetCheck($rdYes)
			Local $continue = 1
			If GUICtrlRead($txtPath) <> "" Then
				IniWrite("accountConfig.ini", "GameInfo", "path", GUICtrlRead($txtPath))
			EndIf
			If $temp == 1  And GUICtrlRead($txtKey) <> "" Then
				IniWrite("accountConfig.ini","Encryption", "enabled", "yes")
				IniWrite("accountConfig.ini","Encryption", "key", GUICtrlRead($txtKey))
			ElseIf $temp == 0 Then
				IniWrite("accountConfig.ini","Encryption", "enabled", "no")
				IniWrite("accountConfig.ini","Encryption", "key", "")
			Else
				MsgBox(16, "Error", "Please enter an encryption key")
				$continue = 0
				GUICtrlSetState($txtKey, $GUI_FOCUS)
			EndIf
			If $continue == 1 Then
				If $temp = 1 And $encryption = "no" Then
					$ans = MsgBox(4, "Password Encryption", "Password encryption has been enabled. Would you like to encrypt all your passwords?")
					If $ans = 6 Then
						For $i = 2 to UBound($passwords) - 2
							$passwords[$i] = StringEncrypt(True, $passwords[$i], GUICtrlRead($txtKey))
							IniWrite("accountConfig.ini", $var[$i+2], "password", $passwords[$i])
						Next
					EndIf
				ElseIf $temp = 0 And $encryption = "yes" Then
					$ans = MsgBox(4, "Password Encryption", "Password encryption has been disabled. Would you like to de-encrypt all your passwords?")
					If $ans = 6 Then
						For $i = 2 to UBound($passwords) - 2
							$passwords[$i] = StringEncrypt(False, $passwords[$i], $key)
							IniWrite("accountConfig.ini", $var[$i+2], "password", $passwords[$i])
						Next
					EndIf
				ElseIf $key <> "" And $key <> GUICtrlRead($txtKey) Then
					$ans = MsgBox(4, "Password Encryption", "The password encryption key has changed. Would you like to update all your passwords?")
					If $ans = 6 Then
						For $i = 2 to UBound($passwords) - 2
							$passwords[$i] = StringEncrypt(False, $passwords[$i], $key)
							$passwords[$i] = StringEncrypt(True, $passwords[$i], GUICtrlRead($txtKey))
							IniWrite("accountConfig.ini", $var[$i+2], "password", $passwords[$i])
						Next
					EndIf
				EndIf
				If GUICtrlRead($cmDefault) <> "<none>" Then
					IniWrite("accountConfig.ini", "Default", "account", GUICtrlRead($cmDefault))
				Else
					IniWrite("accountConfig.ini", "Default", "account", "")
				EndIf
				refresh()
				GUISwitch($frmLOAConfig)
				GUISetState(@SW_HIDE)
				GUISwitch($frmLogin)
				GUISetState(@SW_ENABLE)
				GUISetState(@SW_SHOW)
				WinActivate("League of Login")
			EndIf
		Case $btnDelete
			If GUICtrlRead($cmAccounts) = "" Then
				MsgBox(16,"Go back to bot games","Please select an account")
			Else
				$del = MsgBox(4, "Account Deletion", "Are you sure you wish to delete the account " & GUICtrlRead($cmAccounts) & "?")
				If $del = 6 Then
					IniDelete("accountConfig.ini", GUICtrlRead($cmAccounts))
					MsgBox(0, "", "Account Deleted!")
					refresh()
				EndIf
			EndIf
	EndSwitch
WEnd

Func _Start($username, $password)
	GUISetState(@SW_HIDE)
	If $path = "" Then
		_FoolProofStart("C:\Riot Games\League of Legends\lol.launcher.exe")
	Else
		_FoolProofStart($path & "\lol.launcher.exe")
	EndIf
	WinWait("LoL Patcher","")
	WinActivate("LoL Patcher","")
	$WinLoc = WinGetPos("LoL Patcher")
	DllStructSetData($tpoint, "X", $WinLoc[2]/2)
	DllStructSetData($tpoint, "Y", $WinLoc[2]/20)
	_WinAPI_ClientToScreen(WinGetHandle("LoL Patcher"), $tPoint)
	$iColor = PixelGetColor(DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-25)
	$exit = 0
	While $exit == 0
		If ($iColor == "12221263" Or $iColor == "16492138") Then
			MouseClick("left",DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-25)
			$exit = 1
		Else
			$WinLoc = WinGetPos("LoL Patcher")
			DllStructSetData($tpoint, "X", $WinLoc[2]/2)
			DllStructSetData($tpoint, "Y", $WinLoc[2]/20)
			_WinAPI_ClientToScreen(WinGetHandle("LoL Patcher"), $tPoint)
			$iColor = PixelGetColor(DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-25)
		EndIf
	WEnd
	$exit = 0
	DllStructSetData($tpoint, "X", $WinLoc[2]/2.5)
	DllStructSetData($tpoint, "Y", $WinLoc[2]/1.3)
	_WinAPI_ClientToScreen(WinGetHandle("LoL Patcher"), $tPoint)
	$iColor = PixelGetColor(DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-370)
	While WinExists("PVP.net Client", "") == 0
		If ($iColor == "986895" Or $iColor == "1513239") Then
			MouseClick("left",DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-370)
			$iColor = PixelGetColor(DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-370)
		Else
			$iColor = PixelGetColor(DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-370)
		EndIf
	WEnd
	$exit = 0
	WinWait("PVP.net Client", "")
	If Not WinActive("PVP.net Client", "") Then WinActivate("PVP.net Client", "")
	WinWaitActive("PVP.net Client", "")
	$WinLoc = WinGetPos("PVP.net Client")
	DllStructSetData($tpoint, "X", $WinLoc[2]/3.5)
	DllStructSetData($tpoint, "Y", $WinLoc[2]/1.9)
	_WinAPI_ClientToScreen(WinGetHandle("PVP.net Client"), $tPoint)
	$iColor = PixelGetColor(DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-250)
	While $exit == 0
		If ($iColor == "9013641") Then
			Send("{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}" & $username & "{TAB}" & $password)
			Sleep(500)
			Send("{ENTER}")
			$exit = 1
		Else
			$WinLoc = WinGetPos("PVP.net Client")
			DllStructSetData($tpoint, "X", $WinLoc[2]/3.5)
			DllStructSetData($tpoint, "Y", $WinLoc[2]/1.9)
			_WinAPI_ClientToScreen(WinGetHandle("PVP.net Client"), $tPoint)
			$iColor = PixelGetColor(DllStructGetData($tpoint, "X"),DllStructGetData($tpoint, "Y")-250)
		EndIf
	WEnd
	_FoolProofStart(@ScriptDir & "\autoAccept.exe")
	Exit
EndFunc

Func _FoolProofStart($What)
   If @OSTYPE = "WIN32_NT" Then
      RunWait(@comspec & ' /c start "" "' & $what &'"',@WorkingDir,@SW_HIDE)
   Else
      RunWait(@comspec & ' /c start ' & FileGetShortName($what),@WorkingDir,@sw_hide)
   EndIf
EndFunc

Func TitleBarClicked()
	GUICtrlSetData($cmAccounts, $sList)
	GUICtrlSetData($cmDefault, "|<none>" & $sList)
	$iIndex = _ArraySearch($var, $default, 0, 0, 0, 1, 1) - 4
	If $default = "" Then
		_GUICtrlComboBox_SetCurSel($cmDefault, "0")
	Else
		_GUICtrlComboBox_SetCurSel($cmDefault, $iIndex + 1)
	EndIf
	If $encryption = "yes" Then
		GUICtrlSetState($rdYes, $GUI_CHECKED)
		GUICtrlSetState($lblKey, $GUI_SHOW)
		GUICtrlSetState($txtKey, $GUI_SHOW)
		GUICtrlSetData($txtKey, $key)
	Else
		GUICtrlSetState($rdNo, $GUI_CHECKED)
		GUICtrlSetState($lblKey, $GUI_HIDE)
		GUICtrlSetState($txtKey, $GUI_HIDE)
	EndIf
	GUISwitch($frmLogin)
	GUISetState(@SW_DISABLE)
	GUISwitch($frmLOAConfig)
	GUISetState(@SW_SHOW)
EndFunc

Func StringEncrypt($bEncrypt, $sData, $sPassword)
    _Crypt_Startup() ; Start the Crypt library.
    Local $sReturn = ''
    If $bEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.
        $sReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_AES_256)
    Else
        $sReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_AES_256))
    EndIf
    _Crypt_Shutdown() ; Shutdown the Crypt library.
    Return $sReturn
EndFunc   ;==>StringEncrypt

Func refresh()
	$usernames = $empty
	$passwords = $empty
	$sList = ""
	$var = IniReadSectionNames("accountConfig.ini")
	$path = IniRead("accountConfig.ini", $var[1], "path", "default")
	$default = IniRead("accountConfig.ini", $var[2], "account", "default")
	$encryption = IniRead("accountConfig.ini", $var[3], "enabled", "default")
	$key = IniRead("accountConfig.ini", $var[3], "key", "default")
	For $i = 4 To $var[0]
		$sList &= "|" & $var[$i]

		$var2 = IniRead("accountConfig.ini", $var[$i], "username", "default")
		$var3 = IniRead("accountConfig.ini", $var[$i], "password", "default")
		_ArrayInsert($usernames,$i-2,$var2)
		_ArrayInsert($passwords,$i-2,$var3)
	Next
	_GUICtrlComboBox_ResetContent($cmList)
	GUICtrlSetData($cmList, $sList)
	_GUICtrlComboBox_ResetContent($cmAccounts)
	GUICtrlSetData($cmAccounts, $sList)
	_GUICtrlComboBox_ResetContent($cmDefault)
	GUICtrlSetData($cmDefault, $sList)
	$iIndex = _ArraySearch($var, $default, 0, 0, 0, 1, 1) - 4
	_GUICtrlComboBox_SetCurSel($cmList, $iIndex)
	_GUICtrlComboBox_SetCurSel($cmDefault, $iIndex)
	If $default <> "" Then
		GUICtrlSetState($btnLogin, $GUI_FOCUS)
	EndIf
EndFunc