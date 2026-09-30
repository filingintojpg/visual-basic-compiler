' Тестируется:
' - Exit For, Exit While, Exit Do и Exit Select
' - Continue For, Continue While и Continue Do
' - управление внутри вложенных циклов, условий и Select
' - однострочный If с Exit и Continue
' - Return, Exit Sub и Exit Function
Class Main
    Shared Sub Main()
        For i = 1 To 100
            If i > 50 Then Exit For
            If i Mod 2 = 0 Then Continue For
            If i > 10 Then
                Exit For
            End If
            Print(i)
        Next

        For Each value In items
            If value < 0 Then
                Continue For
            End If
            Exit For
        Next

        While True
            x = x + 1
            If x > 100 Then Exit While
            If x < 10 Then
                Continue While
            End If
        End While

        Do
            x = x + 1
            If x > 100 Then
                Exit Do
            End If
            If x < 10 Then Continue Do
        Loop

        Do While x < 100
            If x > 50 Then Exit Do
            x = x + 1
        Loop

        Do
            x = x + 1
            If x > 5 Then Continue Do
        Loop Until x > 100

        Select Case x
            Case 1
                Exit Select
            Case 2
                If y > 0 Then Exit Select
                Print(2)
        End Select

        For i = 1 To 3
            While j < i
                Do
                    j = j + 1
                    If j > 10 Then Exit Do
                Loop Until j > 5
                Exit While
            End While
            If i = 2 Then Continue For
        Next
    End Sub

    Shared Sub EarlySub(x As Integer)
        If x < 0 Then Return
        If x = 0 Then
            Exit Sub
        End If
        Print(x)
    End Sub

    Shared Function EarlyFunction(x As Integer) As Integer
        If x < 0 Then
            Exit Function
        End If
        Return x
    End Function
End Class
