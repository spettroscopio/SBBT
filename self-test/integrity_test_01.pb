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
; It just tries to reveal bugs in the manipulation of the data structure.
; No CallDebugger statement should be executed.

START()

#nodes = 100000

Macro PadKey(n)
 RSet(Str(n),pad,"0")        
EndMacro

Define key$, half$
Define j, count, value
Define pad = Len(Str(#nodes))

; Prepare an array of all the numbers between 1 and #nodes randomly ordered.
Dim arr(#nodes)
For j = 1 To #nodes : arr(j) = j : Next : RandomizeArray(arr(), 1, #nodes)

; creates the tree
Global t = sbbt::New(#PB_String)

; loading data
Debug "Inserting " + #nodes + " nodes ..."

For j = 1 To #nodes 
    key$ = PadKey(arr(j))
    If sbbt::InsertStr(t, key$, Val(key$)) = 0    
        ; all the keys are unique, so this must never happen
        CallDebugger 
    EndIf    
Next

Debug "Nodes in the tree = " + sbbt::Count(t)
If sbbt::Count(t) <> #nodes
    ; the two must match, so this must never happen
    CallDebugger 
EndIf

Debug "Tree height = " + sbbt::GetHeight(t)

Debug "Searching nodes ..."
count = 0
For j = 1 To #nodes 
    key$ = PadKey(j)
    If sbbt::SearchStr(t, key$, @value) = 0
        ; all the nodes must be found, so this must never happen
        CallDebugger 
    EndIf
    If j <> value 
        ; the val of the key has been stored in the node, they must always match
        CallDebugger
    EndIf
    count + 1
Next
Debug Str(count) + " nodes found"
Debug "Nodes in the tree = " + Str(sbbt::Count(t))


Debug "Enumerate all nodes ascending ..."
count = 0
sbbt::EnumStart(t)
While sbbt::EnumNext(t)
    count + 1    
    If sbbt::GetValue(t) <> count
        ; the val of the key has been stored in the node, they must always match
        CallDebugger    
    EndIf    
Wend
sbbt::EnumEnd(t)
Debug Str(count) + " nodes enumerated"

Debug "Enumerate all nodes descending ..."
count = 0
sbbt::EnumStart(t, sbbt::#EnumDescending)
While sbbt::EnumNext(t)           
    If sbbt::GetValue(t) <> #nodes - count
        ; the val of the key has been stored in the node, they must always match
        CallDebugger    
    EndIf
    count + 1
Wend
sbbt::EnumEnd(t)
Debug Str(count) + " nodes enumerated"

; search for the key in the middle
half$ = PadKey(#nodes / 2)
If sbbt::SearchStr(t, half$)
    Debug "Middle key " + Chr(34) + half$ + Chr(34) + " node found"
Else 
    ; it must be found
    CallDebugger
EndIf

Debug "Navigate through the next three nodes ..."
For j = 1 To 3
    If sbbt::GoNext(t)
        Debug "key = " + sbbt::GetKeyStr(t)        
    EndIf
    If Val(sbbt::GetKeyStr(t)) <> (#nodes / 2) + j
        CallDebugger
    EndIf
Next

Debug "Go to the first node ..."
If sbbt::GoFirst(t)
    Debug "key = " + sbbt::GetKeyStr(t)
Else 
    ; it must be found
    CallDebugger
EndIf

Debug "Navigate through the next three nodes ..."
For j = 1 To 3
    If sbbt::GoNext(t)        
        Debug "key = " + sbbt::GetKeyStr(t)
    EndIf
    If Val(sbbt::GetKeyStr(t)) <>  j + 1
        CallDebugger
    EndIf
Next

Debug "Go to the last node ..."
If sbbt::GoLast(t)
    Debug "key = " + sbbt::GetKeyStr(t)
Else 
    ; it must be found
    CallDebugger
EndIf

Debug "Navigate through the previous three nodes ..."
For j = 1 To 3
    If sbbt::GoPrev(t)
        Debug "key = " + sbbt::GetKeyStr(t)
    EndIf
    If Val(sbbt::GetKeyStr(t)) <>  #nodes - j
        CallDebugger
    EndIf
Next

Debug "Deleting half of the nodes ..."
count = 0
For j = 1 To #nodes / 2
    key$ = PadKey(j)
    If sbbt::DeleteStr(t, key$, @value) = 0    
        ; all keys must be found, this must never happen
        CallDebugger 
    EndIf
    If j <> value 
        ; the val of the key has been stored in the node, they must always match
        CallDebugger
    EndIf
    count + 1
Next

Debug Str(count) + " nodes deleted"
Debug "Nodes in the tree = " + sbbt::Count(t)

Debug "Go to the first node ..."
If sbbt::GoFirst(t)
    Debug "key = " + sbbt::GetKeyStr(t)
Else 
    ; it must be found
    CallDebugger
EndIf

Debug "Navigate through the next three nodes ..."
For j = 1 To 3
    If sbbt::GoNext(t)        
        Debug "key = " + sbbt::GetKeyStr(t)
    EndIf
    If Val(sbbt::GetKeyStr(t)) <>  (#nodes / 2) + 1 + j
        CallDebugger
    EndIf    
Next

Debug "Go to the last node ..."
If sbbt::GoLast(t)
    Debug "key = " + sbbt::GetKeyStr(t)
Else 
    ; it must be found
    CallDebugger
EndIf

Debug "Navigate through the previous three nodes ..."
For j = 1 To 3
    If sbbt::GoPrev(t)
        Debug "key = " + sbbt::GetKeyStr(t)
    EndIf
    If Val(sbbt::GetKeyStr(t)) <>  #nodes - j
        CallDebugger
    EndIf        
Next

Debug "Go to the first node ..."
If sbbt::GoFirst(t)
    Debug "key = " + sbbt::GetKeyStr(t)
Else 
    ; it must be found
    CallDebugger
EndIf

Debug "Manually navigate through all the subsequent nodes ..."
count = 0
While sbbt::GoNext(t)
    If sbbt::GetValue(t) <> Val(sbbt::GetKeyStr(t))
        ; the val of the key has been stored in the node, they must always match
        CallDebugger    
    EndIf
    count + 1
Wend
Debug Str(count) + " nodes walked"

sbbt::Free(t)

Debug "Self test completed, all seems fine."

STOP ("SELF TEST")
; IDE Options = PureBasic 6.01 LTS (Windows - x86)
; CursorPosition = 229
; FirstLine = 182
; Folding = -
; Optimizer
; EnableXP
; EnableUser
; Executable = PureBasic.exe
; CPU = 1
; CompileSourceDirectory
; Debugger = IDE
; DisablePurifier = 0,0,0,0
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode