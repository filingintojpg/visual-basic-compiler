' Тестируется:
' - цепочки обращений через точку: поля, вызовы методов, индексы
' - вызов и индексация результата вызова
' - обращение к членам литерала, результата в скобках и примитивного типа
' - ключевые слова в качестве имени члена после точки
' - обращения слева от присваивания и в виде отдельного оператора
' - Call с обращением к члену
Class Main
    Shared Sub Main()
        Dim chain = a.b.c.d
        Dim calls = a.b().c()
        Dim indexed = a.items(0).name
        Dim afterCall = Foo(1).Bar
        Dim callOnCall = Foo()(1)
        Dim staticAccess = Counter.Total
        Dim maxInteger = Integer.MaxValue
        Dim emptyString = String.Empty
        Dim maxDouble = Double.MaxValue
        Dim minLong = Long.MinValue
        Dim upper = "text".ToUpper()
        Dim length = "text".Length
        Dim fromParentheses = (a + b).ToString()
        Dim keywordMembers = obj.End + obj.Next + obj.Step + obj.Loop + obj.Select + obj.Do

        a.b.c = 5
        a.b(1).c = 6
        a.b(1).c(2) = 7
        a.b.c()
        a.b(1)
        a.b
        Call a.b()
        Call a.b.c(1, 2)
        a.b.c += 1
    End Sub
End Class
