#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=update.ico
#AutoIt3Wrapper_Outfile=teamviewer-o-matic.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Comment=TeamViewer unattented installscript
#AutoIt3Wrapper_Res_Description=This script automates the TeamViewer setup
#AutoIt3Wrapper_Res_Fileversion=2.0.11.0
#AutoIt3Wrapper_Res_LegalCopyright=© 2015 <https://blog.mcdope.org/>
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_Field=License|GPLv2 (https://www.gnu.org/licenses/gpl-2.0.txt)
#AutoIt3Wrapper_Res_Field=Sourcecode|https://github.com/mcdope/teamviewer-o-matic
#AutoIt3Wrapper_Res_Field=Homepage|https://blog.mcdope.org/tags/teamviewer/
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <MsgBoxConstants.au3>

Global $wTitle = "", $wTitle2 = "", $wTitle3 = "", $wTitle4 = "", $wTitleInitial = ""
Global $wInstallStartText = "", $wAdvancedOptionsText = "", $wUnattendedStartText = "", $wUnattendedStep1Text = "", $wUnattendedStep2Text = "", $wUnattendedFinishText = "", $wInitialLaunchText = ""
Global $sTrayTitle = "", $sInstallStartTip = "", $sConfigStartTip = "", $sUnattendedStartTip = "", $sImportRegTip = "", $sFinishedTip = ""
Global $wTitleInfo = "", $wInfoText = "", $wTextAreaOfUsage = "", $wTextLicense = "", $wTextComponents = "", $wTextTargetDir = ""
Global $strUser = "", $strPass = "", $strPassword = "", $iDelay  = 250

Global $sType, $sLanguageToUse
If $CmdLine[0] < 2 Then
	MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "Incorrect parameter count, be sure to give variant and language!");
	Exit 1
Else
	$sType = $CmdLine[1]
	$sLanguageToUse = $CmdLine[2]

	__readLanguageStrings($sLanguageToUse, $sType)
	__readConfigFile()
	If $sType == "Host" Then
		__hostInstallerAutomation()
	Else
		__fullInstallerAutomation()
	EndIf
	Exit 0
EndIf



Func __readLanguageStrings($sLanguageToUse, $sVariant)
	Local $sLangFile = @ScriptDir & "\teamviewer-o-matic.strings." & $sLanguageToUse & ".conf"

	Local $iFileExists = FileExists($sLangFile)
	If $iFileExists Then
		$wTitle = IniRead($sLangFile, $sVariant & "_WindowTitles", "MainTitle", "")
		$wTitle2 = IniRead($sLangFile, $sVariant & "_WindowTitles", "UnattendedMainTitle", "")
		$wTitle3 = IniRead($sLangFile, $sVariant & "_WindowTitles", "UnattendedStep1Title", "")
		$wTitle4 = IniRead($sLangFile, $sVariant & "_WindowTitles", "UnattendedStep2Title", "")
		$wTitleInitial = IniRead($sLangFile, $sVariant & "_WindowTitles", "InitialLaunchTitle", "")
		$wTitleInfo = IniRead($sLangFile, $sVariant & "_WindowTitles", "InfoTitle", "")

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
		Else
			$wInstallStartText = IniRead($sLangFile, $sVariant & "_WindowTexts", "InstallStartText", "")
			$wAdvancedOptionsText = IniRead($sLangFile, $sVariant & "_WindowTexts", "AdvancedOptionsText", "")
		EndIf

		$sTrayTitle = IniRead($sLangFile, $sVariant & "_TrayTips", "TrayTitle", "")
		$sInstallStartTip = IniRead($sLangFile, $sVariant & "_TrayTips", "InstallStartTip", "")
		$sConfigStartTip = IniRead($sLangFile, $sVariant & "_TrayTips", "ConfigStartTip", "")
		$sUnattendedStartTip = IniRead($sLangFile, $sVariant & "_TrayTips", "UnattendedStartTip", "")
		$sImportRegTip = IniRead($sLangFile, $sVariant & "_TrayTips", "ImportRegTip", "")
		$sFinishedTip = IniRead($sLangFile, $sVariant & "_TrayTips", "FinishedTip", "")
	Else
		MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "The given language '" & $sLanguageToUse & "' couldn't be found!");
		Exit 2
	EndIf
EndFunc

Func __readConfigFile()
	$strUser = IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Setup", "AccountUsername", "")
	$strPass = IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Setup", "AccountPassword", "")
	$strPassword = IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Setup", "ConnectPassword", "")
	$iDelay = Int(IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Advanced", "SleepDelay", "0"))
	Opt("SendKeyDelay", Int(IniRead(@ScriptDir & "\teamviewer-o-matic.conf", "Advanced", "SendKeyDelay", "250")) )

	$iErr = 0;
	If $strUser == "" Then
		MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "The Teamviewer-Account ('AccountUsername') couldn't be found in 'teamviewer-o-matic.conf'!");
		$iErr = 1;
	EndIf
	If $strPass == "" Then
		MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "The Teamviewer-Account password ('AccountPassword') couldn't be found in 'teamviewer-o-matic.conf'!");
		$iErr = 1;
	EndIf
	If $strPassword == "" Then
		MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "The connection password ('ConnectPassword') couldn't be found in 'teamviewer-o-matic.conf'!");
		$iErr = 1;
	EndIf
	If $iErr == 1 Then
		Exit 3
	EndIf
EndFunc

Func __fullInstallerAutomation()
	; Install
	TrayTip($sTrayTitle, $sInstallStartTip, 0, 1)
	WinWait($wTitle, $wInstallStartText)
	TrayTip($sTrayTitle, $sConfigStartTip, 0, 1)
	WinActivate($wTitle)
	Sleep($iDelay)
	WinWaitActive($wTitle)
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:5]") ; Installieren, um später aus der Ferne auf diesen Computer zuzugreifen check
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:8]") ; privat / nicht-kommerziell check
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:10]") ; Erweiterte Einstellungen check
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:2]") ; Stimme zu - weiter
	WinWait($wTitle, $wAdvancedOptionsText)
	Sleep($iDelay)
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:2]") ; Fertig stellen
	WinWaitClose($wTitle)

	; Install done - adding to list
	__addToContacts()

	; Close initial launch
	WinWait($wTitleInitial, $wInitialLaunchText)
	WinActivate($wTitleInitial, $wInitialLaunchText)
	Sleep($iDelay)
	WinClose($wTitleInitial, $wInitialLaunchText)

	; Import configuration (if exists)
	Local $iFileExists = FileExists(@ScriptDir & "\tv_full.reg")
	If $iFileExists Then
		TrayTip($sTrayTitle, $sImportRegTip, 0, 1)
		RunWait(@ComSpec & " /c net stop TeamViewer", @ScriptDir)
		RunWait(@ComSpec & " /c ""regedit.exe /s tv_full.reg""", @ScriptDir)
		RunWait(@ComSpec & " /c net start TeamViewer", @ScriptDir)

		; Close info dialog which occurs after restarting the TeamViewer service
		WinWait($wTitleInfo, $wInfoText)
		WinActivate($wTitleInfo, $wInfoText)
		Sleep($iDelay)
		WinWaitActive($wTitleInfo)
		WinClose($wTitleInfo, $wInfoText)
	EndIf

	TrayTip($sTrayTitle, $sFinishedTip, 15, 1)
EndFunc

Func __hostInstallerAutomation()
	; Install
	TrayTip($sTrayTitle, $sInstallStartTip, 0, 1)
	WinWait($wTitle)
	Sleep($iDelay)
	TrayTip($sTrayTitle, $sConfigStartTip, 0, 1)
	WinActivate($wTitle)
	WinWaitActive($wTitle)
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:4]") ; Erweiterte Einstellungen check
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wTitle, $wTextAreaOfUsage)
	Sleep($iDelay)
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:4]") ; Privat radio
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wTitle, $wTextLicense)
	Sleep($iDelay)
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:4]") ; Akzeptiere... check
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:5]") ; Privat check
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wTitle, $wTextComponents)
	Sleep($iDelay)
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wTitle, $wTextTargetDir)
	Sleep($iDelay)
	ControlClick($wTitle, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWaitClose($wTitle)

	; Install done - adding to list
	__addToContacts()

	; Close info dialog
	WinWait($wTitleInitial, $wInitialLaunchText)
	WinActivate($wTitleInitial)
	Sleep($iDelay)
	WinWaitActive($wTitleInitial)
	ControlClick($wTitleInitial, "", "[CLASS:Button; INSTANCE:1]") ; OK

	; Import configuration (if exists)
	Local $iFileExists = FileExists(@ScriptDir & "\tv_host.reg")
	If $iFileExists Then
		TrayTip($sTrayTitle, $sImportRegTip, 0, 1)
		RunWait(@ComSpec & " /c net stop TeamViewer", @ScriptDir)
		RunWait(@ComSpec & " /c ""regedit.exe /s tv_host.reg""", @ScriptDir)
		RunWait(@ComSpec & " /c net start TeamViewer", @ScriptDir)

		; Close info dialog which occurs after restarting the TeamViewer service
		WinWait($wTitleInfo, $wInfoText)
		WinActivate($wTitleInfo, $wInfoText)
		Sleep($iDelay)
		WinWaitActive($wTitleInfo)
		ControlClick($wTitleInfo, "", "[CLASS:Button; INSTANCE:1]") ; OK
	EndIf

	TrayTip($sTrayTitle, $sFinishedTip, 15, 1)
EndFunc

Func __addToContacts()
	TrayTip($sTrayTitle, $sUnattendedStartTip, 0, 1)
	WinWait($wTitle2, $wUnattendedStartText)
	WinActivate($wTitle2)
	Sleep($iDelay)
	WinWaitActive($wTitle2)
	ControlClick($wTitle2, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wTitle3, $wUnattendedStep1Text)
	WinActivate($wTitle3)
	Sleep($iDelay)
	WinWaitActive($wTitle3)
	ControlSend($wTitle3, "", "[CLASS:Edit; INSTANCE:2]", $strPassword, 1) ; Passwort 1
	Sleep($iDelay)
	ControlSend($wTitle3, "", "[CLASS:Edit; INSTANCE:3]", $strPassword, 1) ; Passwort confirm
	Sleep($iDelay)
	ControlClick($wTitle3, "", "[CLASS:Button; INSTANCE:2]") ; Weiter
	WinWait($wTitle4, $wUnattendedStep2Text)
	WinActivate($wTitle4)
	Sleep($iDelay)
	WinWaitActive($wTitle4)
	ControlClick($wTitle4, "", "[CLASS:Button; INSTANCE:2]") ; Ich habe bereits ein TeamViewer Konto
	ControlSend($wTitle4, "", "[CLASS:Edit; INSTANCE:2]", $strUser, 1) ; User
	Sleep($iDelay)
	ControlSend($wTitle4, "", "[CLASS:Edit; INSTANCE:3]", $strPass, 1) ; Pass
	Sleep($iDelay)
	ControlClick($wTitle4, "", "[CLASS:Button; INSTANCE:6]") ; Weiter
	WinWait($wTitle2, $wUnattendedFinishText)
	WinActivate($wTitle2)
	Sleep($iDelay)
	WinWaitActive($wTitle2)
	ControlClick($wTitle2, "", "[CLASS:Button; INSTANCE:7]") ; Fertigstellen
	Sleep($iDelay)
	WinWaitClose($wTitle2)
	TrayTip($sTrayTitle, "", 0, 1)
EndFunc
