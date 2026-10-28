' Тестируется:
' - функции приведения: CBool, CInt, CSng, CChar, CStr
' - CType с примитивными типами, массивами и классами
' - вложенные приведения, приведения внутри выражений и аргументов
Class Main
    Shared Sub Main()
        Dim text As String = "42"

        Dim toBoolean = CBool(text)
        Dim toInteger = CInt(text)
        Dim toSingle = CSng(text)
        Dim toChar = CChar(text)
        Dim toString = CStr(42)

        Dim typedInteger = CType(text, Integer)
        Dim typedString = CType(toInteger, String)
        Dim typedArray = CType(text, Integer())
        Dim typedClass = CType(text, Animal)

        Dim nested = CInt(CStr(CSng(text)))
        Dim inExpression = CInt(text) + CInt(toString) * 2
        Dim onCall = CInt(Console.ReadLine())
        Dim onMember = CSng(text.Length) / 2
        Dim concatenated = CStr(toInteger) & CStr(toSingle)
        Dim typedSum As Integer = CType(toInteger + 1, Integer)
        Print(CInt(1.5), CSng(1), CSng(1.5F))
    End Sub
End Class
