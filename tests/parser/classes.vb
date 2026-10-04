' Тестируется:
' - объявление классов: поля (в том числе Const), методы Sub и Function
' - Inherits: на отдельной строке и через ":", цепочка наследования
' - Me, MyBase и MyClass: обращение к полям и вызов методов
' - создание объектов: New Class, New Class(), New с примитивным типом
' - присваивание объектов, Nothing, Is и IsNot
' - обращение к полям и методам, цепочки вызовов, массивы объектов
' - статические члены через имя класса
Class Counter
    Public Shared Total As Integer
    Public Shared Sub Reset()
        Counter.Total = 0
    End Sub
End Class

Class Animal
    Public Name As String
    Public Age As Integer
    Private Const Legs As Integer = 4

    Public Function Speak() As String
        Return "..."
    End Function

    Public Sub Introduce()
        Console.WriteLine(Me.Name & " says " & Me.Speak())
        Console.WriteLine(MyClass.Speak())
    End Sub

    Public Sub Rename(Name As String)
        Me.Name = Name
    End Sub

    Public Function SameAs(other As Animal) As Boolean
        Return Me Is other
    End Function

    Public Function Self() As Animal
        Return Me
    End Function
End Class

Class Dog
    Inherits Animal

    Public Function Bark() As String
        Return "Woof"
    End Function

    Public Sub Test()
        Console.WriteLine(MyBase.Speak())
        Console.WriteLine(MyBase.Name)
        MyBase.Introduce()
        MyBase.Age = MyBase.Age + 1
        Me.Age += 1
    End Sub
End Class

Class Puppy : Inherits Dog
    Public Function Squeak() As String
        Return Me.Bark() & MyBase.Bark()
    End Function
End Class

Class Empty
End Class

Class Main
    Shared Sub Main()
        Dim pet As Animal = New Dog()
        Dim dog As Dog = New Dog
        Dim puppy = New Puppy()
        Dim nothingYet As Animal = Nothing
        Dim zeroInteger = New Integer()

        Console.WriteLine(pet.Speak())
        pet.Introduce()
        pet.Name = "Max"
        pet.Age = pet.Age + 1
        Dim nameLength = pet.Name.Length

        If pet IsNot Nothing Then
            Console.WriteLine(pet.Name)
        End If
        If nothingYet Is Nothing Then
            nothingYet = New Animal()
        End If

        Console.WriteLine(pet.Self().Self().Name)
        Dim same = pet.SameAs(dog)

        Dim zoo(2) As Animal
        zoo(0) = New Dog()
        zoo(1) = New Animal()
        zoo(0).Introduce()
        zoo(1).Name = "Cat"

        Counter.Total = Counter.Total + 1
        Counter.Reset()
    End Sub
End Class
