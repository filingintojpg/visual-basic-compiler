' Тестируется:
' - обобщённые классы: с одним, двумя и тремя параметрами типа, с модификатором доступа
' - параметры типа в полях, массивах, параметрах и результатах методов
' - Inherits у обобщённого класса
' - параметры типа, записанные в несколько строк
' - обобщённые типы в Dim: простые, с несколькими аргументами, вложенные, массивы
' - создание обобщённых объектов: New Box(Of Integer), с () и с аргументами, массивы обобщённых объектов (с размером и без)
' - обобщённые типы в параметрах и результатах методов
' - вызов методов на обобщённых объектах, цепочки вызовов
' - статическое поле в обобщённом классе
Class Box(Of T)
    Public Content As T
    Private History() As T
    Public Shared Count As Integer

    Public Function Unwrap() As T
        Return Me.Content
    End Function

    Public Sub Put(item As T)
        Me.Content = item
    End Sub

    Public Function Replace(item As T) As Box(Of T)
        Me.Content = item
        Return Me
    End Function
End Class

Class Pair(Of K, V)
    Public Key As K
    Public Value As V

    Public Function Swap() As Pair(Of V, K)
        Dim result As Pair(Of V, K) = New Pair(Of V, K)()
        result.Key = Me.Value
        result.Value = Me.Key
        Return result
    End Function
End Class

Class Triple(Of A, B, C)
    Public First As A
    Public Second As B
    Public Third As C
End Class

Class Multiline(
    Of First,
    Second
)
    Public Left As First
    Public Right As Second
End Class

Public Class Stack(Of T)
    Inherits Container
    Private items() As T
    Public Top As Integer
End Class

Private Class Wrapper(Of T)
    Public Inner As Box(Of T)
    Public Labeled As Pair(Of String, T)
End Class

Class Container
End Class

Class Main
    Shared Sub Main()
        Dim numbers As Box(Of Integer) = New Box(Of Integer)()
        Dim words As Box(Of String) = New Box(Of String)
        Dim entry As Pair(Of String, Integer) = New Pair(Of String, Integer)("a", 1)
        Dim lookup As Dictionary(Of String, List(Of Integer)) = New Dictionary(Of String, List(Of Integer))()
        Dim nested As Box(Of Pair(Of Integer, Box(Of String)))
        Dim boxOfBoxes = New Box(Of Box(Of Integer))()
        Dim emptyBoxes(3) As Box(Of Integer)
        Dim sizedBoxes = New Box(Of Integer)(2) {}
        Dim boxes As Box(Of Integer)() = New Box(Of Integer)() {New Box(Of Integer)(), New Box(Of Integer)()}
        Dim animals As Box(Of Animal) = New Box(Of Animal)()
        Dim triple As Triple(Of Integer, String, Boolean)

        numbers.Put(5)
        Dim value As Integer = numbers.Unwrap()
        words.Put("text").Put("more")
        entry.Key = "k"
        Dim swapped = entry.Swap()
        Dim sum = numbers.Unwrap() + entry.Value
        boxes(0).Put(1)

        For Each item In boxes
            item.Put(value)
        Next

        Show(numbers, entry)
        Dim built = Build(1)
        Dim builtAll = BuildAll()
    End Sub

    Shared Sub Show(item As Box(Of Integer), label As Pair(Of String, Integer))
        Console.WriteLine(item.Unwrap() & label.Key)
    End Sub

    Shared Function Build(value As Integer) As Box(Of Integer)
        Dim result As Box(Of Integer) = New Box(Of Integer)()
        result.Put(value)
        Return result
    End Function

    Shared Function BuildAll() As Box(Of Integer)()
        Return New Box(Of Integer)() {Build(1), Build(2)}
    End Function
End Class
