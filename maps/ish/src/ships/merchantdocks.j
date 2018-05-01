// Manages the various merchant ships that crisscross the ocean

library MerchantDocks initializer init requires TimerUtils
globals
    private unit tU
    private constant real UPDATE_SHIPS_INTERVAL = 5.
    private trigger orderDetect = CreateTrigger()
endglobals
interface MerchantShip
    unit tg
endinterface
private struct Data extends MerchantShip
    integer i
    Trigger target
    static method create takes unit u returns thistype
        local thistype this = thistype.allocate()
        call SetUnitUserData(u,this)
        set this.target = Trigger.create(u)
        return this
    endmethod
    method onDestroy takes nothing returns nothing
        call this.target.free()
        set this.tg = null
    endmethod
endstruct
//Makes sure ships going past major terrain issues don't get stuck due to pathing problems.
public function IssueMoveOrder takes unit u returns nothing
    local MerchantShip dat = GetUnitUserData(u)
    local boolean uN = RectContainsUnit(gg_rct_NorthSea,u) or RectContainsUnit(gg_rct_NorthSea2,u)
    local boolean tN = RectContainsUnit(gg_rct_NorthSea,dat.tg) or RectContainsUnit(gg_rct_NorthSea2,dat.tg)
    local boolean uM = RectContainsUnit(gg_rct_MediterraneanSea,u) or RectContainsUnit(gg_rct_MediterraneanSea2,u)
    local boolean tM = RectContainsUnit(gg_rct_MediterraneanSea,dat.tg) or RectContainsUnit(gg_rct_MediterraneanSea2,dat.tg)
    local boolean eG = RectContainsUnit(gg_rct_GibraltarHub,u)
    local boolean eD = RectContainsUnit(gg_rct_DanishHub,u)
    local boolean uA = not (uN or uM)
    local boolean tA = not (tN or tM)
    call DisableTrigger(orderDetect)
    if (uN and not tN) or (uA and tN and not eD) then
        call IssuePointOrderById(u,851986,GetRectCenterX(gg_rct_DanishHub),GetRectCenterY(gg_rct_DanishHub))
    elseif (uM and not tM) or (uA and tM and not eG) then
        call IssuePointOrderById(u,851986,GetRectCenterX(gg_rct_GibraltarHub),GetRectCenterY(gg_rct_GibraltarHub))
    else
        call IssueTargetOrderById(u,852600,dat.tg)
    endif
    call EnableTrigger(orderDetect)
endfunction
private function FindHarbourFilter2 takes nothing returns boolean
    return IsUnitAlly(GetFilterUnit(),GetOwningPlayer(tU)) and GetPlayerId(GetOwningPlayer(GetFilterUnit())) < 12 and GetWidgetLife(GetFilterUnit()) > 0 and not (GetOwningPlayer(tU) == GetOwningPlayer(GetFilterUnit()))
endfunction
private function FindHarbourFilter takes nothing returns boolean
    local Data dat
    set tU = GetFilterUnit()
    if GetWidgetLife(tU) > 0 and GetUnitCurrentOrder(tU) != 852600 and GetUnitCurrentOrder(tU) != 851986 then
        call GroupEnumUnitsOfType(enumGrp2,"custom_h02F",Filter(function FindHarbourFilter2))
        set dat = GetUnitUserData(tU)
        set dat.tg = GroupPickRandomUnit(enumGrp2)
        call IssueMoveOrder(tU)
    endif
    return false
endfunction
private function FindHarbour takes nothing returns nothing
    call GroupEnumUnitsOfType(enumGrp,"custom_h02G",Filter(function FindHarbourFilter))
endfunction
private function SendShipsFilter2 takes nothing returns boolean
    local unit u = GetFilterUnit()
    local unit t
    local Data dat
    if IsUnitAlly(u,GetOwningPlayer(tU)) and GetWidgetLife(u) > 0 and GetPlayerId(GetOwningPlayer(u)) < 12 and not (GetOwningPlayer(tU) == GetOwningPlayer(u)) then
        if GetRandomInt(1,SPAWN_SHIPS_CHANCE) == 1 then
            set t = CreateUnit(GetOwningPlayer(tU),MERCHANT_SHIP,GetUnitX(tU),GetUnitY(tU),0)
            set dat = Data.create(t)
            set dat.tg = u
            call IssueMoveOrder(t)
        endif
    endif
    set u = null
    set t = null
    return false
endfunction
private function SendShipsFilter takes nothing returns boolean
    set tU = GetFilterUnit()
    if GetWidgetLife(tU) > 0 and GetPlayerId(GetOwningPlayer(tU)) < 12 then
        call GroupEnumUnitsOfType(enumGrp2,"custom_h02F",Filter(function SendShipsFilter2))
    endif
    return false
endfunction
private function SendShips takes nothing returns nothing
    call GroupEnumUnitsOfType(enumGrp,"custom_h02F",Filter(function SendShipsFilter))
endfunction
private struct TDATA
    unit tm
endstruct
private function OrdActions_Child takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local TDATA dat = GetTimerData(t)
    call IssueMoveOrder(dat.tm)
    call dat.destroy()
    call ReleaseTimer(t)
endfunction
private function OrdActions takes nothing returns nothing
    local timer t = NewTimer()
    local TDATA dat = TDATA.create()
    set dat.tm = GetTriggerUnit()
    call SetTimerData(t,dat)
    call TimerStart(t,0,false,function OrdActions_Child)
endfunction
private function OrdConditions takes nothing returns boolean
    return (GetUnitTypeId(GetTriggerUnit()) == MERCHANT_SHIP or GetUnitTypeId(GetTriggerUnit()) == 'h02Y') and GetIssuedOrderId() != 852600
endfunction
private function CastActions takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local Data dat = GetUnitUserData(u)
    local player p = GetOwningPlayer(dat.tg)
    set dat.tg = null
    call dat.destroy()
    call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+SHIP_WORTH)
    call DisplayIncomeTextTag(u,SHIP_WORTH)
    call RemoveUnit(u)
    set u = null
endfunction
private function CastConditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00S'
endfunction
private function DeathActions takes nothing returns nothing
    call Data(GetUnitUserData(GetTriggerUnit())).destroy()
endfunction
private function DeathConditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit()) == MERCHANT_SHIP
endfunction
private function RedirectActions takes nothing returns nothing
    call IssueMoveOrder(GetTriggerUnit())
endfunction
private function RedirectConditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit()) == MERCHANT_SHIP or GetUnitTypeId(GetTriggerUnit()) == SUPPLY_SHIP
endfunction
private function TradeDocksFilter takes nothing returns boolean
    call BuildingData.get(GetFilterUnit())
    return false
endfunction
private function TradeDocksInit takes nothing returns nothing
    call GroupEnumUnitsOfType(enumGrp,"custom_h02F",Filter(function TradeDocksFilter))
    call DestroyTimer(GetExpiredTimer())
endfunction
public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),0.,false,function TradeDocksInit)
endfunction
private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    local trigger o = CreateTrigger()
    local region r = CreateRegion()
    local integer i = 0
    local player p
    call TimerStart(CreateTimer(),SPAWN_SHIPS_INTERVAL,true,function SendShips)
    call TimerStart(CreateTimer(),UPDATE_SHIPS_INTERVAL,true,function FindHarbour)
    loop
        exitwhen i > 11
        set p = Player(i)
        call TriggerRegisterPlayerUnitEvent(orderDetect,p,EVENT_PLAYER_UNIT_ISSUED_ORDER,null)
        call TriggerRegisterPlayerUnitEvent(orderDetect,p,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER,null)
        call TriggerRegisterPlayerUnitEvent(orderDetect,p,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER,null)
        call TriggerRegisterPlayerUnitEvent(t,p,EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        call TriggerRegisterPlayerUnitEvent(o,p,EVENT_PLAYER_UNIT_DEATH,null)
        set i = i + 1
    endloop
    call TriggerAddCondition(orderDetect,Condition(function OrdConditions))
    call TriggerAddCondition(o,Condition(function DeathConditions))
    call TriggerAddCondition(t,Condition(function CastConditions))
    call TriggerAddAction(orderDetect,function OrdActions)
    call TriggerAddAction(t,function CastActions)
    call TriggerAddAction(o,function DeathActions)
    call RegionAddRect(r,gg_rct_DanishHub)
    call RegionAddRect(r,gg_rct_GibraltarHub)
    set t = CreateTrigger()
    call TriggerRegisterEnterRegion(t,r,null)
    call TriggerAddCondition(t,Condition(function RedirectConditions))
    call TriggerAddAction(t,function RedirectActions)
    set t = CreateTrigger()
endfunction
endlibrary
