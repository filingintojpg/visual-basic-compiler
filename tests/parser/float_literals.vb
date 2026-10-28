' Тестируется:
' - Single (F) литералы и литерал без суффикса
' - экспоненциальная запись в разных формах и с суффиксом F
' - литералы без целой части и с разделителями "_"
' - арифметика и сравнения с вещественными числами
' - вещественные параметры и результаты функций
Class Calc
    Shared Function Half(x As Single) As Single
        Return x / 2.0
    End Function

    Shared Function Scale(x As Single) As Single
        Return x * 0.5F
    End Function
End Class

Class Main
    Shared Sub Main()
        Dim singleValue As Single = 1.5F
        Dim singleNoPoint = 2F
        Dim plainValue As Single = 1.5
        Dim unassigned As Single

        Dim exponentPositive = 1.5e+1
        Dim exponentNegative = 1.5E-3
        Dim exponentInteger = 1e10
        Dim exponentSingle = 1E5F
        Dim exponentSingleFraction = 1.5e1F

        Dim leadingPoint = .5
        Dim leadingZero = 0.5
        Dim leadingPointSingle = .5F
        Dim grouped = 1_000.000_1
        Dim zero = 0.0
        Dim precise = 123.456F

        plainValue = plainValue + 1.5
        plainValue = plainValue - 2.5 * singleValue / 3.0
        plainValue = -plainValue
        plainValue = plainValue \ 2
        plainValue = (plainValue + singleValue) * (plainValue - singleValue)
        plainValue = plainValue ^ 2
        plainValue = plainValue Mod 2.5
        singleValue = singleValue * 2F

        Dim isLess = plainValue < singleValue
        Dim isGreater = plainValue > 1.5
        Dim isEqual = plainValue = 0.1
        Console.WriteLine(Calc.Half(3.0))
        Console.WriteLine(1.5 + 2)
    End Sub
End Class
