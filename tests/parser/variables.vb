' Тестируется:
' - локальные переменные Dim: с типом, с инициализатором, с выводом типа (Dim x = 10)
' - все примитивные типы
' - переменные типа-класса и Nothing (Object - обычный идентификатор типа)
' - локальные константы Const
' - поля класса: Dim и с инициализатором
' - присваивание и использование переменных в выражениях
' - несколько переменных в одном Dim/Const: у каждой свой тип или инициализатор, массивы, перенос после запятой
' - Dim ... As New: со скобками, без скобок, примитивный тип
' - то же для полей класса
Class Point
    Dim horizontal As Integer
    Dim vertical As Integer = 5
    Const dimensions = 2
    Dim left As Integer, right As Integer
    Public first As Integer, second As Integer
    Private Shared shared1 As Integer, shared2 As Integer
    Private Const low = 1, high = 2
    Public origin As New Point()
    Dim copy1 As New Point, copy2 As New Point()
End Class

Class Main
    Shared Sub Main()
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

        Dim a As Integer, b As Integer
        Dim f As Integer, g As String
        Dim h = 1, i = 2
        Dim j As Integer = 1, k As String = "k"
        Dim m(3) As Integer, n As Integer
        Dim o As Integer,
            p As Integer
        Const c1 = 1, c2 = 2
        Const c3 As Integer = 3, c4 As String = "four"

        Dim person As New Point()
        Dim noParens As New Point
        Dim primitive As New Integer()
        Dim primitiveNoParens As New Integer
        Dim primitiveDouble As New Double
        Dim first As New Point(), second As New Point()
        Dim x As New Point(), y As New Point(1, 2)
        Dim z As New Point() : Dim w As New Point()
    End Sub
End Class
