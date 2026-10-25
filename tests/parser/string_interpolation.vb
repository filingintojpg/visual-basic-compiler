Class Program
    Sub Main()
        Dim name As String = "World"
        Dim x As Integer = 5

        Console.WriteLine($"")
        Console.WriteLine($"Hello")
        Console.WriteLine($"Hello, {name}!")
        Console.WriteLine($"{name}")
        Console.WriteLine($"{name}{x}")
        Console.WriteLine($"x + 1 = {x + 1}, x * 2 = {x * 2}")
        Console.WriteLine($"Braces: {{literal}} and quote: "" and {x}")
        Console.WriteLine($"Call: {Foo(x, 2)} and string arg: {Foo("a}b", 1)}")
        Console.WriteLine($"Array: {New Integer() {1, 2, 3}.Length}")
        Console.WriteLine($"Nested: {$"inner {x} here"} done")
        Console.WriteLine($"Ternary: {If(x > 3, "big", "small")}")

        Dim s As String = $"a{x}b" & "c" & $"{x}"
        s &= $"-{x}"
        Console.WriteLine("not interpolated: $""{x}""") ' $"{ignored in comment}"
    End Sub
End Class
