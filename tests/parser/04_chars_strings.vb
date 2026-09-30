' Символьные и строковые литералы. Нет escape-последовательностей:
' кавычка экранируется удвоением, спецсимволы через & vbLf / vbCr / vbTab ...
Class Main
    Shared Sub Main()
        ' символы
        Dim c1 = "A"c
        Dim c2 = "a"C
        Dim c3 = """"c
        Dim c4 = " "c
        Dim c5 = "z"c
        Dim c6 As Char = "'"c
        Dim c7 As Char = "="c
        
        ' строки
        Dim s1 = ""
        Dim s2 = "Hello, World!"
        Dim s3 = "Она сказала ""Привет"""
        Dim s4 = """"
        Dim s5 = """"""
        Dim s6 = "back\slash" & vbCrLf & "	 не escape"
        Dim s7 = "It's not a comment"
        Dim s8 = "1 + 2 = 3"
        Dim s9 = "a; b: c, d (e) [f] {g}"
        Dim s10 = "Юникод: Жёлтый шар ©"
        Dim s11 = "text ' still text"
        
        ' служебные последовательности через константы
        Dim t1 = "a" & vbLf & "b"
        Dim t2 = "x" & vbCr & vbLf & "y"
        Dim t3 = "col1" & vbTab & "col2"
        Dim t4 = "line" & vbCrLf
        Dim t5 = vbNewLine & "after"
        Dim t6 = "a" & vbBack & vbFormFeed & vbVerticalTab & vbNullChar
        
        ' конкатенация
        Dim u1 = "a" & "b" & "c"
        Dim u2 = "n=" & 5
        Dim u3 = "n=" & CStr(5) & "!"
        Dim u4 = "" & ""
        Dim u5 = s1 & s2 & c1
        
        Console.WriteLine("Hello ""World""")
        Console.WriteLine("""")
    End Sub
End Class