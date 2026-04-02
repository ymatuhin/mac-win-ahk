#Requires AutoHotkey v2.0
#SingleInstance Force

global altTabActive := false

LWin::LControl

SendKeys(keys) {
    Send(keys)
}

SendAltTab(reverse := false) {
    global altTabActive

    if !altTabActive {
        Send("{Alt Down}")
        altTabActive := true
    }

    if reverse {
        Send("+{Tab}")
    } else {
        Send("{Tab}")
    }
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
<^Tab::
{
    SendAltTab()
}

<^+Tab::
{
    SendAltTab(true)
}

~LControl Up::
{
    global altTabActive

    if altTabActive {
        Send("{Alt Up}")
        altTabActive := false
    }
}
