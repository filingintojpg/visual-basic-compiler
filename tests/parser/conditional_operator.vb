' Тестируется:
' - If(условие, значение1, значение2) как выражение
' - If(значение, запасное значение) - двухаргументная форма
' - вложенные If() в ветках и в условии
' - If() в выражениях, аргументах вызовов, Return и инициализаторах
' - If() с логическими операциями и приведениями
' - запись в несколько строк
Class Chooser
    Shared Function Pick(a As Integer, b As Integer) As Integer
        Return If(a > b, a, b)
    End Function
End Class

Class Main
    Shared Sub Main()
        Dim maximum = If(a > b, a, b)
        Dim label = If(a > b, "a", "b")
        Dim nestedThen = If(a > b, If(a > c, a, c), If(b > c, b, c))
        Dim nestedCondition = If(If(a, b, c), 1, 2)
        Dim coalesced = If(x, y)
        Dim chainedCoalesce = If(x, If(y, z))
        Dim sumOfTwo = If(a > 0, 1, 2) + If(b > 0, 3, 4)
        Dim withLogic = If(a AndAlso b, 1, 2)
        Dim withConversion = If(CInt(text) > 0, CInt(text), 0)
        Dim fromCall = Chooser.Pick(If(a, 1, 2), If(b, 3, 4))
        Print(If(a < b, "less", "not less"))
        Dim multiline = If(
            a > b,
            a,
            b)
    End Sub
End Class
