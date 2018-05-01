// Rebuilds a unit every time it finishes if necessary.

scope AutoBuildUnits initializer init
private struct Data
    unit u
    integer id = 0
endstruct

private function RebuildUnit takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local Data dat = GetTimerData(t)
    call ReleaseTimer(t)
    call BuildingData.get(dat.u).buildUnit(dat.id)
    set dat.u = null
    call dat.destroy()
    set t = null
endfunction
private function Actions takes nothing returns nothing
    local timer t = NewTimer()
    local Data dat = Data.create()
    local unit u = GetTrainedUnit()
    set dat.u = GetTriggerUnit()
    set dat.id = GetUnitTypeId(u)
    call SetTimerData(t,dat)
    call TimerStart(t,0.,false,function RebuildUnit)
    if dat.id == FREE_MORTAR then
        call IssueRallyPointOrder(CreateUnit(GetOwningPlayer(u),MORTAR,GetUnitX(u),GetUnitY(u),GetUnitFacing(u)),dat.u)
        call KillUnit(u)
    endif
    set u = null
endfunction

private function Conditions takes nothing returns boolean
    local integer id = GetUnitTypeId(GetTrainedUnit())
    local integer i = 0
    loop
        exitwhen i > 11
        if id == INFANTRY[i] then
            return true
        endif
        set i = i + 1
    endloop
    return id == FREE_MORTAR or id == RAW_MATERIALS
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_TRAIN_FINISH)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction
endscope
