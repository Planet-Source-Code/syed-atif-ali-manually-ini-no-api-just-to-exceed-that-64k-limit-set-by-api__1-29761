VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Adv_INI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\\custom ini class
'\\\written by Syed Atif Ali. email me at iamatif@hotmail.com for more info
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\\NOTES:
'\\\     FILENAME -- be sure to specify this first before using this class _
 \\\      its the name of the ini you want to write to or read from.
'\\\     MATCHCASE -- there is no matchcase in writeini because if there was then there _
 \\\      would be some confusions when reading them (as there would be more _
 \\\      than one same name. however, i did include a matchcase in readini _
 \\\      so make use of it if u have to.
'\\\     DELETING KEYS AND VALUES -- to delete keys and values do this... _
 \\\      to delete a key: Call WriteINI("AnySection","KeyToDelete",vbNullString) _
 \\\      to delete a section: Call WriteINI("SectionToDelete",vbNullString,vbNullString _
 \\\      ...its just specifying some null values.
'\\\     READING/WRITING FROM AND TO ARRAYS - a good feature provided with _
 \\\      this class is the ability to read a whole section of an ini file into _
 \\\      two arrays and and write a whole section from two arrays. However, care _
 \\\      must be taken (while using these functions) that the correct data type _
 \\\      array is supplied, else error occurs. Also, when supplying arrays to _
 \\\      the ReadINI_toArray function, arrays must be dynamic. static arrays will _
 \\\      not work in this function because this function will redim the array to _
 \\\      allow all the items in a section to fit it.
'\\\     CHECKING -- this class (especially the WriteINI function) goes through _
 \\\      many checks to ensure the validity and integrity of data. If you find _
 \\\      any errors, please work out HOW you got the problem (cuz it might be _
 \\\      some locked file you were trying to access or something) and then report _
 \\\      or work out why there was a problem (from the code)...although the code _
 \\\      has been tested against the toughest of enviroments.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Dim strFile As String

Public Property Get INIFile() As String
INIFile = strFile
End Property

Public Property Let INIFile(What_File As String)
strFile = What_File
End Property

Public Function WriteINI(strSection As String, strKey As String, strValue As String) As String
Dim lLineNum As Long, getFreeFile As Long, strArray() As String
ReDim strArray(0) As String
Dim x As Long, y As Long, fromLine As Long, toLine As Long

ReadINI_ReturnLineNumber strSection, strKey, lLineNum

getFreeFile = FreeFile
Open strFile For Input As #getFreeFile
    Do Until EOF(getFreeFile)
        ReDim Preserve strArray((UBound(strArray)) + 1) As String
        Line Input #getFreeFile, strArray(UBound(strArray))
    Loop
Close #getFreeFile

If lLineNum <> 0 Then 'line number is returned, new key does not have to be added, only updated.
    If strKey = vbNullString Then 'delete the section
        For x = 1 To UBound(strArray)
            If LCase(strArray(x)) = "[" & LCase(strSection) & "]" Then
                For y = (x + 1) To UBound(strArray)
                    If (Trim(strArray(y)) = "") Then 'if the section has ended.
                        fromLine = x 'line number of the name of the section
                        toLine = y 'line number where section ends.
                        Exit For
                    ElseIf (Strings.Left(strArray(y), 1) = "[") Then 'if there is a section name _
                                                                      immediately after another _
                                                                      section name...we should _
                                                                      take into account every _
                                                                      possible possibility
                        fromLine = x
                        toLine = x
                        Exit For
                    End If
                Next y
                If toLine - fromLine = 1 Then
                    For y = (x + 1) To UBound(strArray)
                        strArray(y - 1) = strArray(y)
                    Next y
                    ReDim Preserve strArray((UBound(strArray)) - 1) As String
                    getFreeFile = FreeFile
                    Open strFile For Output As #getFreeFile
                        For y = 1 To UBound(strArray)
                            Print #getFreeFile, strArray(y)
                        Next y
                    Close #getFreeFile
                Else
                    For y = (toLine + 1) To UBound(strArray)
                        strArray(y - (toLine - fromLine)) = strArray(y)
                    Next y
                    ReDim Preserve strArray((UBound(strArray)) - (toLine - fromLine)) As String
                    For y = 1 To UBound(strArray)
                        If LCase(strArray(y)) = "[" & LCase(strSection) & "]" Then
                            fromLine = y 'specify where the section is
                            toLine = -1 'just to indicate section name is still there....so delete it!
                        End If
                    Next y
                    If toLine = -1 Then
                        For y = (fromLine + 1) To UBound(strArray)
                            strArray(y - 1) = strArray(y)
                        Next y
                    End If
                    ReDim Preserve strArray((UBound(strArray)) - 1) As String
                    Open strFile For Output As #getFreeFile
                        For y = 1 To UBound(strArray)
                            Print #getFreeFile, strArray(y)
                        Next y
                    Close #getFreeFile
                End If
                Exit For
            End If
        Next x
    ElseIf strValue = vbNullString Then 'delete the value
        For x = (lLineNum + 1) To UBound(strArray)
            strArray(x - 1) = strArray(x)
        Next x
        ReDim Preserve strArray((UBound(strArray)) - 1) As String
        getFreeFile = FreeFile
        Open strFile For Output As #getFreeFile
            For x = 1 To UBound(strArray)
                Print #getFreeFile, strArray(x)
            Next x
        Close #getFreeFile
    Else 'write the value
        strArray(lLineNum) = strKey & "=" & strValue
        Open strFile For Output As #getFreeFile
            For x = 1 To UBound(strArray)
                Print #getFreeFile, strArray(x)
            Next x
        Close #getFreeFile
    End If
Else 'line number is zero, its a new key to be added
    fromLine = -1 'section doesn't exist...at least now :)
    toLine = -1
    For x = 1 To UBound(strArray)
        If LCase(strArray(x)) = "[" & LCase(strSection) & "]" Then
            fromLine = x
            Exit For
        End If
    Next x
    If fromLine <> -1 Then
        For x = (fromLine + 1) To UBound(strArray)
            If (Trim(strArray(x)) = "") Or (Strings.Left(strArray(x), 1) = "[") Then
                toLine = x
                Exit For
            End If
        Next x
        If toLine <> -1 Then
            ReDim Preserve strArray((UBound(strArray)) + 1) As String
            For x = ((UBound(strArray)) - 1) To toLine Step -1 'we have to shift arrays backwards _
                                                        or else the same items will be copied _
                                                        over and over again into the next items _
                                                        ...think about it logically
                strArray(x + 1) = strArray(x)
            Next x
            strArray(toLine) = strKey & "=" & strValue
            Open strFile For Output As #getFreeFile
                For x = 1 To UBound(strArray)
                    Print #getFreeFile, strArray(x)
                Next x
            Close #getFreeFile
        End If
    End If
End If
End Function

Public Function WriteINI_fromArray(strSection As String, strKeys() As String, strValues() As String) As String
If UBound(strKeys) <> UBound(strValues) Then Exit Function 'don't want inequal values...

Dim lLineNums() As Long, getFreeFile As Long, strArray() As String
ReDim strArray(0) As String, lLineNums(UBound(strKeys)) As Long
Dim x As Long, y As Long, z As Long, fromLine As Long, toLine As Long
Dim WriteNow As Boolean

For x = LBound(strKeys) To UBound(strKeys) 'this array might start with 0, unlike ours that starts with 1 :D
    ReadINI_ReturnLineNumber strSection, strKeys(x), lLineNums(x)
Next x

getFreeFile = FreeFile
Open strFile For Input As #getFreeFile
    Do Until EOF(getFreeFile)
        ReDim Preserve strArray((UBound(strArray)) + 1) As String
        Line Input #getFreeFile, strArray(UBound(strArray))
    Loop
Close #getFreeFile

For z = LBound(lLineNums) To UBound(lLineNums)
    toLine = 0: fromLine = 0 'just for validity purposes :)
    If lLineNums(z) <> 0 Then 'line number is returned, new key does not have to be added, only updated.
        If strKeys(z) = vbNullString Then '---delete the section---
            For x = 1 To UBound(strArray)
                If LCase(strArray(x)) = "[" & LCase(strSection) & "]" Then
                    For y = (x + 1) To UBound(strArray)
                        If (Trim(strArray(y)) = "") Then 'if the section has ended.
                            fromLine = x 'line number of the name of the section
                            toLine = y 'line number where section ends.
                            Exit For
                        ElseIf (Strings.Left(strArray(y), 1) = "[") Then 'if there is a section name _
                                                                          immediately after another _
                                                                          section name...we should _
                                                                          take into account every _
                                                                          possible possibility
                            fromLine = x
                            toLine = x
                            Exit For
                        End If
                    Next y
                    If toLine - fromLine = 1 Then
                        For y = (x + 1) To UBound(strArray)
                            strArray(y - 1) = strArray(y)
                        Next y
                        ReDim Preserve strArray((UBound(strArray)) - 1) As String
                        getFreeFile = FreeFile
                        'Open strFile For Output As #getFreeFile
                        '    For y = 1 To UBound(strArray)
                        '        Print #getFreeFile, strArray(y)
                        '    Next y
                        'Close #getFreeFile
                        WriteNow = True
                    Else
                        For y = (toLine + 1) To UBound(strArray)
                            strArray(y - (toLine - fromLine)) = strArray(y)
                        Next y
                        ReDim Preserve strArray((UBound(strArray)) - (toLine - fromLine)) As String
                        For y = 1 To UBound(strArray)
                            If LCase(strArray(y)) = "[" & LCase(strSection) & "]" Then
                                fromLine = y 'specify where the section is
                                toLine = -1 'just to indicate section name is still there....so delete it!
                            End If
                        Next y
                        If toLine = -1 Then
                            For y = (fromLine + 1) To UBound(strArray)
                                strArray(y - 1) = strArray(y)
                            Next y
                        End If
                        ReDim Preserve strArray((UBound(strArray)) - 1) As String
                        'Open strFile For Output As #getFreeFile
                        '    For y = 1 To UBound(strArray)
                        '        Print #getFreeFile, strArray(y)
                        '    Next y
                        'Close #getFreeFile
                        WriteNow = True
                    End If
                    Exit For
                End If
            Next x
        ElseIf strValues(x) = vbNullString Then 'delete the value
            For x = (lLineNums(z) + 1) To UBound(strArray)
                strArray(x - 1) = strArray(x)
            Next x
            ReDim Preserve strArray((UBound(strArray)) - 1) As String
            getFreeFile = FreeFile
            'Open strFile For Output As #getFreeFile
            '    For x = 1 To UBound(strArray)
            '        Print #getFreeFile, strArray(x)
            '    Next x
            'Close #getFreeFile
            WriteNow = True
        Else 'write the value
            strArray(lLineNums(z)) = strKeys(z) & "=" & strValues(z)
            'Open strFile For Output As #getFreeFile
            '    For x = 1 To UBound(strArray)
            '        Print #getFreeFile, strArray(x)
            '    Next x
            'Close #getFreeFile
            WriteNow = True
        End If
    Else 'line number is zero, its a new key to be added
        fromLine = -1 'section doesn't exist...at least now :)
        toLine = -1
        For x = 1 To UBound(strArray)
            If LCase(strArray(x)) = "[" & LCase(strSection) & "]" Then
                fromLine = x
                Exit For
            End If
        Next x
        If fromLine <> -1 Then
            For x = (fromLine + 1) To UBound(strArray)
                If (Trim(strArray(x)) = "") Or (Strings.Left(strArray(x), 1) = "[") Then
                    toLine = x
                    Exit For
                End If
            Next x
            If toLine <> -1 Then
                ReDim Preserve strArray((UBound(strArray)) + 1) As String
                For x = ((UBound(strArray)) - 1) To toLine Step -1 'we have to shift arrays backwards _
                                                            or else the same items will be copied _
                                                            over and over again into the next items _
                                                            ...think about it logically
                    strArray(x + 1) = strArray(x)
                Next x
                strArray(toLine) = strKeys(z) & "=" & strValues(z)
                'Open strFile For Output As #getFreeFile
                '    For x = 1 To UBound(strArray)
                '        Print #getFreeFile, strArray(x)
                '    Next x
                'Close #getFreeFile
                WriteNow = True
            End If
        End If
    End If
Next z

If WriteNow = True Then 'finally write to the file
    Open strFile For Output As #getFreeFile
        For x = 1 To UBound(strArray)
            Print #getFreeFile, strArray(x)
        Next x
    Close #getFreeFile
End If
End Function

Public Sub ReadINI(strSection As String, strKey As String, strValue As String, Optional MatchCase As Boolean = False)
On Error GoTo errH

Dim getFreeFile As Long, strTemp As String, bFound As Boolean, strArray() As String, lTemp As Long, x As Long
ReDim strArray(0) As String
getFreeFile = FreeFile

Open strFile For Input As #getFreeFile
    Do Until EOF(getFreeFile)
        Line Input #getFreeFile, strTemp
        If bFound = False Then
            If Strings.Left(LCase(strTemp), Len("[" & strSection & "]")) = "[" & LCase(strSection) & "]" Then
                bFound = True
                lTemp = UBound(strArray) + 2
            End If
        End If
        ReDim Preserve strArray((UBound(strArray)) + 1) As String
        strArray(UBound(strArray)) = strTemp
    Loop
Close #getFreeFile

If bFound = True Then
    For x = lTemp To UBound(strArray)
        If strArray(x) = vbNullString Then
            Exit For
        Else
            If MatchCase = True Then
                If Strings.Left(strArray(x), Len(strKey)) = strKey Then
                    strValue = Strings.Mid(strArray(x), Len(strKey) + 2, Len(strArray(x)))
                    Exit For
                End If
            Else
                If LCase(Strings.Left(strArray(x), Len(strKey))) = LCase(strKey) Then
                    strValue = Strings.Mid(strArray(x), Len(strKey) + 2, Len(strArray(x)))
                    Exit For
                End If
            End If
        End If
    Next x
End If


errH:
If Err.Number <> 0 Then
    strValue = vbNullString
    Exit Sub
End If
End Sub

Public Sub ReadINI_toArray(strSection As String, strKeys() As String, strValues() As String)
Dim getFreeFile As Long, strTemp1 As String, strTemp2 As String, bFound As Boolean, strArray() As String
Dim x As Long, y As Long, lineFrom As Long, lineTo As Long
ReDim strArray(0) As String
getFreeFile = FreeFile

Open strFile For Input As #getFreeFile
    Do Until EOF(getFreeFile)
        Line Input #getFreeFile, strTemp1
        ReDim Preserve strArray((UBound(strArray)) + 1) As String
        strArray(UBound(strArray)) = strTemp1
    Loop
Close #getFreeFile

For x = 1 To UBound(strArray)
    If LCase(strArray(x)) = "[" & LCase(strSection) & "]" Then
        lineFrom = x + 1
        For y = (x + 1) To UBound(strArray)
            If (Trim(strArray(y)) = "") Or (Strings.Left(strArray(y), 1) = "[") Then
                lineTo = y - 1
                bFound = True
                Exit For
            End If
        Next y
        If bFound = True Then Exit For
    End If
Next x

ReDim strKeys(lineTo - lineFrom) As String
ReDim strValues(lineTo - lineFrom) As String

If lineTo - lineFrom = 0 Then Exit Sub

For x = 1 To (lineTo - lineFrom)
    For y = 1 To Len(strArray(x + lineFrom))
        If Strings.Mid(strArray(x + lineFrom), y, 1) = "=" Then
            strTemp1 = Strings.Mid(strArray(x + lineFrom), 1, y - 1)
            strTemp2 = Strings.Mid(strArray(x + lineFrom), y + 1, Len(strArray(x + lineFrom)))
            Exit For
        End If
    Next y
    strKeys(x) = strTemp1
    strValues(x) = strTemp2
Next x
End Sub

Public Sub Read_All_Sections(inputArray() As String)
Dim x As Long, getFreeFile As Long, strArray() As String
ReDim strArray(0) As String, inputArray(0) As String
getFreeFile = FreeFile

Open strFile For Input As #getFreeFile
    Do Until EOF(getFreeFile)
        ReDim Preserve strArray((UBound(strArray)) + 1) As String
        Line Input #getFreeFile, strArray(UBound(strArray))
    Loop
Close #getFreeFile

For x = 1 To UBound(strArray)
    If (Left(strArray(x), 1) = "[") And (Right(strArray(x), 1) = "]") Then
        ReDim Preserve inputArray((UBound(inputArray)) + 1) As String
        inputArray(UBound(inputArray)) = Mid(strArray(x), 2, Len(strArray(x)) - 2)
    End If
Next x
End Sub

Private Sub ReadINI_ReturnLineNumber(strSection As String, strKey As String, lLineNumber As Long, Optional MatchCase As Boolean = False)
On Error GoTo errH

Dim getFreeFile As Long, strTemp As String, bFound As Boolean, strArray() As String, lTemp As Long, x As Long
ReDim strArray(0) As String
getFreeFile = FreeFile

Open strFile For Input As #getFreeFile
    Do Until EOF(getFreeFile)
        Line Input #getFreeFile, strTemp
        If bFound = False Then
            If Strings.Left(LCase(strTemp), Len("[" & strSection & "]")) = "[" & LCase(strSection) & "]" Then
                bFound = True
                lTemp = UBound(strArray) + 2
            End If
        End If
        ReDim Preserve strArray((UBound(strArray)) + 1) As String
        strArray(UBound(strArray)) = strTemp
    Loop
Close #getFreeFile

If bFound = True Then
    If strKey = vbNullString Then
        lLineNumber = lTemp
        Exit Sub
    End If
    For x = lTemp To UBound(strArray)
        If strArray(x) = vbNullString Then
            Exit For
        Else
            If MatchCase = True Then
                If Strings.Left(strArray(x), Len(strKey)) = strKey Then
                    lLineNumber = x
                    Exit For
                End If
            Else
                If LCase(Strings.Left(strArray(x), Len(strKey))) = LCase(strKey) Then
                    lLineNumber = x
                    Exit For
                End If
            End If
        End If
    Next x
End If


errH:
If Err.Number <> 0 Then
    lLineNumber = 0
    Exit Sub
End If
End Sub

Private Function FileExists(Path As String) As Boolean
  Const NotFile = vbDirectory + vbVolume
  On Error Resume Next
  FileExists = (GetAttr(Path) And NotFile) = 0
End Function

