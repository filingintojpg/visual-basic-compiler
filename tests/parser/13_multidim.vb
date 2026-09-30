' Многомерные (прямоугольные) и зубчатые массивы
Class Main
    Shared Sub Main()
        ' прямоугольные
        Dim a(3, 3) As Integer
        a(1, 2) = 5
        Dim v = a(1, 2)
        
        Dim b(2, 2, 2) As Integer
        b(0, 1, 2) = 1
        
        Dim c As Integer(,) = New Integer(1, 1) {{1, 2}, {3, 4}}
        Dim c2(,) As Integer = {{1, 2}, {3, 4}}
        Dim c3(1, 2) As Integer = {{1, 2, 3}, {4, 5, 6}}
        Dim c4 As Integer(,) = New Integer(,) {{1, 2}, {3, 4}}
        Dim n(k, k + 1) As Double
        
        a(i + 1, j * 2) = a(i, j) + a(j, i)
        Print(a(0, 0), a(1, 1))
        
        For i = 0 To 3
            For j = 0 To 3
                a(i, j) = i * j
            Next
        Next
        
        ' зубчатые
        Dim jag()() As Integer
        ReDim jag(2)
        jag(0) = New Integer(4) {}
        jag(1) = New Integer(1) {}
        jag(2) = New Integer() {1, 2, 3}
        jag(0)(1) = 7
        Dim jv = jag(2)(0)
        jag(i)(j) = jag(j)(i) + 1
        
        Dim j2()() As Integer = New Integer()() {New Integer() {1}, New Integer() {1, 2}}
        Dim j3 As Integer()() = New Integer(2)() {}
        Dim j4(2)() As Integer
        Dim j5 As Integer()() = {New Integer() {1}, New Integer() {2, 3}}
        
        ' строки разной длины
        For i = 0 To 2
            jag(i) = New Integer(i) {}
            For k = 0 To i
                jag(i)(k) = i + k
            Next
        Next
        
        ' смесь: зубчатый массив прямоугольных
        Dim mix()(,) As Integer
        Dim strs(1, 1) As String
        strs(0, 0) = "a"
        
        Console.WriteLine(strs(0, 0) & strs(1, 1))
        Console.WriteLine(jag(1)(0))
        Console.WriteLine(a(1, 2))
    End Sub
End Class