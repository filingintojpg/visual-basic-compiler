Public Class Form1

    Private Sub Button1_Click(sender As Object, e As EventArgs)

        Dim number As Integer
        number = CInt(TextBox1.Text)

        Select Case number
            Case Is < 0
                MsgBox("Negative")
            Case 0
                MsgBox("Zero")
            Case 1 To 9, 10
                MsgBox("Small")
            Case Else
                MsgBox("Big")
        End Select

        Do While number > 0
            number -= 1
            If number Mod 2 = 0 Then
                Continue Do
            End If
            MsgBox(number * 2)
        Loop

    End Sub

End Class
