EnableExplicit

IncludeFile "../sbbt.pb" 

; In this example the key is treated as a numeric value.
; The value associated to the node is used for counting of the number of times each number has been extracted.

#items = 20

Define key
Define j, value

Global t = sbbt::New(#PB_Integer)

Debug "Inserts some random numbers"

For j = 1 To #items
    key = Random(#items,1)
    Debug Str(j) + ") inserting " + Str(key)
    If sbbt::Insert (t, key, 1) = 0 ; a duplicate is not inserted
        Debug "... " + Str(key) + " is already there"
        sbbt::IncValue(t) ; but the counter is incremented           
    EndIf
Next

Debug "Unique numbers inserted = " + Str(sbbt::Count(t))

Debug "List the sorted numbers and print the number of their occurrences ..."

Debug "ascending ..."

sbbt::EnumStart(t, sbbt::#Ascending)

While sbbt::EnumNext(t)
    Debug Str (sbbt::GetKey(t)) + " x " + Str(sbbt::GetValue(t)) + " times"
Wend

sbbt::EnumEnd(t)

Debug "descending ..."

sbbt::EnumStart(t, sbbt::#Descending)

While sbbt::EnumNext(t)
    Debug Str (sbbt::GetKey(t)) + " x " + Str(sbbt::GetValue(t)) + " times"
Wend

sbbt::EnumEnd(t)

Debug "Lowest key = " + Str(sbbt::GetLowestKey(t))
Debug "Highest key = " + Str(sbbt::GetHighestKey(t))

sbbt::Free(t)
; IDE Options = PureBasic 6.02 LTS (Windows - x86)
; CursorPosition = 27
; FirstLine = 3
; EnableXP
; EnableUser
; CPU = 1
; CompileSourceDirectory
; DisablePurifier = 0,0,0,0
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode