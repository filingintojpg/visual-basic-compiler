Public Class Form1

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click

        Try
            Dim number As Integer
            number = CInt(TextBox1.Text)
            MsgBox(number * 2)

        Catch ex As Exception
            MsgBox("Invalid number")

        Finally
            TextBox1.Clear()
        End Try

    End Sub

End Class