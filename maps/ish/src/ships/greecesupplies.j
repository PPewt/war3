// Allows the Commonwealth and Great Britain players to send units to Greece

library GreeceSupplies initializer init requires FakeUpgrade
struct ShippingData extends MerchantShip
    integer worth
    integer howitzers
    integer mortars
    integer infantry
    integer mark1s
    integer mark4s
    integer renaults
endstruct
globals
    private constant real SUPPLIES_INTERVAL = 60.
    private integer ehowitzers = 0
    private integer emortars = 0
    private integer einfantry = 0
    private integer emark1s = 0
    private integer emark4s = 0
    private integer erenaults = 0
    ShippingData NextBritishGreekShipment
    ShippingData NextCommonwealthGreekShipment
endglobals
private function Actions takes nothing returns nothing
    local unit u
    if FakeUpgrade_IsResearched(GREAT_BRITAIN,SHIPPING_TO_GREECE) then
        call SetPlayerState(GREAT_BRITAIN,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(GREAT_BRITAIN,PLAYER_STATE_RESOURCE_GOLD)-100)
        set u = CreateUnit(GREAT_BRITAIN,SUPPLY_SHIP,GetUnitX(docks[LONDON_DOCK_OFFSET]),GetUnitY(docks[LONDON_DOCK_OFFSET]),270.)
        call SetUnitUserData(u,NextBritishGreekShipment)
        set NextBritishGreekShipment.tg = GetCapitalUnit(ATHENS)
        call MerchantDocks_IssueMoveOrder(u)
        set u = null
        set NextBritishGreekShipment = ShippingData.create()
        set NextBritishGreekShipment.worth = 150
        set NextBritishGreekShipment.infantry = 6
    endif
    if FakeUpgrade_IsResearched(COMMONWEALTH,SHIPPING_TO_GREECE) then
        call SetPlayerState(COMMONWEALTH,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(COMMONWEALTH,PLAYER_STATE_RESOURCE_GOLD)-100)
        set u = CreateUnit(COMMONWEALTH,SUPPLY_SHIP,GetUnitX(docks[HALIFAX_DOCK_OFFSET]),GetUnitY(docks[HALIFAX_DOCK_OFFSET]),270.)
        call SetUnitUserData(u,NextCommonwealthGreekShipment)
        set NextCommonwealthGreekShipment.tg = GetCapitalUnit(ATHENS)
        call MerchantDocks_IssueMoveOrder(u)
        set u = null
        set NextCommonwealthGreekShipment = ShippingData.create()
        set NextCommonwealthGreekShipment.worth = 150
        set NextCommonwealthGreekShipment.infantry = 6
    endif
endfunction
private function ShippingConditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit()) == SUPPLY_SHIP
endfunction
private function DeathActions takes nothing returns nothing
    call ShippingData(GetUnitUserData(GetTriggerUnit())).destroy()
endfunction
private function UnloadShip takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local ShippingData dat = GetUnitUserData(u)
    local player p = GetOwningPlayer(dat.tg)
    call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+dat.worth)
    call DisplayIncomeTextTag(u,dat.worth)
    set dat.infantry = dat.infantry + einfantry
    set dat.mortars = dat.mortars + emortars
    set dat.howitzers = dat.howitzers + ehowitzers
    set dat.mark1s = dat.mark1s + emark1s
    set dat.mark4s = dat.mark4s + emark4s
    set dat.renaults = dat.renaults + erenaults
    loop
        exitwhen dat.infantry <= 0 or (GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_CAP) - GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_USED)) < 1
        call CreateUnit(SERBIA,INFANTRY[SERBIA_ID],GetUnitX(dat.tg),GetUnitY(dat.tg),270.)
        set dat.infantry = dat.infantry - 1
    endloop
    loop
        exitwhen dat.mortars <= 0 or (GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_CAP) - GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_USED)) < 2
        call CreateUnit(SERBIA,MORTAR,GetUnitX(dat.tg),GetUnitY(dat.tg),270.)
        set dat.mortars = dat.mortars - 1
    endloop
    loop
        exitwhen dat.howitzers <= 0 or (GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_CAP) - GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_USED)) < 2
        call CreateUnit(SERBIA,HOWITZER_PACKED,GetUnitX(dat.tg),GetUnitY(dat.tg),270.)
        set dat.howitzers = dat.howitzers - 1
    endloop
    loop
        exitwhen dat.mark1s <= 0 or (GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_CAP) - GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_USED)) < 2
        call CreateUnit(SERBIA,MARK_I,GetUnitX(dat.tg),GetUnitY(dat.tg),270.)
        set dat.mark1s = dat.mark1s - 1
    endloop
    loop
        exitwhen dat.mark4s <= 0 or (GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_CAP) - GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_USED)) < 2
        call CreateUnit(SERBIA,MARK_IV,GetUnitX(dat.tg),GetUnitY(dat.tg),270.)
        set dat.mark4s = dat.mark4s - 1
    endloop
    loop
        exitwhen dat.renaults <= 0 or (GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_CAP) - GetPlayerState(SERBIA,PLAYER_STATE_RESOURCE_FOOD_USED)) < 2
        call CreateUnit(SERBIA,RENAULT,GetUnitX(dat.tg),GetUnitY(dat.tg),270.)
        set dat.renaults = dat.renaults - 1
    endloop
    set einfantry = dat.infantry
    set emortars = dat.mortars
    set ehowitzers = dat.howitzers
    set emark1s = dat.mark1s
    set emark4s = dat.mark4s
    set erenaults = dat.renaults
    set dat.tg = null
    call dat.destroy()
    call RemoveUnit(u)
    set u = null
endfunction
private function ResendShipsF takes nothing returns boolean
    if GetUnitCurrentOrder(GetFilterUnit()) == 0 then
        call MerchantDocks_IssueMoveOrder(GetFilterUnit())
    endif
    return false
endfunction
private function ResendShips takes nothing returns nothing
    call GroupEnumUnitsOfType(enumGrp,"custom_h02Y",Filter(function ResendShipsF))
endfunction
public function Initialize takes nothing returns nothing
    set NextBritishGreekShipment = ShippingData.create()
    set NextBritishGreekShipment.worth = 150
    set NextBritishGreekShipment.infantry = 6
    set NextBritishGreekShipment.tg = GetCapitalUnit(ATHENS)
    set NextCommonwealthGreekShipment = ShippingData.create()
    set NextCommonwealthGreekShipment.worth = 150
    set NextCommonwealthGreekShipment.infantry = 6
    set NextCommonwealthGreekShipment.tg = GetCapitalUnit(ATHENS)
endfunction
private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TimerStart(CreateTimer(),SUPPLIES_INTERVAL,true,function Actions)
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(t,Condition(function ShippingConditions))
    call TriggerAddAction(t,function DeathActions)
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function ShippingConditions))
    call TriggerAddAction(t,function UnloadShip)
    call TimerStart(CreateTimer(),5.,true,function ResendShips)
endfunction
endlibrary
