// Prevents howitzers from charging suicidally into the enemy once they pack.

scope HowitzerPack initializer init
private function Conditions takes nothing returns boolean
    local integer uid = GetUnitTypeId(GetTriggerUnit())
    local integer sid = GetSpellAbilityId()
    if (uid == HOWITZER_PACKED or uid == HEAVY_HOWITZER_PACKED or uid == GAS_HOWITZER_PACKED) and (sid == 'A000' or sid == 'A00D' or sid == 'A00E') then
        call IssueImmediateOrder(GetTriggerUnit(),"stop")
    endif
    return false
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_FINISH)
    call TriggerAddCondition(t,Condition(function Conditions))
endfunction
endscope
