' Тестируется:
' - блочный If: простой, с Else, с ElseIf (одним и несколькими), с пустыми ветками
' - однострочный If: с Else, с несколькими операторами через ":", с Return
' - вложенные If
' - сложные условия: сравнения, логические операции, вызовы, скобки
Class Main
    Shared Sub Main()
        If x > 0 Then
            Print(1)
        End If

        If x > 0 Then
        End If

        If x > 0 Then
            Print(1)
        Else
            Print(2)
        End If

        If x > 0 Then
            Print(1)
        ElseIf x < 0 Then
            Print(2)
        End If

        If x > 0 Then
            Print(1)
        ElseIf x < 0 Then
            Print(2)
        ElseIf x <> 5 Then
            Print(3)
        ElseIf x >= 5 Then
        Else
            Print(4)
        End If

        If x > 0 Then
        Else
        End If

        If x > 0 Then
        ElseIf x < 0 Then
        End If

        If x > 0 Then
        Else
            Print(2)
        End If

        If x > 0 Then
            Print(1)
        Else
        End If

        If x > 0 Then
        ElseIf x < 0 Then
            Print(2)
        Else
            Print(3)
        End If

        If x > 0 Then Print(1)
        If x > 0 Then Print(1) Else Print(2)
        If x > 0 Then a = 1 : b = 2
        If x > 0 Then a = 1 : b = 2 Else a = 3 : b = 4
        If x > 0 Then Foo() Else Bar()
        If x > 0 Then Return
        If x > 0 Then a = 1 :

        If a > 0 Then
            If b > 0 Then
                Print(1)
            Else
                Print(2)
            End If
        Else
            If c > 0 Then
                Print(3)
            ElseIf d > 0 Then
                Print(4)
            End If
        End If

        If a > 0 Then
            If b > 0 Then Print(1) Else Print(2)
        End If

        If a > 0 And b < 0 Or Not c Then
            Print(1)
        End If

        If (a + b) * 2 > c AndAlso Foo(a) OrElse Bar(b) Then
            Print(2)
        End If

        If items(0) = obj.Value Then
            Print(3)
        End If

        If a > 0 Then : Print(1) : End If
    End Sub
End Class
