' This is a simple class to represent a person
Public Class Person

    Public Property Name As String
    Public Property Age As Integer

    Public Sub New(ByVal name As String, ByVal age As Integer)
        Me.Name = name
        Me.Age = age
    End Sub

End Class
' This is a simple program to demonstrate the use of a Person class
Public Class Form1

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click

        Dim person As New Person("John", 25)
        MsgBox(person.Name & " " & person.Age)

    End Sub

End Class
