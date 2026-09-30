' Логические операции: And Or Not Xor AndAlso OrElse, приоритеты, побитовое применение
Class Main
    Shared Sub Main()
        Dim r1 = a And b
        Dim r2 = a Or b
        Dim r3 = Not a
        Dim r4 = a Xor b
        Dim r5 = a AndAlso b
        Dim r6 = a OrElse b
        
        ' приоритеты: Not > And > Or
        Dim p1 = Not a And b
        Dim p2 = a Or b And c
        Dim p3 = a And b Or c And d
        Dim p4 = Not a Or Not b
        Dim p5 = Not (a And b)
        Dim p6 = Not Not a
        Dim p7 = a AndAlso b OrElse c AndAlso d
        Dim p8 = a Or b OrElse c
        
        ' Or и Xor одного приоритета, левоассоциативны
        Dim x1 = a Xor b Or c
        Dim x2 = a Or b Xor c
        
        ' вместе со сравнениями и арифметикой
        Dim q1 = a < b And c < d
        Dim q2 = (a < b) AndAlso (c > d) OrElse Not e
        Dim q3 = x > 0 AndAlso Check(x) OrElse False
        Dim q4 = a + 1 > b * 2 Or c \ 2 <> d
        Dim q5 = Not a < b
        Dim q6 = Not x > 0 AndAlso y < 0
        
        ' литералы
        Dim l1 = True And False
        Dim l2 = True Or False
        Dim l3 = Not True
        Dim l4 = True Xor True
        Dim l5 = True AndAlso False OrElse True
        
        ' побитовое применение к числам
        Dim b1 = 5 And 3
        Dim b2 = 5 Or 3
        Dim b3 = 5 Xor 3
        Dim b4 = Not 5
        Dim b5 = &HFF And &H0F
        
        ' в условиях
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
        
        Dim t = If(a AndAlso b, 1, 2)
    End Sub
End Class