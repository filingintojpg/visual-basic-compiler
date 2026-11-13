Public Class NumericTable

    ''' <summary>
    ''' the name of current table object
    ''' </summary>
    Public name As String

    ''' <summary>
    ''' the comment text about this table
    ''' </summary>
    Public description As String

    ''' <summary>
    ''' 行 ID / 样本名。如果这个字段为 Nothing 或者长度和样本数量不一致，
    ''' 则会使用 1..n 的序号作为缺省的行名。
    ''' </summary>
    Public rowNames As String()

    ''' <summary>
    ''' 样本特征矩阵的列名
    ''' </summary>
    Public featureNames As String()

    ''' <summary>
    ''' 样本特征矩阵，行主序的二维数组，即 features(sample, feature)
    ''' </summary>
    Public features As Single(,)

    ''' <summary>
    ''' 标签矩阵的列名。聚类结果的类标签列也会出现在这里
    ''' </summary>
    Public labelNames As String()

    ''' <summary>
    ''' 标签矩阵，行主序的二维数组，即 labels(sample, label)
    ''' </summary>
    Public labels As Single(,)

    ''' <summary>
    ''' 样本的数量（矩阵的行数）
    ''' </summary>
    Public Function nsamples() As Integer
        Return If(features Is Nothing, 0, features.GetLength(0))
    End Function

    ''' <summary>
    ''' 特征的数量（特征矩阵的列数）
    ''' </summary>
    Public Function nfeatures() As Integer
        Return Width(features)
    End Function

    ''' <summary>
    ''' 标签列的数量（标签矩阵的列数）
    ''' </summary>
    Public Function nlabels() As Integer
        Return Width(labels)
    End Function

    ''' <summary>
    ''' 是否当前表中没有任何特征数据？
    ''' </summary>
    Public Function isEmpty() As Boolean
        Return nsamples() = 0
    End Function

    ''' <summary>
    ''' 获取指定行的特征向量数据（返回该行的副本）
    ''' </summary>
    ''' <param name="i"></param>
    Public Function Item(i As Integer) As Single()
        If features Is Nothing Then
            Return Nothing
        End If

        Dim w As Integer = nfeatures()
        Dim v As Single() = New Single(w - 1) {}

        For j As Integer = 0 To w - 1
            v(j) = features(i, j)
        Next

        Return v
    End Function

    Sub New()
    End Sub

    ''' <summary>
    ''' 从特征矩阵构造一个二维表对象
    ''' </summary>
    ''' <param name="features">行主序的特征矩阵</param>
    ''' <param name="rowNames">行名/样本 ID，可选</param>
    ''' <param name="featureNames">特征列名，可选</param>
    Sub New(features As Single(,), Optional rowNames As String() = Nothing, Optional featureNames As String() = Nothing)
        Me.features = features
        Me.rowNames = rowNames
        Me.featureNames = featureNames
    End Sub

    ''' <summary>
    ''' Overloads for regression
    ''' </summary>
    ''' <param name="x"></param>
    ''' <param name="y"></param>
    Sub New(x As Single(,), y As Single())
        Dim n As Integer = y.Length

        Me.features = x
        Me.labels = New Single(n - 1, 0) {}

        For i As Integer = 0 To n - 1
            Me.labels(i, 0) = y(i)
        Next
    End Sub

    ''' <summary>
    ''' Overloads for classification
    ''' </summary>
    ''' <param name="x"></param>
    ''' <param name="y"></param>
    Sub New(x As Single(,), y As Integer())
        Dim n As Integer = y.Length

        Me.features = x
        Me.labels = New Single(n - 1, 0) {}

        For i As Integer = 0 To n - 1
            Me.labels(i, 0) = CSng(y(i))
        Next
    End Sub

    ''' <summary>
    ''' 从列向量集合构造二维表（转置为行主序）
    ''' </summary>
    ''' <param name="featureNames">特征列名</param>
    ''' <param name="columns">columns(feature, sample)：每一行是一列特征数据</param>
    ''' <param name="rowNames">行名/样本 ID，可选</param>
    Sub New(featureNames As String(), columns As Single(,), Optional rowNames As String() = Nothing)
        Me.featureNames = featureNames
        Me.rowNames = rowNames
        Me.features = ColumnsToMatrix(columns)
    End Sub

    Private Shared Function Width(mat As Single(,)) As Integer
        If mat Is Nothing OrElse mat.GetLength(0) = 0 Then
            Return 0
        Else
            Return mat.GetLength(1)
        End If
    End Function

    Private Shared Function ColumnsToMatrix(columns As Single(,)) As Single(,)
        If columns Is Nothing Then
            Return Nothing
        End If

        Dim nc As Integer = columns.GetLength(0)

        If nc = 0 Then
            Return Nothing
        End If

        Dim nr As Integer = columns.GetLength(1)
        Dim mat As Single(,) = CreateMatrix(nr, nc)

        For j As Integer = 0 To nc - 1
            For i As Integer = 0 To nr - 1
                mat(i, j) = columns(j, i)
            Next
        Next

        Return mat
    End Function

    ''' <summary>
    ''' 创建一个 rows x cols 的零值二维数组
    ''' </summary>
    Private Shared Function CreateMatrix(rows As Integer, cols As Integer) As Single(,)
        If rows <= 0 Then
            Return New Single(-1, -1) {}
        End If

        Return New Single(rows - 1, cols - 1) {}
    End Function

    ''' <summary>
    ''' 用分隔符把字符串数组连接成一行文本（Nothing 视为空数组）
    ''' </summary>
    Private Shared Function Join(parts As String(), separator As String) As String
        If parts Is Nothing Then
            Return ""
        End If

        Dim text As String = ""

        For i As Integer = 0 To parts.Length - 1
            If i > 0 Then
                text &= separator
            End If
            text &= parts(i)
        Next

        Return text
    End Function

    ''' <summary>
    ''' 获取缺省的行名数组（当 rowNames 缺失时生成 1..n 序号）
    ''' </summary>
    Public Function RowNamesOrDefault() As String()
        Dim n As Integer = nsamples()

        If rowNames IsNot Nothing AndAlso rowNames.Length = n Then
            Return rowNames
        End If

        Dim generated As String() = New String(n - 1) {}

        For i As Integer = 1 To n
            generated(i - 1) = CStr(i)
        Next

        Return generated
    End Function

    ''' <summary>
    ''' 获取指定行的行名/样本 ID
    ''' </summary>
    Public Function GetRowName(i As Integer) As String
        Return RowNamesOrDefault()(i)
    End Function

    ''' <summary>
    ''' 获取指定行的特征向量数据（等价于 Item）
    ''' </summary>
    Public Function Row(i As Integer) As Single()
        Return Item(i)
    End Function

    ''' <summary>
    ''' 获取指定名称的特征列向量；如果列不存在则返回 Nothing
    ''' </summary>
    ''' <param name="name"></param>
    Public Function Feature(name As String) As Single()
        Dim idx As Integer = RequireFeatureIndex(name)

        If idx < 0 Then
            Return Nothing
        End If

        Dim n As Integer = nsamples()
        Dim v As Single() = New Single(n - 1) {}

        For i As Integer = 0 To n - 1
            v(i) = features(i, idx)
        Next

        Return v
    End Function

    ''' <summary>
    ''' 判断是否存在指定名称的特征列
    ''' </summary>
    Public Function HasFeature(name As String) As Boolean
        Return FeatureIndex(name) > -1
    End Function

    ''' <summary>
    ''' 判断是否存在指定名称的标签列
    ''' </summary>
    Public Function HasLabel(name As String) As Boolean
        Return LabelIndex(name) > -1
    End Function

    Private Function FeatureIndex(name As String) As Integer
        Return IndexOfName(featureNames, name)
    End Function

    Private Function LabelIndex(name As String) As Integer
        Return IndexOfName(labelNames, name)
    End Function

    Private Shared Function IndexOfName(names As String(), name As String) As Integer
        If names Is Nothing OrElse String.IsNullOrEmpty(name) Then
            Return -1
        End If

        Dim target As String = name.ToLower()

        For i As Integer = 0 To names.Length - 1
            If names(i).ToLower() = target Then
                Return i
            End If
        Next

        Return -1
    End Function

    ' Вместо исключения KeyNotFoundException печатаем сообщение и возвращаем -1
    Private Function RequireFeatureIndex(name As String) As Integer
        Dim idx As Integer = FeatureIndex(name)

        If idx < 0 Then
            Console.WriteLine($"error: missing feature column '{name}' in the table: {Join(featureNames, ", ")}")
        End If

        Return idx
    End Function

    Private Function RequireLabelIndex(name As String) As Integer
        Dim idx As Integer = LabelIndex(name)

        If idx < 0 Then
            Console.WriteLine($"error: missing label column '{name}' in the table: {Join(labelNames, ", ")}")
        End If

        Return idx
    End Function

    ''' <summary>
    ''' 获取指定名称的标签列向量；如果列不存在则返回 Nothing
    ''' </summary>
    ''' <param name="name"></param>
    Public Function GetLabel(name As String) As Single()
        Dim idx As Integer = RequireLabelIndex(name)

        If idx < 0 Then
            Return Nothing
        End If

        Return GetLabel(idx)
    End Function

    Public Function GetClassLabel(idx As Integer) As Integer()
        Dim v As Single() = GetLabel(idx)
        Dim result As Integer() = New Integer(v.Length - 1) {}

        For i As Integer = 0 To v.Length - 1
            result(i) = CInt(v(i))
        Next

        Return result
    End Function

    Public Function GetLabel(idx As Integer) As Single()
        Dim n As Integer = nsamples()
        Dim v As Single() = New Single(n - 1) {}

        For i As Integer = 0 To n - 1
            v(i) = labels(i, idx)
        Next

        Return v
    End Function

    ''' <summary>
    ''' 尝试获取指定名称的标签列向量。
    ''' оригинал возвращал Boolean через ByRef-параметр; здесь вместо этого
    ''' возвращается Nothing, если такой колонки нет (и без сообщения об ошибке)
    ''' </summary>
    Public Function TryGetLabel(name As String) As Single()
        Dim idx As Integer = LabelIndex(name)

        If idx < 0 Then
            Return Nothing
        End If

        Return GetLabel(idx)
    End Function

    ''' <summary>
    ''' 写入或者新增一列标签数据。如果指定的标签列已经存在，则覆盖其数值；
    ''' 否则在标签矩阵的末尾追加一个新的标签列。
    ''' </summary>
    ''' <param name="name">标签列的名称</param>
    ''' <param name="values">标签数据，长度必须和样本数量一致</param>
    ''' <returns>返回当前表对象以支持链式调用</returns>
    Public Function SetLabel(name As String, values As Single()) As NumericTable
        If String.IsNullOrEmpty(name) Then
            Console.WriteLine("error: the label name is empty")
            Return Me
        End If
        If values Is Nothing Then
            Console.WriteLine("error: the label values are missing")
            Return Me
        End If
        If values.Length <> nsamples() Then
            Console.WriteLine($"error: the label column '{name}' has {values.Length} values, but the table has {nsamples()} samples!")
            Return Me
        End If

        Dim idx As Integer = LabelIndex(name)

        If idx < 0 Then
            AppendLabelColumn(name, values)
        Else
            For i As Integer = 0 To nsamples() - 1
                labels(i, idx) = values(i)
            Next
        End If

        Return Me
    End Function

    ''' <summary>
    ''' 写入或者新增一列整数标签数据（例如聚类的类编号结果）
    ''' </summary>
    Public Function SetLabel(name As String, values As Integer()) As NumericTable
        If values Is Nothing Then
            Console.WriteLine("error: the label values are missing")
            Return Me
        End If

        Dim converted As Single() = New Single(values.Length - 1) {}

        For i As Integer = 0 To values.Length - 1
            converted(i) = CSng(values(i))
        Next

        Return SetLabel(name, converted)
    End Function

    Private Sub AppendLabelColumn(name As String, values As Single())
        Dim n As Integer = nsamples()
        Dim oldK As Integer = nlabels()
        Dim newK As Integer = oldK + 1
        Dim newLabels As Single(,) = CreateMatrix(n, newK)
        Dim newNames As String() = New String(newK - 1) {}

        For j As Integer = 0 To oldK - 1
            newNames(j) = labelNames(j)

            For i As Integer = 0 To n - 1
                newLabels(i, j) = labels(i, j)
            Next
        Next

        newNames(oldK) = name

        For i As Integer = 0 To n - 1
            newLabels(i, oldK) = values(i)
        Next

        labels = newLabels
        labelNames = newNames
    End Sub

    ''' <summary>
    ''' 删除指定名称的标签列
    ''' </summary>
    ''' <param name="name"></param>
    ''' <returns>是否成功的删除了一个标签列</returns>
    Public Function RemoveLabel(name As String) As Boolean
        Dim idx As Integer = LabelIndex(name)

        If idx < 0 Then
            Return False
        End If

        Dim n As Integer = nsamples()
        Dim newK As Integer = nlabels() - 1

        If newK <= 0 Then
            labels = Nothing
            labelNames = Nothing
            Return True
        End If

        Dim newLabels As Single(,) = CreateMatrix(n, newK)
        Dim newNames As String() = New String(newK - 1) {}
        Dim d As Integer = 0

        For j As Integer = 0 To labelNames.Length - 1
            If j = idx Then
                Continue For
            End If

            newNames(d) = labelNames(j)

            For i As Integer = 0 To n - 1
                newLabels(i, d) = labels(i, j)
            Next

            d += 1
        Next

        labels = newLabels
        labelNames = newNames

        Return True
    End Function

    ''' <summary>
    ''' 按行下标进行行切片，返回一个共享列名、行名子集的新表对象
    ''' </summary>
    ''' <param name="rows"></param>
    Public Function Slice(rows As Integer()) As NumericTable
        Dim names0 As String() = RowNamesOrDefault()
        Dim nf As Integer = nfeatures()
        Dim nl As Integer = nlabels()

        If rows Is Nothing OrElse rows.Length = 0 Then
            Dim blank As New NumericTable(New Single(-1, -1) {}, New String(-1) {}, featureNames)

            If labels IsNot Nothing Then
                blank.labels = New Single(-1, -1) {}
            End If

            blank.labelNames = labelNames
            blank.name = name
            blank.description = description

            Return blank
        End If

        Dim outNames As String() = New String(rows.Length - 1) {}
        Dim outFeatures As Single(,) = New Single(rows.Length - 1, nf - 1) {}
        Dim outLabels As Single(,) = Nothing

        If labels IsNot Nothing Then
            outLabels = New Single(rows.Length - 1, nl - 1) {}
        End If

        For n As Integer = 0 To rows.Length - 1
            Dim r As Integer = rows(n)

            If r < 0 OrElse r >= nsamples() Then
                Console.WriteLine($"error: row index {r} is out of the table range [0, {nsamples() - 1}]")
                Return Nothing
            End If

            outNames(n) = names0(r)

            For j As Integer = 0 To nf - 1
                outFeatures(n, j) = features(r, j)
            Next

            If outLabels IsNot Nothing Then
                For j As Integer = 0 To nl - 1
                    outLabels(n, j) = labels(r, j)
                Next
            End If
        Next

        Dim result As New NumericTable(outFeatures, outNames, featureNames)

        result.labels = outLabels
        result.labelNames = labelNames
        result.name = name
        result.description = description

        Return result
    End Function

    ''' <summary>
    ''' 特征列投影，返回仅包含指定特征列的新表对象
    ''' </summary>
    ''' <param name="features">需要保留的特征列名</param>
    Public Function [Select](features As String()) As NumericTable
        If features Is Nothing Then
            Return Nothing
        End If

        Dim n As Integer = nsamples()
        Dim idx As Integer() = New Integer(features.Length - 1) {}

        For j As Integer = 0 To features.Length - 1
            idx(j) = RequireFeatureIndex(features(j))

            If idx(j) < 0 Then
                Return Nothing
            End If
        Next

        Dim outFeatures As Single(,) = CreateMatrix(n, features.Length)

        For i As Integer = 0 To n - 1
            For j As Integer = 0 To features.Length - 1
                outFeatures(i, j) = Me.features(i, idx(j))
            Next
        Next

        Dim result As New NumericTable(outFeatures, rowNames, features)

        result.labels = labels
        result.labelNames = labelNames
        result.name = name
        result.description = description

        Return result
    End Function

    ''' <summary>
    ''' 深拷贝当前表对象
    ''' </summary>
    Public Function Clone() As NumericTable
        Dim result As New NumericTable(CopyMatrix(features), CopyArray(rowNames), CopyArray(featureNames))

        result.labels = CopyMatrix(labels)
        result.labelNames = CopyArray(labelNames)
        result.name = name
        result.description = description

        Return result
    End Function

    Private Shared Function CopyArray(v As String()) As String()
        If v Is Nothing Then
            Return Nothing
        End If

        Dim copy As String() = New String(v.Length - 1) {}

        For i As Integer = 0 To v.Length - 1
            copy(i) = v(i)
        Next

        Return copy
    End Function

    Private Shared Function CopyMatrix(mat As Single(,)) As Single(,)
        If mat Is Nothing Then
            Return Nothing
        End If

        Dim nr As Integer = mat.GetLength(0)
        Dim nc As Integer = mat.GetLength(1)
        Dim copy As Single(,) = New Single(nr - 1, nc - 1) {}

        For i As Integer = 0 To nr - 1
            For j As Integer = 0 To nc - 1
                copy(i, j) = mat(i, j)
            Next
        Next

        Return copy
    End Function

    ''' <summary>
    ''' 检查当前表内部的维度是否一致，用于在计算之前做数据校验。
    ''' Вместо исключений InvalidConstraintException выводит сообщения и
    ''' возвращает False, если найдена хотя бы одна проблема.
    ''' </summary>
    Public Function Validate() As Boolean
        Dim ok As Boolean = True
        Dim n As Integer = nsamples()
        Dim w As Integer = nfeatures()

        If features Is Nothing Then
            Return True
        End If

        If featureNames IsNot Nothing AndAlso featureNames.Length <> w Then
            Console.WriteLine($"error: the feature name size {featureNames.Length} is not equals to the feature dimension {w}!")
            ok = False
        End If

        If labels Is Nothing Then
            Return ok
        End If

        If labels.GetLength(0) <> n Then
            Console.WriteLine($"error: the label row size {labels.GetLength(0)} is not equals to the sample size {n}!")
            ok = False
        End If

        Dim k As Integer = nlabels()

        If labelNames IsNot Nothing AndAlso labelNames.Length <> k Then
            Console.WriteLine($"error: the label name size {labelNames.Length} is not equals to the label dimension {k}!")
            ok = False
        End If

        Return ok
    End Function

    ''' <summary>
    ''' 从行主序的特征矩阵构造二维表对象
    ''' </summary>
    Public Shared Function FromRows(rowNames As String(), features As Single(,), Optional featureNames As String() = Nothing) As NumericTable
        Return New NumericTable(features, rowNames, featureNames)
    End Function

    ''' <summary>
    ''' 从列向量集合构造二维表对象（内部转置为行主序）
    ''' </summary>
    Public Shared Function FromColumns(featureNames As String(),
                                       columns As Single(,),
                                       Optional rowNames As String() = Nothing) As NumericTable

        Return New NumericTable(featureNames, columns, rowNames)
    End Function

    ''' <summary>
    ''' 拷贝特征矩阵（默认返回内部数组的引用，即浅拷贝）
    ''' </summary>
    Public Function ArrayPack(Optional deepcopy As Boolean = False) As Single(,)
        If deepcopy Then
            Return CopyMatrix(features)
        Else
            Return features
        End If
    End Function

    ''' <summary>
    ''' 返回每一行数据的标签（行名）
    ''' </summary>
    Public Function GetLabels() As String()
        Return RowNamesOrDefault()
    End Function

    Public Function ToString() As String
        Dim text As String = $"[{nsamples()} x {nfeatures()}]"

        If labelNames IsNot Nothing AndAlso labelNames.Length > 0 Then
            text &= $" labels: {Join(labelNames, ", ")}"
        End If
        If Not String.IsNullOrEmpty(name) Then
            text &= $" '{name}'"
        End If

        Return text
    End Function
End Class