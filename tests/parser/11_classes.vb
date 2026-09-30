' Классы: поля, методы, свойства, Inherits, Me / MyBase / MyClass,
' динамическое связывание (Overridable / Overrides / MustInherit / MustOverride)
Class Animal
    Public Name As String
    Protected age As Integer
    Private Const Legs As Integer = 4
    
    Public Sub New(name As String)
        Me.Name = name
    End Sub
    
    Public Overridable Function Speak() As String
        Return "..."
    End Function
    
    Public Sub Introduce()
        Console.WriteLine(Me.Name & " says " & Me.Speak())
        Console.WriteLine(MyClass.Speak())
    End Sub
    
    Public Function Same(other As Animal) As Boolean
        Return Me Is other
    End Function
    
    Public Function Self() As Animal
        Return Me
    End Function
End Class

Class Dog
    Inherits Animal
    
    Public Sub New(name As String)
        MyBase.New(name)
    End Sub
    
    Public Overrides Function Speak() As String
        Return "Woof"
    End Function
    
    Public Sub Test()
        Console.WriteLine(MyBase.Speak())
        Console.WriteLine(MyBase.Name)
        MyBase.Introduce()
    End Sub
End Class

MustInherit Class Shape
    Public MustOverride Function Area() As Double
    
    Public NotOverridable Function Kind() As String
        Return "shape"
    End Function
End Class

Class Square
    Inherits Shape
    Public Side As Double
    
    Public Overrides Function Area() As Double
        Return Side * Side
    End Function
End Class

Class Empty
End Class

Class Main
    Shared Sub Main()
        Dim a As Animal = New Dog("Rex")
        Console.WriteLine(a.Speak())
        a.Introduce()
        a.Age = 5
        a.Name = "Max"
        Dim n = a.Age + 1
        
        Dim d As Dog = New Dog("Rex")
        Dim d2 As New Dog("Bob")
        
        Dim s As Shape = New Square()
        Console.WriteLine(s.Area())
        
        If a IsNot Nothing Then
            Console.WriteLine(a.Description)
        End If
        If a Is Nothing Then
            a = New Animal("x")
        End If
        
        Console.WriteLine(a.Self().Self().Name)
        
        Dim zoo(2) As Animal
        zoo(0) = New Dog("A")
        zoo(1) = New Animal("B")
        zoo(0).Introduce()
    End Sub
End Class