' Одномерные массивы: в скобках верхняя граница, инициализаторы, доступ к элементу.
Class Main
    Shared Sub Main()
        Dim a(10) As Integer
        Dim b(4) As Integer = {1, 2, 3, 4, 5}
        Dim c() As Integer = {1, 2, 3}
        Dim d As Integer() = New Integer() {1, 2, 3}
        Dim e As Integer() = New Integer(9) {}
        Dim f(2) As String = {"a", "b", "c"}
        Dim g As Char() = {"a"c, "b"c}
        Dim h(0) As Boolean
        Dim i() As Boolean = {True, False}
        Dim j As Integer() = {}
        Dim k(n - 1) As Integer
        Dim l(2 * n + 1) As Long
        
        ' чтение и запись элементов
        a(0) = 1
        a(10) = a(0) + a(1) * 2
        a(a(0)) = 5
        a(i + 1) = a(i) - 1
        a(Foo(1)) = 3
        Dim x = a(3)
        Dim y = a(0) + a(1)
        Console.WriteLine(a(i + 1))
        Print(a(0), a(1), a(2))
        
        ' обход
        For n = 0 To 10
            a(n) = n * n
        Next
        Dim len = a.Length
        Dim ub = a.GetUpperBound(0)
        
        ' элементы массива строк и символов
        f(0) = "z"
        g(1) = "q"c
        Dim s = f(0) & f(1)
        Dim t = New Integer() {1, 2, 3}(1)
    End Sub
End Class