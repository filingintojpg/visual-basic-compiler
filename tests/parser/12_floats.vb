' Числа с плавающей точкой: Single (F), Double (R), Decimal (D), экспоненциальная запись
Class Main
    Shared Sub Main()
        Dim s1 As Single = 1.5F
        Dim s2 = 2F
        Dim d1 As Double = 1.5
        Dim d2 = 1.5R
        Dim d3 = 3R
        Dim m1 As Decimal = 1.5D
        Dim m2 = 3D
        Dim m3 As Decimal
        
        ' экспоненциальная запись
        Dim e1 = 1.5e+1
        Dim e2 = 1.5E-3
        Dim e3 = 1e10
        Dim e4 = 1E5F
        Dim e5 = 1.5e1F
        Dim e6 = 2.5E+2R
        Dim e7 = 1e2D
        Dim e8 = 1.5E+10
        
        ' прочие формы
        Dim p1 = .5
        Dim p2 = 0.5
        Dim p3 = .5F
        Dim p4 = 1_000.000_1
        Dim p5 = 0.0
        Dim p6 = 123.456R
        
        ' операции
        d1 = d1 + 1.5
        d1 = d1 - 2.5 * d2 / 3.0
        d1 = -d1
        d1 = d1 \ 2
        d1 = (d1 + d2) * (d1 - d2)
        d1 = d1 ^ 2
        d1 = d1 Mod 2.5
        
        Dim r1 As Boolean = d1 < d2
        Dim r2 As Boolean = d1 > 1.5
        Dim r3 As Boolean = d1 <= d2
        Dim r4 As Boolean = d1 >= d2
        Dim r5 As Boolean = d1 <> d2
        Dim r6 As Boolean = d1 = 0.1
        
        s1 = s1 * 2F
        m1 = m1 + 0.1D
        
        ' приведения
        Dim c1 = CDbl("1.5")
        Dim c2 = CSng(1.5)
        Dim c3 = CDec(1)
        Dim c4 = CInt(1.5R)
        
        ' параметры и результаты
        Console.WriteLine(Half(3.0))
        Console.WriteLine(1.5 + 2)
    End Sub
    
    Shared Function Half(x As Double) As Double
        Return x / 2.0
    End Function
    
    Shared Function Money(x As Decimal) As Decimal
        Return x * 1.05D
    End Function
    
    Shared Function Sing(x As Single) As Single
        Return x
    End Function
End Class