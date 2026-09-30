' Знак "=" парсится как оператор сравнения (равенства).
Class Main
    Shared Sub Main()
        ' Сравнение в условии If
        If a = 5 Then
            Print(1)
        End If

        If a = b Then
            Print(2)
        End If

        If s1 = s2 Then
            Print(3)
        End If

        ' Сравнение с Nothing
        If obj1 = Nothing Then
            Print(4)
        End If

        ' Сравнение в составе сложных логических выражений
        If a = 5 And b = 5 Then
            Print(5)
        End If

        If a = 1 Or b = 5 Then
            Print(6)
        End If

        If Not (a = 10) Then
            Print(7)
        End If

        ' Сравнение в цикле While
        While a = 5
            Print(8)
            Exit While
        End While

        ' Сравнение в цикле Do ... Loop
        Do
            Print(9)
            Exit Do
        Loop While a = b

        Do
            Print(10)
            Exit Do
        Loop Until a = 10

        ' Сравнение результатов вызовов функций
        If Foo() = Bar() Then
            Print(11)
        End If
    End Sub
End Class