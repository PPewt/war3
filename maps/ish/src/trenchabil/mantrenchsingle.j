// Simulates the "Load Burrow" ability used to load infantry into trenches,
// but only summons one infantry per trench rather than two.

library ManTrenchSingle initializer init requires TrenchSystem
globals
    private integer infId
    private player p
endglobals
private function CallFilter takes nothing returns boolean
    return GetUnitTypeId(GetFilterUnit()) == infId and GetOwningPlayer(GetFilterUnit()) == p and GetUnitCurrentOrder(GetFilterUnit()) != 852043
endfunction
private function Actions takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer id = GetUnitTypeId(u)
    local integer i = 0
    loop
        exitwhen i > 11
        if id == TRENCH[i] or id == FORTIFIED_TRENCH[i] then
            set infId = INFANTRY[i]
            exitwhen true
        endif
        set i = i + 1
    endloop
    set p = GetOwningPlayer(u)
    call GroupEnumUnitsInRange(enumGrp,GetUnitX(u),GetUnitY(u),1000.,Filter(function CallFilter))
    if FirstOfGroup(enumGrp) != null then
        call IssueTargetOrder(FirstOfGroup(enumGrp),"board",u)
    else
        call SimError(GetOwningPlayer(u),"No available regiments are nearby.")
    endif
    set u = null
endfunction
private function Actions2 takes nothing returns nothing
    local Trench dat = GetUnitUserData(GetTransportUnit())
    local unit u = GetTriggerUnit()
    if dat.first == null then
        set dat.first = u
    else
        set dat.second = u
    endif
    call SetUnitUserData(u,dat)
    set u = null
endfunction
private function Actions3 takes nothing returns nothing
    call Trench.create(GetTriggerUnit())
endfunction
private function Actions4 takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local Trench dat = GetUnitUserData(u)
    set dat.trench = null
    if dat.first != null then
        call SetUnitUserData(dat.first,0)
    endif
    if dat.second != null then
        call SetUnitUserData(dat.second,0)
    endif
    set dat.first = null
    set dat.second = null
    call dat.destroy()
    set u = null
endfunction
private function Actions5 takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local Trench dat = GetUnitUserData(u)
    if u == dat.first then
        set dat.first = null
    elseif u == dat.second then
        set dat.second = null
    endif
    call SetUnitUserData(u,0)
    set u = null
endfunction
private function Conditions takes nothing returns boolean
    local Trench dat = GetUnitUserData(GetTriggerUnit())
    return GetSpellAbilityId() == 'A00W' and (dat.first == null or dat.second == null)
endfunction
private function Conditions2 takes nothing returns boolean
    return GetUnitRace(GetTransportUnit()) == RACE_ORC
endfunction
private function Conditions3 takes nothing returns boolean
    return GetUnitRace(GetTriggerUnit()) == RACE_ORC
endfunction
private function Conditions4 takes nothing returns boolean
    local integer i = 0
    loop
        exitwhen i > 11
        if GetUnitTypeId(GetTriggerUnit()) == INFANTRY[i] then
            return GetUnitUserData(GetTriggerUnit()) > 0 and GetIssuedOrderId() == 851972
        endif
        set i = i + 1
    endloop
    return false
endfunction
private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_LOADED)
    call TriggerAddCondition(t,Condition(function Conditions2))
    call TriggerAddAction(t,function Actions2)
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_CONSTRUCT_FINISH)
    call TriggerAddCondition(t,Condition(function Conditions3))
    call TriggerAddAction(t,function Actions3)
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(t,Condition(function Conditions3))
    call TriggerAddAction(t,function Actions4)
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerAddCondition(t,Condition(function Conditions4))
    call TriggerAddAction(t,function Actions5)
endfunction
endlibrary
