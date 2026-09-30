' Целочисленные литералы: десятичные, &H &O &B, суффиксы S I L US UI UL,
' подчёркивания внутри числа, разный регистр.
Class Main
    Shared Sub Main()
        Dim d0 = 0
        Dim d1 = 123
        Dim d2 = 1_000_000
        Dim d3 = 1_00__0
        Dim d4 = 34359738368
        Dim d5 = 9223372036854775807L
        Dim h1 = &H1F
        Dim h2 = &HFF_FF
        Dim h3 = &hff
        Dim h4 = &H0
        Dim o1 = &O17
        Dim o2 = &o777
        Dim o3 = &O7_7
        Dim b1 = &B1010
        Dim b2 = &B1010_1010
        Dim b3 = &b1
        
        ' суффиксы типов
        Dim s1 = 100S
        Dim i1 = 100I
        Dim l1 = 100L
        Dim us1 = 100US
        Dim ui1 = 100UI
        Dim ul1 = 100UL
        Dim s2 = 100s
        Dim l2 = 100l
        Dim ul2 = 100ul
        Dim ul3 = 100Ul
        
        ' префикс + суффикс
        Dim x1 = &H7FS
        Dim x2 = &HFFUS
        Dim x3 = &HFFUI
        Dim x4 = &HFFFFFFFFFUL
        Dim x5 = &B11UL
        Dim x6 = &O7I
        Dim x7 = &HFF_FFL
        Dim x8 = 1_000UL
        
        ' унарный минус и выражения с литералами
        Dim n1 = -42
        Dim n2 = -&HFF
        Dim n3 = 1_0 + &H10 * &B10 - &O10
        Dim n4 As Short = -32768S
        Dim n5 As UInteger = 4294967295UI
        Const c1 As Integer = 34359738368
    End Sub
End Class