// Allows transport ships to turn on a teleport between two sides of certain
// narrow channels to drastically simplify transportation over certain
// bodies of water, and reduce micromanagement necessary.

library FerrySystem initializer init requires TimerUtils
globals
    private hashtable ferryHash = InitHashtable()
    private unit pass
endglobals
private struct TDATA
    unit tm
endstruct
private function OrdActions_Child takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local TDATA dat = GetTimerData(t)
    call IssueImmediateOrder(dat.tm,"stop")
    call dat.destroy()
    call ReleaseTimer(t)
endfunction
private function OrdActions takes nothing returns nothing
    local timer t = NewTimer()
    local TDATA dat = TDATA.create()
    set dat.tm = GetTriggerUnit()
    call SetTimerData(t,dat)
    call TimerStart(t,0,false,function OrdActions_Child)
endfunction
private function OrdConditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit()) == TRANSPORT_SHIP and GetIssuedOrderId() != 852600 and GetIssuedOrderId() != 851972 and LoadUnitHandle(ferryHash,GetHandleId(GetTriggerUnit()),0) != null
endfunction
private function CastActions takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local unit ferry = GetSpellTargetUnit()
    local unit ferry2 = LoadUnitHandle(ferryHash,GetHandleId(ferry),1)
    call WaygateActivate(ferry,true)
    call WaygateActivate(ferry2,true)
    call SetUnitOwner(ferry,GetOwningPlayer(u),true)
    call SetUnitOwner(ferry2,GetOwningPlayer(u),true)
    call UnitRemoveAbility(u,'A00U')
    call UnitAddAbility(u,'A00V')
    call SaveUnitHandle(ferryHash,GetHandleId(u),0,ferry)
    set u = null
    set ferry = null
    set ferry2 = null
endfunction
private function UncastActions takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local unit ferry = LoadUnitHandle(ferryHash,GetHandleId(u),0)
    local unit ferry2 = LoadUnitHandle(ferryHash,GetHandleId(ferry),1)
    call SetUnitOwner(ferry,NEUTRAL,true)
    call SetUnitOwner(ferry2,NEUTRAL,true)
    call WaygateActivate(ferry,false)
    call WaygateActivate(ferry2,false)
    call UnitRemoveAbility(u,'A00V')
    call UnitAddAbility(u,'A00U')
    call FlushChildHashtable(ferryHash,GetHandleId(u))
    set u = null
    set ferry = null
    set ferry2 = null
endfunction
private function CastConditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00U' and GetOwningPlayer(GetSpellTargetUnit()) == NEUTRAL and GetUnitTypeId(GetSpellTargetUnit()) == FERRY_POINT
endfunction
private function UncastConditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00V'
endfunction
private function DeathActions takes nothing returns nothing
    local unit u = LoadUnitHandle(ferryHash,GetHandleId(GetTriggerUnit()),0)
    local unit u2
    if u != null then
        set u2 = LoadUnitHandle(ferryHash,GetHandleId(u),1)
        call SetUnitOwner(u2,NEUTRAL,true)
        call SetUnitOwner(u,NEUTRAL,true)
        call WaygateActivate(u2,false)
        call WaygateActivate(u,false)
        call FlushChildHashtable(ferryHash,GetHandleId(GetTriggerUnit()))
        set u = null
        set u2 = null
    endif
endfunction
private function DeathConditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit()) == TRANSPORT_SHIP
endfunction

private function FindPartner takes nothing returns boolean
    return GetUnitTypeId(GetFilterUnit()) == FERRY_POINT and GetFilterUnit() != pass
endfunction

private function InitializeAutoFerryPointsFilter takes nothing returns boolean
    local unit u = GetFilterUnit()
    local unit u2
    set pass = u
    call GroupEnumUnitsInRange(enumGrp2,GetUnitX(u),GetUnitY(u),1500.,Filter(function FindPartner))
    set pass = null
    set u2 = FirstOfGroup(enumGrp2)
    call WaygateSetDestination(u,GetUnitX(u2),GetUnitY(u2))
    call WaygateActivate(u,false)
    call SaveUnitHandle(ferryHash,GetHandleId(u),1,u2)
    set u = null
    set u2 = null
    return false
endfunction

private function InitializeAutoFerryPoints takes nothing returns nothing
    call GroupEnumUnitsOfType(enumGrp,"custom_h02J",Filter(function InitializeAutoFerryPointsFilter))
    call DestroyTimer(GetExpiredTimer())
endfunction

public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),1.,false,function InitializeAutoFerryPoints)
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerAddCondition(t,Condition(function OrdConditions))
    call TriggerAddAction(t,function OrdActions)
    
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function CastConditions))
    call TriggerAddAction(t,function CastActions)
    
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function UncastConditions))
    call TriggerAddAction(t,function UncastActions)
    
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(t,Condition(function DeathConditions))
    call TriggerAddAction(t,function DeathActions)
endfunction
endlibrary
