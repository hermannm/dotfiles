; Default AutoHotKey script setup.
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Allows only a single instance of this script.
#SingleInstance, Force
return

; Maps curly brackets to AltGr + O and AltGr + P.
<^>!o::<^>!7
<^>!p::<^>!0

; Maps Alt + F4 and Ctrl + F4 to Alt + Q and Alt + W for more MacOS-like window closing.
!q::Send !{F4}
!w::Send ^{F4}
