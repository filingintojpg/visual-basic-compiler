' Тестируется:
' - классы с модификаторами Public, Private, Protected и без модификатора (по умолчанию Public)
' - поля: Public, Private, Protected и без модификатора (через Dim и без Dim)
' - константы Const с каждым модификатором и без него
' - методы Sub и Function с каждым модификатором и без модификатора
' - Shared в сочетании с модификатором доступа (в обоих порядках), а также Dim Shared и Const Shared
' - модификаторы в разном регистре
' - обращение к членам с разными модификаторами
Public Class PublicClass
    Public publicField As Integer
    Private privateField As Integer
    Protected protectedField As Integer
    Dim defaultField As Integer

    Public Dim publicDim As Integer
    Private Dim privateDim As Integer
    Protected Dim protectedDim As Integer

    Public Const publicConst As Integer = 1
    Private Const privateConst As Integer = 2
    Protected Const protectedConst As Integer = 3
    Const defaultConst As Integer = 4

    Public Sub PublicSub()
        publicField = privateField + protectedField
    End Sub

    Private Sub PrivateSub()
        privateField = 1
    End Sub

    Protected Sub ProtectedSub()
        protectedField = 2
    End Sub

    Sub DefaultSub()
        defaultField = 3
    End Sub

    Public Function PublicFunction() As Integer
        Return publicField
    End Function

    Private Function PrivateFunction() As Integer
        Return privateField
    End Function

    Protected Function ProtectedFunction() As Integer
        Return protectedField
    End Function

    Function DefaultFunction() As Integer
        Return defaultField
    End Function
End Class

Private Class PrivateClass
    Public Value As Integer
    Sub Run()
    End Sub
End Class

Protected Class ProtectedClass
    Public Value As Integer
    Sub Run()
    End Sub
End Class

Class DefaultClass
    Public Value As Integer
    Sub Run()
    End Sub
End Class

Class SharedMembers
    Public Shared publicShared As Integer
    Private Shared privateShared As Integer
    Protected Shared protectedShared As Integer
    Shared defaultShared As Integer

    Shared Public reversedPublic As Integer
    Shared Private reversedPrivate As Integer
    Shared Protected reversedProtected As Integer

    Shared Dim sharedDim As Integer
    Dim Shared dimShared As Integer
    Public Dim Shared publicDimShared As Integer
    Public Shared Dim publicSharedDim As Integer

    Public Shared Const publicSharedConst As Integer = 5
    Private Shared Const privateSharedConst As Integer = 6
    Shared Const defaultSharedConst As Integer = 7
    Const Shared constShared As Integer = 8
    Public Const Shared publicConstShared As Integer = 9

    Public Shared Sub PublicSharedSub()
    End Sub

    Private Shared Sub PrivateSharedSub()
    End Sub

    Protected Shared Sub ProtectedSharedSub()
    End Sub

    Shared Sub DefaultSharedSub()
    End Sub

    Shared Public Sub ReversedSharedSub()
    End Sub

    Public Shared Function PublicSharedFunction() As Integer
        Return publicShared
    End Function

    Private Shared Function PrivateSharedFunction() As Integer
        Return privateShared
    End Function

    Shared Protected Function ReversedSharedFunction() As Integer
        Return protectedShared
    End Function

    Shared Function DefaultSharedFunction() As Integer
        Return defaultShared
    End Function
End Class

PUBLIC CLASS UpperCaseModifiers
    PRIVATE SHARED counter AS INTEGER
    protected const limit as integer = 10
    public shared sub Run()
    end sub
END CLASS

Class Main
    Shared Sub Main()
        Dim item As PublicClass = New PublicClass()
        item.publicField = 1
        item.PublicSub()
        item.DefaultSub()
        Dim result = item.PublicFunction() + item.DefaultFunction()

        Dim other As DefaultClass = New DefaultClass()
        other.Value = 2
        other.Run()

        SharedMembers.publicShared = 3
        SharedMembers.PublicSharedSub()
        SharedMembers.DefaultSharedSub()
        Dim total = SharedMembers.PublicSharedFunction() + SharedMembers.defaultShared
        UpperCaseModifiers.Run()
    End Sub
End Class
