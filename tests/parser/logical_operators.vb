' Тестируется:
' - операторы And, Or, Xor, Not, AndAlso, OrElse
' - приоритеты и ассоциативность, скобки
' - сочетание со сравнениями и арифметикой
' - литералы True и False
' - побитовое применение к числам
' - логические выражения в If, While, Do Until и If()
Class Main
    Shared Sub Main()
        Dim both = a And b
        Dim either = a Or b
        Dim negated = Not a
        Dim exclusive = a Xor b
        Dim shortAnd = a AndAlso b
        Dim shortOr = a OrElse b

        Dim notThenAnd = Not a And b
        Dim orThenAnd = a Or b And c
        Dim andThenOr = a And b Or c And d
        Dim notOrNot = Not a Or Not b
        Dim notGrouped = Not (a And b)
        Dim doubleNot = Not Not a
        Dim shortMixed = a AndAlso b OrElse c AndAlso d
        Dim shortAndOr = a Or b OrElse c
        Dim xorThenOr = a Xor b Or c
        Dim orThenXor = a Or b Xor c

        Dim withComparison = a < b And c < d
        Dim withGrouping = (a < b) AndAlso (c > d) OrElse Not e
        Dim withCall = x > 0 AndAlso Check(x) OrElse False
        Dim withArithmetic = a + 1 > b * 2 Or c \ 2 <> d
        Dim notComparison = Not a < b

        Dim literalAnd = True And False
        Dim literalOr = True Or False
        Dim literalNot = Not True
        Dim literalXor = True Xor True

        Dim bitAnd = 5 And 3
        Dim bitOr = 5 Or 3
        Dim bitXor = 5 Xor 3
        Dim bitNot = Not 5
        Dim masked = &HFF And &H0F

        If a And b Then
            Print(1)
        End If

        If a AndAlso Not b Then
            Print(2)
        End If

        While a OrElse b
            a = False
        End While

        Do Until a Xor b
            a = True
        Loop

        Dim picked = If(a AndAlso b, 1, 2)
    End Sub
End Class
