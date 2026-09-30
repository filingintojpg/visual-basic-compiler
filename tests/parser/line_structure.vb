' Тестируется:
' - комментарии через апостроф и REM: отдельной строкой и в конце строки
' - разделитель операторов ":" (в том числе в конце строки)
' - явный перенос строки через " _"
' - неявный перенос после оператора, запятой, открывающей скобки и точки
' - неявный перенос перед закрывающей скобкой и внутри инициализатора массива
' - пустые строки между операторами
Class Main
    Shared Sub Main()
        Dim first = 1 ' trailing comment
        REM full line remark
        Dim second = 2 : Dim third = 3 : first = second + third

        Print(first) : Print(second) :
        ' comment only line

        Dim explicitSum = first + _
            second + _
            third
        Dim implicitSum = first +
            second *
            third
        Print(first,
              second,
              third)
        Dim called = Foo(
            first,
            second
        )
        Dim member = obj.
            Name
        Dim list = {
            1,
            2,
            3
        }
        Dim picked = If(
            first > second,
            first,
            second)
        If first > 0 AndAlso
           second > 0 Then
            Print(1)
        End If
    End Sub
End Class
