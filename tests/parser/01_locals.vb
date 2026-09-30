' Локальные переменные: с типом, без типа, с суффиксом-символом типа.
' Арифметика: + - * / \ ; сравнения ; присваивание. Регистронезависимость.
Class Main
    Shared Sub Main()
        Dim a As Integer = 10
        Dim b As Integer
        Dim c = 10
        Dim d% = 10
        Dim e As String = "text"
        Dim f$ = "text"
        Dim g As Char = "A"c
        Dim h As Long = 10L
        Dim k& = 5
        Dim s As Short = 7S
        DIM m aS INTEGER = 1
        
        ' регистронезависимость имён
        Dim Total = 1
        total = TOTAL + 1
        tOtAl = Total
        
        ' арифметика
        a = b + c
        a = b - c
        a = b * c
        a = b / c
        a = b \ c
        a = -b
        a = +b
        a = b - -c
        a = b + c * d - e / f
        a = (b + c) * (d - e)
        a = b \ c \ d
        a = b - c - d
        a = 100 \ 7 * 2
        a = b Mod c
        a = b ^ 2
        
        ' сравнения
        Dim r1 As Boolean = a < b
        Dim r2 As Boolean = a > b
        Dim r3 As Boolean = a <= b
        Dim r4 As Boolean = a >= b
        Dim r5 As Boolean = a <> b
        Dim r6 As Boolean = a = b
        Dim r7 As Boolean = a + 1 < b * 2
        Dim r8 = (a + b) \ 2 >= c - 1
        
        ' переменные разных типов вместе
        Dim str = "n = " & a
        Dim ch = "x"c
        Dim ok = True
    End Sub
End Class