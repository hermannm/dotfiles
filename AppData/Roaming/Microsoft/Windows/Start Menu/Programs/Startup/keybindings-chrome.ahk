; Default AutoHotKey script setup.
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Allows only a single instance of this script.
#SingleInstance, Force
return

; Applies script only when Chrome is the active window.
#IfWinActive, ahk_exe chrome.exe

; Binds Alt + T to Ctrl + T for opening new tabs.
!t::Send ^t

; Binds Alt + {1-9} to Ctrl + {1-9} for tab switching.
!1::Send ^1
!2::Send ^2
!3::Send ^3
!4::Send ^4
!5::Send ^5
!6::Send ^6
!7::Send ^7
!8::Send ^8
!9::Send ^9
