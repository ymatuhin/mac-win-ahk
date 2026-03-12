#Requires AutoHotkey v2.0
#SingleInstance Force
A_MenuMaskKey := "vkE8"

SendCtrl(combo) {
    Send("^" combo)
    ReleaseWin()
}

SendShiftCtrl(combo) {
    Send("^+" combo)
    ReleaseWin()
}

SendAndRelease(keys) {
    Send(keys)
    ReleaseWin()
}

ReleaseWin() {
    if GetKeyState("LWin", "P") {
        KeyWait("LWin")
    }
    if GetKeyState("RWin", "P") {
        KeyWait("RWin")
    }
    Send("{Blind}{vkE8}")
}

; Copy, paste, cut
#c::SendCtrl("c")
#v::SendCtrl("v")
#x::SendCtrl("x")

; New, Save, Open
#n::SendCtrl("n")
#+n::SendShiftCtrl("n")
#s::SendCtrl("s")
#+s::SendShiftCtrl("s")
#o::SendCtrl("o")
#p::SendCtrl("p")

; Browser tabs
#t::SendCtrl("t")
#w::SendCtrl("w")
#+t::SendShiftCtrl("t")
#+w::SendShiftCtrl("w")
#r::SendCtrl("r")
#l::SendCtrl("l")
#d::SendCtrl("d")

; Select all
#a::SendCtrl("a")

; Line start/end
#Right::SendAndRelease("{End}")
#Left::SendAndRelease("{Home}")

; Select to line end/start
#+Right::SendAndRelease("+{End}")
#+Left::SendAndRelease("+{Home}")

; Document start/end
#Up::SendAndRelease("^{Home}")
#Down::SendAndRelease("^{End}")

; Select to document start/end
#+Up::SendAndRelease("^+{Home}")
#+Down::SendAndRelease("^+{End}")

; Undo/redo
#z::SendCtrl("z")
#+z::SendShiftCtrl("z")

; Find, find next
#f::SendCtrl("f")
#g::SendCtrl("g")

; Text formatting (bold, italic, etc)
#b::SendCtrl("b")
#i::SendCtrl("i")
#u::SendCtrl("u")
#k::SendCtrl("k")
#,::SendCtrl(",")

; Send/line break
#Enter::SendCtrl("{Enter}")

; Screenshot selection
#+4::SendAndRelease("#+s")

; Forward delete on Mac keyboards
#Backspace::SendAndRelease("{Delete}")

; 1Password browser shortcut
#::SendAndRelease("^")

; Cmd + Q as Alt + F4
#q::
{
    Send("{Alt Down}{F4}{Alt Up}")
    ReleaseWin()
}

; Cmd + M minimizes the active window
#m::
{
    WinMinimize("A")
    ReleaseWin()
}

; Alt + Tab while holding Win/Cmd
#Tab::
{
    static altDown := false

    if !altDown {
        Send("{Blind}{Alt down}")
        Sleep(50)
        Send("{Tab}")
        altDown := true
    } else {
        Send("{Tab}")
    }

    if GetKeyState("LWin", "P") {
        KeyWait("LWin")
    }
    if GetKeyState("RWin", "P") {
        KeyWait("RWin")
    }

    Send("{Alt up}")
    altDown := false
    Send("{Blind}{vkE8}")
}
