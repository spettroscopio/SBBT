; *********************************************************************************************************************
; shuffle.pb
; Tool to randomize or sort the datafiles for testing various data structures
; *********************************************************************************************************************

Procedure.s DetectEOL (fi, fmt)
 Protected eol$, fp, c.c
 
 fp = Loc(fi) ; handles BOM 
 
 While Not Eof(fi)    
    c = ReadCharacter(fi, fmt)
       
    If Chr(c) = Chr($0D)
        eol$ + Chr(c)
        If Not Eof(fi)
            c = ReadCharacter(fi, fmt)
            If Chr(c) = Chr($0A)
                eol$ + Chr(c) ; windows
            EndIf        
        EndIf    
        Break
    EndIf

    If Chr(c) = Chr($0A) 
        eol$ + Chr(c) ; linux, osx
        Break
    EndIf
 Wend
 
 FileSeek(fi, fp)
 
 ProcedureReturn eol$
EndProcedure

Procedure Shutdown()
CompilerIf (#PB_Compiler_Debugger = 1)
 Input()
CompilerEndIf
 CloseConsole()
 End
EndProcedure

Procedure Usage()
 PrintN("")
 PrintN("Usage:")
 PrintN("")
 PrintN("shuffle " + " ASC|DES|RND inputfile outputfile")
 PrintN("")
 PrintN("Example:")
 PrintN("")
 PrintN("shuffle" + " RND input.txt output.txt")
 PrintN("")
EndProcedure

Procedure Banner()
 PrintN("Shuffle 1.0")
 PrintN("Sorts ascending/descending/randomly a list of words from one file into another.")
 PrintN("The words must be EOL delimited (LF or CR + LF).")
EndProcedure

OpenConsole()

Banner()

;- read params

op$ = ProgramParameter(0)
fi$ = ProgramParameter(1)
fo$ = ProgramParameter(2)

op$ = UCase(op$)

If CountProgramParameters() = 0
    Usage()
    Shutdown()
EndIf

Select op$
    Case "ASC", "DES", "RND"
        ; ok
    Default        
        PrintN("Sorting option not recognized: " + op$)
        Usage()
        Shutdown()        
EndSelect

If fi$ = ""
    PrintN("Input file not specified.")
    Usage()
    Shutdown()        
EndIf
     
If fo$ = ""    
    PrintN("Destination file not specified.")
    Usage()
    Shutdown()        
EndIf

If FileSize(fi$) = -1
    PrintN("File " + fi$ + " not found.")
    Shutdown()
EndIf

fi = ReadFile(#PB_Any, fi$)

If fi = 0
    PrintN("Cannot open " + fi$ + " for reading.")
    Shutdown()
EndIf

PrintN("")

;- detect format

fmt = ReadStringFormat(fi)

If fmt = #PB_Ascii 
    PrintN("ASCII detected.")
ElseIf fmt = #PB_Unicode 
    PrintN("Unicode detected.")
ElseIf fmt = #PB_UTF8   
    PrintN("UTF8 detected.")
Else
    PrintN("Unsupported format.")
    Shutdown()
EndIf

;- detect EOL

eol$ = DetectEOL(fi, fmt)

If eol$ = ""
    PrintN("EOL not found.")
ElseIf eol$ = Chr($0A)
    PrintN("EOL: CR")
ElseIf eol$ = Chr($0D) + Chr($0A)
    PrintN("EOL: CR + LF")
EndIf

;- reading input 

NewList text$()

While Not Eof(fi)        
    l$ = ReadString(fi, fmt)
    AddElement(text$())
    text$() = l$
    lc + 1
Wend

CloseFile(fi)

PrintN(Str(lc) + " lines read.")

;- sorting / shuffling

Select op$
    Case "RND"
        PrintN("Randomizing ...")
        RandomizeList(text$())
    Case "ASC"
        PrintN("Sorting ascending ...")
        SortList(text$(), #PB_Sort_Ascending)
    Case "DES"
        PrintN("Sorting descending ...")
        SortList(text$(), #PB_Sort_Descending)
EndSelect

;- writing output

fo = CreateFile(#PB_Any, fo$)

If fo = 0
    PrintN("Cannot open " + fo$ + " for writing.")
    Shutdown()
EndIf

WriteStringFormat(fo, fmt)

ResetList(text$())

lc = 0

While NextElement(text$())
    WriteString(fo, text$() + eol$, fmt)
    lc + 1
Wend

CloseFile(fo)

PrintN(Str(lc) + " lines written.")

PrintN("Done.")

Shutdown()
; IDE Options = PureBasic 6.01 LTS (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 1
; Folding = -
; EnableXP
; EnableUser
; Executable = shuffle.exe
; CPU = 1
; CompileSourceDirectory
; EnablePurifier
; EnableExeConstant