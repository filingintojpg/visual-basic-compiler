Public Class Form1

    Private Sub Button1_Click(sender As Object, e As EventArgs)

        Dim names() As String = {"John", "Mary", "Peter"}

        For Each name As String In names
            MsgBox("Hello " & name) ' displaying message box for each name
        Next

    End Sub

End Class
