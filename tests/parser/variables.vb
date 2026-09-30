' Тестируется:
' - локальные переменные Dim: без типа, с типом, с инициализатором
' - все примитивные типы
' - переменные типа-класса, Object и Nothing
' - локальные константы Const
' - поля класса: Dim и с инициализатором
' - присваивание и использование переменных в выражениях
Class Point
    Dim horizontal As Integer
    Dim vertical As Integer = 5
    Const dimensions = 2
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
    End Sub
End Class
