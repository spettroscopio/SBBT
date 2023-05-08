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

; For this one is useful to monitor the memory usage consumption to verify it does not grow.

START()

#nodes = 100000
#cycles = 3

Macro PadKey(n)
 RSet(Str(n),pad,"0")        
EndMacro

Define key$
Define j, k, count
Define pad = Len(Str(#nodes))

; Prepare an array of all the numbers between 1 and #nodes randomly ordered.
Dim arr(#nodes)
For j = 1 To #nodes : arr(j) = j : Next : RandomizeArray(arr(), 1, #nodes)

; creates the tree
Global t = sbbt::New(#PB_String)

For k = 1 To #cycles 
    ; loading data
    Debug "Inserting " + #nodes + " nodes ..."
    
    For j = 1 To #nodes 
        key$ = PadKey(arr(j))
        If sbbt::InsertStr(t, key$) = 0    
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
    
    Debug "Deleting nodes ..."
    count = 0
    For j = 1 To #nodes 
        key$ = PadKey(j)
        If sbbt::DeleteStr(t, key$) = 0
            ; all the nodes must be found, so this must never happen
            CallDebugger 
        EndIf
        count + 1
    Next
    Debug Str(count) + " nodes deleted"
    Debug "Nodes in the tree = " + Str(sbbt::Count(t))
        
    Debug "Pause ... check if the memory has been released."
    MessageRequester("PAUSE", "Click OK to continue")
Next

sbbt::Free(t)

Debug "Self test completed, all seems fine."

STOP ("SELF TEST")
; IDE Options = PureBasic 6.01 LTS (Windows - x86)
; CursorPosition = 36
; FirstLine = 32
; Folding = -
; Optimizer
; EnableXP
; EnableUser
; CPU = 1
; CompileSourceDirectory
; EnablePurifier = 0,0,0,0
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode