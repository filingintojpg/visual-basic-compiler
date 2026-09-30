' Тестируется:
' - Console.WriteLine и Console.Write с разными аргументами
' - Console.ReadLine: результат в переменную, в приведение, в выражение
' - полное имя System.Console и разный регистр
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
        Console.WriteLine(items(0))

        Console.Write("Enter: ")
        Console.Write(1)
        Console.Write(x & " ")
        Console.Write(vbLf)

        Dim line As String = Console.ReadLine()
        Dim inferred = Console.ReadLine()
        Dim whole As Integer = CInt(Console.ReadLine())
        Dim fractional As Double = CDbl(Console.ReadLine())
        Dim flag As Boolean = CBool(Console.ReadLine())
        Dim letter As Char = CChar(Console.ReadLine())
        Dim typed As Integer = CType(Console.ReadLine(), Integer)
        Console.WriteLine(CInt(Console.ReadLine()) + CInt(Console.ReadLine()))
        Console.WriteLine(CStr(whole) & CStr(fractional))

        System.Console.WriteLine("full name")
        system.console.writeline("lower")
        CONSOLE.WRITE("upper")
    End Sub
End Class
