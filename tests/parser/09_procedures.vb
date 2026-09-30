' Sub и Function, Return, вызовы, параметры, тип результата можно не указывать
Class MathUtil
    Shared Sub Hello()
        Console.WriteLine("Hello")
    End Sub
    
    Shared Sub Greet(name As String)
        Console.WriteLine("Hi, " & name)
    End Sub
    
    Shared Sub Both(ByVal name As String, ByRef count As Integer)
        count = count + 1
    End Sub
    
    Shared Sub Empty()
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
    
    Shared Function NoParams() As String
        Return "s"
    End Function
    
    Shared Function Bool(a As Integer, b As Integer) As Boolean
        Return a < b
    End Function
    
    Shared Sub EarlyExit(x As Integer)
        If x < 0 Then
            Return
        End If
        If x = 0 Then
            Exit Sub
        End If
        Print(x)
    End Sub
    
    Shared Function EarlyFunc(x As Integer) As Integer
        If x < 0 Then
            Exit Function
        End If
        Return x
    End Function
    
    Shared Sub ArrParam(a() As Integer, b As Integer(), m(,) As Integer)
    End Sub
    
    Shared Function ArrRet() As Integer()
        Return New Integer() {1, 2, 3}
    End Function
    
    Shared Sub Opt(Optional x As Integer = 5, Optional y As String = "s")
    End Sub
    
    Shared Sub Pa(ParamArray xs() As Integer)
    End Sub
    
    Shared Function Multi(a As Integer, b As Double, c As String, d As Char, e As Boolean, f As Long) As Double
        Return a + b
    End Function
End Class

Class Main
    Shared Sub Main()
        MathUtil.Hello()
        Call MathUtil.Hello()
        MathUtil.Greet("Ivan")
        Call MathUtil.Greet("Ivan")
        
        Dim s = MathUtil.Sum(1, 2)
        Dim f = MathUtil.Fact(5)
        Print(MathUtil.Sum(MathUtil.Sum(1, 2), 3))
        
        Dim z = MathUtil.Sum(1, 2) * MathUtil.Sum(3, 4) - MathUtil.Fact(3)
        Dim arr = MathUtil.ArrRet()
        Dim first = MathUtil.ArrRet()(0)
        
        MathUtil.Both("a", cnt)
        MathUtil.Opt()
        MathUtil.Opt(1)
        MathUtil.Opt(1, "x")
        MathUtil.Pa(1, 2, 3)
        MathUtil.Pa()
        
        If MathUtil.Bool(1, 2) Then
            Print("less")
        End If
    End Sub
End Class