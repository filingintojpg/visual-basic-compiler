' Тестируется:
' - любое ключевое слово языка в качестве имени члена после точки (id_or_kw): obj.End, obj.Next, obj.Integer, obj.CInt, ...
' - те же имена в вызове метода: obj.End(), obj.Next(), ...
' - ключевые слова как члены в выражениях и слева от присваивания
Class Main
    Shared Sub Main()
        Dim asIf = obj.If
        Dim asThen = obj.Then
        Dim asElse = obj.Else
        Dim asElseIf = obj.ElseIf
        Dim asEnd = obj.End
        Dim asSelect = obj.Select
        Dim asCase = obj.Case
        Dim asTo = obj.To
        Dim asFor = obj.For
        Dim asEach = obj.Each
        Dim asWhile = obj.While
        Dim asNext = obj.Next
        Dim asIn = obj.In
        Dim asUntil = obj.Until
        Dim asLoop = obj.Loop
        Dim asDo = obj.Do
        Dim asStep = obj.Step
        Dim asMe = obj.Me
        Dim asMyBase = obj.MyBase
        Dim asMyClass = obj.MyClass
        Dim asNew = obj.New
        Dim asAs = obj.As
        Dim asOptional = obj.Optional
        Dim asDim = obj.Dim
        Dim asConst = obj.Const
        Dim asFunction = obj.Function
        Dim asSub = obj.Sub
        Dim asClass = obj.Class
        Dim asInherits = obj.Inherits
        Dim asCall = obj.Call
        Dim asContinue = obj.Continue
        Dim asExit = obj.Exit
        Dim asReturn = obj.Return
        Dim asPublic = obj.Public
        Dim asPrivate = obj.Private
        Dim asProtected = obj.Protected
        Dim asShared = obj.Shared
        Dim asInteger = obj.Integer
        Dim asBoolean = obj.Boolean
        Dim asChar = obj.Char
        Dim asString = obj.String
        Dim asSingle = obj.Single
        Dim asCBool = obj.CBool
        Dim asCInt = obj.CInt
        Dim asCChar = obj.CChar
        Dim asCStr = obj.CStr
        Dim asCSng = obj.CSng
        Dim asCType = obj.CType

        obj.If()
        obj.End()
        obj.Next()
        obj.Loop()
        obj.New()
        obj.Sub()
        obj.Function()
        obj.Integer()
        obj.Cint()
        obj.Select()
        obj.Do()
        obj.Dim()

        obj.End = 1
        obj.Next = obj.Loop + obj.Step
        obj.If.Then.Else = 2
        obj.Select.Case = obj.Integer
        Dim chained = obj.Function.Sub.Class.Inherits
        Dim viaCall = obj.New().Dim().Const
    End Sub
End Class
