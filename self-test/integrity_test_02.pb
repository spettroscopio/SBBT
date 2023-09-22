EnableExplicit

Global _time_

Macro START()
_time_ = ElapsedMilliseconds()
EndMacro

Macro STOP(testname)
_time_ = ElapsedMilliseconds() - _time_
MessageRequester(testname, "Time = " + Str(_time_))
EndMacro

IncludeFile "../sbbt.pb" 

; This is a self test to verify the data integrity when the tree is being exercised.
; It just to tries to reveal bugs in the manipulation of the data structure.
; No CallDebugger statement should be executed.

START()

Global t = sbbt::New(#PB_String)

Define f, s$, file_count, count, *ll, *lr, *cur

#frandom$ = "../data/random.txt" ; file with unique words in random order
#fsorted$ = "../data/ascending.txt" ; file with unique words in ascending order

; loading data

file_count = 0

Debug "Inserting from file ..."

f = ReadFile(#PB_Any, #frandom$)

While Not Eof(f)
    file_count + 1
    s$ = ReadString(f)    
    
    If sbbt::InsertStr(t, s$) = 0
        CallDebugger ; must never happen with the test file provided 
    EndIf
    
    If file_count % 25000 = 0
        Debug "Read from file : " + file_count
    EndIf 
Wend

CloseFile(f)

Debug "Read " + file_count + " records, nodes in the tree = " + Str(sbbt::Count(t))

; enumerating 

count = 0
Debug ""
Debug "Checking cross-linkage for all nodes (manual looping) ..."

sbbt::GoFirst(t)

Repeat  
    count + 1    
    *cur = sbbt::GetCurrent(t)
    
    ; check left leaf    
    *ll = sbbt::GetLeft(t)    
    If *ll
        If sbbt::GetParentOf(t, *ll) <> *cur
            CallDebugger ; must never happen 
        EndIf 
    EndIf

    ; check right leaf    
    *lr = sbbt::GetRight(t)    
    If *lr        
        If sbbt::GetParentOf(t, *lr) <> *cur            
            CallDebugger ; must never happen 
        EndIf 
    EndIf
        
    If count % 25000 = 0
        Debug count
    EndIf 
Until sbbt::GoNext(t) = 0

Debug "Checked " + count + " nodes."


count = 0
Debug ""
Debug "Checking cross-linkage for all nodes (enumeration) ..."

sbbt::EnumStart(t)

While sbbt::EnumNext(t)
    count + 1    
    *cur = sbbt::GetCurrent(t)

    ; check left leaf    
    *ll = sbbt::GetLeft(t)    
    If *ll
        If sbbt::GetParentOf(t, *ll) <> *cur
            CallDebugger ; must never happen 
        EndIf 
    EndIf

    ; check right leaf    
    *lr = sbbt::GetRight(t)    
    If *lr        
        If sbbt::GetParentOf(t, *lr) <> *cur            
            CallDebugger ; must never happen 
        EndIf 
    EndIf
        
    If count % 25000 = 0
        Debug count
    EndIf 
Wend

sbbt::EnumEnd(t)

Debug "Checked " + count + " nodes."


; compare the sorted tree with the sorted file to see if they match

file_count = 0

Debug ""
Debug "Reading from the sorted file and comparing the sort order ..."

f = ReadFile(#PB_Any, #fsorted$)

sbbt::GoFirst(t)

While Not Eof(f)
    file_count + 1
    s$ = ReadString(f)    
    
    If sbbt::GetKeyStr(t) <> s$
        CallDebugger ; must never happen with the test file provided 
    EndIf
    
    If file_count % 25000 = 0
        Debug "Reading from file = " + file_count
    EndIf
    
    sbbt::GoNext(t)
Wend

CloseFile(f)

Debug "Compared " + file_count + " records with the sorted tree."

; search all the words from the unsorted file in the tree

file_count = 0

Debug ""
Debug "Reading from the unsorted file and searching the keys in the tree ..."

f = ReadFile(#PB_Any, #frandom$)

While Not Eof(f)
    file_count + 1
    s$ = ReadString(f)    
    
    If sbbt::SearchStr(t, s$) = 0
        CallDebugger ; must never happen with the test file provided 
    EndIf
    
    If file_count % 25000 = 0
        Debug "Reading from file = " + file_count
    EndIf   
Wend

CloseFile(f)
Debug "Searched " + file_count + " records with the sorted tree."

file_count = 0

Debug ""
Debug "Reading from the unsorted file and deleting the keys in the tree ..."

f = ReadFile(#PB_Any, #frandom$)

While Not Eof(f)
    file_count + 1
    s$ = ReadString(f)    
    
    If sbbt::DeleteStr(t, s$) = 0
        CallDebugger ; must never happen with the test file provided 
    EndIf
    
    If file_count % 25000 = 0
        Debug "Reading from file = " + file_count + ", nodes in the tree = " + sbbt::Count(t)
    EndIf   
Wend

CloseFile(f)

Debug "Deleted " + file_count + " records from the sorted tree, nodes in the tree = " + sbbt::Count(t)

sbbt::Free(t)

Debug "Self test completed, all seems fine."


; IDE Options = PureBasic 6.02 LTS (Windows - x86)
; CursorPosition = 118
; FirstLine = 106
; Optimizer
; EnableXP
; EnableUser
; CPU = 1
; CompileSourceDirectory
; EnablePurifier = 0,0,0,0
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode