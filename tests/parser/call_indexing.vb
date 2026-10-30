' Тестируется:
' - индексация результата вызова сразу после скобок: Items()(i), в том числе вызов с аргументами
' - вызов метода объекта, статического метода, цепочки, Me, MyBase и MyClass
' - несколько индексов подряд и обращение к члену или методу элемента
' - индекс - выражение, вызов, другая индексация, обращение к члену, приведение
' - несколько аргументов и пустые скобки во втором вызове
' - индексация строкового литерала, выражения в скобках и New-массива
' - использование в выражениях, операциях, объявлениях, аргументах и Return
' - использование в условиях, циклах и Select Case
' - присваивание, составное присваивание и отдельный оператор
' - перенос индекса на несколько строк
Class Source
    Public Function Items() As Integer()
        Return New Integer() {1, 2, 3}
    End Function

    Public Function Row(n As Integer) As Integer()
        Return Items()
    End Function

    Public Function First() As Integer
        Return Items()(0)
    End Function

    Public Function FromMe() As Integer
        Return Me.Items()(0) + Items()(1)
    End Function
End Class

Class Derived
    Inherits Source

    Public Function FromBase() As Integer
        Return MyBase.Items()(0)
    End Function

    Public Function FromMyClass() As Integer
        Return MyClass.Items()(0) * Row(1)(2)
    End Function
End Class

Class Main
    Shared Sub Main()
        Dim first = Items()(0)
        Dim withArgument = Row(1)(2)
        Dim twice = Items()(0)(1)
        Dim thrice = Items()(0)(1)(2)
        Dim ofObject = source.Items()(1)
        Dim ofStatic = Util.Numbers()(2)
        Dim ofChain = a.b.Items()(0)
        Dim ofIndexedChain = a.b(1).c()(2)
        Dim ofCreated = New Source().Items()(0)
        Dim member = Items()(0).Name
        Dim memberCall = Items()(0).ToString()
        Dim memberIndex = Items()(0).Parts()(1).Length
        Dim afterMembers = a.b()(1).c()(2).d

        Dim byExpression = Items()(i + 1)
        Dim byCall = Items()(Foo(1))
        Dim byIndex = Items()(sized(0))
        Dim byResult = Items()(Items()(0))
        Dim byMember = Items()(a.b.c)
        Dim byConversion = Items()(CInt(x))
        Dim twoArguments = Items()(1, 2)
        Dim emptyBrackets = Items()()
        Dim emptyAfterIndex = Items()(0)()

        Dim ofString = "text"(0)
        Dim ofParentheses = (a)(0)
        Dim ofParenthesizedCall = (Items())(0)
        Dim ofArrayCreation = New Integer() {1, 2, 3}(0)

        Dim sum = Items()(0) + Items()(1) * 2
        Dim compared = Items()(0) > Items()(1)
        Dim negated = -Items()(0)
        Dim inverted = Not flags()(0)
        Dim joined = names()(0) & names()(1)
        Dim grouped = (Items()(0) + 1) * 2
        Dim conditional = If(flags()(0), Items()(0), Items()(1))
        Dim converted = CInt(Items()(0))
        Dim typed = CType(Items()(0), Single)
        Dim declared As Integer = Items()(0)
        Dim sized(Items()(0)) As Integer

        Items()(0) = 1
        Items()(i + 1) = Items()(i) - 1
        Items()(0) += 2
        Row(1)(2) = 3
        a.b()(1).c = 4
        a.b()(1).c(2) = 5
        Items()(0)
        Call Items()(0)
        Call a.b()(1).c()
        Print(Items()(0), Items()(1))
        Console.WriteLine(Items()(0))

        If Items()(0) > 0 Then
            Print(Items()(0))
        ElseIf Items()(1) = 2 Then
            Items()(2) = 0
        End If

        For index = Items()(0) To Items()(1) Step Items()(2)
            Items()(index) = index
        Next

        While Items()(0) < 5
            Items()(0) += 1
        End While

        Do
            Items()(0) -= 1
        Loop Until Items()(0) = 0

        Select Case Items()(0)
            Case Items()(1)
                Print("equal")
            Case Items()(1) To Items()(2)
                Print("between")
            Case Is > Items()(2)
                Print("greater")
        End Select

        Dim multiline = Items()(
            1
        )
        Dim multilineArguments = Items()(
            1,
            2
        )
    End Sub
End Class
