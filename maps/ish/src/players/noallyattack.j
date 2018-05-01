// Prevent griefing

scope NoAllyAttack initializer init
private function Actions takes nothing returns nothing
    call IssueImmediateOrder(GetAttacker(),"stop")
endfunction
private function Conditions takes nothing returns boolean
    return not (IsUnitEnemy(GetTriggerUnit(),GetOwningPlayer(GetAttacker())) or GetOwningPlayer(GetTriggerUnit()) == GetOwningPlayer(GetAttacker()))
endfunction
private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction
endscope
