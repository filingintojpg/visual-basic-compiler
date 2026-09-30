' Развилки If / ElseIf / Else и тернарный оператор If(...)
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
        
        ' вложенные
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
        
        ' сложные условия
        If a > 0 And b < 0 Or Not c Then
            Print(1)
        End If
        
        If (a + b) * 2 > c AndAlso Foo(a) OrElse Bar(b) Then
            Print(2)
        End If
        
        ' тернарный оператор
        Dim m = If(a > b, a, b)
        Dim n = If(a > b, "a", "b")
        Dim o = If(a > b, If(a > c, a, c), If(b > c, b, c))
        Dim p = If(x, y)
        Dim q = If(a > 0, 1, 2) + If(b > 0, 3, 4)
        Print(If(a < b, "less", "not less"))
        
        Dim r = If(
            a > b,
            a,
            b)
    End Sub
End Class