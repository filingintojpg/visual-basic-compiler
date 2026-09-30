' Тестируется:
' - составное присваивание: += -= *= /= \= ^= &= <<= >>=
' - левая часть: переменная, элемент массива, член объекта
' - правая часть: литерал, выражение, вызов
' - составное присваивание внутри циклов и условий
Class Counter
    Public Shared Total As Integer
    Public Hits As Integer
End Class

Class Main
    Shared Sub Main()
        Dim value = 10
        Dim text = "a"
        Dim items(3) As Integer
        Dim tally As Counter = New Counter()

        value += 1
        value -= 2
        value *= 3
        value /= 4
        value \= 5
        value ^= 2
        text &= "b"
        value <<= 1
        value >>= 1

        value += value * 2 + 1
        value -= Foo(1)
        text &= "x" & value
        items(0) += 5
        items(value) *= 2
        tally.Hits += 1
        Counter.Total -= 1
        Counter.Total += tally.Hits

        For i = 1 To 3
            value += i
        Next

        While value < 100
            value *= 2
        End While

        If value > 50 Then value -= 50 Else value += 50
    End Sub
End Class
