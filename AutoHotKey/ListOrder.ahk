#Requires AutoHotkey v2.0

; creates an unordered list from selected by mouse text
; press win + u
#u:: {
    ; Store original clipboard content
    originalClipboard := ClipboardAll()

    ; Clear clipboard and copy selected text
    A_Clipboard := ""
    Send "^c"

    ; Wait for clipboard to contain text
    if !ClipWait(0.5) {
        A_Clipboard := originalClipboard
        return
    }

    ; Process the text
    text := A_Clipboard
    lines := StrSplit(text, "`n", "`r")
    prefixedText := ""

    for line in lines {
        trimmedLine := Trim(line)
        if (trimmedLine != "") {
            prefixedText .= "- " . trimmedLine . "`n"
        }
    }

    ; Remove trailing newline and paste back
    prefixedText := RTrim(prefixedText, "`n")
    A_Clipboard := prefixedText
    Send "^v"

    ; Brief pause for reliability
    Sleep 50

    ; Restore original clipboard
    A_Clipboard := originalClipboard
}

; creates an ordered list from selected by mouse text
; press win + o
#o:: {
    ; Store original clipboard content
    originalClipboard := ClipboardAll()

    ; Clear clipboard and copy selected text
    A_Clipboard := ""
    Send "^c"

    ; Wait for clipboard to contain text
    if !ClipWait(0.5) {
        A_Clipboard := originalClipboard
        return
    }

    ; Process the text
    text := A_Clipboard
    lines := StrSplit(text, "`n", "`r")
    prefixedText := ""
    counter := 1

    for line in lines {
        trimmedLine := Trim(line)
        if (trimmedLine != "") {
            prefixedText .= counter . ". " . trimmedLine . "`n"
            counter++
        }
    }

    ; Remove trailing newline and paste back
    prefixedText := RTrim(prefixedText, "`n")
    A_Clipboard := prefixedText
    Send "^v"

    ; Brief pause for reliability
    Sleep 50

    ; Restore original clipboard
    A_Clipboard := originalClipboard
}
