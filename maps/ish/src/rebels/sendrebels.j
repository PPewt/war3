// Spawns purchased rebels on the bottom of the map where requested

scope SendRebels initializer init
private function SpawnRegiments takes nothing returns nothing
    local integer regiments = GetUnitAbilityLevel(GetTriggerUnit(),GetSpellAbilityId())-1
    local real x = GetSpellTargetX()
    local real y = GetSpellTargetY()
    local integer i
    local player p = GetOwningPlayer(GetTriggerUnit())
    if regiments > 3 then
        set regiments = 3
    endif
    call SetUnitAbilityLevel(GetTriggerUnit(),GetSpellAbilityId(),GetUnitAbilityLevel(GetTriggerUnit(),GetSpellAbilityId()) - regiments)
    loop
        exitwhen regiments == 0
        call CreateUnit(p,INFANTRY[OTTOMAN_EMPIRE_ID],x,y,90.)
        call CreateUnit(p,INFANTRY[OTTOMAN_EMPIRE_ID],x,y,90.)
        call CreateUnit(p,INFANTRY[OTTOMAN_EMPIRE_ID],x,y,90.)
        call CreateUnit(p,INFANTRY[OTTOMAN_EMPIRE_ID],x,y,90.)
        call CreateUnit(p,INFANTRY[OTTOMAN_EMPIRE_ID],x,y,90.)
        call CreateUnit(p,INFANTRY[OTTOMAN_EMPIRE_ID],x,y,90.)
        call CreateUnit(p,SPAHI,x,y,90.)
        call CreateUnit(p,SPAHI,x,y,90.)
        call CreateUnit(p,SPAHI,x,y,90.)
        set regiments = regiments - 1
    endloop
endfunction

private function EnsureValidSpot takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer level = GetUnitAbilityLevel(u,GetSpellAbilityId())
    local boolean stop = false
    if not RectContainsCoords(gg_rct_SenussiSpawn,GetSpellTargetX(),GetSpellTargetY()) then
        call SimError(GetOwningPlayer(u),"Must target the south part of the African desert")
        set stop = true
    elseif level == 1 then
        call SimError(GetOwningPlayer(u),"You don't have any rebels available to send")
        set stop = true
    endif
    
    if stop then
        call IssueImmediateOrder(u,"stop")
        call UnitRemoveAbility(u,SEND_SENUSSI_REBELS)
        call UnitAddAbility(u,SEND_SENUSSI_REBELS)
        call SetUnitAbilityLevel(u,SEND_SENUSSI_REBELS,level)
    endif
endfunction

private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == SEND_SENUSSI_REBELS
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function EnsureValidSpot)
    
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function SpawnRegiments)
endfunction
endscope
