;=======================================================================================
;BDD Test Naming Mode AHK Script
;
;Description:
;  Replaces spaces with underscores while typing, to help with writing BDD test names.
;  Toggle on and off with Ctrl + Shift + U.
;  Insert new test template and turn on test naming mode with Ctrl + Alt + U
;=======================================================================================

;==========================
;Initialise
;==========================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

EnabledIcon := "testnamingmode_16.ico"
DisabledIcon := "testnamingmode_disabled_16.ico"
TestTemplate = 
(
[Test]
public void
)
IsInTestNamingMode := false
SetTestNamingMode(false)

;==========================
;Functions
;==========================
SetTestNamingMode(toActive) {
  local iconFile := toActive ? EnabledIcon : DisabledIcon
  local state := toActive ? "ON" : "OFF"

  IsInTestNamingMode := toActive
  Menu, Tray, Icon, %iconFile%,
  Menu, Tray, Tip, Test naming mode is %state%   
}

;==========================
;Test Mode toggle
;==========================
^+u::
  SetTestNamingMode(!IsInTestNamingMode)
return

;==========================
;Insert new test and turn on test naming mode
;==========================
^!u::  
  SetTestNamingMode(false)
  Send, tua
  Sleep, 500
  Send, {Tab}
  SetTestNamingMode(true)
return  

^!i::  
  SetTestNamingMode(false)
  Send, tx
  Sleep, 500
  Send, {Tab}
  SetTestNamingMode(true)
return  


;==========================
;Handle specific key presses
;==========================
$Space::
  if (IsInTestNamingMode) {
    Send, _
  } else {
    Send, {Space}
  } 
return
  
~$Enter::
  SetTestNamingMode(false)
return

~$Escape::
  SetTestNamingMode(false)  
return

~$+9::  ; Left parenthesis pressed '('
  SetTestNamingMode(false)  
return 

~$+[:: ; left brace '{'
  SetTestNamingMode(false)
return  

~$+`;:: ; Colon ':'
  SetTestNamingMode(false)
return

~$Tab::
  SetTestNamingMode(false)
return
  
~$^g::
  SetTestNamingMode(false)
return


