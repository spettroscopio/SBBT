EnableExplicit

; ASCENDING ORDERED INPUT

IncludeFile "../SBBT.pb" 

IncludeFile "../utils/treeview.pb" ; simple tree viewer 

; In this example is possible to see how even in the worst case scenario of an ordered input sequence 
; the tree is kept at low height and it does not degenerate into a list as it would happen with 
; a normal binary tree.

#nodes = 50

Define j, k, count
Define pad = Len(Str(#nodes))

; Prepare an ordered array of all the numbers between 1 and #nodes 
Dim arr(#nodes)
For j = 1 To #nodes : arr(j) = j : Next 

; as strings

Define key$

Global t = sbbt::New(#PB_String)

For j = 1 To #nodes
    key$ = RSet(Str(arr(j)), pad, "0")        
    sbbt::InsertStr(t, key$)    
    Debug key$
Next

Debug "Tree height = " + sbbt::GetHeight(t)
Debug "Tree nodes = " + sbbt::Count(t)

TreeView(t, 1200, 600)    

; as numbers

Define key

Global t = sbbt::New(#PB_Integer)

For j = 1 To #nodes
    key = arr(j)
    sbbt::Insert(t, key)
    Debug key
Next

Debug "Tree height = " + sbbt::GetHeight(t)
Debug "Tree nodes = " + sbbt::Count(t)

TreeView(t, 1200, 600)    

; IDE Options = PureBasic 6.01 LTS (Windows - x86)
; CursorPosition = 33
; FirstLine = 6
; EnableXP
; EnableUser
; CPU = 1
; CompileSourceDirectory
; DisablePurifier = 0,0,0,0
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode