Public Class Form1

    rem This is a simple program to multiply two numbers
    Private Function Calculate(a As Integer, b As Integer) As Integer
        Return a * b
    End Function

    Private Sub Button1_Click(sender As Object, e As EventArgs)

        Dim result As Integer
        result = Calculate(5, 4)

        MsgBox("Result = " & result)

    End Sub

End Class
