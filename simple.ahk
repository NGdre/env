^+d:: Run "C:\Users\Андрей\Downloads" ; ctrl+shift+d

Hotkey("^d", clearText)

clearText(*) {
    Send("^a")
    Sleep 10
    Send("{Delete}")
}

; Uppercase selected text
; Hotkey: Ctrl+Alt+U
^!u:: {
    try {
        ; Save original clipboard contents
        clip_original := ClipboardAll()

        ; Copy selected text
        A_Clipboard := ""
        Send "^c"
        if !ClipWait(0.5)  ; Wait 0.5 seconds for clipboard to contain text
            return

        ; Convert to uppercase
        A_Clipboard := StrUpper(A_Clipboard)

        ; Paste the modified textпрпрпр
        Send "^v"

        ; Short delay to ensure paste completes before restoring clipboard
        Sleep 100
    }
    finally {
        ; Restore original clipboard
        A_Clipboard := clip_original
        clip_original := ""  ; Free memory
    }
}

; Activate only in code editors (customize as needed)
GroupAdd "CodeEditors", "ahk_exe Code.exe"      ; VS Code
GroupAdd "CodeEditors", "ahk_exe WebStorm.exe"  ; WebStorm
GroupAdd "CodeEditors", "ahk_exe idea64.exe"    ; IntelliJ

#HotIf WinActive("ahk_group CodeEditors")
; Hotstring("::console.log", RemindDebugger)
Hotstring("::clg", RemindDebugger)
#HotIf

RemindDebugger(*) {
    ; Visual alert with fading tooltip
    xpos := 0
    ypos := 0
    MouseGetPos(&xpos, &ypos)

    ToolTip("Consider using debugger instead!", xpos + 20, ypos - 40)
    SetTimer(() => ToolTip(), -5000)  ; Remove after 2 seconds

    ; Optional sound feedback (remove if not wanted)
    SoundPlay "*-1"  ; System 'ding' sound
}

; insert double cycle by typing "dfor" and pressing tab
Hotstring(":T:dfor", dfor)

dfor(Hotstring) {
    Send "const m = grid.length;{Enter}"
    Send "const n = grid[0].length;{Enter}{Enter}"
    Send "for (let i = 0; i < m; i{+}{+}) {{}{Enter}"
    Send "for (let j = 0; j < n; j{+}{+}) {{}{Enter}"
    Send "// code here{Enter}"
    Send "{}}"
}

; insert matrix filled with zeros
Hotstring(":T:zeromat", zeromat)

zeromat(Hotstring) {
    Send "const mat = Array.from({{}length: m{}}, () => new Array(n).fill(0));{Enter}"
}

; insert empty matrix
Hotstring(":T:mat", mat)

mat(Hotstring) {
    Send "const mat = Array.from({{}length: m{}}, () => new Array(n));{Enter}"
}

Hotstring(":T:freq", freq)

freq(Hotstring) {
    Send "const freqs = new Map();{Enter}{Enter}"
    Send "for (let i = 0; i < m; i{+}{+}) {{}{Enter}"
    Send "const freq = freqs.get(freqs[i]);{Enter}"
    Send "freqs.set(freqs[i], (freq || 0) {+} 1);{Enter}"
    Send "{}}"
}

~^s:: {
    MsgBox "easier to change or harder to change?"
}

; opens programing folder
; Hotkey: Alt+p
!p:: {
    Run("C:\Users\Андрей\OneDrive\Рабочий стол\Программирование")
}

; opens google keep
; Hotkey: Alt+k
!k:: Run("https://keep.google.com/u/0/#home")

; runs work context
; Hotkey: Alt+w
!w:: {
    Run("C:\Users\Андрей\AppData\Local\Programs\Microsoft VS Code\Code.exe")
    Run("https://chat.deepseek.com/")
    Run("https://keep.google.com/u/0/#label/%D0%9F%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D1%8B")
}

; pastes the next date above some date (changes now only days)
; Hotkey: Ctrl+Alt+N
^!n::
{
    A_Clipboard := "" ; Start with empty clipboard

    ; Select and copy the current line
    Send "{Home}+{End}^c"
    if !ClipWait(0.5) { ; Wait for clipboard to contain text
        return
    }

    ; Get input date (from clipboard or input box)
    clipboardContent := Trim(A_Clipboard)
    if (RegExMatch(clipboardContent, "^\d{2}.\d{2}.\d{4}$")) {
        inputDate := clipboardContent
    } else {
        return
    }

    ; Validate format and split into parts
    if (!RegExMatch(inputDate, "^(?<day>\d{2}).(?<month>\d{2}).(?<year>\d{4})$", &match)) {
        return
    }

    year := match.year, month := match.month, day := match.day

    ahkDate := year . month . day
    if (StrLen(ahkDate) != 8 || !IsInteger(ahkDate)) {
        MsgBox "Invalid date components."
        return
    }

    ahkDate += 1, "Days"

    formattedNextDate := FormatTime(ahkDate, "dd.MM.yyyy")

    ; Paste above the original line
    A_Clipboard := formattedNextDate
    Send "{Home}{Enter}{Up}^v"
}

IsInteger(str) {
    return RegExMatch(str, "^\d+$") ? true : false
}

!i:: {
    Send "и т.д."
}

; pastes dash
; Hotkey: -- + Tab
Hotstring(":T:--", pasteDash)

pasteDash(Hotstring) {
    Send "—"
}

; opens selected english text in google translate
; Hotkey: Ctrl + Shift + T
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

; Custom URL-encoding function
UriEncode(str) {
    buf := Buffer(StrPut(str, "UTF-8"))
    StrPut(str, buf, "UTF-8")
    encoded := ""

    loop buf.Size - 1 {  ; Exclude null terminator
        byte := NumGet(buf, A_Index - 1, "UChar")
        if (byte >= 0x41 && byte <= 0x5A) ; A-Z
        || (byte >= 0x61 && byte <= 0x7A) ; a-z
        || (byte >= 0x30 && byte <= 0x39) ; 0-9
        || byte == 0x2D ; -
        || byte == 0x5F ; _
        || byte == 0x2E ; .
        || byte == 0x7E ; ~
        {
            encoded .= Chr(byte)
        } else {
            encoded .= "%" Format("{:02X}", byte)
        }
    }
    return encoded
}

; converts selected text into kebab case for english characters
; Press Ctrl+Shift+K
^+k:: {
    ; Store original clipboard contents
    originalClipboard := ClipboardAll()

    ; Clear clipboard and copy selected text
    A_Clipboard := ""
    Send('^c')
    if !ClipWait(1) {
        ; Restore clipboard if no text was selected
        A_Clipboard := originalClipboard
        return
    }

    ; Process the text - convert to kebab-case
    text := A_Clipboard
    if text != "" {
        ; Convert to kebab-case
        ; 1. Convert to lowercase
        kebabText := StrLower(text)
        ; 2. Replace spaces and underscores with hyphens
        kebabText := StrReplace(kebabText, " ", "-")
        kebabText := StrReplace(kebabText, "_", "-")
        ; 3. Remove special characters (keep only alphanumeric and hyphens)
        kebabText := RegExReplace(kebabText, "[^a-z0-9-]", "")
        ; 4. Replace multiple consecutive hyphens with single hyphen
        kebabText := RegExReplace(kebabText, "-+", "-")
        ; 5. Remove leading/trailing hyphens
        kebabText := RegExReplace(kebabText, "^-|-$", "")

        A_Clipboard := kebabText

        ; Paste the converted text
        Send('^v')
    }

    ; Brief pause then restore original clipboard
    Sleep(100)
    A_Clipboard := originalClipboard
}
