' This is a simple class to represent a person
Public Class Person

    Public Name As String
    Public Age As Integer

    Public Sub Init(name As String, age As Integer)
        Me.Name = name
        Me.Age = age
    End Sub

End Class
' This is a simple program to demonstrate the use of a Person class
Public Class Form1

    Private Sub Button1_Click(sender As Object, e As EventArgs)

        Dim person As New Person
        person.Init("John", 25)
        MsgBox(person.Name & " " & person.Age)

    End Sub

End Class
