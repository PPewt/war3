//! runtextmacro EventBefore("March","1916")
    //Serbia gets Portugal
    local unit u = GetCapitalUnit(BELGRADE)
    local integer i = 0
    if GetOwningPlayer(u) != SERBIA then
        set u = GetCapitalUnit(DURRES)
    endif
    call KillDestructablesRect(gg_rct_BalkanPortugal)
    call GivePlayerRect(SERBIA,gg_rct_BalkanPortugal)
    call DisplayRect(BULGARIA,gg_rct_BalkanPortugal)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00March 1916|r - After Portugal, at Britain's request, refuses to let German ships leave Portuguese ports, Germany declares war on Portugal, and with it, the Central Powers. |cffffcc00Portugal joins the war on the side of the Entente Powers.|r")

    if GetOwningPlayer(u) == SERBIA then
        loop
            exitwhen i > 11
            call CreateUnit(SERBIA,INFANTRY[SERBIA_ID],GetUnitX(u),GetUnitY(u),270.)
            set i = i + 1
        endloop
        call CreateUnit(SERBIA,HOWITZER_PACKED,GetUnitX(u),GetUnitY(u),270.)
        call CreateUnit(SERBIA,HOWITZER_PACKED,GetUnitX(u),GetUnitY(u),270.)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"Portugal has sent a detachment of units to aid in the defence of Serbia.")
    endif
    set u = null
//! runtextmacro EventAfter()
