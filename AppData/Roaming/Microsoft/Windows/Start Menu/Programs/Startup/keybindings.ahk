; Default AutoHotKey script setup
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Allows only a single instance of this script
#SingleInstance, Force
return

; Binds AltGr + O and AltGr + P to { and }
<^>!o::Send {{}
<^>!p::Send {}}

; Binds AltGr + K and AltGr + L to [ and ]
<^>!k::Send {[}
<^>!l::Send {]}

; Binds Ctrl + Q and Ctrl + W to Alt + F4 and Ctrl + F4 for more MacOS-like window closing
^q::Send !{F4}
^w::Send ^{F4}

; Binds Ctrl-Tab to Alt-Tab
^Tab::
Send {Alt down}{Tab}
Keywait Control
Send {Alt up}
return

; Binds Ctrl-Shift-Tab to Alt-Shift-Tab
^+Tab::
Send {Alt down}{Shift down}{Tab}
Keywait Control
Send {Alt up}
Send {Shift up}
return

; Binds Ctrl + Alt + Q to lock computer, like MacOS
^!q::DllCall("LockWorkStation")
