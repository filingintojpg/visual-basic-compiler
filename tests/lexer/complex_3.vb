Public Class Form1

    rem This is a simple program to check if a number is positive, negative or zero
    Private Function Calculate(ByVal a As Integer, ByVal b As Integer) As Integer
        Return a * b
    End Function

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click

        Dim result As Integer
        result = Calculate(5, 4)

        MsgBox("Result = " & result)

    End Sub

End Class
