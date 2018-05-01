// Allows Germany and Great Britain to attack neutral countries. Mostly
// implemented to simplify pathing in the Denmark and Netherlands areas.

library WarNeutrals requires BuildingAutomation, GiveNation
globals
    private integer plyr
    private boolean dW = false
    private boolean nW = false
    private trigger theTrigger
endglobals
private function KillDestructables takes nothing returns nothing
    call KillDestructable(GetEnumDestructable())
endfunction
private function PathingBlockerFilter takes nothing returns boolean
    local integer i = GetDestructableTypeId(GetFilterDestructable())
    return i == 'YTfb' or i == 'YTfc'
endfunction
private function NationAdd takes nothing returns boolean
    local unit u = GetFilterUnit()
    local real x
    local real y
    local real f
    if plyr == WEST_GERMANY_ID then
        if GetUnitTypeId(u) == INFANTRY[GREAT_BRITAIN_ID] and GetOwningPlayer(u) == Player(15) then
            set x = GetUnitX(u)
            set y = GetUnitY(u)
            set f = GetUnitFacing(u)
            call RemoveUnit(u)
            set u = CreateUnit(Player(plyr),INFANTRY[WEST_GERMANY_ID],x,y,f)
        elseif GetUnitTypeId(u) == TRENCH[GREAT_BRITAIN_ID] and GetOwningPlayer(u) == Player(15) then
            set x = GetUnitX(u)
            set y = GetUnitY(u)
            call RemoveUnit(u)
            set u = CreateUnit(Player(plyr),TRENCH[WEST_GERMANY_ID],x,y,270.)
            call IssueImmediateOrder(u,"battlestations")
        endif
    endif
    if GetOwningPlayer(u) == NEUTRAL and GetUnitTypeId(u) != FERRY_POINT then
        call SetUnitOwner(u,Player(plyr),true)
        call StartFactory(u,0)
        if GetUnitAbilityLevel(u,TOWN_INCOME_ABILITY) > 0 or GetUnitTypeId(u) == TRADE_DOCKS or GetUnitTypeId(u) == FACTORY or GetUnitTypeId(u) == BARRACKS then
            set BuildingData.get(u).owner = plyr
        endif
        if GetUnitRace(u) == RACE_ORC then
            call IssueImmediateOrder(u,"battlestations")
        endif
    endif
    set u = null
    return false
endfunction

private function Actions takes nothing returns nothing
    local integer i = 0
    local player opponent = WEST_GERMANY
    set plyr = GREAT_BRITAIN_ID
    if GetTriggerPlayer() == GREAT_BRITAIN then
        set plyr = WEST_GERMANY_ID
        set opponent = GREAT_BRITAIN
    endif
    if StringCase(GetEventPlayerChatString(),false) == "-war denmark" and not dW then
        set dW = true
        if plyr == WEST_GERMANY_ID then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"The British government, frustrated with Denmark's refusal to grant them passage, has declared war on Denmark. Consequently, |cffffcc00Denmark has asked Germany for aid against the British, and has joined the war on the side of the Central Powers.|r")
        else
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"The German General Staff, frustrated with Denmark's refusal to grant them passage, has declared war on Denmark. Consequently,|cffffcc00Denmark has asked Great Britain for aid against the Germans, and has joined the war on the side of the Entente Powers.|r")
        endif
        call EnumDestructablesInRect(gg_rct_Denmark1,Filter(function PathingBlockerFilter),function KillDestructables)
        call EnumDestructablesInRect(gg_rct_Denmark2,Filter(function PathingBlockerFilter),function KillDestructables)
        call EnumDestructablesInRect(gg_rct_Iceland,Filter(function PathingBlockerFilter),function KillDestructables)
        call EnumDestructablesInRect(gg_rct_Denmark3,Filter(function PathingBlockerFilter),function KillDestructables)
        call GroupEnumUnitsInRect(enumGrp,gg_rct_Denmark1,Filter(function NationAdd))
        call GroupEnumUnitsInRect(enumGrp,gg_rct_Denmark2,Filter(function NationAdd))
        if plyr == GREAT_BRITAIN_ID then
            set plyr = COMMONWEALTH_ID
        endif
        call GroupEnumUnitsInRect(enumGrp,gg_rct_Iceland,Filter(function NationAdd))
        if plyr == COMMONWEALTH_ID then
            set plyr = GREAT_BRITAIN_ID
        endif
        call GroupEnumUnitsInRect(enumGrp,gg_rct_Denmark3,Filter(function NationAdd))
        call DisplayRect(opponent,gg_rct_Denmark1)
        call DisplayRect(opponent,gg_rct_Denmark2)
        call DisplayRect(opponent,gg_rct_Iceland)
        call DisplayRect(opponent,gg_rct_Denmark3)
    elseif StringCase(GetEventPlayerChatString(),false) == "-war netherlands" and not nW then
        set nW = true
        if plyr == WEST_GERMANY_ID then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"The British government, frustrated with the Netherlands' refusal to grant them passage, has declared war on the Netherlands. Consequently, |cffffcc00the Netherlands has asked Germany for aid against the British, and has joined the war on the side of the Central Powers.|r")
        else
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"The German General Staff, frustrated with the Netherlands' refusal to grant them passage, has declared war on the Netherlands. Consequently, |cffffcc00the Netherlands has asked Great Britain for aid against the Germans, and has joined the war on the side of the Entente Powers.|r")
        endif
        call EnumDestructablesInRect(gg_rct_Netherlands,Filter(function PathingBlockerFilter),function KillDestructables)
        call GroupEnumUnitsInRect(enumGrp,gg_rct_Netherlands,Filter(function NationAdd))
        call DisplayRect(opponent,gg_rct_Netherlands)
    endif
endfunction

public function Initialize takes nothing returns nothing
    set theTrigger = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(theTrigger,GREAT_BRITAIN,"-war Denmark",true)
    call TriggerRegisterPlayerChatEvent(theTrigger,GREAT_BRITAIN,"-war Netherlands",true)
    call TriggerRegisterPlayerChatEvent(theTrigger,WEST_GERMANY,"-war Denmark",true)
    call TriggerRegisterPlayerChatEvent(theTrigger,WEST_GERMANY,"-war Netherlands",true)
    call TriggerAddAction(theTrigger,function Actions)
endfunction
endlibrary
