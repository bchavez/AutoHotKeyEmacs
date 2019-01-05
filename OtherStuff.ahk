; Reference: ^ = Ctrl, ! = Alt, + = Shift, # = Win
; Source & Credits: http://www.autohotkey.com/forum/viewtopic.php?p=218283, http://lifehacker.com/5046035/tabslock-puts-your-browser-one-keystroke-away
; Relevant blog post: http://www.howtotuts.com/2008/09/05/how-to-set-keyboard-shortcuts-in-chrome/



#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;disable F1 help key
f1::Return

^!Left::
  Winamp("Fast Rewind")
return

^!Right::
  Winamp("Fast Forward")
return


; Refreshes firefox
$^z::
  curWin := WinExist("A")
  if WinExist("ahk_class Chrome_WidgetWin_1") {
     WinActivate
     WinWaitActive
     Send +{F5}
     Sleep, 100  ; 100ms
     Send {ENTER}
     WinActivateBottom, ahk_id %curWin%
  }
return


;NOTEPAD++
;#IfWinActive ahk_exe explorer.exe
;  $!LButton::RapidHotkey("OpenWithNotepad",2,0.3,1)
;  OpenWithNotepad:
;			sel := Explorer_GetSelected()
;			nppfiles := ""
;			for item in sel{
;			  path := item.path
;			  nppfiles := nppfiles . " """ . path . """"
;      }
;      nppfiles := """C:\Program Files (x86)\Notepad++\notepad++.exe"" -nosession" . nppfiles
;      Run, %nppfiles%
;  return
;#IfWinActive

#IfWinActive ahk_exe explorer.exe
  $!LButton::RapidHotkey("OpenWithNotepad",2,0.3,1)
  OpenWithNotepad:
			sel := Explorer_GetSelected()
			for item in sel{
			  path := item.path
        Run,Notepad %path%
      }
  return
#IfWinActive



#IfWinActive ahk_class mintty
XButton1::Send, ^+c
XButton2::Send, ^+v
#IfWinActive

#IfWinActive ahk_class VirtualConsoleClass
XButton1::Send, ^+c
XButton2::Send, ^+v
#IfWinActive

;#n::Run,C:\Program Files (x86)\Notepad++\notepad++.exe -nosession
#n::Run,C:\Program Files\Notepad2\Notepad2.exe
;#s::Run,c:\cygwin\bin\rxvt.exe -geometry 160x52 -display :0 -rv -sl 3208 -cr red -e /bin/tcsh -l, c:\cygwin\home\Cowboy
#s::Run,c:\cygwin\bin\mintty.exe -t tcsh -e /bin/tcsh -l, c:\cygwin\home\Cowboy
#w::Run,C:\Users\Cowboy\AppData\Local\Google\Chrome\Application\chrome.exe

;copy selected items to temp directory.
#IfWinActive ahk_exe explorer.exe
$^t::
    sel := Explorer_GetSelected()
    nppfiles := ""
    target := ""
		for item in sel{
		  path := item.path
		  nppfiles := nppfiles . path . "|"
		  SplitPath, path, name
		  target := target "c:\temp\" A_Now "\" name . "|"
    }
    if( nppfiles == "" )
        return
    
    ShellFileOperation("FO_COPY", nppfiles, target, "FOF_SIMPLEPROGRESS|FOF_NOCONFIRMMKDIR|FOF_MULTIDESTFILES")
    
#IfWinActive

$!^d::Run,C:\Code\Projects\WinampDeleteSong\WinampDeleteSong\bin\Debug\WinampDeleteSong.exe,,Hide


; ===========================================================================
; ===================== LIB =================================================
; ===========================================================================

ShellFileOperation( fileO=0x0, fSource="", fTarget="", flags=0x0, ghwnd=0x0 )     
{

	;dout_f(A_ThisFunc)
	FO_MOVE   := 0x1
	FO_COPY   := 0x2
	FO_DELETE := 0x3
	FO_RENAME := 0x4
	
	FOF_MULTIDESTFILES :=  			0x1				; Indicates that the to member specifies multiple destination files (one for each source file) rather than one directory where all source files are to be deposited.
	FOF_SILENT := 					0x4				; Does not display a progress dialog box.
	FOF_RENAMEONCOLLISION := 		0x8				; Gives the file being operated on a new name (such as "Copy #1 of...") in a move, copy, or rename operation if a file of the target name already exists.
	FOF_NOCONFIRMATION := 			0x10			; Responds with "yes to all" for any dialog box that is displayed.
	FOF_ALLOWUNDO := 				0x40			; Preserves undo information, if possible. With del, uses recycle bin.
	FOF_FILESONLY := 				0x80			; Performs the operation only on files if a wildcard filename (*.*) is specified.
	FOF_SIMPLEPROGRESS := 			0x100			; Displays a progress dialog box, but does not show the filenames.
	FOF_NOCONFIRMMKDIR := 			0x200			; Does not confirm the creation of a new directory if the operation requires one to be created.
	FOF_NOERRORUI := 				0x400			; don't put up error UI
	FOF_NOCOPYSECURITYATTRIBS := 	0x800			; dont copy file security attributes
	FOF_NORECURSION := 				0x1000			; Only operate in the specified directory. Don't operate recursively into subdirectories.
	FOF_NO_CONNECTED_ELEMENTS := 	0x2000			; Do not move connected files as a group (e.g. html file together with images). Only move the specified files.
	FOF_WANTNUKEWARNING :=		 	0x4000			; Send a warning if a file is being destroyed during a delete operation rather than recycled. This flag partially overrides FOF_NOCONFIRMATION.

	
	; no more annoying numbers to deal with (but they should still work, if you really want them to)
	fileO := %fileO% ? %fileO% : fileO
	
	; the double ternary was too fun to pass up
	_flags := 0
	Loop Parse, flags, |
		_flags |= %A_LoopField%	
	flags := _flags ? _flags : (%flags% ? %flags% : flags)
	
	If ( SubStr(fSource,0) != "|" )
		fSource := fSource . "|"

	If ( SubStr(fTarget,0) != "|" )
		fTarget := fTarget . "|"
	
	char_size := A_IsUnicode ? 2 : 1
	char_type := A_IsUnicode ? "UShort" : "Char"
;	  MsgBox %fSource%, %fTarget%
	fsPtr := &fSource
	Loop % StrLen(fSource)
		if NumGet(fSource, (A_Index-1)*char_size, char_type) = 124
			NumPut(0, fSource, (A_Index-1)*char_size, char_type)

	ftPtr := &fTarget
	Loop % StrLen(fTarget)
		if NumGet(fTarget, (A_Index-1)*char_size, char_type) = 124
			NumPut(0, fTarget, (A_Index-1)*char_size, char_type)
	
	VarSetCapacity( SHFILEOPSTRUCT, 60, 0 )                 ; Encoding SHFILEOPSTRUCT
	NextOffset := NumPut( ghwnd, &SHFILEOPSTRUCT )          ; hWnd of calling GUI
	NextOffset := NumPut( fileO, NextOffset+0    )          ; File operation
	NextOffset := NumPut( fsPtr, NextOffset+0    )          ; Source file / pattern
	NextOffset := NumPut( ftPtr, NextOffset+0    )          ; Target file / folder
	NextOffset := NumPut( flags, NextOffset+0, 0, "Short" ) ; options

	code := DllCall( "Shell32\SHFileOperation" . (A_IsUnicode ? "W" : "A"), UInt,&SHFILEOPSTRUCT )
	ErrorLevel := ShellFileOperation_InterpretReturn(code)

	Return NumGet( NextOffset+0 )
}

ShellFileOperation_InterpretReturn(c)
{
	static dict
	if !dict
	{
		dict := Object()
		dict[0x0]		:= 	""
		dict[0x71]		:=	"DE_SAMEFILE - The source and destination files are the same file."
		dict[0x72]		:=	"DE_MANYSRC1DEST - Multiple file paths were specified in the source buffer, but only one destination file path."
		dict[0x73]		:=	"DE_DIFFDIR - Rename operation was specified but the destination path is a different directory. Use the move operation instead."
		dict[0x74]		:=	"DE_ROOTDIR - The source is a root directory, which cannot be moved or renamed."
		dict[0x75]		:=	"DE_OPCANCELLED - The operation was cancelled by the user, or silently cancelled if the appropriate flags were supplied to SHFileOperation."
		dict[0x76]		:=	"DE_DESTSUBTREE - The destination is a subtree of the source."
		dict[0x78]		:=	"DE_ACCESSDENIEDSRC - Security settings denied access to the source."
		dict[0x79]		:=	"DE_PATHTOODEEP - The source or destination path exceeded or would exceed MAX_PATH."
		dict[0x7A]		:=	"DE_MANYDEST - The operation involved multiple destination paths, which can fail in the case of a move operation."
		dict[0x7C]		:=	"DE_INVALIDFILES	- The path in the source or destination or both was invalid."
		dict[0x7D]		:=	"DE_DESTSAMETREE	- The source and destination have the same parent folder."
		dict[0x7E]		:=	"DE_FLDDESTISFILE - The destination path is an existing file."
		dict[0x80]		:=	"DE_FILEDESTISFLD - The destination path is an existing folder."
		dict[0x81]		:=	"DE_FILENAMETOOLONG - The name of the file exceeds MAX_PATH."
		dict[0x82]		:=	"DE_DEST_IS_CDROM - The destination is a read-only CD-ROM, possibly unformatted."
		dict[0x83]		:=	"DE_DEST_IS_DVD - The destination is a read-only DVD, possibly unformatted."
		dict[0x84]		:=	"DE_DEST_IS_CDRECORD - The destination is a writable CD-ROM, possibly unformatted."
		dict[0x85]		:=	"DE_FILE_TOO_LARGE - The file involved in the operation is too large for the destination media or file system."
		dict[0x86]		:=	"DE_SRC_IS_CDROM - The source is a read-only CD-ROM, possibly unformatted."
		dict[0x87]		:=	"DE_SRC_IS_DVD - The source is a read-only DVD, possibly unformatted."
		dict[0x88]		:=	"DE_SRC_IS_CDRECORD - The source is a writable CD-ROM, possibly unformatted."
		dict[0xB7]		:=	"DE_ERROR_MAX - MAX_PATH was exceeded during the operation."
		dict[0x402]		:= 	"An unknown error occurred. This is typically due to an invalid path in the source or destination. This error does not occur on Windows Vista and later."
		dict[0x10000]	:=	"RRORONDEST	- An unspecified error occurred on the destination."
		dict[0x10074]	:=	"E_ROOTDIR | ERRORONDEST	- Destination is a root directory and cannot be renamed."
	}
	
	return dict[c] ? dict[c] : "Error code not recognized"
}

/*
	Library for getting info from a specific explorer window (if window handle not specified, the currently active
	window will be used).  Requires AHK_L or similar.  Works with the desktop.  Does not currently work with save
	dialogs and such.
	
	
	Explorer_GetSelected(hwnd="")   - paths of target window's selected items
	Explorer_GetAll(hwnd="")        - paths of all items in the target window's folder
	Explorer_GetPath(hwnd="")       - path of target window's folder
	
	example:
		F1::
			path := Explorer_GetPath()
			all := Explorer_GetAll()
			sel := Explorer_GetSelected()
			MsgBox % path
			MsgBox % all
			MsgBox % sel
		return
	
	Joshua A. Kinnison
	2011-04-27, 16:12
*/

Explorer_GetPath(hwnd="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All 
	
	; thanks to polyethene
	Loop
		If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		Else Break
	return path
}
Explorer_GetAll(hwnd="")
{
	return Explorer_Get(hwnd)
}
Explorer_GetSelected(hwnd="")
{
	return Explorer_Get(hwnd,true)
}

Explorer_GetWindow(hwnd="")
{
	; thanks to jethrow for some pointers here
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%
	
	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				return window
	}
	else if (class ~= "Progman|WorkerW") 
		return "desktop" ; desktop found
}
Explorer_Get(hwnd="",selection=false)
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
	{
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
		if !hwWindow ; #D mode
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			path := base "\" A_LoopField
			IfExist %path% ; ignore special icons like Computer (at least for now)
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
//    for item in collection
//			ret .= item.path "`n"
	}
	return collection
}















; ==================== RAPID HOTKEY ==================

RapidHotkey(keystroke, times="2", delay=0.2, IsLabel=0)
{
	Pattern := Morse(delay*1000)
	If (StrLen(Pattern) < 2 and Chr(Asc(times)) != "1")
		Return
	If (times = "" and InStr(keystroke, """"))
	{
		Loop, Parse, keystroke,""	
			If (StrLen(Pattern) = A_Index+1)
				continue := A_Index, times := StrLen(Pattern)
	}
	Else if (RegExMatch(times, "^\d+$") and InStr(keystroke, """"))
	{
		Loop, Parse, keystroke,""
			If (StrLen(Pattern) = A_Index+times-1)
				times := StrLen(Pattern), continue := A_Index
	}
	Else if InStr(times, """")
	{
		Loop, Parse, times,""
			If (StrLen(Pattern) = A_LoopField)
				continue := A_Index, times := A_LoopField
	}
	Else if (times = "")
		continue := 1, times := 2
	Else if (times = StrLen(Pattern))
		continue = 1
	If !continue
		Return
	Loop, Parse, keystroke,""
		If (continue = A_Index)
			keystr := A_LoopField
	Loop, Parse, IsLabel,""
		If (continue = A_Index)
			IsLabel := A_LoopField
	hotkey := RegExReplace(A_ThisHotkey, "[\*\~\$\#\+\!\^]")
	IfInString, hotkey, %A_Space%
		StringTrimLeft, hotkey,hotkey,% InStr(hotkey,A_Space,1,0)
	backspace := "{BS " times "}"
	keywait = Ctrl|Alt|Shift|LWin|RWin
	Loop, Parse, keywait, |
		KeyWait, %A_LoopField%
	If ((!IsLabel or (IsLabel and IsLabel(keystr))) and InStr(A_ThisHotkey, "~") and !RegExMatch(A_ThisHotkey
	, "i)\^[^\!\d]|![^\d]|#|Control|Ctrl|LCtrl|RCtrl|Shift|RShift|LShift|RWin|LWin|Alt|LAlt|RAlt|Escape|BackSpace|F\d\d?|"
	. "Insert|Esc|Escape|BS|Delete|Home|End|PgDn|PgUp|Up|Down|Left|Right|ScrollLock|CapsLock|NumLock|AppsKey|"
	. "PrintScreen|CtrlDown|Pause|Break|Help|Sleep|Browser_Back|Browser_Forward|Browser_Refresh|Browser_Stop|"
	. "Browser_Search|Browser_Favorites|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|MButton|RButton|LButton|"
	. "Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|Launch_App1|Launch_App2"))
		Send % backspace
	If (WinExist("AHK_class #32768") and hotkey = "RButton")
		WinClose, AHK_class #32768
	If !IsLabel
		Send % keystr
	else if IsLabel(keystr)
		Gosub, %keystr%
	Return
}	
Morse(timeout = 400) { ;by Laszo -> http://www.autohotkey.com/forum/viewtopic.php?t=16951 (Modified to return: KeyWait %key%, T%tout%)
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   IfInString, key, %A_Space%
		StringTrimLeft, key, key,% InStr(key,A_Space,1,0)
	If Key in Shift,Win,Ctrl,Alt
		key1:="{L" key "}{R" key "}"
   Loop {
      t := A_TickCount
      KeyWait %key%, T%tout%
		Pattern .= A_TickCount-t > timeout
		If(ErrorLevel)
			Return Pattern
    If key in Capslock,LButton,RButton,MButton,ScrollLock,CapsLock,NumLock
      KeyWait,%key%,T%tout% D
    else if Asc(A_ThisHotkey)=36
		KeyWait,%key%,T%tout% D
    else
      Input,pressed,T%tout% L1 V,{%key%}%key1%
	If (ErrorLevel="Timeout" or ErrorLevel=1)
		Return Pattern
	else if (ErrorLevel="Max")
		Return
   }
}




; ======================== WINAMP


;****************
;*              *
;*    Winamp    *
;*              *
;****************
Winamp(p_Command,p_Option=0)
    {
;-------------------------------------------------------------------------------
;
; Parameters        Description
; ==========        -----------
; p_Command         Winamp command/message.  This is a Winamp window command or
;                   a message to the Winamp program.  See the "Commands" section
;                   for more  information.  [Required]
;
; p_Option          Message option.  This parameter is only used if p_Command is
;                   idenfied as a WM_USER or WM_COPYDATA message.  The default
;                   value is 0.  [Optional]
;
;
;
; Commands
; ========
; There are 2 types commands:
;
;   1)  Window commands.  These commands allow you to determine the status of
;       the Winamp window(s) and to perform actions on these windows.  The
;       following commands are currently supported:
;
;           Command     Description/Return Code
;           -------     -----------------------
;           Active      Returns true if Winamp is active, false if it is not.
;
;           Activate    Activates the Winamp window.  Returns false if Winamp
;                       does not exist.
;
;           Exist       Returns true if the Winamp windows exist, false if they
;                       do not.
;
;           Minimize    If active, will minimize Winamp.  Returns false if
;                       Winamp does not exist.
;
;           Title       Returns the Winamp window title.  Depending on the
;                       configuration of Winamp, the title includes the artist
;                       and the song title of the current song.  This
;                       information can be extracted from the window title for
;                       other uses.
;
;
;   2)  Winamp message.  Winamp has been programmed to receive and respond to
;       a large number of messages sent to the primary Winamp window.  These
;       messages allow you to manipulate the Winamp and allow you to get the
;       current status of Winamp conditions.
;
;       Instead of using the raw Windows message components, this function uses
;       message "names" which are then converted into the standard message
;       components.  Once a message has been coded in this function, you only
;       have to remember (or look for) the appropriate message "name" in order
;       to use it.
;
;       Unfortunately, there are too many messages to document in this section.
;       Here's how to find/use the message names in the AHK code:
;
;       The message "names" can be extracted from the variables that begin with
;       "WA_WM_COMMAND_", "WA_WM_USER_" and "WA_WM_COPYDATA_".  For example, the
;       "WA_WM_COMMAND_NextTrack" variable is assigned the message that
;       instructs Winamp to skip to the next track in the playlist.  To send
;       this message to Winamp, simply call this function using "NextTrack" as
;       the command parameter, i.e. Winamp("NextTrack")
;
;
;   Notes
;   =====
;
;       Parameters
;       ----------
;       All spaces are removed from the p_Command parameter before the parameter
;       is processed.  This modification allows the function to use more
;       user-friendly (readable?) commands.  For example, the following all
;       execute the the same command:
;
;           Winamp("SetPlaylistPosition",273)
;           Winamp("Set PlaylistPosition",273)
;           Winamp("Set Playlist Position",273)
;
;
;       Winamp Versions
;       ---------------
;       Not all of the messages will work on all versions of Winamp.  Most
;       require version 2.0 or greater, many require version 2.05 or greater,
;       and a few require version 5.00 or greater.  Unfortunately, you have to
;       either do a "try it and see" or you have to download the SDK to
;       determine if the message will work with your version.  If you have a
;       fairly recent version of Winamp, it is likely that everything will work.
;       See the "References and Credit" section for more information.
;
;
;       Return Codes
;       ------------
;       The return codes for the Window commands are documented in the
;       "Commands" section above.
;
;       The return codes for the Winamp messages, if applicable, are documented
;       within the code.  If Winamp is not running or if the message "name" is
;       not is not found, return code 999 is returned.
;
;
;
;   References and Credit
;   =====================
;   Only a small fraction of the total number of Winamp messages have been
;   included in this function.  See the following posts for more complete list
;   of messages:
;
;       http://forums.winamp.com/showthread.php?threadid=180297
;       http://autohotkey.com/forum/viewtopic.php?t=126
;
;   Much of the Winamp message documentation included in this function was 
;   extracted from these posts and from the Winamp SDK.
;
;   Although these posts are stll contain accurate information (for the most
;   part), the latest versions of Winamp SDK include new messages and updated
;   documentation.  At this writing, the following include links to the latest
;   versions of the Winamp SDK:
;
;        http://www.winamp.com/nsdn/winamp/sdk/
;        http://forums.winamp.com/showthread.php?s=&threadid=168643
;
;   Most of the code to process WM_COPYDATA messages was extracted from the AHK
;   help file and from posts on the AHK forum.
;
;   Thank you to everyone who contributed.
;
;
;
;   Examples Of Use
;   ===============
;   Here are a few examples of how this function can be used in a script:
;
;   ;----- Start of examples -----
;   ^#!Up::Winamp("Play")  ;-- Nothing will happen if Winamp is not running.
;
;   ^#!Down::
;   if Winamp("Exist")  ;-- winamp running?
;       if Winamp("Is Playing")=1  ;-- Playing? (Check to avoid Pause toggle)
;           Winamp("Pause")
;   return
;   
;   ^#!Left::Winamp("Previous Track")  ;-- Go back 1 track
;   
;   ^#!Right::Winamp("Next Track")  ;-- Skip to the next track
;   ;----- End of examples -----
;
;-------------------------------------------------------------------------------

    ;[===================]
    ;[  AHK Environment  ]
    ;[===================]
    l_SavedDetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows On


    ;[=====================]
    ;[  Format parameters  ]
    ;[=====================]
    ;-- "Command"
    p_Command=%p_Command%  ;-- AutoTrim
    StringReplace p_Command,p_Command,%A_Space%,,All

    ;-- "Option"
    p_Option=%p_Option%    ;-- AutoTrim


    ;[==============]
    ;[  Initialize  ]
    ;[==============]
    GroupAdd l_WinampGroup,ahk_class BaseWindow_RootWnd
    GroupAdd l_WinampGroup,ahk_class Winamp EQ
    GroupAdd l_WinampGroup,ahk_class Winamp Gen
    GroupAdd l_WinampGroup,ahk_class Winamp PE
    GroupAdd l_WinampGroup,ahk_class Winamp Video
    GroupAdd l_WinampGroup,ahk_class Winamp v1.x
    l_WinampWindowTitle=ahk_class Winamp v1.x
    l_ReturnCode:=""


    ;[===================]
    ;[  Process command  ]
    ;[===================]
    gosub ProcessCommand


    ;[=====================]
    ;[  Reset environment  ]
    ;[=====================]
    DetectHiddenWindows %l_SavedDetectHiddenWindows%


    ;[====================]
    ;[  Return to sender  ]
    ;[====================]
    return %l_ReturnCode%




    ;*********************************
    ;*                               *
    ;*                               *
    ;*        Process Command        *
    ;*                               *
    ;*                               *
    ;*********************************
    ProcessCommand:
    ;-- Rule of thumb: Look for the "group" but act on the "window".

    ;*************************
    ;*                       *
    ;*    Window commands    *
    ;*                       *
    ;*************************
    ;[==========]
    ;[  Active  ]
    ;[==========]
    if p_Command in active,ifactive,ifwinactive
        {
        IfWinActive ahk_group l_WinampGroup
            l_ReturnCode:=true
         else
            l_ReturnCode:=false
        return
        }

    ;[============]
    ;[  Activate  ]
    ;[============]
    if p_Command in activate,winactivate
        {
        IfWinExist ahk_group l_WinampGroup
            {
            l_ReturnCode:=true
            IfWinNotActive ahk_group l_WinampGroup
                WinActivate %l_WinampWindowTitle%
            }
         else
            l_ReturnCode:=false
        return
        }


    ;[=========]
    ;[  Exist  ]
    ;[=========]
    if p_Command in exist,ifexist,ifwinexist
        {
        IfWinExist ahk_group l_WinampGroup
            l_ReturnCode:=true
         else
            l_ReturnCode:=false
        return
        }


    ;[============]
    ;[  Minimize  ]
    ;[============]
    if p_Command in min,minimize
        {
        IfWinExist ahk_group l_WinampGroup
            {
            l_ReturnCode:=true
            IfWinActive ahk_group l_WinampGroup
                WinMinimize %l_WinampWindowTitle%
            }
         else
            l_ReturnCode:=false
        return
        }

    ;[=========]
    ;[  Title  ]
    ;[=========]
    if p_Command=title
        {
        IfWinExist ahk_group l_WinampGroup
            {
            WinGetTitle l_TrackTitle,%l_WinampWindowTitle%
            l_ReturnCode:=l_TrackTitle
            }
         else
            l_ReturnCode:=false
        return
        }
    ;---------------------------------------------------------------------------
    ;
    ;  Include other Winamp window commands here
    ;
    ;---------------------------------------------------------------------------


    ;*************************
    ;*                       *
    ;*    Winamp Messages    *
    ;*                       *
    ;*************************
    ;-------------------
    ;-- Winamp running? 
    ;-------------------
    IfWinNotExist ahk_group l_WinampGroup
        {
        l_ReturnCode=999
        return
        }

    ;[=======================]
    ;[                       ]
    ;[  WM_COMMAND Messages  ]
    ;[                       ]
    ;[=======================]
    ;------------------------------
    ;-- Define WM_COMMAND messages 
    ;------------------------------
    WA_WM_COMMAND_Exit         =40001   ;-- Exit Winamp
    WA_WM_COMMAND_PreviousTrack=40044   ;-- Go to the previous track
    WA_WM_COMMAND_Play         =40045   ;-- Play/Restart
    WA_WM_COMMAND_Pause        =40046   ;-- Pause (toggle)
    WA_WM_COMMAND_Stop         =40047   ;-- Stop
    WA_WM_COMMAND_NextTrack    =40048   ;-- Skip to the next track
    WA_WM_COMMAND_VolumeUp     =40058   ;-- Increase volume a little (~1.5%)
    WA_WM_COMMAND_VolumeDown   =40059   ;-- Reduce volume a litte (~1.5%)  
    WA_WM_COMMAND_FastRewind   =40144   ;-- Fast-rewind 5 seconds
    WA_WM_COMMAND_FadeoutStop  =40147   ;-- Fadeout and stop
    WA_WM_COMMAND_FastForward  =40148   ;-- Fast-forward 5 seconds

    ;---------------------------------------------------------------------------
    ;
    ;  Include other WM_COMMAND messages here
    ;
    ;---------------------------------------------------------------------------

    ;-----------
    ;-- Aliases 
    ;-----------
    WA_WM_COMMAND_Close   :=WA_WM_COMMAND_Exit
    WA_WM_COMMAND_Quit    :=WA_WM_COMMAND_Exit
    WA_WM_COMMAND_Previous:=WA_WM_COMMAND_PreviousTrack
    WA_WM_COMMAND_Next    :=WA_WM_COMMAND_NextTrack
    WA_WM_COMMAND_Rewind  :=WA_WM_COMMAND_FastRewind
    WA_WM_COMMAND_Fadeout :=WA_WM_COMMAND_FadeoutStop
    WA_WM_COMMAND_Forward :=WA_WM_COMMAND_FastForward

    ;------------------------------
    ;-- Attempt to match p_Command 
    ;-- to known message     
    ;------------------------------
    l_WM_COMMAND_Message:=WA_WM_COMMAND_%p_Command%

    ;-----------------------------
    ;-- Valid WM_COMMAND message? 
    ;-----------------------------
    if strlen(l_WM_COMMAND_Message)
        {
        ;-- Send message to Winamp.  Wait for a response.
        SendMessage 0x0111,l_WM_COMMAND_Message,,,%l_WinampWindowTitle%
        l_ReturnCode:=ErrorLevel
        return
        }

    ;[====================]
    ;[                    ]
    ;[  WM_USER Messages  ]
    ;[                    ]
    ;[====================]
    ;---------------------------
    ;-- Define WM_USER messages 
    ;---------------------------
    WA_WM_USER_GetVersion=0         ;-- Version will be 0x20yx for winamp 2.yx.
                                    ;   Versions previous to Winamp 2.0
                                    ;   typically (but not always) use 0x1zyx
                                    ;   for 1.zx versions.  For Winamp 5.x, it
                                    ;   uses 0x50yx for Winamp 5.yx e.g. 5.01 ->
                                    ;   0x5001.
                                    ;
                                    ;   Note: Returned version may not match the
                                    ;   exact value of current version.  i.e.
                                    ;   Version 5.02 may return the same value
                                    ;   as for 5.01.


    WA_WM_USER_StartPlay=102        ;-- Starts/Restarts playback at the
                                    ;   beginning of the current track in the
                                    ;   playlist.
 
    WA_WM_USER_IsPlaying=104        ;-- Returns 1 if WA is playing, returns 3 if
                                    ;   WA is paused, and returns 0 if WA is NOT
                                    ;   playing.

    WA_WM_USER_GetOutputTime=105    ;-- If p_Option=0, returns the current
                                    ;   playback position in milliseconds.  If
                                    ;   p_Option=1, returns current track length
                                    ;   in seconds.  Returns -1 if WA is not
                                    ;   playing or if an error occurs.
                                    ;
                                    ;   Observations
                                    ;   ------------
                                    ;
                                    ;     p_Option=0
                                    ;     ----------
                                    ;     If Winamp is stopped, returns
                                    ;     4294967295.
                                    ;
                                    ;     If playing streaming data, returns the
                                    ;     amount of time the stream has been
                                    ;     playing, in milliseconds.
                                    ;
                                    ;   
                                    ;     p_Option=1
                                    ;     ----------
                                    ;     If playing streaming data, returns
                                    ;     4294967295.
                                    ;
                                    ;     If playing non-streaming data, will
                                    ;     sometimes return 4294967295 if the
                                    ;     message is sent while WA is in-between
                                    ;     tracks.  If you're planning to send WA
                                    ;     this message/option immediately after
                                    ;     after forcing a track change
                                    ;     (PreviousTrack or NextTrack), insert a
                                    ;     minor delay (sleep 1) in-between the
                                    ;     track change and this message/option
                                    ;     to avoid getting the 4294967295 value.
                                    ;
                                    ;     If playing non-streaming data, will
                                    ;     sometimes return 4294967295 if the
                                    ;     message is sent immediately after a
                                    ;     "Play" message.  Insert a significant
                                    ;     delay (sleep 50 should do it) after
                                    ;     the "Play" message to avoid getting
                                    ;     the 4294967295 value.


    WA_WM_USER_JumpToTime=106       ;-- Sets the position of the current track
                                    ;   to the offset specified in p_Option (in
                                    ;   milliseconds).

    WA_WM_USER_WritePlayList=120    ;-- Writes the current playlist to
                                    ;   <winampdir>\\Winamp.m3u, and returns the
                                    ;   current playlist position (relative to
                                    ;   0).

    WA_WM_USER_SetPlaylistPos=121   ;-- Sets the playlist position to the track
                                    ;   number (relative to 0) specified by the
                                    ;   value of p_Option.

    WA_WM_USER_SetVolume=122        ;-- Sets the volume to the value of p_Option
                                    ;   which can be between 0 (silent) and 255
                                    ;   (maximum).  If p_Option is set to -666
                                    ;   (I know, it's evil), will return the
                                    ;   current volume (0 - 255).

    WA_WM_USER_SetPanning=123       ;-- Sets the panning (balance) to the value
                                    ;   of p_Option, which can be between -127
                                    ;   (all left) and 127 (all right).

    WA_WM_USER_GetListLength=124    ;-- Returns the length of the current
                                    ;   playlist, in tracks.

    WA_WM_USER_GetListPos=125       ;-- Returns the position in tracks (relative
                                    ;   to 0) in the current playlist.    

    WA_WM_USER_GetInfo=126          ;-- Returns information about the currently
                                    ;   playing track.  If p_Option=0, returns
                                    ;   sample rate (i.e. 44100). If p_Option=1,
                                    ;   returns the bitrate (Note: If VBR, will
                                    ;   return the "current" bitrate).  If
                                    ;   p_Option=2, returns the number of
                                    ;   channels. 

    WA_WM_USER_RestartWinamp=135    ;-- Restarts Winamp.
    
    WA_WM_USER_CurrentFile=211      ;-- Retrieves (and returns a pointer
                                    ; in 'ret') a string that contains the
                                    ; filename of a playlist entry (indexed
                                    ; by 'data'). Returns NULL if error, or
                                    ; if 'data' is out of range. 
    ;---------------------------------------------------------------------------
    ;
    ;  Include other WM_USER messages here
    ;
    ;---------------------------------------------------------------------------

    ;-----------
    ;-- Aliases 
    ;-----------
    WA_WM_USER_Version            :=WA_WM_USER_GetVersion

    WA_WM_USER_GetPlaybackPosition:=WA_WM_USER_GetOutputTime
    WA_WM_USER_PlaybackPosition   :=WA_WM_USER_GetOutputTime

    WA_WM_USER_SetTrackPosition   :=WA_WM_USER_JumpToTime

    WA_WM_USER_SetPlaylistPosition:=WA_WM_USER_SetPlaylistPos

    WA_WM_USER_SetBalance         :=WA_WM_USER_SetPanning

    WA_WM_USER_GetPlaylistPosition:=WA_WM_USER_GetListPos
    WA_WM_USER_PlaylistPosition   :=WA_WM_USER_GetListPos

    WA_WM_USER_GetTrackInformation:=WA_WM_USER_GetInfo
    WA_WM_USER_TrackInformation   :=WA_WM_USER_GetInfo

    WA_WM_USER_Restart            :=WA_WM_USER_RestartWinamp 

    ;------------------------------
    ;-- Attempt to match p_Command 
    ;-- to known message     
    ;------------------------------
    l_WM_USER_Message:=WA_WM_USER_%p_Command%

    ;--------------------------
    ;-- Valid WM_USER message? 
    ;--------------------------
    if strlen(l_WM_USER_Message)
        {
        ;-- Send message to Winamp.  Wait for a response.
        SendMessage 0x400,p_Option,l_WM_USER_Message,,%l_WinampWindowTitle%
        l_ReturnCode:=ErrorLevel
        return
        }


    ;[========================]
    ;[                        ]
    ;[  WM_COPYDATA Messages  ]
    ;[                        ]
    ;[========================]
    ;-------------------------------
    ;-- Define WM_COPYDATA messages 
    ;------------------------------
    WA_WM_COPYDATA_EnqueueFile=100      ;-- Adds the file/address found in
                                        ;   p_Option to the end of the playlist.

    ;---------------------------------------------------------------------------
    ;
    ;  Include other WM_COPYDATA messages here
    ;
    ;---------------------------------------------------------------------------

    ;-----------
    ;-- Aliases 
    ;-----------
    WA_WM_COPYDATA_Enqueue :=WA_WM_COPYDATA_EnqueueFile
    WA_WM_COPYDATA_AddFile :=WA_WM_COPYDATA_EnqueueFile
    WA_WM_COPYDATA_AddTrack:=WA_WM_COPYDATA_EnqueueFile

    ;------------------------------
    ;-- Attempt to match p_Command 
    ;-- to known message     
    ;------------------------------
    l_WM_COPYDATA_Message:=WA_WM_COPYDATA_%p_Command%

    ;------------------------------
    ;-- Valid WM_COPYDATA message? 
    ;------------------------------
    if strlen(l_WM_COPYDATA_Message)
        {
        VarSetCapacity(l_cds,12) 
        InsertInteger(l_WM_COPYDATA_Message,l_cds) 
        InsertInteger(StrLen(p_Option)+1,l_cds,4) 
        InsertInteger(&p_Option,l_cds,8)

        ;-- Send message to Winamp.  Wait for a response.
        SendMessage,0x4A,0,&l_cds,,%l_WinampWindowTitle% 
        l_ReturnCode:=ErrorLevel
        return
        }


    ;[===========================]
    ;[  No valid messages found  ]
    ;[===========================]
    l_ReturnCode=999

    ;-- Return to sender
    return
    }



;************************
;*                      *
;*    Insert Integer    *
;*                      *
;************************
;-- This function was extracted from the AHK help file - Keyword: OnMessage
InsertInteger(pInteger,ByRef pDest,pOffset=0,pSize=4)
    {
	loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
		DllCall("RtlFillMemory",UInt,&pDest+pOffset+A_Index-1,UInt,1,UChar,pInteger>>8*(A_Index-1) & 0xFF)
    }

