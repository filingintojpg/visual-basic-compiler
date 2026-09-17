Public Class Form1

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click

        Dim names() As String = {"John", "Mary", "Peter"}

        For Each name As String In names
            MsgBox("Hello " & name) ' displaying message box for each name
        Next

    End Sub

End Class
