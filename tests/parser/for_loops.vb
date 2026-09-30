' Тестируется:
' - For ... Next: обычный, со Step (положительным и отрицательным), с пустым телом
' - переменная цикла с типом (As Integer, As Long)
' - границы и шаг: выражения, вызовы, элементы массива, отрицательные и вещественные значения
' - вложенные циклы For
' - For Each: по массиву, строке, инициализатору, вызову, члену объекта; с типом переменной
' - вложенные For Each, смешанные вложения и однострочная запись через ":"
Class Main
    Shared Sub Main()
        For i = 1 To 10
            Print(i)
        Next

        For i = 1 To 10
        Next

        For i = 10 To 1 Step -1
            Print(i)
        Next

        For i = 0 To 100 Step 5
            Print(i)
        Next

        For i = 1 To 10 Step 2
        Next

        For i As Integer = 0 To n - 1
            Print(i)
        Next

        For i As Long = 1L To 10L Step 2L
            Print(i)
        Next

        For i = a(0) To a(1) + 1 Step k * 2
            Print(i)
        Next

        For i = Foo(1) To Bar(2)
            Print(i)
        Next

        For i = -5 To -1
            Print(i)
        Next

        For ratio = 0.5 To 2.5 Step 0.5
            Print(ratio)
        Next

        For i = 1 To If(a > b, a, b)
            Print(i)
        Next

        For i = 1 To 3 : Print(i) : Next

        For i = 0 To 3
            For j = 0 To 3
                Print(i * j)
            Next
        Next

        For Each value In items
            Print(value)
        Next

        For Each value As Integer In items
            Print(value)
        Next

        For Each letter As Char In "hello"
            Print(letter)
        Next

        For Each value In {1, 2, 3}
            Print(value)
        Next

        For Each value In New Integer() {4, 5, 6}
            Print(value)
        Next

        For Each item In Foo()
        Next

        For Each item In obj.Items
            Print(item)
        Next

        For Each pet As Animal In zoo
            pet.Introduce()
        Next

        For Each row In rows
            For Each cell In row
                Print(cell)
            Next
        Next

        For Each value In items : Print(value) : Next

        For i = 0 To 2
            For Each value In items
                Print(i * value)
            Next
        Next
    End Sub
End Class
