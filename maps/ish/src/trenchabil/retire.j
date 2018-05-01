// Kills unwanted units

scope Retire initializer init
private function Actions takes nothing returns nothing
    call ShowUnit(GetTriggerUnit(),false)
    call KillUnit(GetTriggerUnit())
endfunction
private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00T'
endfunction
private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction
endscope
