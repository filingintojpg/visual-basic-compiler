' Тестируется:
' - функции приведения: CBool, CByte, CSByte, CShort, CUShort, CInt, CUInt, CLng, CULng, CSng, CDbl, CDec, CChar, CStr
' - CType с примитивными типами, массивами и классами
' - вложенные приведения, приведения внутри выражений и аргументов
Class Main
    Shared Sub Main()
        Dim text As String = "42"

        Dim toBoolean = CBool(text)
        Dim toByte = CByte(text)
        Dim toSByte = CSByte(text)
        Dim toShort = CShort(text)
        Dim toUShort = CUShort(text)
        Dim toInteger = CInt(text)
        Dim toUInteger = CUInt(text)
        Dim toLong = CLng(text)
        Dim toULong = CULng(text)
        Dim toSingle = CSng(text)
        Dim toDouble = CDbl(text)
        Dim toDecimal = CDec(text)
        Dim toChar = CChar(text)
        Dim toString = CStr(42)

        Dim typedInteger = CType(text, Integer)
        Dim typedString = CType(toInteger, String)
        Dim typedArray = CType(text, Integer())
        Dim typedClass = CType(text, Animal)

        Dim nested = CInt(CStr(CDbl(text)))
        Dim inExpression = CInt(text) + CInt(toString) * 2
        Dim onCall = CInt(Console.ReadLine())
        Dim onMember = CDbl(text.Length) / 2
        Dim concatenated = CStr(toInteger) & CStr(toDouble)
        Dim typedSum As Integer = CType(toInteger + 1, Integer)
        Print(CInt(1.5R), CDbl(1), CSng(1.5))
    End Sub
End Class
