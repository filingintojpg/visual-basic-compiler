' ============================================================================
' FormMain.vb - VBBrainFNET, адаптирован под компилятор (lexer.l + parser.y)
' ============================================================================

Public Class FormMain
    Inherits Form

    Private dlgMemory As FormMemory
    Private compilerStartTime As Integer

    Private ocIncVal As Byte
    Private ocDecVal As Byte
    Private ocIncPtr As Byte
    Private ocDecPtr As Byte
    Private ocPrnChr As Byte
    Private ocInpChr As Byte
    Private ocWleStr As Byte
    Private ocWleEnd As Byte

    Private MenuItem2 As MenuItem
    Private MenuItemOutTextSize As MenuItem
    Private MenuItemOTSSmallest As MenuItem
    Private MenuItemOTSSmall As MenuItem
    Private MenuItemOTSNormal As MenuItem
    Private MenuItemOTSLarge As MenuItem
    Private MenuItemOTSLargest As MenuItem
    Private StatusBarPanelElapsed As StatusBarPanel
    Private TextBoxCode As TextBox

    Private IsTranslated As Boolean
    Private TabPageBoF As TabPage
    Private TextBoxBoF As TextBox
    Private MenuItemFileSaveBoF As MenuItem
    Private pFileName As String

    Private brq() As Integer

    Private BFCodePointers() As Integer
    Private BasicCodePointers() As Integer
    Private CCodePointers() As Integer
    Private JSCodePointers() As Integer
    Private BoFCodePointers() As Integer

    Private Breakpoints() As Boolean

    Private prgLen As Integer

    Private nextStep As Boolean
    Private nextStepOver As Boolean
    Private nextStepPos As Integer
    Private nextStepOut As Boolean
    Private runToCursorPos As Integer
    Private liveTrace As Boolean

    Private sOut As String

    Private fuckThread As ThreadStub
    Private fuckEvent As EventStub

    Private refreshDisplayThread As ThreadStub
    Private refreshEvent As EventStub

    Private translateThread As ThreadStub

    Private debugEvent As EventStub

    Private ipsThread As ThreadStub
    Private ipsEvent As EventStub
    Private insPerSec As Integer

    Private IsDragging As Boolean

    ' ========================================================================
    ' Запуск
    ' ========================================================================

    Private Sub Run(s As String)
        InitProgram()

        forceAbort = False
        nextStep = False
        nextStepOver = False
        nextStepPos = 0

        If GetProgram(s) Then
            fuckEvent.Set()
        End If
    End Sub

    Private Function GetProgram(s As String) As Boolean
        Dim ok As Boolean
        ok = False
        If s <> "" Then
            prg = RuntimeHelper.EmptyBytes()
            prg = RuntimeHelper.AsciiBytes(s)
            prgLen = RuntimeHelper.UBound(prg)

            Breakpoints = RuntimeHelper.ReDimBool(Breakpoints, prgLen)
            BFCodePointers = RuntimeHelper.ReDimInt(BFCodePointers, prgLen)

            If prgLen < 32767 Then
                maxMem = 32676
            Else
                If prgLen < 65536 Then
                    maxMem = 32768 * 2
                Else
                    maxMem = 32768 * 3
                End If
            End If

            FilterOpcodes()
            OptimizeBraquets()

            ok = True
        End If
        Return ok
    End Function

    Private Sub InitProgram()
        mem = RuntimeHelper.ReDimByte(mem, maxMem)
        TextBoxOut.Text = ""
        sOut = ""
        ptr = 0
    End Sub

    Private Sub RefreshDisplaySub()
        Dim running As Boolean
        running = True
        While running
            refreshEvent.WaitOne(500, True)
            UpdateDisplay(False)
        End While
    End Sub

    ' ========================================================================
    ' Оптимизация скобок
    ' ========================================================================

    Private Sub OptimizeBraquets()
        Dim q As Integer
        Dim done As Boolean
        done = False

        If prgLen <= 0 Then
            Exit Sub
        End If
        brq = RuntimeHelper.ReDimInt(brq, prgLen - 1)

        For i As Integer = 0 To prgLen
            If Not done AndAlso prg(i) = ocWleStr Then
                q = 0
                For j As Integer = i To prgLen
                    If prg(j) = ocWleEnd Then
                        For k As Integer = 0 To prgLen
                            If brq(k) = -q Then
                                brq(k) = j
                                Exit For
                            End If
                        Next
                        q -= 1
                    Else
                        If prg(j) = ocWleStr AndAlso j < prgLen Then
                            q += 1
                            brq(j) = -q
                        End If
                    End If
                    If q = 0 Then
                        Exit For
                    End If
                Next
            End If
        Next
    End Sub

    ' ========================================================================
    ' Отображение
    ' ========================================================================

    Private Sub UpdateDisplay(IsEOP As Boolean)
        Dim nCode As String
        nCode = RuntimeHelper.GetStatic("nCode")
        If nCode <> sOut OrElse IsEOP Then
            nCode = sOut
            RuntimeHelper.SetStatic("nCode", nCode)
            TextBoxOut.Text += RuntimeHelper.Substring(
                RuntimeHelper.FixNull(RuntimeHelper.FixEOL(nCode)),
                RuntimeHelper.Len(TextBoxOut.Text))
            If IsEOP Then
                TextBoxOut.Text += RuntimeHelper.CrLf()
                TextBoxOut.Text += RuntimeHelper.StrDupChar("-", 20)
                TextBoxOut.Text += RuntimeHelper.CrLf()
                TextBoxOut.Text += "End of Program"
                If forceAbort Then
                    TextBoxOut.Text += RuntimeHelper.CrLf()
                    TextBoxOut.Text += "User Aborted!"
                End If
                TextBoxOut.Text += RuntimeHelper.CrLf()
                TextBoxOut.Text += CalcCompileTime()
                compilerStartTime = 0

                dlgMemory.Refresh()

                TextBoxCode.SelectionStart = RuntimeHelper.Len(TextBoxCode.Text)
                TextBoxCode.SelectionLength = 0

                TextBoxBasic.SelectionStart = RuntimeHelper.Len(TextBoxBasic.Text)
                TextBoxBasic.SelectionLength = 0

                TextBoxC.SelectionStart = RuntimeHelper.Len(TextBoxC.Text)
                TextBoxC.SelectionLength = 0

                TextBoxJS.SelectionStart = RuntimeHelper.Len(TextBoxJS.Text)
                TextBoxJS.SelectionLength = 0

                TextBoxBoF.SelectionStart = RuntimeHelper.Len(TextBoxBoF.Text)
                TextBoxBoF.SelectionLength = 0
            End If

            TextBoxOut.SelectionStart = RuntimeHelper.Len(TextBoxOut.Text)
            TextBoxOut.ScrollToCaret()
        End If
    End Sub

    Private Function CalcCompileTime() As String
        Dim result As String
        result = "0h 0m 0s 0ms"
        If compilerStartTime <> 0 Then
            Dim span As TimeSpanStub
            span = TimeSpanStub.FromTicks((RuntimeHelper.TickCount() - compilerStartTime) * 10000)
            result = RuntimeHelper.IntToStr(span.Hours) + "h " +
                     RuntimeHelper.IntToStr(span.Minutes) + "m " +
                     RuntimeHelper.IntToStr(span.Seconds) + "s " +
                     RuntimeHelper.IntToStr(span.Milliseconds) + "ms"
        End If
        Return result
    End Function

    ' ========================================================================
    ' Поток интерпретатора
    ' ========================================================================

    Private Sub FuckThreadSub()
        Dim running As Boolean
        running = True
        While running
            If fuckThread.ThreadState = ThreadStub.Running Then
                fuckEvent.WaitOne(ThreadStub.Infinite, True)

                isRunning = True
                UpdateUI()
                insPerSec = 0

                ReadCustomSettings()

                FuckIt(FindOpcode(0))

                dlgMemory.Refresh()
                isRunning = False
                UpdateUI()

                UpdateDisplay(True)
                ResumeTranslation()
            Else
                running = False
            End If
        End While
    End Sub

    ' ========================================================================
    ' Пользовательские настройки
    ' ========================================================================

    Private Sub ReadCustomSettings()
        Dim p As Integer
        p = 0
        Dim s As String
        s = TextBoxCode.Text
        Dim params() As String
        params = New String() {"CellSize"}
        Dim v As String
        v = ""
        Dim loop1 As Boolean
        loop1 = True

        While loop1
            p = RuntimeHelper.IndexOf(s, "#", p)
            If p = -1 OrElse p + 1 >= RuntimeHelper.Len(s) Then
                loop1 = False
            Else
                p += 1
                For Each param As String In params
                    If RuntimeHelper.ToLower(RuntimeHelper.Substr(s, p, RuntimeHelper.Len(param))) = RuntimeHelper.ToLower(param) Then
                        p = RuntimeHelper.IndexOf(s, "=", p)
                        If p = -1 OrElse p + 3 >= RuntimeHelper.Len(s) Then
                            loop1 = False
                        Else
                            v = ""
                            If param = params(0) Then
                                For i As Integer = p + 1 To RuntimeHelper.Len(s) - 1
                                    If RuntimeHelper.IsNumber(RuntimeHelper.Substr(s, i, 1)) Then
                                        v += RuntimeHelper.Substr(s, i, 1)
                                    Else
                                        If v <> "" Then
                                            Exit For
                                        End If
                                    End If
                                Next
                                If v = "256" Then
                                    SetMaxCellSize(256)
                                End If
                                If v = "512" Then
                                    SetMaxCellSize(512)
                                End If
                            End If
                        End If
                    End If
                Next
            End If
        End While
    End Sub

    ' ========================================================================
    ' Фильтрация опкодов
    ' ========================================================================

    Private Sub FilterOpcodes()
        Dim j As Integer
        j = 0

        For i As Integer = 0 To prgLen
            If prg(i) = ocIncVal OrElse prg(i) = ocDecVal OrElse
               prg(i) = ocIncPtr OrElse prg(i) = ocDecPtr OrElse
               prg(i) = ocPrnChr OrElse prg(i) = ocInpChr OrElse
               prg(i) = ocWleStr OrElse prg(i) = ocWleEnd Then
                BFCodePointers(j) = i
                prg(j) = prg(i)
                j += 1
            End If
        Next

        prgLen = j - 1
        prg = RuntimeHelper.ReDimByte(prg, prgLen)
    End Sub

    ' ========================================================================
    ' Интерпретатор
    ' ========================================================================

    Private Function FuckIt(i As Integer) As Integer
        Dim result As Integer
        result = i
        Dim j As Integer
        j = 0
        Dim k As Integer
        k = i
        Dim loopDone As Boolean
        loopDone = False

        While Not loopDone AndAlso k <= prgLen
            i = k
            If forceAbort Then
                loopDone = True
            Else
                insPerSec += 1

                If isDebugging OrElse liveTrace Then
                    If runToCursorPos = i Then
                        DoBreak()
                        runToCursorPos = -1
                    End If

                    If (Not (nextStepOut OrElse nextStepOver)) OrElse liveTrace Then
                        Dim tabName As String
                        tabName = TabControlLanguages.TabPages(TabControlLanguages.SelectedIndex).Name
                        If tabName = TabPageBF.Name Then
                            TextBoxCode.SelectionStart = BFCodePointers(i)
                            TextBoxCode.SelectionLength = 1
                            TextBoxCode.ScrollToCaret()
                        ElseIf tabName = TabPageVBasic.Name Then
                            If IsTranslated Then
                                If BasicCodePointers(i) = 0 Then
                                    nextStep = True
                                Else
                                    TextBoxBasic.SelectionLength = 0
                                    TextBoxBasic.SelectionStart = BasicCodePointers(i)
                                    TextBoxBasic.SelectionLength = RuntimeHelper.InStr(
                                        TextBoxBasic.SelectionStart, TextBoxBasic.Text, RuntimeHelper.CrLf()) - TextBoxBasic.SelectionStart
                                    TextBoxBasic.ScrollToCaret()
                                End If
                            End If
                        ElseIf tabName = TabPageC.Name Then
                            If IsTranslated Then
                                If CCodePointers(i) = 0 Then
                                    nextStep = True
                                Else
                                    TextBoxC.SelectionLength = 0
                                    TextBoxC.SelectionStart = CCodePointers(i)
                                    TextBoxC.SelectionLength = RuntimeHelper.InStr(
                                        TextBoxC.SelectionStart, TextBoxC.Text, RuntimeHelper.CrLf()) - TextBoxC.SelectionStart
                                    TextBoxC.ScrollToCaret()
                                End If
                            End If
                        ElseIf tabName = TabPageJS.Name Then
                            If IsTranslated Then
                                If JSCodePointers(i) = 0 Then
                                    nextStep = True
                                Else
                                    TextBoxJS.SelectionLength = 0
                                    TextBoxJS.SelectionStart = JSCodePointers(i)
                                    TextBoxJS.SelectionLength = RuntimeHelper.InStr(
                                        TextBoxJS.SelectionStart, TextBoxJS.Text, RuntimeHelper.CrLf()) - TextBoxJS.SelectionStart
                                    TextBoxJS.ScrollToCaret()
                                End If
                            End If
                        ElseIf tabName = TabPageBoF.Name Then
                            If IsTranslated Then
                                If BoFCodePointers(i) = 0 Then
                                    nextStep = True
                                Else
                                    TextBoxBoF.SelectionLength = 0
                                    TextBoxBoF.SelectionStart = BoFCodePointers(i)
                                    TextBoxBoF.SelectionLength = RuntimeHelper.InStr(
                                        TextBoxBoF.SelectionStart, TextBoxBoF.Text, RuntimeHelper.CrLf()) - TextBoxBoF.SelectionStart
                                    TextBoxBoF.ScrollToCaret()
                                End If
                            End If
                        End If
                        If dlgMemory.Visible Then
                            dlgMemory.Invalidate()
                        End If

                        If isDebugging Then
                            If Not nextStepOver AndAlso Not nextStepOut Then
                                Dim waitLoop As Boolean
                                waitLoop = True
                                While waitLoop
                                    debugEvent.WaitOne(1, False)
                                    Application.DoEvents()
                                    If nextStep OrElse nextStepOver OrElse nextStepOut OrElse forceAbort Then
                                        waitLoop = False
                                    End If
                                End While
                                nextStep = False
                                If nextStepOver AndAlso prg(i) = ocWleStr Then
                                    nextStepPos = brq(i)
                                Else
                                    nextStepOver = False
                                End If
                            End If
                        End If
                    End If
                Else
                    If Breakpoints(i) Then
                        DoBreak()
                    End If
                End If

                If prg(i) = ocIncPtr Then
                    If ptr < maxMem Then
                        ptr += 1
                    Else
                        ptr = 0
                    End If
                ElseIf prg(i) = ocDecPtr Then
                    If ptr > 0 Then
                        ptr -= 1
                    Else
                        ptr = maxMem
                    End If
                ElseIf prg(i) = ocIncVal Then
                    If mem(ptr) = maxCellSize Then
                        mem(ptr) = 0
                    Else
                        mem(ptr) += 1
                    End If
                ElseIf prg(i) = ocDecVal Then
                    If mem(ptr) = 0 Then
                        mem(ptr) = maxCellSize
                    Else
                        mem(ptr) -= 1
                    End If
                ElseIf prg(i) = ocPrnChr Then
                    sOut += RuntimeHelper.ByteToChar(mem(ptr) And &HFF)
                    If isDebugging OrElse liveTrace Then
                        refreshEvent.Set()
                    End If
                ElseIf prg(i) = ocInpChr Then
                    refreshEvent.Set()
                    If Not DoInputChar(Me, ptr) Then
                        DoBreak()
                    End If
                ElseаIf prg(i) = ocWleStr Then
                    j = brq(i)
                    Dim loopBody As Boolean
                    loopBody = True
                    While loopBody
                        If mem(ptr) = 0 OrElse forceAbort Then
                            loopBody = False
                        Else
                            j = FuckIt(i + 1)
                        End If
                    End While
                    If isDebugging Then
                        If nextStepOver AndAlso j = nextStepPos Then
                            nextStepOver = False
                        End If
                        If nextStepOut Then
                            nextStepOut = False
                            nextStep = False
                        End If
                    End If
                    i = j
                ElseIf prg(i) = ocWleEnd Then
                    loopDone = True
                Else
                    i = FindOpcode(i)
                End If
            End If
            k = i + 1
        End While

        result = i
        Return result
    End Function

    Private Function FindOpcode(i As Integer) As Integer
        Dim c As String
        c = ""
        Dim found As Boolean
        found = False
        Dim k As Integer
        k = i

        While Not found AndAlso k <= prgLen
            If prg(k) = ocIncVal OrElse prg(k) = ocDecVal OrElse
               prg(k) = ocIncPtr OrElse prg(k) = ocDecPtr OrElse
               prg(k) = ocPrnChr OrElse prg(k) = ocInpChr OrElse
               prg(k) = ocWleStr OrElse prg(k) = ocWleEnd Then
                found = True
            Else
                If prg(k) = RuntimeHelper.ByteOf(RuntimeHelper.Cr()) AndAlso prg(k + 1) = RuntimeHelper.ByteOf(RuntimeHelper.Lf()) Then
                    k += 1
                Else
                    c = RuntimeHelper.ByteToChar(prg(k))
                    If c = "'" OrElse c = "/" OrElse c = "*" Then
                        Dim kk As Integer
                        kk = k
                        Dim stopComment As Boolean
                        stopComment = False
                        While Not stopComment AndAlso kk <= prgLen
                            c = RuntimeHelper.ByteToChar(prg(kk))
                            If c = RuntimeHelper.Cr() OrElse c = RuntimeHelper.Lf() Then
                                k = kk
                                stopComment = True
                            Else
                                kk += 1
                            End If
                        End While
                    End If
                End If
                If Not found Then
                    k += 1
                End If
            End If
        End While

        If k < 1 Then
            Return 0
        Else
            Return k - 1
        End If
    End Function

    ' ========================================================================
    ' Закрытие окна памяти
    ' ========================================================================

    Private Sub DlgMemory_Closing(sender As Object, e As CancelEventArgsStub)
        If forceAbort Then
            dlgMemory = Nothing
        Else
            ToggleMemoryMap()
            e.Cancel = True
        End If
    End Sub

    Private Function FixEOL(s As String) As String
        Return RuntimeHelper.FixEOL(s)
    End Function

    ' ========================================================================
    ' Управление отладкой
    ' ========================================================================

    Private Sub DoRun()
        SuspendTranslation()

        compilerStartTime = RuntimeHelper.TickCount()

        If isDebugging Then
            isDebugging = False
            nextStep = True
            UpdateUI()
        Else
            isDebugging = False
            Run(TextBoxCode.Text)
        End If
    End Sub

    Private Sub DoStop()
        forceAbort = True
        isDebugging = False

        Dim waitRunning As Boolean
        waitRunning = True
        While waitRunning
            If isRunning Then
                Application.DoEvents()
            Else
                waitRunning = False
            End If
        End While

        UpdateUI()
        ResumeTranslation()
    End Sub

    Private Sub DoBreak()
        If TextBoxCode.Text = "" Then
            Exit Sub
        End If

        isDebugging = True
        If Not dlgMemory.Visible Then
            ToggleMemoryMap()
        End If
        If Not isRunning Then
            Run(TextBoxCode.Text)
        End If
        ResumeTranslation()

        UpdateUI()
    End Sub

    Private Sub DoStep()
        If Not isRunning Then
            DoBreak()
        Else
            nextStep = True
        End If
    End Sub

    Private Sub SuspendTranslation()
        If Not translateThread Is Nothing Then
            If translateThread.ThreadState = ThreadStub.Running Then
                translateThread.Suspend()
                StatusBarPanelTransStatus.Text = "(Translation Suspended)"
            End If
        End If
    End Sub

    Private Sub ResumeTranslation()
        If Not translateThread Is Nothing Then
            If translateThread.ThreadState = ThreadStub.Suspended Then
                translateThread.Resume()
                StatusBarPanelTransStatus.Text = "Translating:"
            End If
        End If
    End Sub

    Private Sub DoStepOut()
        nextStepOut = True
    End Sub

    Private Sub DoStepOver()
        nextStepOver = True
        If Not isRunning Then
            DoBreak()
        End If
    End Sub

    Private Sub DoFileNew()
        CancelTranslateThread()
        pFileName = "Untitled.bf"
        Breakpoints = RuntimeHelper.EmptyBools()
        DoStop()
        prgLen = 0
        TextBoxCode.Text = ""
        TextBoxOut.Text = ""
        UpdateTitle()
    End Sub

    Private Sub UpdateTitle()
        Dim fn As String
        fn = ""
        Dim p As Integer
        p = RuntimeHelper.LastIndexOf(pFileName, "\")
        If p <> -1 Then
            fn = RuntimeHelper.Substr(pFileName, p + 1, RuntimeHelper.Len(pFileName) - p - 1)
        Else
            fn = pFileName
        End If

        Me.Text = "VBBrainFNET - " + fn
    End Sub
End Class