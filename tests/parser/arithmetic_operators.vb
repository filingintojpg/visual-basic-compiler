' Тестируется:
' - операторы + - * / \ Mod ^ (бинарные и унарные), сдвиги << и >>
' - приоритеты, левая ассоциативность, скобки
' - конкатенация & и её приоритет относительно арифметики
' - операнды: литералы, переменные, вызовы, элементы массива, члены объекта
Class Main
    Shared Sub Main()
        Dim a = 7
        Dim b = 3
        Dim c = 2

        Dim addition = a + b
        Dim subtraction = a - b
        Dim multiplication = a * b
        Dim division = a / b
        Dim integerDivision = a \ b
        Dim remainder = a Mod b
        Dim power = a ^ b
        Dim negation = -a
        Dim unaryPlus = +a
        Dim doubleNegation = a - -b
        Dim leftShift = a << 2
        Dim rightShift = a >> 2

        Dim chained = a - b - c
        Dim chainedDivision = a \ b \ c
        Dim mixedPriority = a + b * c - a / b
        Dim integerThenMultiply = 100 \ 7 * 2
        Dim powerChain = a ^ b ^ c
        Dim negativePower = -a ^ 2
        Dim powerOfNegative = a ^ -b
        Dim modThenAdd = a Mod b + c
        Dim shiftThenAdd = a + b << 1
        Dim grouped = (a + b) * (c - a)
        Dim nested = ((a + b) * (c - a)) / ((b))

        Dim concatenation = "n = " & a
        Dim concatenationChain = "a" & b & "c" & a
        Dim concatenationAndSum = "sum " & a + b

        Dim withCalls = Foo(a) * Bar(b) - Baz()
        Dim withMembers = obj.Value + items(0) * other.Size
    End Sub
End Class
