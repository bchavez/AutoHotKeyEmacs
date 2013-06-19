;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         David <tchepak@gmail.com>
;
; Script Function:
;   Provides an Emacs-like keybinding emulation mode that can be toggled on and off using
;   the CapsLock key.
;


;==========================
;Initialise
;==========================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

enabledIcon := "emacs_everywhere_16.ico"
disabledIcon := "emacs_everywhere_disabled_16.ico"
IsInEmacsMode := false
IsInSelectMode := false

SetEmacsMode(false)
SetSelectMode(false)

FilterApps(ByRef emacskey, ByRef stroke1, ByRef stroke2){
   SetTitleMatchMode 2 ; match start with
   
   if WinActive("ahk_exe mintty.exe")
   {
      ; MsgBox emackskey:'%emacskey%'
      if ( emacskey = "^k" ) 
      {
          ;MsgBox "foo"
          Send, ^k
          return "stop"
      }
   }
   
   if WinActive("ahk_class AcrobatSDIWindow"){
      if( emacskey = "^s" ){
         stroke1 = ^f
      }
      if( emacskey = "^r" ){
         stroke1 = {Shift}+{F3}
      }
   }
   
   if WinActive("ahk_class Notepad2U"){
      if( emacskey = "^s")
        stroke1 = ^f
      if( emacskey = "^r")
        stroke1 = ^f
   }
   
   if WinActive("ahk_class MozillaUIWindowClass"){
      if( emacskey = "^s")
        stroke1 = ^f
      if( emacskey = "^r")
        stroke1 = {Shift}+{F3}
   }
   
   if WinActive("ahk_exe Notepad2.exe") AND WinActive("Find Text") {
      if( emacskey = "^s"){
          ControlClick, &Find Next, Find Text
          return "stop"
      }
      if( emacskey = "^r"){
          ControlClick, Find &Previous, Find Text
          return "stop"
      }
        
   }
   
   if WinActive("ahk_exe cmd.exe") {
      if( emacskey = "^x^c"){
          WinClose, A
          return "stop"
      }
   }
   
   if WinActive("ahk_class Chrome_WidgetWin_1"){
      if( emacskey = "^s")
        stroke1 = {F3}
      if( emacskey = "^r")
        stroke1 = {SHIFTDOWN}{F3}{SHIFTUP}
   }
   
   
   SetTitleMatchMode 2
   if WinActive("Microsoft Visual Studio") {
      if( emacsKey = "^k" ){
        Send, ^k
        return "stop"
      }
      if( emacskey = "^s" OR emacskey = "^r" OR emacsKey = "^x^s" OR emacsKey = "^xu" OR emacsKey = "^x^x"){
        Send, %emacskey%
        return "stop"
      }
   }
   
   return "ok"
}

;==========================
;Functions
;==========================
SetEmacsMode(toActive) {
  local iconFile := toActive ? enabledIcon : disabledIcon
  local state := toActive ? "ON" : "OFF"

  IsInEmacsMode := toActive
  ;TrayTip, Emacs Everywhere, Emacs mode is %state%, 10, 1
  Menu, Tray, Icon, %iconFile%,
  Menu, Tray, Tip, Emacs Everywhere`nEmacs mode is %state%  

  Send {Shift Up}
}
SetSelectMode(toActive){
  global IsInSelectMode
  IsInSelectMode := toActive
  ;MsgBox % IsInSelectMode
}

SendCommand(emacsKey, translationToWindowsKeystrokes, secondWindowsKeystroke="") {
  global IsInEmacsMode
  global IsInSelectMode
  
  if(IsInSelectMode){
     translationToWindowsKeystrokes := "+" . translationToWindowsKeystrokes
     ;MsgBox %translationToWindowsKeystrokes%
  }
  
    processkey := FilterApps( emacsKey, translationToWindowsKeystrokes, secondWindowsKeystroke )
    if( emacsKey = "" OR processkey = "stop" ){
        return
    }
  
  if (IsInEmacsMode AND processkey = "ok") {
       Send, %translationToWindowsKeystrokes%
    if (secondWindowsKeystroke<>"") {
       Send, %secondWindowsKeystroke%
    }
  } else if( processkey = "ok") {
     ;MsgBox "passthru"
    Send, %emacsKey% ;passthrough original keystroke
  }
  return
}

;+++++++++++++++++++++++++++++++++++++++++
; Gets selected text
;+++++++++++++++++++++++++++++++++++++++++

GetSelectedText()
{
   Clipboard =
   Send, ^c ; simulate Ctrl+C
   ClipWait 0.1
   
   sel := Clipboard
   
   return sel
}

;==========================
;Emacs mode toggle
;==========================


  SetEmacsMode(!IsInEmacsMode)


$^Space::
  SetSelectMode(!IsInSelectMode)
return
  
$^g::
  if( !IsInSelectMode ){
     IfWinActive ahk_class MUSHYBAR
     {
        Send, !{F4}
     }
     Else
     {
        Send, {Esc}
     }
   }
  else{
    SetSelectMode(false)
  }
return
~$^c::
  SetSelectMode(false)
return

  
;==========================
;Character navigation
;==========================

$^p::SendCommand("^p","{Up}")

$^n::SendCommand("^n","{Down}")

$^f::SendCommand("^f","{Right}")

$^b::SendCommand("^b","{Left}")

;==========================
;Word Navigation
;==========================

;$!p::SendCommand("!p","^{Up}")

;$!n::SendCommand("!n","^{Down}")

$!f::SendCommand("!f","^{Right}")

$!b::SendCommand("!b","^{Left}")

;==========================
;Line Navigation
;==========================

$^a::SendCommand("^a","{Home}")

$^e::SendCommand("^e","{End}")

;==========================
;Page Navigation
;==========================

;Ctrl-V disabled. Too reliant on that for pasting :$
$!n::SendCommand("^v","{PgDn}")
$!p::SendCommand("!v","{PgUp}")

$!<::SendCommand("!<","^{Home}")

$!>::SendCommand("!>","^{End}")

;==========================
;Undo
;==========================

;$^_::SendCommand("^_","^z")
$^7::SendCommand("^7","^z")
$+^7::SendCommand("^+7","^y")


;==========================
;Killing and Deleting
;==========================

$^d::
   SetSelectMode(false)
   SendCommand("^d","{Delete}")
return

$^k::
   SetSelectMode(false)
 
    emacskey := "^k"
    processkey := FilterApps( emacskey, emacskey, "" )
    if( processkey == "stop"){
        ;MsgBox "bypassed"
        return
    }
   
   selection := GetSelectedText()
   
   if( selection <> "" ){
      ;selection exists....
      ;MsgBox "isnotempty '" . %selection%
      Send, ^x
   }
   else{
      ;MsgBox "Is empty!" .%selection%
      Send, {Home}
      Send, {Home}
      Send, +{End}
      Send, ^x
      Send, {Del}
   }
   
return

$^y::SendCommand("^y","^v") ;paste

;==========================
;Search
;==========================
$^s::SendCommand("^s","{F3}") ;find
$^r::SendCommand("^r","{Shift}+{F3}") ;reverse

;=====
; File Handling Commands CTRL+X
;=====
$^x::
  Suspend, On ; other hotkeys such as ^s from being queued http://l.autohotkey.net/docs/misc/Threads.htm
  Critical ; and don't interrupt (suspend) the current thread's execution
    
  Input, RawInput, L1 M
  Transform, AsciiCode, Asc, %RawInput%
  
  ;MsgBox RawInput: %RawInput%
  ;MsgBox AsciiCode: %AsciiCode%
  ;KeyHistory
    
  if( AsciiCode <= 26 ){
    ; Check if Control+Letter, if so, boost to ascii letter.
    AsciiCode += 96
    Transform, CtrlLetter, Chr, %AsciiCode%
    Stroke = ^%CtrlLetter%
  }
  else{
    Stroke = %RawInput%
  }
  
          
  ; C-g		keyboard-quit		Stop current command Now!
  if( Stroke = "^g" ){
      Suspend, Off
      return
  }
  
  if( Stroke = "^s" ){
  
      ; C-x C-s: save-buffer,	Save the current buffer.
      SendCommand("^x^s", "^s")
      
  } else if( Stroke = "^c" ){
  
      ; C-x C-c: save-buffers-kill-emacs, Save all open buffers and get out of emacs.
      SendCommand("^x^c", "!{F4}" )
      
  }
  else{  
      ;else pass along the emacs key
      emacsKey = ^x%Stroke%
      SendCommand(emacsKey, emacsKey)
  }
  
  Suspend, Off
  
return

