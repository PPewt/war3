// Allows toggling on/off of basic supply shipping.

scope GreeceSuppliesToggle initializer init
private function Conditions takes nothing returns boolean
    if GetSpellAbilityId() == SEND_GOLD_TO_GREECE then
        call FakeUpgrade_Research(GetOwningPlayer(GetTriggerUnit()),SHIPPING_TO_GREECE)
        call UnitRemoveAbility(GetTriggerUnit(),SEND_GOLD_TO_GREECE)
        call UnitAddAbility(GetTriggerUnit(),UNSEND_GOLD_TO_GREECE)
    elseif GetSpellAbilityId() == UNSEND_GOLD_TO_GREECE then
        call FakeUpgrade_Unresearch(GetOwningPlayer(GetTriggerUnit()),SHIPPING_TO_GREECE)
        call UnitRemoveAbility(GetTriggerUnit(),UNSEND_GOLD_TO_GREECE)
        call UnitAddAbility(GetTriggerUnit(),SEND_GOLD_TO_GREECE)
    endif
    return false
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function Conditions))
endfunction
endscope
