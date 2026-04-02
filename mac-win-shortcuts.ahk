#Requires AutoHotkey v2.0
#SingleInstance Force

A_MenuMaskKey := "vkE8"

SendCtrl(combo) {
    Send("^" combo)
}

SendShiftCtrl(combo) {
    Send("^+" combo)
}

SendKeys(keys) {
    Send(keys)
}

; Copy, paste, cut
<#c::SendCtrl("c")
<#v::SendCtrl("v")
<#x::SendCtrl("x")

; New, Save, Open, Print
<#n::SendCtrl("n")
<#+n::SendShiftCtrl("n")
<#s::SendCtrl("s")
<#+s::SendShiftCtrl("s")
<#o::SendCtrl("o")
<#p::SendCtrl("p")

; Browser tabs
<#t::SendCtrl("t")
<#w::SendCtrl("w")
<#+t::SendShiftCtrl("t")
<#+w::SendShiftCtrl("w")
<#r::SendCtrl("r")
<#l::SendCtrl("l")
<#d::SendCtrl("d")

; Select all
<#a::SendCtrl("a")

; Undo/redo
<#z::SendCtrl("z")
<#+z::SendShiftCtrl("z")

; Find, find next
<#f::SendCtrl("f")
<#g::SendCtrl("g")

; Text formatting
<#b::SendCtrl("b")
<#i::SendCtrl("i")
<#u::SendCtrl("u")
<#k::SendCtrl("k")
<#,::SendCtrl(",")

; Send/line break
<#Enter::SendCtrl("{Enter}")

; Line start/end
<#Right::SendKeys("{End}")
<#Left::SendKeys("{Home}")

; Select to line end/start
<#+Right::SendKeys("+{End}")
<#+Left::SendKeys("+{Home}")

; Document start/end
<#Up::SendKeys("^{Home}")
<#Down::SendKeys("^{End}")

; Select to document start/end
<#+Up::SendKeys("^+{Home}")
<#+Down::SendKeys("^+{End}")

; Screenshot selection
<#+4::SendKeys("#+s")

; Forward delete on Mac keyboards
<#Backspace::SendKeys("{Delete}")

; Cmd + Q as Alt + F4
<#q::
{
    Send("{Alt Down}{F4}{Alt Up}")
}

; Cmd + M minimizes the active window
<#m::
{
    WinMinimize("A")
}

; Cmd + Tab while holding the physical left Win key
<#Tab::AltTab
