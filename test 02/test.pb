EnableExplicit

; RANDOMLY ORDERED INPUT

IncludeFile "../sbbt.pb" 

IncludeFile "../utils/treeview.pb" ; simple tree viewer 

; In this example is possible to see how the tree is built differently depending on the randomly chosen order 
; of insertion of the keys, but it's always kept at its minimun height.

#nodes = 50

Define key$
Define j, k, count
Define pad = Len(Str(#nodes))

; Prepare an array of all the numbers between 1 and #nodes
Dim arr(#nodes)
For j = 1 To #nodes : arr(j) = j : Next

; And randomize its contents
RandomizeArray(arr(), 1, #nodes)

Global t = sbbt::New(#PB_String)

For j = 1 To #nodes
    key$ = RSet(Str(arr(j)), pad, "0")        
    sbbt::InsertStr(t, key$)
    Debug key$
Next

Debug "Tree height = " + sbbt::GetHeight(t)
Debug "Tree nodes = " + sbbt::Count(t)

TreeView(t, 1200, 600)

sbbt::Free(t)
; IDE Options = PureBasic 6.01 LTS (Windows - x86)
; CursorPosition = 37
; EnableXP
; EnableUser
; CPU = 1
; CompileSourceDirectory
; DisablePurifier = 0,0,0,0
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode