/*
********************************************************
* Easily add or remove folding Block Comments and      *
* Folding Regions in AutoHotkey scripts.               *
* Requires VSCode and an AutoHotkey language extension.*
* ******************************************************
* Allows nesting of all types of folding blocks, but   *
* does not permit nesting of Block Comments.           *
********************************************************
* NOTE: The script functions by manipulting the        *
* Clipboard causing any original content to be lost.   *
********************************************************
*/

#SingleInstance, force
SetTitleMatchMode, Regex
If (!WinActive("^.*?- Visual Studio Code$")){
    MsgBox,% 48+262144, Easy Folding, VSC not active.
    ExitApp
}

Gui, +hwndguihwnd +ToolWindow -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui, Font, s8
Gui, Add, Text,, Label:
Gui, Add, Edit, x+m ym-4 w186 vlabel,
Gui, Add, GroupBox, xm w112 Section, Block Comment:
Gui, Add, Button, xs+10 ys+20 gbcAdd, Add
Gui, Add, Button, x+m yp gbcRemove, Remove
Gui, Add, GroupBox, x+m yp-20 w112 Section, Region:
Gui, Add, Button, xs+10 ys+20 gfrAdd, Add
Gui, Add, Button, x+m yp gfrRemove, Remove
Gui, Show,, Easy Folding

SetTitleMatchMode, 3
Loop
    If !WinExist("Easy Folding")
        ExitApp
Return

bcAdd:
    Gui, Submit
    GoSub, getClipboard
    If (label != "")
        label := " " label
    Clipboard := RegExReplace(Clipboard, "s)^(.*)$", "/* `;region" label "`n$1`n`*/ `;endregion" label "")
    Send, ^v
    Reload
Return

bcRemove:
    Gui, Destroy
    GoSub, getClipboard
    RegEx := "^\/\*.*?\R|\R\*\/.*?$"
    If (!RegExMatch(Clipboard, RegEx)){
        MsgBox,% 48+262144,The area selected is..., ...not a Block Comment.
        Reload
    }
    Clipboard := RegExReplace(Clipboard, RegEx)
    Send, ^v
    Reload
Return

frAdd:
    Gui, Submit
    GoSub, getClipboard
    If (label != "")
        label := " " label
    Clipboard := RegExReplace(Clipboard, "s)^(.*)$", "`;region" label "`n$1`n`;endregion" label "")
    Send, ^v
    Reload
Return

frRemove:
    Gui, Destroy
    GoSub, getClipboard
    RegEx := "^`;region.*?\R|\R`;endregion.*?$"
    If (!RegExMatch(Clipboard, RegEx)){
        MsgBox,% 48+262144,The area selected is..., ...not a Folding Region.
        Reload
    }
    Clipboard := RegExReplace(Clipboard, RegEx)
    Send, ^v
    Reload
Return

getClipboard:
    Clipboard =
    While, (Clipboard)
        Sleep, 0
    Send, ^c
    ClipWait, 2
    if ErrorLevel
    {
        MsgBox,% 48+262144,Clipboard has no content., Select an area of code`nand try again.`n`nIf you have preselected an area, perhaps the editor has lost focus.
        Run %A_ScriptFullPath%
    }
Return

GuiEscape:
    Gui, Destroy
    ExitApp
Return