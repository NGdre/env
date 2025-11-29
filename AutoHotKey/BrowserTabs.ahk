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

; opens google keep
; Hotkey: Alt+K
!k:: Run("https://keep.google.com/u/0/#home")

; runs work context
; Hotkey: Alt+W
!w:: {
    Run("C:\Users\Андрей\AppData\Local\Programs\Microsoft VS Code\Code.exe")
    Run("https://chat.deepseek.com/")
    Run("https://keep.google.com/u/0/#label/%D0%9F%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D1%8B")
}

; opens selected english text in google translate
; Hotkey: Ctrl+Shift+T
^+t::
{
    ; Save original clipboard contents
    savedClip := ClipboardAll()

    ; Clear clipboard and copy selected text
    A_Clipboard := ""
    Send "^c"

    ; Wait for clipboard to contain text (max 1 second)
    if !ClipWait(1) {
        MsgBox "No text selected or couldn't copy text."
        A_Clipboard := savedClip
        return
    }

    ; URL-encode the selected text
    encodedText := UriEncode(A_Clipboard)

    ; Construct Google Translate URL
    translateURL := "https://translate.google.com/?hl=ru&sl=en&tl=ru&text="
        . encodedText
        . "&op=translate"

    ; Restore original clipboard
    A_Clipboard := savedClip

    ; Open URL in default browser
    Run translateURL
}
