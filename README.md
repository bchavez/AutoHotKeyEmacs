## AutoHotkey Emacs Key Bindings for Windows

This is my **AutoHotkey** script that gives Emacs key bindings for the **Windows OS**. Also, one that is **Visual Studio** friendly.

## How to use

#### Startup Configuration

Create a shortcut to **emacs_everywhere.ahk** and place it in your Windows start up folder. Be sure to add the **\*.ico** icons in where you place the **.ahk** script.

Use the **FilterApps** function to do some per-filtering for special re-mappings that need to be made to emulate Emacs.

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

#### Import Visual Studio keyboard settings
Next, import the `Keyboard` settings from one of the latest `*.vssettings` file in this repo.

If all goes well, you should have Emacs keybindings everywhere in the **Windows OS**, including **Chrome**, **Notepad** and **Visual Studio**. 

## License

Do what you want. I think I downloaded it somewhere on the internet, but I modified it to better suit my needs. If it kills your cat, melts your ice cream, or accidentally sends emails to your boss; don't blame me.

Brian Chavez

