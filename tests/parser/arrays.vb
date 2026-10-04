' Тестируется:
' - одномерные массивы: с размером, со списком значений, без размера
' - New Integer() {...} и New Integer(n) {}
' - массивы разных типов, в том числе объектов
' - чтение и запись элемента: индекс - выражение, вызов, другой элемент
' - Length и методы массива
' - массивы как поля класса, параметры и результат функции
' - многострочный инициализатор
Class Holder
    Public numbers(9) As Integer
    Private names() As String
    Protected flags As Boolean() = {True, False}

    Public Function Copy(source() As Integer) As Integer()
        Return New Integer() {source(0), source(1)}
    End Function

    Public Sub Fill(target As Integer())
        For i = 0 To target.Length - 1
            target(i) = i * i
        Next
    End Sub
End Class

Class Main
    Shared Sub Main()
        Dim sized(10) As Integer
        Dim sizedByExpression(n - 1) As Long
        Dim sizedByProduct(2 * n + 1) As Long
        Dim sizedAndFilled(4) As Integer = {1, 2, 3, 4, 5}
        Dim unsized() As Integer = {1, 2, 3}
        Dim typed As Integer() = New Integer() {1, 2, 3}
        Dim preallocated As Integer() = New Integer(9) {}
        Dim empty As Integer() = {}
        Dim words As String() = {"a", "b", "c"}
        Dim letters As Char() = {"a"c, "b"c}
        Dim flags() As Boolean = {True, False}
        Dim holders(2) As Holder
        Dim objects As Holder() = {New Holder(), New Holder()}
        Dim created As Holder() = New Holder() {New Holder()}
        Dim sizedObjects = New Holder(2) {}
        Dim multiline = {
            1,
            2
        }

        sized(0) = 1
        sized(10) = sized(0) + sized(1) * 2
        sized(sized(0)) = 5
        sized(i + 1) = sized(i) - 1
        sized(Foo(1)) = 3
        Dim first = sized(0)
        Dim sum = sized(0) + sized(1)
        Dim element = New Integer() {1, 2, 3}(1)
        Console.WriteLine(sized(i + 1))
        Print(sized(0), sized(1), sized(2))

        For index = 0 To 10
            sized(index) = index * index
        Next
        Dim length = sized.Length
        Dim upper = sized.GetUpperBound(0)

        words(0) = "z"
        letters(1) = "q"c
        Dim joined = words(0) & words(1)
        holders(0) = New Holder()
        holders(0).numbers(1) = 7
    End Sub
End Class
