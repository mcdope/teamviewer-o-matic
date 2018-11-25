#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=update.ico
#AutoIt3Wrapper_Outfile=teamviewer-o-matic.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Comment=TeamViewer unattented installscript
#AutoIt3Wrapper_Res_Description=This script automates the TeamViewer setup
#AutoIt3Wrapper_Res_Fileversion=2.0.14.0
#AutoIt3Wrapper_Res_LegalCopyright=© 2018 <https://blog.mcdope.org/>
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_Field=License|GPLv3 (https://www.gnu.org/licenses/gpl-3.0.txt)
#AutoIt3Wrapper_Res_Field=Sourcecode|https://github.com/mcdope/teamviewer-o-matic/tree/teamviewer-14
#AutoIt3Wrapper_Res_Field=Homepage|https://blog.mcdope.org/tags/teamviewer/
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <MsgBoxConstants.au3>

Global $wtMainTitle = "", $wtUnattendedMainTitle = "", $wtUnattendedStep1Title = "", $wtUnattendedStep2Title = "", $wtInitialLaunchTitle = "", $wtUnattendedAuthorizeTitle = ""
Global $wInstallStartText = "", $wAdvancedOptionsText = "", $wUnattendedStartText = "", $wUnattendedStep1Text = "", $wUnattendedStep2Text = "", $wUnattendedFinishText = "", $wInitialLaunchText = "", $wUnattendedAuthorizeText = ""
Global $sTrayTitle = "", $sInstallStartTip = "", $sConfigStartTip = "", $sUnattendedStartTip = "", $sUnattendedStartNoAddSupportedTip = "", $sUnattendedStartNoAddTip = "", $sUnattendedSkipTip = "", $sImportRegTip = "", $sFinishedTip = ""
Global $wtInfoTitle = "", $wInfoText = "", $wTextAreaOfUsage = "", $wTextLicense = "", $wTextComponents = "", $wTextTargetDir = ""
Global $strUser = "", $strPass = "", $strPassword = "", $iDelay  = 250
Global $bAddToContacts = 0

Global $sType, $sLanguageToUse
If $CmdLine[0] < 2 Then
	MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "Incorrect parameter count, be sure to give variant and language!");
	Exit 1
Else
	$sType = StringLower($CmdLine[1])
	$sLanguageToUse = $CmdLine[2]

	__readLanguageStrings($sLanguageToUse, $sType)
	__readConfigFile()
	Opt("WinTitleMatchMode", 2)
	If $sType == "host" Then
		__hostInstallerAutomation()
	Else
		__fullInstallerAutomation()
	EndIf
	Exit 0
EndIf



Func __readLanguageStrings($sLanguageToUse,  $sVariant)
	Local $sLangFile = @ScriptDir & "\teamviewer-o-matic.strings." & $sLanguageToUse & ".conf"

	Local $iFileExists = FileExists($sLangFile)
	If $iFileExists Then
		$wtMainTitle = IniRead($sLangFile, $sVariant & "_WindowTitles", "MainTitle", "default")
		$wtUnattendedMainTitle = IniRead($sLangFile, $sVariant & "_WindowTitles", "UnattendedMainTitle", "")
		$wtUnattendedStep1Title = IniRead($sLangFile, $sVariant & "_WindowTitles", "UnattendedStep1Title", "")
		$wtUnattendedStep2Title = IniRead($sLangFile, $sVariant & "_WindowTitles", "UnattendedStep2Title", "")
		$wtInitialLaunchTitle = IniRead($sLangFile, $sVariant & "_WindowTitles", "InitialLaunchTitle", "")
		$wtInfoTitle = IniRead($sLangFile, $sVariant & "_WindowTitles", "InfoTitle", "")

		$wUnattendedStartText = IniRead($sLangFile, $sVariant & "_WindowTexts", "UnattendedStartText", "")
		$wUnattendedStep1Text = IniRead($sLangFile, $sVariant & "_WindowTexts", "UnattendedStep1Text", "")
		$wUnattendedStep2Text = IniRead($sLangFile, $sVariant & "_WindowTexts", "UnattendedStep2Text", "")
		$wUnattendedFinishText = IniRead($sLangFile, $sVariant & "_WindowTexts", "UnattendedFinishText", "")
		$wInitialLaunchText = IniRead($sLangFile, $sVariant & "_WindowTexts", "InitialLaunchText", "")
		$wInfoText = IniRead($sLangFile, $sVariant & "_WindowTexts", "InfoText", "")
		If $sVariant == "Host" Then
			$wTextAreaOfUsage = IniRead($sLangFile, $sVariant & "_WindowTexts", "AreaOfUsage", "")
			$wTextLicense = IniRead($sLangFile, $sVariant & "_WindowTexts", "License", "")
			$wTextComponents = IniRead($sLangFile, $sVariant & "_WindowTexts", "Components", "")
			$wTextTargetDir = IniRead($sLangFile, $sVariant & "_WindowTexts", "TargetDir", "")
			$wUnattendedAuthorizeTitle = IniRead($sLangFile, $sVariant & "_WindowTexts", "UnattendedAuthorizeTitle", "")
			$wUnattendedAuthorizeText = IniRead($sLangFile, $sVariant & "_WindowTexts", "UnattendedAuthorizeText", "")
		Else
			$wInstallStartText = IniRead($sLangFile, $sVariant & "_WindowTexts", "InstallStartText", "")
			$wAdvancedOptionsText = IniRead($sLangFile, $sVariant & "_WindowTexts", "AdvancedOptionsText", "")
		EndIf

		$sTrayTitle = IniRead($sLangFile, $sVariant & "_TrayTips", "TrayTitle", "")
		$sInstallStartTip = IniRead($sLangFile, $sVariant & "_TrayTips", "InstallStartTip", "")
		$sConfigStartTip = IniRead($sLangFile, $sVariant & "_TrayTips", "ConfigStartTip", "")
		$sUnattendedStartTip = IniRead($sLangFile, $sVariant & "_TrayTips", "UnattendedStartTip", "")
		$sUnattendedStartNoAddSupportedTip = IniRead($sLangFile, $sVariant & "_TrayTips", "UnattendedStartNoAddSupportedTip", "")
		$sUnattendedStartNoAddTip = IniRead($sLangFile, $sVariant & "_TrayTips", "UnattendedStartNoAddTip", "")
		$sUnattendedSkipTip = IniRead($sLangFile, $sVariant & "_TrayTips", "UnattendedSkipTip", "")
		$sImportRegTip = IniRead($sLangFile, $sVariant & "_TrayTips", "ImportRegTip", "")
		$sFinishedTip = IniRead($sLangFile, $sVariant & "_TrayTips", "FinishedTip", "")
	Else
		MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "The given language '" & $sLanguageToUse & "' couldn't be found!");
		Exit 2
	EndIf
EndFunc

Func __readConfigFile()
	$bAddToContacts = Int(IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Setup", "AddToContacts", 0))
	$strUser = IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Setup", "AccountUsername", "")
	$strPass = IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Setup", "AccountPassword", "")
	$strPassword = IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Setup", "ConnectPassword", "")
	$iDelay = Int(IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Advanced", "SleepDelay", "0"))
	Opt("SendKeyDelay", Int(IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Advanced", "SendKeyDelay", "250")) )

	$iErr = 0;
	If StringLower($CmdLine[1]) == "host" And $bAddToContacts == 1 Then
		If $strUser == "" Then
			MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "The Teamviewer-Account ('AccountUsername') couldn't be found, or was empty, in 'teamviewer-o-matic.conf'!");
			$iErr = 1;
		EndIf
		If $strPass == "" Then
			MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "The Teamviewer-Account password ('AccountPassword') couldn't be found, or was empty, in 'teamviewer-o-matic.conf'!");
			$iErr = 1;
		EndIf
	EndIf

	If $strPassword == "" Then
		MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "The connection password ('ConnectPassword') couldn't be found, or was empty, in 'teamviewer-o-matic.conf'!");
		$iErr = 1;
	EndIf

	If $iErr == 1 Then
		Exit 3
	EndIf
EndFunc

Func __fullInstallerAutomation()
	; Install
	TrayTip($sTrayTitle, $sInstallStartTip, 0, 1)
	WinWait($wtMainTitle, $wInstallStartText)
	TrayTip($sTrayTitle, $sConfigStartTip, 0, 1)
	WinActivate($wtMainTitle)
	Sleep($iDelay)
	WinWaitActive($wtMainTitle)
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:5]") ; Installieren, um später aus der Ferne auf diesen Computer zuzugreifen check
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:8]") ; privat / nicht-kommerziell check
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:10]") ; Erweiterte Einstellungen check
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:2]") ; Stimme zu - weiter
	WinWait($wtMainTitle, $wAdvancedOptionsText)
	Sleep($iDelay)
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:2]") ; Fertig stellen
	WinWaitClose($wtMainTitle)

	; Install done - configuring unattended access
	__configureUnattendedAccess($bAddToContacts, False)

	; Close initial launch
	WinWait($wtInitialLaunchTitle, $wInitialLaunchText)
	WinActivate($wtInitialLaunchTitle, $wInitialLaunchText)
	Sleep($iDelay)
	WinClose($wtInitialLaunchTitle, $wInitialLaunchText)

	; Import configuration (if exists)
	Local $iFileExists = FileExists(@ScriptDir & "\tv_full.reg")
	If $iFileExists Then
		TrayTip($sTrayTitle, $sImportRegTip, 0, 1)
		RunWait(@ComSpec & " /c net stop TeamViewer", @ScriptDir)
		RunWait(@ComSpec & " /c ""regedit.exe /s tv_full.reg""", @ScriptDir)
		RunWait(@ComSpec & " /c net start TeamViewer", @ScriptDir)

		; Close info dialog which occurs after restarting the TeamViewer service
		WinWait($wtInfoTitle, $wInfoText)
		WinActivate($wtInfoTitle, $wInfoText)
		Sleep($iDelay)
		WinWaitActive($wtInfoTitle)
		WinClose($wtInfoTitle, $wInfoText)
	EndIf

	TrayTip($sTrayTitle, $sFinishedTip, 15, 1)
EndFunc

Func __hostInstallerAutomation()
	; Install
	TrayTip($sTrayTitle, $sInstallStartTip, 0, 1)
	WinWait($wtMainTitle)
	Sleep($iDelay)
	TrayTip($sTrayTitle, $sConfigStartTip, 0, 1)
	WinActivate($wtMainTitle)
	WinWaitActive($wtMainTitle)
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:4]") ; Erweiterte Einstellungen check
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wtMainTitle, $wTextAreaOfUsage)
	Sleep($iDelay)
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:4]") ; Privat radio
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wtMainTitle, $wTextLicense)
	Sleep($iDelay)
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:4]") ; Akzeptiere... check
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:5]") ; Privat check
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wtMainTitle, $wTextComponents)
	Sleep($iDelay)
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wtMainTitle, $wTextTargetDir)
	Sleep($iDelay)
	ControlClick($wtMainTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWaitClose($wtMainTitle)

	; Install done - configuring unattended access
	__configureUnattendedAccess($bAddToContacts, True)

	; Close info dialog
	WinWait($wtInitialLaunchTitle, $wInitialLaunchText)
	WinActivate($wtInitialLaunchTitle)
	Sleep($iDelay)
	WinWaitActive($wtInitialLaunchTitle)
	ControlClick($wtInitialLaunchTitle, "", "[CLASS:Button; INSTANCE:1]") ; OK

	; Import configuration (if exists)
	Local $iFileExists = FileExists(@ScriptDir & "\tv_host.reg")
	If $iFileExists Then
		TrayTip($sTrayTitle, $sImportRegTip, 0, 1)
		RunWait(@ComSpec & " /c net stop TeamViewer", @ScriptDir)
		RunWait(@ComSpec & " /c ""regedit.exe /s tv_host.reg""", @ScriptDir)
		RunWait(@ComSpec & " /c net start TeamViewer", @ScriptDir)

		; Close info dialog which occurs after restarting the TeamViewer service
		WinWait($wtInfoTitle, $wInfoText)
		WinActivate($wtInfoTitle, $wInfoText)
		Sleep($iDelay)
		WinWaitActive($wtInfoTitle)
		ControlClick($wtInfoTitle, "", "[CLASS:Button; INSTANCE:1]") ; OK
	EndIf

	TrayTip($sTrayTitle, $sFinishedTip, 15, 1)
EndFunc

Func __configureUnattendedAccess($addToContacts = 0, $isAccountAddSupported = False)
	If $addToContacts == 1 Then
		If $isAccountAddSupported == True Then
			TrayTip($sTrayTitle, $sUnattendedStartTip, 0, 1)
		Else
			TrayTip($sTrayTitle, $sUnattendedStartNoAddSupportedTip, 0, 1)
		EndIf
	Else
		TrayTip($sTrayTitle, $sUnattendedStartNoAddTip, 0, 1)
	EndIf

	WinWait($wtUnattendedMainTitle, $wUnattendedStartText)
	WinActivate($wtUnattendedMainTitle)
	Sleep($iDelay)
	WinWaitActive($wtUnattendedMainTitle)
	ControlClick($wtUnattendedMainTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wtUnattendedStep1Title, $wUnattendedStep1Text)
	WinActivate($wtUnattendedStep1Title)
	Sleep($iDelay)
	WinWaitActive($wtUnattendedStep1Title)
	ControlSend($wtUnattendedStep1Title, "", "[CLASS:Edit; INSTANCE:2]", $strPassword, 1) ; Passwort 1
	Sleep($iDelay)
	ControlSend($wtUnattendedStep1Title, "", "[CLASS:Edit; INSTANCE:3]", $strPassword, 1) ; Passwort confirm
	Sleep($iDelay)
	ControlClick($wtUnattendedStep1Title, "", "[CLASS:Button; INSTANCE:2]") ; Weiter

	; Starting with TV14, the full version doesn't support "add to account" in the setup wizard anymore
	; In theory, it could be realized by automating the settings screen. But it would be kinda pointless,
	; since the whole functionality will only work if the current device is already trusted to access the
	; TeamViewer account.
	;
	; That trusting process could be automated too, by implementing a POP/IMAP check for the mail, regex'ing
	; the link, presenting it in a browser to click, waiting for the user to do the magic, and then continuing
	; "add to contacts". But a) it would be a pain in the ass and b) it wouldn't be really unattended anymore.
	; If someone is willing to do it, feel free to submit a pull request. But I won't do it...
	;
	; Alternativly, for paid TeamViewer plans - starting at ONLY 19€ PER MONTH FOR ONE SESSION (and that on sale,
	; usually 27,90€) - it would be possible to use a script (see TeamViewer docs and MMC). But again, it won't
	; happen except someone creates a pull request.
	;
	; If someone is willing to pay for it to be integrated, contact me and we will figure something out.

	If $isAccountAddSupported Then
		WinWait($wtUnattendedStep2Title, $wUnattendedStep2Text)
		WinActivate($wtUnattendedStep2Title)
		Sleep($iDelay)
		WinWaitActive($wtUnattendedStep2Title)

		If $addToContacts Then
			ControlClick($wtUnattendedStep2Title, "", "[CLASS:Button; INSTANCE:2]") ; Ich habe bereits ein TeamViewer Konto
			ControlSend($wtUnattendedStep2Title, "", "[CLASS:Edit; INSTANCE:2]", $strUser, 1) ; User
			Sleep($iDelay)
			ControlSend($wtUnattendedStep2Title, "", "[CLASS:Edit; INSTANCE:3]", $strPass, 1) ; Pass
			Sleep($iDelay)
			ControlClick($wtUnattendedStep2Title, "", "[CLASS:Button; INSTANCE:6]") ; Weiter

			If WinWait($wtUnattendedMainTitle, $wUnattendedFinishText, (($iDelay/1000)*2)) == 0 Then ; ... no success message after iDelay*2 - so we assume this device is unauthorized
				WinWait($wtUnattendedAuthorizeTitle, $wUnattendedAuthorizeText)
				WinActivate($wtUnattendedAuthorizeTitle)
				Sleep($iDelay)
				WinWaitActive($wtUnattendedAuthorizeTitle)
				ControlClick($wtUnattendedAuthorizeTitle, "", "[CLASS:Button; INSTANCE:4]") ; OK
				ControlClick($wtUnattendedStep2Title, "", "[CLASS:Button; INSTANCE:8]") ; Abbrechen - Workaround because we can't finish the authorization
			Else ; ... "add to contacts" was successful
				WinActivate($wtUnattendedMainTitle)
				Sleep($iDelay)
				WinWaitActive($wtUnattendedMainTitle)
				ControlClick($wtUnattendedMainTitle, "", "[CLASS:Button; INSTANCE:7]") ; Fertigstellen
			EndIf
		Else
			ControlClick($wtUnattendedStep2Title, "", "[CLASS:Button; INSTANCE:3]") ; Ich möchte jetzt kein TeamViewer Konto erstellen
			ControlClick($wtUnattendedStep2Title, "", "[CLASS:Button; INSTANCE:6]") ; Weiter

			WinWait($wtUnattendedMainTitle, $wUnattendedFinishText)
			WinActivate($wtUnattendedMainTitle)
			Sleep($iDelay)
			WinWaitActive($wtUnattendedMainTitle)
			ControlClick($wtUnattendedMainTitle, "", "[CLASS:Button; INSTANCE:7]") ; Fertigstellen
		EndIf
	EndIf

	Sleep($iDelay)
	WinWaitClose($wtUnattendedMainTitle)
	TrayTip($sTrayTitle, "", 0, 1)
EndFunc
