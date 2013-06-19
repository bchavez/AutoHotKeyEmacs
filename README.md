## AutoHotkey Emacs key bindings for Windows

This is my AutoHotkey script that gives Emacs key bindings for windows that is Visual Studio 2012 friendly.

###How to use

Create a shortcut to **emacs_everywhere.ahk** and place it in your Windows start up folder. Be sure to add the **\*.ico** icons in where you place the **.ahk** script.

Use the **FilterApps** function to do some per-filtering for special mappings that need to be made to emulate Emacs.

Here's an example:

```
FilterApps(ByRef emacskey, ByRef stroke1, ByRef stroke2){
    if WinActive("ahk_exe mintty.exe")
    {
       if ( emacskey = "^k" ) 
       {
           Send, ^k
           return "stop"
       }
    }

    if WinActive("ahk_class Notepad2U"){
       if( emacskey = "^s")
         stroke1 = ^f
       if( emacskey = "^r")
         stroke1 = ^f
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
}
```




### License

Do what you want. I think I downloaded it somewhere on the internet, but I modified it to better suit my needs. If it kills your cat, melts your ice cream, or accidentally sends emails to your boss; don't blame me.

Brian Chavez

