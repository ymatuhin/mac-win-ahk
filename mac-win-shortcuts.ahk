#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook True
#MenuMaskKey vkE8
SendMode("Input")
SetKeyDelay(-1, -1)

global gAltTabActive := false

SendCtrl(combo) {
    Send("^" combo)
    MaskWin()
}

SendShiftCtrl(combo) {
    Send("^+" combo)
    MaskWin()
}

SendAndMask(keys) {
    Send(keys)
    MaskWin()
}

IsWinPressed() {
    return GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
}

MaskWin() {
    Send("{Blind}{vkE8}")
}

ReleaseAltTab(*) {
    global gAltTabActive

    if IsWinPressed() {
        return
    }

    Send("{Blind}{Alt up}")
    gAltTabActive := false
    SetTimer(ReleaseAltTab, 0)
    MaskWin()
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
#Right::SendAndMask("{End}")
#Left::SendAndMask("{Home}")

; Select to line end/start
#+Right::SendAndMask("+{End}")
#+Left::SendAndMask("+{Home}")

; Document start/end
#Up::SendAndMask("^{Home}")
#Down::SendAndMask("^{End}")

; Select to document start/end
#+Up::SendAndMask("^+{Home}")
#+Down::SendAndMask("^+{End}")

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
#+4::SendAndMask("#+s")

; Forward delete on Mac keyboards
#Backspace::SendAndMask("{Delete}")

; 1Password browser shortcut
#::SendAndMask("^")

; Cmd + Q as Alt + F4
#q::
{
    Send("{Alt Down}{F4}{Alt Up}")
    MaskWin()
}

; Cmd + M minimizes the active window
#m::
{
    WinMinimize("A")
    MaskWin()
}

; Alt + Tab while holding Win/Cmd
#Tab::
{
    global gAltTabActive

    if !gAltTabActive {
        Send("{Blind}{Alt down}")
        gAltTabActive := true
        SetTimer(ReleaseAltTab, 50)
    }

    Send("{Blind}{Tab}")
    MaskWin()
}
