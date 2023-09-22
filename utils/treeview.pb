; This is a simple tree viewer I've used for debugging the SBBT module.
; Should be only used with a small amount of nodes (less then 100) since the screen space required to show a larger tree 
; may be too much.

#tv_draw_offset_y = 50
#tv_draw_margins = 100

Procedure DrawNode (t, n, w, *x.Integer, *y.Integer, level)  
 ; draw a single node
 
 Protected kw, kh, offx, key$, iw, i$, top
 
 If n    
    If sbbt::GetKeyType(t) = #PB_Integer
        key$ = Str(sbbt::GetKeyOf(t, n))
    Else
        key$ = sbbt::GetKeyStrOf(t, n)
    EndIf
    
    top = sbbt::GetParentOf(t, n)
    
    If top
        If sbbt::GetKeyType(t) = #PB_Integer
            i$ = "(" + Str(sbbt::GetKeyOf(t, top)) + ")"
        Else
            i$ = "(" + sbbt::GetKeyStrOf(t, top) + ")"
        EndIf
        
    Else
        i$ = "(ROOT)"
    EndIf
    
    kw = TextWidth(key$)
    kh = TextHeight(key$) + 1

    iw = TextWidth(i$)
    
    offx = w  / 1 << (level+1) 
    
    DrawText(*x\i - kw/2, *y\i, key$, #Blue, #White)
    
    Circle(*x\i, *y\i + kh, 2, #Black)
    
    ; DrawText(*x\i - iw/2, *y\i + kh + 3, i$, #Red, #White)
    
    If (sbbt::GetRightOf(t, n))
        Line(*x\i, *y\i + kh, offx, #tv_draw_offset_y - kh - 5, #Black)
    EndIf
    
    If (sbbt::GetLeftOf(t, n))
        Line(*x\i, *y\i + kh, - offx, #tv_draw_offset_y - kh - 5, #Black)
    EndIf    
 EndIf 
EndProcedure

Procedure DrawTree (t, n, w, *x.Integer, *y.Integer, level)
 ; navigate the tree
 
 Protected offx 
 
 If n        
    level + 1    
    offx = w  / 1 << level     
    *y\i + #tv_draw_offset_y    
    
    *x\i - offx
    DrawTree (t, sbbt::GetLeftOf(t, n), w, *x, *y, level)
    *x\i + offx
    
    level - 1        
    DrawNode (t, n, w, *x, *y, level)
    level + 1
    
    *x\i + offx
    DrawTree (t, sbbt::GetRightOf(t, n), w, *x, *y, level)      
    *x\i - offx
 
    *y\i - #tv_draw_offset_y       
 EndIf 
EndProcedure
 
Procedure TreeView (t, w, h)
 Protected iEvent, flgExit, x, y
 Protected iImageTree
 Protected nWin, nBtnClose, nImageTree, nFont
 
 flgExit = #False
 
 iImageTree = CreateImage(#PB_Any, w, h)
 
 If iImageTree  
    nFont = LoadFont(#PB_Any, "Arial", 8)
    
    x = w/2 : y = 10 - #tv_draw_offset_y
    
    StartDrawing(ImageOutput(iImageTree))
     DrawingFont(FontID(nFont))
     Box(0,0,w,h,#White)
     DrawTree (t, sbbt::GetRoot(t), w - #tv_draw_margins, @x, @y, 1)
    StopDrawing()
    
    
    nWin = OpenWindow(#PB_Any, 10, 10, w, h + 70, "Tree Viewer", #PB_Window_SystemMenu)  
    
    If nWin
        nBtnClose = ButtonGadget(#PB_Any, w/2 - 50, h + 35, 100, 30, "Close")               
        
        nImageTree = ImageGadget(#PB_Any, 0, 0, w, h, ImageID(iImageTree))
                   
        Repeat 
            iEvent = WaitWindowEvent()
             
            Select iEvent
                 Case #PB_Event_Gadget
                     Select EventGadget()
                        Case nBtnClose
                            flgExit = #True
                     EndSelect
             EndSelect        
        Until iEvent = #PB_Event_CloseWindow Or flgExit
        
        FreeImage(iImageTree)
        FreeFont(nFont)
        CloseWindow(nWin)    
    EndIf
 EndIf  
EndProcedure

; IDE Options = PureBasic 6.02 LTS (Windows - x86)
; CursorPosition = 19
; FirstLine = 15
; EnableXP
; EnableUser
; CPU = 1
; CompileSourceDirectory
; EnablePurifier
; EnableBuildCount = 0
; EnableExeConstant