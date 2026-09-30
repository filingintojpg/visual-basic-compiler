' Тестируется:
' - Single (F), Double (R) и Decimal (D) литералы, литерал по умолчанию
' - экспоненциальная запись в разных формах и с суффиксами
' - литералы без целой части и с разделителями "_"
' - арифметика и сравнения с вещественными числами
' - вещественные параметры и результаты функций
Class Calc
    Shared Function Half(x As Double) As Double
        Return x / 2.0
    End Function

    Shared Function Price(x As Decimal) As Decimal
        Return x * 1.05D
    End Function

    Shared Function Scale(x As Single) As Single
        Return x * 0.5F
    End Function
End Class

Class Main
    Shared Sub Main()
        Dim singleValue As Single = 1.5F
        Dim singleNoPoint = 2F
        Dim doubleValue As Double = 1.5
        Dim doubleSuffix = 1.5R
        Dim doubleNoPoint = 3R
        Dim decimalValue As Decimal = 1.5D
        Dim decimalNoPoint = 3D
        Dim unassigned As Decimal

        Dim exponentPositive = 1.5e+1
        Dim exponentNegative = 1.5E-3
        Dim exponentInteger = 1e10
        Dim exponentSingle = 1E5F
        Dim exponentSingleFraction = 1.5e1F
        Dim exponentDouble = 2.5E+2R
        Dim exponentDecimal = 1e2D

        Dim leadingPoint = .5
        Dim leadingZero = 0.5
        Dim leadingPointSingle = .5F
        Dim grouped = 1_000.000_1
        Dim zero = 0.0
        Dim precise = 123.456R

        doubleValue = doubleValue + 1.5
        doubleValue = doubleValue - 2.5 * doubleSuffix / 3.0
        doubleValue = -doubleValue
        doubleValue = doubleValue \ 2
        doubleValue = (doubleValue + doubleSuffix) * (doubleValue - doubleSuffix)
        doubleValue = doubleValue ^ 2
        doubleValue = doubleValue Mod 2.5
        singleValue = singleValue * 2F
        decimalValue = decimalValue + 0.1D

        Dim isLess = doubleValue < doubleSuffix
        Dim isGreater = doubleValue > 1.5
        Dim isEqual = doubleValue = 0.1
        Console.WriteLine(Calc.Half(3.0))
        Console.WriteLine(1.5 + 2)
    End Sub
End Class
