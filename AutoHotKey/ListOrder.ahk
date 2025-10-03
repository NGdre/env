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

; Чтобы использовать, выделите нужный текст и нажмите Ctrl+Win+L
^#l::
{
    savedClipboard := ClipboardAll()
    A_Clipboard := ""

    Send "^c"
    if !ClipWait(0.5) {
        A_Clipboard := savedClipboard
        return
    }

    text := A_Clipboard
    normalizedText := NormalizeList(text)

    A_Clipboard := normalizedText
    Send "^v"

    Sleep 500
    A_Clipboard := savedClipboard
}

NormalizeList(text) {
    lines := StrSplit(text, "`n", "`r")
    elements := []
    currentElement := { content: "", additional: [] }
    delimiter := ""

    ; Собираем элементы с их дополнительным текстом
    for line in lines {
        line := Trim(line, " `t`r`n") ; Убираем пробелы и табы только с краев

        ; Если строка пустая, добавляем ее к текущему элементу как дополнительную
        if line = "" {
            if currentElement.content != ""
                currentElement.additional.Push("")
            continue
        }

        ; Проверяем, является ли строка элементом списка
        if RegExMatch(line, "^\s*(\d+)([.)])\s*(.*)", &match) {
            ; Сохраняем разделитель из первого найденного элемента
            if delimiter = ""
                delimiter := match[2]

            content := Trim(match[3])

            ; Если у нас уже есть элемент, сохраняем его
            if currentElement.content != "" {
                elements.Push(currentElement.Clone())
                currentElement := { content: "", additional: [] }
            }

            ; Устанавливаем содержание нового элемента
            if content != "" {
                ; Приводим первую букву к верхнему регистру
                content := RegExReplace(content, "^(.)", UCase("$1"))
                currentElement.content := content
            }
        }
        else {
            ; Если это не элемент списка, добавляем как дополнительный текст
            if currentElement.content != ""
                currentElement.additional.Push(line)
        }
    }

    ; Добавляем последний элемент
    if currentElement.content != ""
        elements.Push(currentElement)

    ; Удаляем элементы с пустым содержанием (замена Filter)
    filteredElements := []
    for element in elements {
        if element.content != ""
            filteredElements.Push(element)
    }
    elements := filteredElements

    ; Сортируем элементы по содержанию (пузырьковая сортировка)
    sortedElements := BubbleSortElements(elements)

    ; Формируем результат
    result := ""
    for i, element in sortedElements {
        ; Добавляем основной элемент
        if delimiter = ")"
            result .= i . ") " . element.content
        else
            result .= i . ". " . element.content

        ; Добавляем дополнительный текст
        for j, additionalLine in element.additional {
            result .= "`r`n" . additionalLine
        }

        if i < sortedElements.Length
            result .= "`r`n"
    }

    return result
}

; Функция пузырьковой сортировки для элементов
BubbleSortElements(arr) {
    sorted := []
    for item in arr
        sorted.Push(item)

    n := sorted.Length
    loop {
        swapped := false
        loop n - 1 {
            if StrCompare(sorted[A_Index].content, sorted[A_Index + 1].content) > 0 {
                temp := sorted[A_Index]
                sorted[A_Index] := sorted[A_Index + 1]
                sorted[A_Index + 1] := temp
                swapped := true
            }
        }
        n := n - 1
    } until !swapped || n <= 1

    return sorted
}

; Функция для преобразования первого символа в верхний регистр
UCase(str) {
    return Format("{:U}", str)
}
