// Gives France gold when the US buys a tank, and Germany gold when Austria
// buys a tank.

scope SellTank initializer init
private function Conditions takes nothing returns boolean
    local unit u = GetTrainedUnit()
    
    //American
    if GetUnitTypeId(u) == RENAULT_AMERICAN then
        call SetPlayerState(Player(1),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(1),PLAYER_STATE_RESOURCE_GOLD)+AMERICAN_TANK_WORTH)
        call DisplayIncomeTextTagSuffix(GetCapitalUnit(PARIS),AMERICAN_TANK_WORTH,"tank sold")
        
    //Austrian
    elseif GetUnitTypeId(u) == A7V_CENTRALS then
        call SetPlayerState(Player(10),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(10),PLAYER_STATE_RESOURCE_GOLD)+CENTRAL_TANK_WORTH/2)
        call SetPlayerState(Player(11),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(11),PLAYER_STATE_RESOURCE_GOLD)+CENTRAL_TANK_WORTH/2)
        call DisplayIncomeTextTagSuffix(GetCapitalUnit(BERLIN),CENTRAL_TANK_WORTH/2,"tank sold")
        call DisplayIncomeTextTagSuffix(GetCapitalUnit(MUNICH),CENTRAL_TANK_WORTH/2,"tank sold")
    endif
    set u = null
    return false
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_TRAIN_FINISH)
    call TriggerAddCondition(t,Condition(function Conditions))
endfunction
endscope
