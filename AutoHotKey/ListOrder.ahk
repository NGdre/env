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
    ; Сохраняем текущий буфер обмена
    savedClipboard := ClipboardAll()
    A_Clipboard := "" ; Очищаем буфер обмена

    ; Копируем выделенный текст
    Send "^c"
    if !ClipWait(0.5) {
        ; Восстанавливаем буфер обмена и выходим, если не удалось скопировать
        A_Clipboard := savedClipboard
        return
    }

    ; Получаем текст из буфера обмена
    text := A_Clipboard

    ; Нормализуем список
    normalizedText := NormalizeList(text)

    ; Вставляем обработанный текст
    A_Clipboard := normalizedText
    Send "^v"

    ; Восстанавливаем оригинальный буфер обмена через 500 мс
    Sleep 500
    A_Clipboard := savedClipboard
}

NormalizeList(text) {
    ; Разбиваем текст на строки
    lines := StrSplit(text, "`n", "`r")
    elements := []
    delimiter := ""

    ; Обрабатываем каждую строку
    for line in lines {
        line := Trim(line)

        ; Пропускаем пустые строки
        if line = ""
            continue

        ; Ищем элементы с номером в начале (поддерживает форматы "1.", "1)", "1) ")
        if RegExMatch(line, "^\s*(\d+)([.)])\s*(.*)", &match) {
            ; Сохраняем разделитель из первого найденного элемента
            if delimiter = ""
                delimiter := match[2]

            content := Trim(match[3])

            ; Пропускаем элементы с пустым содержимым
            if content != "" {
                ; Приводим первую букву к верхнему регистру
                if content != "" {
                    firstChar := SubStr(content, 1, 1)
                    restOfString := SubStr(content, 2)
                    content := Format("{:U}", firstChar) . restOfString
                }

                elements.Push(content)
            }
        }
    }

    ; Сортируем элементы в лексикографическом порядке
    ; В AHK v2 используем обычную сортировку массива строк
    sortedElements := SortArray(elements)

    ; Формируем новый список с правильной нумерацией
    result := ""
    loop sortedElements.Length {
        if delimiter = ")"
            result .= A_Index . ") " . sortedElements[A_Index]
        else
            result .= A_Index . ". " . sortedElements[A_Index]

        if A_Index < sortedElements.Length
            result .= "`r`n"
    }

    return result
}

; Функция для сортировки массива в AHK v2
SortArray(arr) {
    ; Создаем копию массива для сортировки
    sorted := []
    for item in arr
        sorted.Push(item)

    ; Простая пузырьковая сортировка
    loop {
        swapped := false
        loop sorted.Length - 1 {
            if StrCompare(sorted[A_Index], sorted[A_Index + 1]) > 0 {
                temp := sorted[A_Index]
                sorted[A_Index] := sorted[A_Index + 1]
                sorted[A_Index + 1] := temp
                swapped := true
            }
        }
    } until !swapped

    return sorted
}
