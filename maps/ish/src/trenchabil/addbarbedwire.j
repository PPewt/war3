// Adds the "Barbed Wire" aura to completed trenches. Warcraft III has a bug
// where buildings which are still under construction provide any auras they
// have, so this prevents unbuilt trenches from slowing enemies at low cost.

library AddBarbedWire initializer init
private function Conditions takes nothing returns boolean
    if GetUnitRace(GetConstructedStructure()) == RACE_ORC then
        call UnitAddAbility(GetConstructedStructure(),'S000')
    endif
    return false
endfunction

private function AddInitialBarbedWire takes nothing returns boolean
    if GetUnitRace(GetFilterUnit()) == RACE_ORC then
        call UnitAddAbility(GetFilterUnit(),'S000')
    endif
    return false
endfunction

private function AddBarbedWireInit takes nothing returns nothing
    call GroupEnumUnitsInRect(enumGrp,bj_mapInitialPlayableArea,Filter(function AddInitialBarbedWire))
    call DestroyTimer(GetExpiredTimer())
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_CONSTRUCT_FINISH)
    call TriggerAddCondition(t,Condition(function Conditions))
endfunction

public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),0.,false,function AddBarbedWireInit)
endfunction
endlibrary
