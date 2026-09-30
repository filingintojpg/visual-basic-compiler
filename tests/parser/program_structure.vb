' Тестируется:
' - несколько классов в одном файле
' - пустой класс, в том числе в одну строку через ":"
' - несколько классов на одной строке
' - пустые строки между классами
' - конец файла без перевода строки
Class Empty
End Class

Class EmptyInline : End Class

Class Inline : Public value As Integer : End Class



Class Helper
    Shared Sub Run()
    End Sub
End Class : Class Second
End Class

Class Main
    Shared Sub Main()
        Helper.Run()
    End Sub
End Class