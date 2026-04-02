#Requires AutoHotkey v2.0
#SingleInstance Force

*LWin::
{
    Send("{LControl Down}")
}

*LWin Up::
{
    Send("{LControl Up}")
}

SendKeys(keys) {
    Send(keys)
}

; Line start/end
<^Right::SendKeys("{End}")
<^Left::SendKeys("{Home}")

; Select to line end/start
<^+Right::SendKeys("+{End}")
<^+Left::SendKeys("+{Home}")

; Document start/end
<^Up::SendKeys("^{Home}")
<^Down::SendKeys("^{End}")

; Select to document start/end
<^+Up::SendKeys("^+{Home}")
<^+Down::SendKeys("^+{End}")

; Screenshot selection
<^+4::SendKeys("#+s")

; Forward delete on Mac keyboards
<^Backspace::SendKeys("{Delete}")

; Cmd + Q as Alt + F4
<^q::
{
    Send("{Alt Down}{F4}{Alt Up}")
}

; Cmd + M minimizes the active window
<^m::
{
    WinMinimize("A")
}

; Alt + Tab while holding Ctrl/Cmd
<^Tab::AltTab
