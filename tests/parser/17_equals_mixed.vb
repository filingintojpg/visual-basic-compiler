' Смешанное использование "=" (присваивание и сравнение).
' Парсер должен корректно различать их по контексту.
Class Main
    Shared Sub Main()
        Dim a As Integer = 10
        Dim b As Integer = 10
        Dim isEqual As Boolean

        ' САМЫЙ ВАЖНЫЙ ТЕСТ
        isEqual = (a = b)
        
        Dim flag As Boolean = (a = 10)

        ' Присваивание внутри тела условия, где само условие содержит сравнение
        If a = b Then
            a = 20
            b = 20
        End If

        ' Цикл While: условие (сравнение) и тело (присваивание)
        While a = b
            a = a + 1
            If a = 15 Then
                b = 20
            End If
        End While

        ' Сброс значений (присваивание)
        a = 5
        b = 5

        ' сравнение в условии, присваивание результата
        Dim result = If(a = 5, 100, 200)
        
        ' Проверка приоритета
        Dim boolResult As Boolean
        boolResult = (a = 5) 

        ' For цикл (инициализация "=") + сравнение внутри тела
        For i = 1 To 10
            If i = 5 Then
                Print(5)
            End If
        Next

        ' Присваивание свойствам на основе сравнения
        obj.Value = If(a = b, 1, 0)
        obj.IsActive = (obj.Value = 1)
    End Sub
End Class