#Requires AutoHotkey v2.0

#Hotstring EndChars -()[]{}:;'",.?!`n `t

::?r::[REFACTOR]:
::?f::[FEAT]:
::?b::[FIX]:
::?d::[DOCS]:
::?t::[TEST]:
::?c::[CHORE]:
::?h::[HOTFIX]:
::?s::[STYLE]:
::?p::[PERF]:

; {Left 3} перемещает курсор на 3 позиции влево (внутрь скобок)
:*:?rs::[REFACTOR()]:{Left 3}
:*:?fs::[FEAT()]:{Left 3}
:*:?bs::[FIX()]:{Left 3}
:*:?ds::[DOCS()]:{Left 3}
:*:?ts::[TEST()]:{Left 3}
:*:?cs::[CHORE()]:{Left 3}
:*:?hs::[HOTFIX()]:{Left 3}
:*:?ss::[STYLE()]:{Left 3}
:*:?ps::[PERF()]:{Left 3}