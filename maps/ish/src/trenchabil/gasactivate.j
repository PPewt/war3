// Applies the damage effect from gas (we cannot use flamestrike directly
// because there are three different types of gas, and Warcraft doesn't
// support multiple copies of the same root ability on a unit).

scope GasActivate initializer init
private function Actions takes nothing returns nothing
    local location l = GetSpellTargetLoc()
    local unit c = GetTriggerUnit()
    local unit u = CreateUnit(GetOwningPlayer(c),GAS_DUMMY,0.,0.,0.)
    call SetUnitX(u,GetUnitX(c))
    call SetUnitY(u,GetUnitY(c))
    call UnitAddAbility(u,GetSpellAbilityId()+1)
    call IssuePointOrderLoc(u,"flamestrike",l)
    call UnitApplyTimedLife(u,'BTLF',8.)
    call SetUnitExploded(u,true)
    call RemoveLocation(l)
    set l = null
    set u = null
    set c = null
endfunction
private function Conditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit()) == GAS_HOWITZER and GetSpellAbilityId() != 'A00E'
endfunction
private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction
endscope
