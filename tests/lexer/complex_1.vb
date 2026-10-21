Public Class Form1
    REM This is a simple program to check if a number is positive, negative or zero
    Private Sub Button1_Click(sender As Object, e As EventArgs)

        Dim number As Integer
        number = CInt(TextBox1.Text)

        ' if statement to check if number is positive, negative or zero
        If number > 0 Then
            MsgBox("Positive")
        ElseIf number < 0 Then
            MsgBox("Negative")
        Else
            MsgBox("Zero")
        End If

    End Sub

End Class