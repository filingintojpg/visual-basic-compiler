' Тестируется:
' - Sub и Function: с параметрами и без, со скобками и без скобок
' - параметры с типом, параметры-массивы, параметры-объекты
' - тип результата Function: примитивный, массив, класс (тип результата обязателен)
' - Return со значением и без, вызов через Call, вызов без скобок
' - рекурсия, вызов функции в аргументах и в выражениях
' - индексация результата функции-массива сразу после вызова
' - вызов методов другого класса и собственных методов
' - перенос списка параметров на несколько строк
' - Optional-параметры со значением по умолчанию, в том числе несколько подряд
' - Sub и Function без модификатора доступа (по умолчанию Public), в том числе без скобок
Class MathUtil
    Shared Sub Hello()
        Console.WriteLine("Hello")
    End Sub

    Shared Sub Greet(name As String)
        Console.WriteLine("Hi, " & name)
    End Sub

    Shared Sub Pair(left As Integer, right As String)
    End Sub

    Shared Sub Empty()
    End Sub

    Shared Sub NoParens
        Console.WriteLine("no parens")
    End Sub

    Shared Sub Multiline(first As Integer,
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

    Shared Function NoParens As Integer
        Return 2
    End Function

    Shared Function NoParams() As String
        Return "s"
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

    Shared Function ManyParameters(a As Integer, b As Single, c As String, d As Char, e As Boolean) As Single
        Return a + b
    End Function

    Shared Function Forward(x As Integer) As Integer
        Return Sum(x, Fact(3))
    End Function

    Shared Sub WithOptional(a As Integer, Optional b As Integer = 5)
        Print(a + b)
    End Sub

    Shared Sub ManyOptional(Optional a As Integer = 1, Optional name As String = "x", Optional flag As Boolean = True)
    End Sub

    Shared Function OptionalExpression(a As Integer, Optional b As Integer = 2 * 3 + 1) As Integer
        Return a + b
    End Function

    Shared Sub OptionalMultiline(a As Integer,
        Optional b As Integer = 5,
        Optional c As Integer =
            10
    )
    End Sub

    Sub PlainSub()
    End Sub

    Sub PlainSubNoParens
        Print("plain")
    End Sub

    Function PlainFunction() As Integer
        Return 1
    End Function

    Function PlainFunctionNoParens As Integer
        Return 2
    End Function

    Function PlainFunctionWithParams(a As Integer, b As Integer) As Integer
        Return a * b
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
        MathUtil.WithOptional(1)
        MathUtil.WithOptional(1, 2)
        MathUtil.ManyOptional()
        MathUtil.ManyOptional(2, "y", False)

        Dim total = MathUtil.Sum(1, 2)
        Dim factorial = MathUtil.Fact(5)
        Print(MathUtil.Sum(MathUtil.Sum(1, 2), 3))
        Dim expression = MathUtil.Sum(1, 2) * MathUtil.Sum(3, 4) - MathUtil.Fact(3)
        Dim numbers = MathUtil.ArrayResult()
        Dim second = MathUtil.ArrayResult()(1)
        Print(MathUtil.ArrayResult()(0) + MathUtil.ArrayResult()(2))

        If MathUtil.IsLess(1, 2) Then
            Print("less")
        End If
    End Sub
End Class
