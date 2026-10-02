' Тестируется:
' - ключевые слова и идентификаторы в любом регистре
' - символы типа у идентификаторов: % & @ ! # $
' - экранированные идентификаторы в квадратных скобках ([End], [Class])
' - идентификаторы с подчёркиванием
CLASS Main
    SHARED SUB Main()
        DIM value AS INTEGER = 1
        Value = VALUE + 1
        vAlUe = Value
        dim total as integer = 0
        TOTAL = total + VALUE
        if value > 0 then
            PRINT(value)
        end if
        FOR i = 1 TO 3
            total += i
        NEXT

        Dim [End] = 1
        Dim [Class] = 2
        Dim [If] = [End] + [Class]

        Dim _hidden = 3
        Dim __double = 4
        Dim name_with_underscores = _hidden + __double
    END SUB
END CLASS
