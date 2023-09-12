EnableExplicit

; Example of EnumStartFrom(), a variant of EnumStart()

IncludeFile "../sbbt.pb" 

IncludeFile "../utils/treeview.pb" ; simple tree viewer 

; In this example we look for a node, and if we found it we enumerate the tree from that specific node
; in ascending and the descending order using EnumStartFrom()

Define nodes, n, j, k

DataSection
 l_data:
 Data.i 26
 Data.i -15, -14, -12, -5, -2, -1, 2, 3, 5, 10, 11, 12, 15, 20, 21, 22, 23, 25, 30, 31, 33, 40, 41, 43, 44, 45
EndDataSection

Read nodes : Dim arr(nodes) 

RandomSeed(1) ; fixed number to be able to replicate the dataset in case of bugs

For j = 1 To nodes : Read k : arr(j) = k : Debug k : Next 
RandomizeArray(arr(), 1, nodes)

Define key

Global t = sbbt::New(#PB_Integer)

For j = 1 To nodes
    key = arr(j)
    sbbt::Insert(t, key)    
Next

Debug "Tree height = " + sbbt::GetHeight(t)
Debug "Tree nodes = " + sbbt::Count(t)
Debug "I'm going to look for the node with key = 30"

TreeView(t, 1200, 600)    


If sbbt::Search(t, 30) ; the node I've been looking for 

    n = sbbt::GetCurrent(t)
    
    Debug "The starting node I've just looked for is: " + sbbt::GetKey(t)
    
    Debug "ascending ..."
    
    sbbt::EnumStartFrom(t, n, sbbt::#Ascending)
    
    While sbbt::EnumNext(t)
        Debug sbbt::GetKey(t)
    Wend
    
    sbbt::EnumEnd(t)
    
    Debug "descending ..."
    
    sbbt::EnumStartFrom(t, n, sbbt::#Descending)
    
    While sbbt::EnumNext(t)
        Debug sbbt::GetKey(t)
    Wend
    
    sbbt::EnumEnd(t)
    
EndIf

sbbt::Free(t)
; IDE Options = PureBasic 6.02 LTS (Windows - x86)
; CursorPosition = 60
; FirstLine = 21
; EnableXP
; EnableUser
; CPU = 1
; CompileSourceDirectory
; DisablePurifier = 0,0,0,0
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode