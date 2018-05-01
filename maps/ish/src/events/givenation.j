//This library provides some utility functions useful when giving units to a
// nation during various month events.

library GiveNation requires Globals, TimerUtils, BuildingAutomation, PathingBlockerManager, Players
globals
    private player plyr
    private rect rct
endglobals
private struct TTDATA
    unit u
endstruct
private function NationAdd takes nothing returns boolean
    local unit u = GetFilterUnit()
    if GetOwningPlayer(u) == NEUTRAL and GetUnitTypeId(u) != FERRY_POINT then
        call SetUnitOwner(u,plyr,true)
        call StartFactory(u,0)
        if GetUnitAbilityLevel(u,TOWN_INCOME_ABILITY) > 0 or GetUnitTypeId(u) == TRADE_DOCKS then
            set BuildingData.get(u).owner = Players_ToCountry(plyr)
        endif
    endif
    set u = null
    return false
endfunction
private function OrderTrenchGarrison_Child takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local TTDATA dat = GetTimerData(t)
    call ReleaseTimer(t)
    call IssueImmediateOrder(dat.u,"battlestations")
    set dat.u = null
    call dat.destroy()
endfunction
private function OrderTrenchGarrison takes nothing returns boolean
    local unit u = GetFilterUnit()
    local timer t
    local TTDATA dat
    if IsUnitRace(u,RACE_ORC) and GetOwningPlayer(u) == plyr then
        set dat = TTDATA.create()
        set dat.u = u
        set t = NewTimer()
        call SetTimerData(t,dat)
        call TimerStart(t,.5,false,function OrderTrenchGarrison_Child)
    endif
    set u = null
    return false
endfunction
private function PathingBlockerFilter takes nothing returns boolean
    local integer i = GetDestructableTypeId(GetFilterDestructable())
    return i == 'YTfb' or i == 'YTfc'
endfunction
private function KillDestructables takes nothing returns nothing
    call PathingBlockerManager_Save(GetEnumDestructable())
    call KillDestructable(GetEnumDestructable())
endfunction
function GivePlayerRect takes player p, rect r returns nothing
    set plyr = p
    call GroupEnumUnitsInRect(enumGrp,r,Filter(function NationAdd))
endfunction
function GarrisonTrenchesRect takes player p, rect r returns nothing
    set plyr = p
    call GroupEnumUnitsInRect(enumGrp,r,Filter(function OrderTrenchGarrison))
endfunction
function KillDestructablesRect takes rect r returns nothing
    call EnumDestructablesInRect(r,Filter(function PathingBlockerFilter),function KillDestructables)
endfunction
private function DisplayRect_Child takes nothing returns nothing
    local player p = plyr
    local rect r = rct
    local fogmodifier f = CreateFogModifierRect(p,FOG_OF_WAR_VISIBLE,r,true,false)
    call FogModifierStart(f)
    call TriggerSleepAction(5.)
    call FogModifierStop(f)
    call DestroyFogModifier(f)
    set f = null
    set r = null
endfunction
function DisplayRect takes player p, rect r returns nothing
    set plyr = p
    set rct = r
    call ExecuteFunc(SCOPE_PRIVATE+"DisplayRect_Child")
endfunction
endlibrary
