' Тестируется:
' - конструкторы Sub New: со скобками и без, без параметров и с параметрами
' - модификаторы доступа у конструкторов: Public, Private, Protected, без модификатора
' - Shared Sub New (статический конструктор)
' - Optional-параметры и перенос списка параметров в конструкторе
' - вызов конструктора базового класса и своего: MyBase.New(...), Me.New(...), MyBase.New без скобок
' - создание объектов: New Class(...), Dim x As New Class(...), Dim x As Class = New Class(...)
' - конструктор рядом с полями и методами класса
Class Person
    Private name As String
    Private age As Integer
    Public Shared Count As Integer

    Sub New()
        Me.name = "unknown"
    End Sub

    Sub New(name As String)
        Me.name = name
    End Sub

    Public Sub New(name As String, age As Integer)
        Me.New(name)
        Me.age = age
    End Sub

    Private Sub New(flag As Boolean)
    End Sub

    Protected Sub New(a As Integer, b As Integer, Optional c As Integer = 0)
        Me.age = a + b + c
    End Sub

    Shared Sub New()
        Count = 0
    End Sub

    Public Sub New(first As String,
        second As String
    )
        Me.name = first & second
    End Sub

    Public Function GetName() As String
        Return Me.name
    End Function
End Class

Class WithoutParens
    Sub New
        Print("default")
    End Sub

    Public Sub New
    End Sub

    Private Sub New
        Dim x = 1
    End Sub

    Protected Sub New
    End Sub

    Shared Sub New
    End Sub
End Class

Class Student : Inherits Person
    Private school As String

    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(name As String, school As String)
        MyBase.New(name)
        Me.school = school
    End Sub

    Public Sub New(name As String, age As Integer, school As String)
        MyBase.New(name, age)
        Me.school = school
    End Sub

    Sub New(flag As Boolean)
        MyBase.New
    End Sub
End Class

Class Main
    Shared Sub Main()
        Dim a As New Person()
        Dim b As New Person
        Dim c As New Person("Ivan")
        Dim d As New Person("Ivan", 20)
        Dim e As Person = New Person("Ivan")
        Dim f = New Person("Ivan", 20)
        Dim g As New Student("Ivan", "MSU")
        Dim h As New Student(), i As New Student("Ivan", "MSU")
        Dim people() As Person = {New Person(), New Person("Ivan")}
        Dim created = New Person("Ivan").GetName()
        Print(New Person("Ivan", 20).GetName())
    End Sub
End Class
