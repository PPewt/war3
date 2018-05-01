// Retires an unwanted trench. Implemented differently from retire so that the
// units in the trench are unharmed.

scope KillTrench initializer init
private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A011'
endfunction
private function Actions takes nothing returns nothing
    call ShowUnit(GetTriggerUnit(),false)
    call KillUnit(GetTriggerUnit())
endfunction
private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t, function Actions)
endfunction
endscope
