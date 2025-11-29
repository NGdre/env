#Requires AutoHotkey v2.0

currentPort := 3000
defaultPort := 3000

; opens localhost tab
; Hotkey: Alt+L
!l::
{
    global currentPort
    Run "http://localhost:" currentPort "/"
}

; change current port of localhost
; Hotkey: Alt+Shift+L
!+l::
{
    global currentPort
    try {
        newPort := InputBox(
            "Enter port number:",
            "Change Port",
            "w300 h150",
            currentPort
        ).value
        if newPort = ""
            return
        currentPort := Integer(newPort)
    }
    catch {
        MsgBox "Invalid port number!", "Error", 16
    }
}

; reset port to default
; Hotkey: Alt+Shift+R
!+r::
{
    global currentPort, defaultPort
    currentPort := defaultPort
    MsgBox "Port reset to default: " currentPort, "Port Reset", 64
}
