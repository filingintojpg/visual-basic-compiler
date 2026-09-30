' Консоль: Console.WriteLine / Write / ReadLine, ввод строковый -> CInt, CDbl и т.д.
Class Main
    Shared Sub Main()
        Console.WriteLine()
        Console.WriteLine("text")
        Console.WriteLine(42)
        Console.WriteLine(1.5)
        Console.WriteLine(True)
        Console.WriteLine("a"c)
        Console.WriteLine(x + 1)
        Console.WriteLine("a" & x & "b")
        Console.WriteLine(Foo(1) * 2)
        Console.WriteLine("{0} + {1}", a, b)
        Console.WriteLine("{0}", a + b)
        
        Console.Write("Enter: ")
        Console.Write(1)
        Console.Write(x & " ")
        Console.Write(vbLf)
        
        Dim s As String = Console.ReadLine()
        Dim s2 = Console.ReadLine()
        Dim n As Integer = CInt(Console.ReadLine())
        Dim d As Double = CDbl(Console.ReadLine())
        Dim l As Long = CLng(Console.ReadLine())
        Dim f As Single = CSng(Console.ReadLine())
        Dim m As Decimal = CDec(Console.ReadLine())
        Dim b As Boolean = CBool(Console.ReadLine())
        Dim c As Char = CChar(Console.ReadLine())
        Dim st As String = CStr(n)
        Dim by As Byte = CByte(n)
        Dim sb As SByte = CSByte(n)
        Dim sh As Short = CShort(n)
        Dim us As UShort = CUShort(n)
        Dim ui As UInteger = CUInt(n)
        Dim ul As ULong = CULng(n)
        Dim ob As Object = CObj(n)
        
        Dim t As Integer = CType(Console.ReadLine(), Integer)
        Dim t2 = CType(n, Double)
        
        Console.WriteLine(CInt(Console.ReadLine()) + CInt(Console.ReadLine()))
        Console.WriteLine(CStr(n) & CStr(d))
        
        ' полные и разнорегистровые имена
        System.Console.WriteLine("full name")
        system.console.writeline("lower")
        CONSOLE.WRITE("upper")
    End Sub
End Class