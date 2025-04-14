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
; Hotkey: Alt+p
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

; pastes const key word with space after
; Hotkey: c + Tab
Hotstring(":T:c", pasteConst)

pasteConst(Hotstring) {
    Send "const "
}
