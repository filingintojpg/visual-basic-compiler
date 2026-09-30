' Тестируется:
' - While ... End While: обычный, с пустым телом, со сложным условием
' - Do ... Loop без условия
' - Do While и Do Until: условие в начале цикла
' - Loop While и Loop Until: условие в конце цикла
' - пустые тела, однострочная запись через ":"
' - вложенные и смешанные циклы (While, Do, For, For Each)
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

        While x < 10 : x += 1 : End While

        Do
            x = x + 1
            Exit Do
        Loop

        Do
        Loop

        Do While x < 100
            x = x + 1
        Loop

        Do Until x > 100
            x = x + 1
        Loop

        Do
            x = x + 1
        Loop While x < 5

        Do
            x = x + 1
        Loop Until x > 100

        Do While x < 100
        Loop

        Do Until x > 100
        Loop

        Do : x += 1 : Loop Until x > 10

        While i < 3
            While j < 3
                j = j + 1
            End While
            i = i + 1
        End While

        For i = 1 To 3
            While j < i
                Do
                    j = j + 1
                Loop Until j > 5

                For Each value In items
                    Print(value)
                Next
            End While
        Next
    End Sub
End Class
