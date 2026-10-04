' Тестируется:
' - локальные переменные Dim: без типа, с типом, с инициализатором
' - все примитивные типы
' - переменные типа-класса, Object и Nothing
' - локальные константы Const
' - поля класса: Dim и с инициализатором
' - присваивание и использование переменных в выражениях
' - несколько переменных в одном Dim/Const: общий тип, разные типы, с инициализаторами, массивы
' - Dim ... As New: со скобками, без скобок, generic-тип, примитивный тип
' - то же для полей класса
Class Point
    Dim horizontal As Integer
    Dim vertical As Integer = 5
    Const dimensions = 2
    Dim left, right As Integer
    Public first, second As Integer
    Private Shared shared1, shared2 As Integer
    Private Const low = 1, high = 2
    Public origin As New Point()
    Dim copy1 As New Point, copy2 As New Point()
End Class

Class Main
    Shared Sub Main()
        Dim untyped
        Dim inferred = 10
        Dim declared As Integer
        Dim initialized As Integer = 10

        Dim byteValue As Byte = 255
        Dim sbyteValue As SByte = -128
        Dim shortValue As Short = -32768
        Dim ushortValue As UShort = 65535
        Dim intValue As Integer = 42
        Dim uintValue As UInteger = 4000000000
        Dim longValue As Long = 9000000000
        Dim ulongValue As ULong = 18000000000
        Dim singleValue As Single = 1.5
        Dim doubleValue As Double = 2.5
        Dim decimalValue As Decimal = 3.5
        Dim boolValue As Boolean = True
        Dim charValue As Char = "c"c
        Dim stringValue As String = "text"
        Dim dateValue As Date
        Dim objectValue As Object = Nothing

        Dim origin As Point = New Point()
        Dim missing As Point = Nothing
        Dim copy = origin

        Const limit = 100
        Const pi As Double = 3.14159
        Const greeting As String = "hi"
        Const doubleLimit As Integer = limit * 2

        intValue = limit
        inferred = inferred + intValue * 2
        Dim computed As Integer = (limit + 1) * 2
        Dim fromCall As Integer = Foo(1)
        Dim message = "n = " & intValue

        Dim a, b As Integer
        Dim c, d, e
        Dim f As Integer, g As String
        Dim h = 1, i = 2
        Dim j As Integer = 1, k As String = "k"
        Dim m(3), n As Integer
        Dim o,
            p As Integer
        Const c1 = 1, c2 = 2
        Const c3 As Integer = 3, c4 As String = "four"

        Dim person As New Point()
        Dim noParens As New Point
        Dim generic As New List(Of Integer)()
        Dim genericNoParens As New List(Of Integer)
        Dim genericPair As New Dictionary(Of String, Integer)()
        Dim primitive As New Integer()
        Dim first As New Point(), second As New Point()
        Dim x, y As New Point()
        Dim z As New Point() : Dim w As New Point()
    End Sub
End Class
