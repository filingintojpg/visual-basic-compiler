' Тестируется:
' - Select Case и Select (без слова Case), Case Else
' - Case: одно значение, список значений, диапазон To, Is с операцией сравнения, без Is
' - строки, символы и выражения в Case и в выбираемом значении
' - пустые ветки и пустой Select
' - вложенные Select, If и циклы внутри ветки
Class Main
    Shared Sub Main()
        Select Case x
            Case 1
                Print("one")
            Case 2, 3
                Print("two or three")
            Case 4 To 10
                Print("4..10")
            Case Is > 10
                Print("big")
            Case Else
                Print("other")
        End Select

        Select x
            Case 1
                Print(1)
        End Select

        Select Case x
            Case Is < 0
                Print("negative")
            Case Is <= 5
                Print("small")
            Case Is >= 100
                Print("huge")
            Case Is <> 50
                Print("not fifty")
            Case Is = 7
                Print("seven")
        End Select

        Select Case x
            Case < 0
                Print(1)
            Case >= 100
                Print(2)
            Case <> 50
                Print(3)
            Case = 7
                Print(4)
        End Select

        Select Case x
            Case 1 To 5, 10, Is > 100
                Print("mix")
            Case 20 To 30, 40 To 50
                Print("ranges")
            Case -5 To -1
                Print("negative range")
        End Select

        Select Case text
            Case "a"
                Print(1)
            Case "b", "c"
                Print(2)
            Case "d" To "z"
                Print(3)
            Case Else
        End Select

        Select Case letter
            Case "x"c
                Print(1)
            Case "a"c To "f"c
                Print(2)
        End Select

        Select Case x Mod 3
            Case 0
                Print("divisible")
            Case 1 To 2
                Print("rest")
        End Select

        Select Case a + b * 2
            Case c + 1
                Print(1)
            Case c + 2 To c * 2
                Print(2)
        End Select

        Select Case Foo(x)
            Case obj.Value
                Print(1)
        End Select

        Select Case True
            Case a > b
                Print(1)
            Case a < b
                Print(2)
        End Select

        Select Case x
            Case Else
                Print("only else")
        End Select

        Select Case x
            Case 1
            Case 2
                Print(2)
            Case Else
        End Select

        Select Case x
        End Select

        Select Case x
            Case 1 : Print(1)
            Case 2 : Print(2) : Print(3)
        End Select

        Select Case x
            Case 1
                Select Case y
                    Case 1
                        Print(11)
                    Case Else
                        Print(1)
                End Select
            Case 2
                If y > 0 Then
                    Print(2)
                End If
            Case 3
                For i = 1 To 3
                    Print(i)
                Next
        End Select
    End Sub
End Class
