## Emacs Key Bindings for Windows Operating System

These are my **AutoHotkey** script that enables Emacs key bindings for the entire **Windows** operating system. Also, these **AutoHotkey** scripts are **Visual Studio** friendly.

## The Scripts

* `emacs_everywhere.ahk` - Enables emacs key bindings everywhere in the **Windows** operating system.
* `TestNamingMode.ahk` - A script that when activated with `Ctrl+Shift+U` or `Ctrl+Shift+I`, replaces space " " characters with underscore \_ characters in the method names of C# unit tests as you type. This is useful when, writing unit tests in the following format:
```csharp
[Fact]
public void my_unit_test_is_very_nice()
{
   Console.WriteLine("Hello World");
}
```
<img src="https://raw.githubusercontent.com/bchavez/AutoHotKeyEmacs/master/docs/testmode.gif"/>

Notice that the spaces in `my_unit_test_is_very_nice` have been replaced with underscore \_ characters as I type the unit test method name. However, when ***I press enter*** to move the typing carrot to the method body, spaces are no longer converted to underscore \_ characters. Additionally, I have **ReSharper Live Templates** in the C# scope wired to expand the "tu" and "tx" keystrokes. My **Live Templates** are listed below:
```csharp
// tu - for NUnit
[Test]
public void $Test$()
{
    $END$
}

//tx - for xUnit
[Fact]
public void $Test$()
{
    $END$
}
```
* `OtherStuff.ahk` - General useful hot keys like `Windows Key+N` for opening up **Notepad2**.


## How to use

#### Startup Configuration

Create a shortcut to `emacs_everywhere.ahk` (and any of the other scripts you want to use) and place it in your **Windows** start up folder.

For example, the `*.ahk` ***shortcuts*** would go here:
```
C:\Users\MyAccountName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
```
Be sure to add the **\*.ico** icons in same folder where the **.ahk** script reside; otherwise, you might get some script errors as the **.ahk** files fail to load system tray icons.

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

If all goes well, you should have Emacs keybindings everywhere in the **Windows** operating system, including **Chrome**, **Notepad** and **Visual Studio**.

## License

Do what you want. I think I downloaded it somewhere on the internet, but I modified it to better suit my needs. If it kills your cat, melts your ice cream, or accidentally sends emails to your boss; don't blame me.

-Brian Chavez

