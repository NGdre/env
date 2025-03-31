^+d:: Run "C:\Users\Андрей\Downloads" ; ctrl+shift+d

LoopRunning := false  ; Control flag for the loop

Hotkey("^+t", StartLoop)  ; Start key (change F1 to your preferred key)
Hotkey("^+b", StopLoop)   ; Stop key (change F2 to your preferred key)

StartLoop(*) {
    global LoopRunning
    if LoopRunning  ; Prevent multiple starts
        return

    sleepDuration := 250

    LoopRunning := true
    while LoopRunning {
        Send "{g down}"
        Sleep sleepDuration
        Send "{g up}"

        Send "{h down}"
        Sleep sleepDuration
        Send "{h up}"

    }
}

StopLoop(*) {
    global LoopRunning := false
}

; gets mouse position by given command
Hotkey("+^1", getMousePos)

getMousePos(*) {
    xpos := 0
    ypos := 0
    MouseGetPos(&xpos, &ypos)
    xy := "x" xpos " y" ypos

    Send(xy)
}

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

        ; Paste the modified text
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
