// Logs the number of rebels that can be sent whenever more rebels are
// purchased.

scope RebelsPurchased initializer init
private function Actions takes nothing returns nothing
    local unit u = GetCapitalUnit(SCUTARI)
    call SetUnitAbilityLevel(u,SEND_SENUSSI_REBELS,GetUnitAbilityLevel(u,SEND_SENUSSI_REBELS) + 1)
    call SetUnitExploded(GetTrainedUnit(),true)
    call KillUnit(GetTrainedUnit())
    set u = null
endfunction

private function Conditions takes nothing returns boolean
    return GetUnitTypeId(GetTrainedUnit()) == SENUSSI_REGIMENT
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_TRAIN_FINISH)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction
endscope
