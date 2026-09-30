' Тестируется:
' - символьные литералы "x"c, в том числе кавычка и спецсимволы внутри
' - строковые литералы: пустая, с удвоенными кавычками, с символами, похожими на разделители
' - строки с юникодом и с символом \ (escape-последовательностей нет)
' - константы vbLf, vbCr, vbTab и др. в конкатенации
' - конкатенация строк через &
Class Main
    Shared Sub Main()
        Dim letter = "A"c
        Dim lowerSuffix = "a"C
        Dim quoteChar = """"c
        Dim space = " "c
        Dim apostrophe As Char = "'"c
        Dim equalsSign As Char = "="c

        Dim empty = ""
        Dim hello = "Hello, World!"
        Dim quoted = "Она сказала ""Привет"""
        Dim onlyQuote = """"
        Dim twoQuotes = """"""
        Dim backslash = "back\slash" & vbCrLf & "\n is not an escape"
        Dim notComment = "It's not a comment"
        Dim arithmetic = "1 + 2 = 3"
        Dim punctuation = "a; b: c, d (e) [f] {g}"
        Dim unicode = "Юникод: Ёлка © шар"
        Dim quoteInside = "text ' still text"

        Dim lineFeed = "a" & vbLf & "b"
        Dim carriageReturn = "x" & vbCr & vbLf & "y"
        Dim tabbed = "col1" & vbTab & "col2"
        Dim newLine = vbNewLine & "after"
        Dim control = "a" & vbBack & vbFormFeed & vbVerticalTab & vbNullChar

        Dim joined = "a" & "b" & "c"
        Dim withNumber = "n=" & 5
        Dim withConversion = "n=" & CStr(5) & "!"
        Dim emptyJoined = "" & ""
        Dim mixed = hello & letter & empty
        mixed &= "tail"

        Console.WriteLine("Hello ""World""")
        Console.WriteLine("""")
    End Sub
End Class
