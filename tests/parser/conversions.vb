' Тестируется:
' - функции приведения: CBool, CByte, CSByte, CShort, CUShort, CInt, CUInt, CLng, CULng, CSng, CDbl, CDec, CChar, CStr, CDate, CObj
' - CType с примитивными типами, массивами, классами и обобщёнными типами
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
        Dim toDate = CDate(text)
        Dim toObject = CObj(text)

        Dim typedInteger = CType(text, Integer)
        Dim typedString = CType(toInteger, String)
        Dim typedArray = CType(toObject, Integer())
        Dim typedClass = CType(toObject, Animal)
        Dim typedGeneric = CType(toObject, Box(Of Integer))

        Dim nested = CInt(CStr(CDbl(text)))
        Dim inExpression = CInt(text) + CInt(toString) * 2
        Dim onCall = CInt(Console.ReadLine())
        Dim onMember = CDbl(toObject.Value) / 2
        Dim concatenated = CStr(toInteger) & CStr(toDouble)
        Dim typedSum As Integer = CType(toInteger + 1, Integer)
        Print(CInt(1.5R), CDbl(1), CSng(1.5))
    End Sub
End Class
