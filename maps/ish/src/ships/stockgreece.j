// Stocks shipments to Greece whenever the placeholder units are trained

scope StockGreeceShipment initializer init
private function Actions takes nothing returns nothing
    local integer i = GetUnitTypeId(GetTrainedUnit())
    if i == AMERICAN_TANK_SQUADRON then
        call DisplayIncomeTextTagSuffix(GetCapitalUnit(PARIS),AMERICAN_TANK_WORTH,"tank sold")
        call SetPlayerState(FRANCE,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(FRANCE,PLAYER_STATE_RESOURCE_GOLD)+AMERICAN_TANK_WORTH)
        set NextCommonwealthGreekShipment.renaults = NextCommonwealthGreekShipment.renaults + 1
        set NextCommonwealthGreekShipment.mortars = NextCommonwealthGreekShipment.mortars + 1
    elseif i == BRITISH_TANK_SQUADRON then
        set NextBritishGreekShipment.mortars = NextBritishGreekShipment.mortars + 1
        if GetPlayerTechMaxAllowed(GREAT_BRITAIN,MARK_IV) >= 0 then
            set NextBritishGreekShipment.mark4s = NextBritishGreekShipment.mark4s + 1
        else
            set NextBritishGreekShipment.mark1s = NextBritishGreekShipment.mark1s + 1
        endif
    elseif GetOwningPlayer(GetTrainedUnit()) == GREAT_BRITAIN then
        set NextBritishGreekShipment.howitzers = NextBritishGreekShipment.howitzers + 1
        set NextBritishGreekShipment.infantry = NextBritishGreekShipment.infantry + 2
    else
        set NextCommonwealthGreekShipment.howitzers = NextCommonwealthGreekShipment.howitzers + 1
        set NextCommonwealthGreekShipment.infantry = NextCommonwealthGreekShipment.infantry + 2
    endif
endfunction

private function Conditions takes nothing returns boolean
    local integer i = GetUnitTypeId(GetTrainedUnit())
    return i == BRITISH_TANK_SQUADRON or i == AMERICAN_TANK_SQUADRON or i == HOWITZER_SQUADRON
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_TRAIN_FINISH)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction
endscope
