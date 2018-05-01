// Handle various generic setup tasks for factories

scope InitializeFactory initializer init
private struct Data
    unit u
endstruct

private function BarracksStart takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local Data dat = GetTimerData(t)
    call ReleaseTimer(t)
    call StartFactory(dat.u,0)
    call dat.destroy()
    set t = null
endfunction

private function FactoryBuildFinish takes nothing returns boolean
    local unit u = GetTriggerUnit()
    local Data dat
    local timer t
    if GetUnitTypeId(u) == BARRACKS or GetUnitTypeId(u) == FACTORY then
        call BuildingData.get(u).setConstructing(false)
        if GetUnitTypeId(u) == BARRACKS then
            set t = NewTimer()
            set dat = Data.create()
            set dat.u = u
            call SetTimerData(t,dat)
            call TimerStart(t,0.,false,function BarracksStart)
            set t = null
        endif
    endif
    set u = null
    return false
endfunction

private function FactoryBuildStart takes nothing returns boolean
    local unit u = GetTriggerUnit()
    if GetUnitTypeId(u) == BARRACKS or GetUnitTypeId(u) == FACTORY then
        call BuildingData.get(u).setConstructing(true)
    endif
    set u = null
    return false
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_CONSTRUCT_START)
    call TriggerAddCondition(t, Condition(function FactoryBuildStart))
    
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH)
    call TriggerAddCondition(t, Condition(function FactoryBuildFinish))
endfunction
endscope
