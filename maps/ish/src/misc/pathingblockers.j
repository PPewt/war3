// Remembers where all pathing blockers were at the start of the game in case
// we need to replace them later.

library PathingBlockerManager
globals
    private hashtable pbHash = InitHashtable()
    private integer counter = 0
endglobals

public function Save takes destructable d returns nothing
    call SaveInteger(pbHash,counter,0,GetDestructableTypeId(d))
    call SaveReal(pbHash,counter,1,GetWidgetX(d))
    call SaveReal(pbHash,counter,2,GetWidgetY(d))
    set counter = counter + 1
endfunction

public function Load takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= counter
        call CreateDestructable(LoadInteger(pbHash,i,0),LoadReal(pbHash,i,1),LoadReal(pbHash,i,2),0.,1.,1)
        set i = i + 1
    endloop
    call FlushParentHashtable(pbHash)
    set counter = 0
endfunction
endlibrary
