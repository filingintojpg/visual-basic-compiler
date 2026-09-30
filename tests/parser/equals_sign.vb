' Тестируется:
' - знак "=" как присваивание: переменной, элементу массива, члену объекта
' - знак "=" как инициализатор в Dim, Const и For
' - знак "=" как сравнение в If, While, Do...Loop, If() и с Nothing
' - смешанное использование в одном выражении и в одном блоке
Class Main
    Shared Sub Main()
        Dim counter As Integer = 10
        Dim inferred = 20
        Dim text As String = "text"
        Dim flag As Boolean = True
        Dim numbers(5) As Integer
        Const limit = 5

        counter = 15
        inferred = counter
        text = "new text"
        numbers(0) = 1
        numbers(counter) = 100
        numbers(1) = counter + inferred
        obj.Value = 42
        obj.Name = "Test"
        counter = (10 + 20) * 3
        inferred = Foo(5)
        text = If(flag, "yes", "no")

        If counter = 5 Then
            Print(1)
        End If

        If text = other Then
            Print(2)
        End If

        If obj = Nothing Then
            Print(3)
        End If

        If counter = 5 And inferred = 5 Then
            Print(4)
        End If

        If Not (counter = 10) Then
            Print(5)
        End If

        If Foo() = Bar() Then
            Print(6)
        End If

        While counter = 5
            Exit While
        End While

        Do
            Exit Do
        Loop While counter = inferred

        Do
            Exit Do
        Loop Until counter = 10

        flag = (counter = inferred)
        flag = counter = inferred
        Dim isTen As Boolean = (counter = 10)
        Dim chosen = If(counter = 5, 100, 200)
        obj.Value = If(counter = inferred, 1, 0)
        obj.IsActive = (obj.Value = 1)
        numbers(0) = If(numbers(1) = 0, 1, 2)

        If counter = inferred Then
            counter = 20
            inferred = 20
        End If

        While counter = inferred
            counter = counter + 1
            If counter = 15 Then
                inferred = 20
            End If
        End While

        For i = 1 To 10
            If i = limit Then
                numbers(0) = i
            End If
        Next
    End Sub
End Class
