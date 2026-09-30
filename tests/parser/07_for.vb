' Циклы For и For Each: Step, вложенность, Exit For, Continue For
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
        
        For i As Integer = 0 To n - 1
            Print(i)
        Next
        
        For i As Long = 1L To 10L Step 2L
            Print(i)
        Next
        
        ' выражения в границах и шаге
        For i = a(0) To a(1) + 1 Step k * 2
            Print(i)
        Next
        
        For i = Foo(1) To Bar(2)
            Print(i)
        Next
        
        For i = -5 To -1
            Print(i)
        Next
        
        ' вложенные
        For i = 0 To 3
            For j = 0 To 3
                Print(i * j)
            Next
        Next
        
        ' управление
        For i = 1 To 100
            If i \ 2 * 2 <> i Then
                Continue For
            End If
            If i > 50 Then
                Exit For
            End If
            Print(i)
        Next
        
        ' For Each
        For Each v In arr
            Print(v)
        Next
        
        For Each v As Integer In arr
            Print(v)
        Next
        
        For Each ch As Char In "hello"
            Print(ch)
        Next
        
        For Each x In {1, 2, 3}
            Print(x)
        Next
        
        For Each x In New Integer() {4, 5, 6}
            Print(x)
        Next
        
        For Each s In Foo()
        Next
        
        For Each o In obj.items
            Print(o)
        Next
        
        For Each row In m
            For Each cell In row
                Print(cell)
            Next
        Next
        
        For Each v In arr
            If v < 0 Then
                Continue For
            End If
            Exit For
        Next
    End Sub
End Class