#Requires AutoHotkey v2.0

!q::  ; Горячая клавиша: Alt + Q
{
    try {
        originalClipboard := ClipboardAll()  ; Сохраняем текущий буфер обмена
        A_Clipboard := ""  ; Очищаем буфер

        Send("^c")         ; Копируем выделенный текст
        if !ClipWait(0.5)  ; Ждем появления текста в буфере
        {
            A_Clipboard := originalClipboard  ; Восстанавливаем буфер в случае ошибки
            return
        }

        selectedText := A_Clipboard  ; Получаем текст из буфера
        A_Clipboard := '"' selectedText '"'  ; Оборачиваем в кавычки

        Sleep(50)  ; Короткая пауза для стабильности
        Send("^v") ; Вставляем модифицированный текст

        Sleep(200) ; Ждем завершения вставки
        A_Clipboard := originalClipboard  ; Восстанавливаем исходный буфер
    }
    catch as e {
        A_Clipboard := originalClipboard  ; Восстанавливаем буфер при ошибке
        MsgBox "Ошибка: " e.Message
    }
}
