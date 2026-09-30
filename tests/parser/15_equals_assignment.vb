' Знак "=" парсится как оператор присваивания.
Class Main
    Shared Sub Main()
        ' Присваивание при объявлении (инициализация)
        Dim a As Integer = 10
        Dim b = 20
        Dim c As String = "text"
        Dim d As Boolean = True

        ' Простое присваивание переменной
        a = 15
        b = a
        c = "new text"
        a = 1
        b = 2
        c = "3"

        ' Присваивание элементу массива
        Dim arr(5) As Integer
        arr(0) = 1
        arr(1) = a + b
        arr(a) = 100

        ' Присваивание свойству объекта
        obj.Value = 42
        obj.Name = "Test"

        ' Присваивание со сложными выражениями в правой части
        a = (10 + 20) * 3
        b = Foo(5)
        c = If(True, "yes", "no")

        ' Инициализация счетчика в цикле For (грамматически это форма присваивания)
        For i = 1 To 10
            arr(i - 1) = i
        Next
    End Sub
End Class