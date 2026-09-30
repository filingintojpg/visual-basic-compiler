' While ... End While, Exit/Continue для While и Do.
Class Main
    Shared Sub Main()
        While x < 10
            x = x + 1
        End While
        
        While True
        End While
        
        While a > 0 And b < 10
            a = a - 1
            b = b + 1
        End While
        
        While Foo(x)
            Print(x)
        End While
        
        ' вложенные
        While i < 3
            While j < 3
                j = j + 1
            End While
            i = i + 1
        End While
        
        ' Exit / Continue
        While True
            x = x + 1
            If x > 100 Then
                Exit While
            End If
            If x < 10 Then
                Continue While
            End If
            Print(x)
        End While
        
        Do
            x = x + 1
            If x > 100 Then
                Exit Do
            End If
            If x < 10 Then
                Continue Do
            End If
        Loop
        
        Do While x < 100
            If x > 50 Then
                Exit Do
            End If
            x = x + 1
        Loop
        
        Do
            x = x + 1
            If x > 5 Then
                Continue Do
            End If
        Loop Until x > 100
        
        Do Until x > 100
            x = x + 1
            Continue Do
        Loop
        
        ' смешанные вложенные циклы
        For i = 1 To 3
            While j < i
                Do
                    j = j + 1
                    If j > 10 Then
                        Exit Do
                    End If
                Loop Until j > 5
                
                For Each v In arr
                    If v = 0 Then
                        Exit For
                    End If
                Next
                Exit While
            End While
        Next
    End Sub
End Class