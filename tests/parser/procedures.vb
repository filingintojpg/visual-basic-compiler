' Тестируется:
' - Sub и Function: с параметрами и без, со скобками и без скобок
' - параметры с типом и без типа, параметры-массивы, параметры-объекты
' - тип результата Function: примитивный, массив, класс; результат без типа
' - Return со значением и без, вызов через Call, вызов без скобок
' - рекурсия, вызов функции в аргументах и в выражениях
' - вызов методов другого класса и собственных методов
' - перенос списка параметров на несколько строк
Class MathUtil
    Shared Sub Hello()
        Console.WriteLine("Hello")
    End Sub

    Shared Sub Greet(name As String)
        Console.WriteLine("Hi, " & name)
    End Sub

    Shared Sub Pair(left As Integer, right As String)
    End Sub

    Shared Sub Untyped(first, second)
    End Sub

    Shared Sub Empty()
    End Sub

    Shared Sub NoParens
        Console.WriteLine("no parens")
    End Sub

    Shared Sub Multiline(
        first As Integer,
        second As Integer
    )
        Print(first + second)
    End Sub

    Shared Sub ArrayParameters(a() As Integer, b As Integer())
    End Sub

    Shared Sub ObjectParameter(target As MathUtil)
    End Sub

    Shared Function Sum(a As Integer, b As Integer) As Integer
        Return a + b
    End Function

    Shared Function Fact(n As Integer) As Integer
        If n <= 1 Then
            Return 1
        End If
        Return n * Fact(n - 1)
    End Function

    Shared Function NoType(x As Integer)
        Return x * 2
    End Function

    Shared Function NoTypeNoParams()
        Return 1
    End Function

    Shared Function NoParens As Integer
        Return 2
    End Function

    Shared Function NoParams() As String
        Return "s"
    End Function

    Shared Function Bare
        Return 3
    End Function

    Shared Function EmptyFunction() As Integer
    End Function

    Shared Function IsLess(a As Integer, b As Integer) As Boolean
        Return a < b
    End Function

    Shared Function ArrayResult() As Integer()
        Return New Integer() {1, 2, 3}
    End Function

    Shared Function ObjectResult() As MathUtil
        Return New MathUtil()
    End Function

    Shared Function ManyParameters(a As Integer, b As Double, c As String, d As Char, e As Boolean, f As Long) As Double
        Return a + b
    End Function

    Shared Function Forward(x As Integer) As Integer
        Return Sum(x, Fact(3))
    End Function
End Class

Class Main
    Shared Sub Main()
        MathUtil.Hello()
        Call MathUtil.Hello()
        MathUtil.NoParens
        Call MathUtil.NoParens
        MathUtil.Greet("Ivan")
        Call MathUtil.Greet("Ivan")
        Hello
        Hello()
        MathUtil.Pair(1, "x")
        MathUtil.Untyped(1, "x")

        Dim total = MathUtil.Sum(1, 2)
        Dim factorial = MathUtil.Fact(5)
        Print(MathUtil.Sum(MathUtil.Sum(1, 2), 3))
        Dim expression = MathUtil.Sum(1, 2) * MathUtil.Sum(3, 4) - MathUtil.Fact(3)
        Dim numbers = MathUtil.ArrayResult()
        Dim first = MathUtil.ArrayResult()(0)

        If MathUtil.IsLess(1, 2) Then
            Print("less")
        End If
    End Sub
End Class
