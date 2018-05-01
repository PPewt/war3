// Manages capturing of cities and victory conditions.

scope CityCapture initializer init
globals
    private integer plyr
    private unit pass
endglobals
private function CapitalFilter takes nothing returns boolean
    return IsUnitCapital(GetFilterUnit()) and GetOwningPlayer(GetFilterUnit()) != NEUTRAL and not RectContainsUnit(gg_rct_GreatBritainCapitals,GetFilterUnit())
endfunction
private function RedirectSupplyShips takes nothing returns boolean
    local unit u = GetFilterUnit()
    local ShippingData dat = GetUnitUserData(u)
    if pass == GetCapitalUnit(ATHENS) then
        if GetOwningPlayer(docks[HALIFAX_DOCK_OFFSET]) == COMMONWEALTH then
            set dat.tg = docks[HALIFAX_DOCK_OFFSET]
            call MerchantDocks_IssueMoveOrder(u)
        elseif GetOwningPlayer(docks[LONDON_DOCK_OFFSET]) == GREAT_BRITAIN then
            set dat.tg = docks[LONDON_DOCK_OFFSET]
            call MerchantDocks_IssueMoveOrder(u)
        endif
    elseif pass == docks[HALIFAX_DOCK_OFFSET] then
        if GetOwningPlayer(GetCapitalUnit(ATHENS)) == SERBIA then
            set dat.tg = GetCapitalUnit(ATHENS)
            call MerchantDocks_IssueMoveOrder(u)
        elseif GetOwningPlayer(docks[LONDON_DOCK_OFFSET]) == GREAT_BRITAIN then
            set dat.tg = docks[LONDON_DOCK_OFFSET]
            call MerchantDocks_IssueMoveOrder(u)
        endif
    elseif GetOwningPlayer(GetCapitalUnit(ATHENS)) == SERBIA then
        set dat.tg = GetCapitalUnit(ATHENS)
        call MerchantDocks_IssueMoveOrder(u)
    elseif GetOwningPlayer(docks[HALIFAX_DOCK_OFFSET]) == GREAT_BRITAIN then
        set dat.tg = docks[HALIFAX_DOCK_OFFSET]
        call MerchantDocks_IssueMoveOrder(u)
    endif
    if dat.tg == pass then
        call KillUnit(u)
    endif
    set u = null
    return false
endfunction
private function Actions takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local unit u2
    local player p = GetOwningPlayer(GetKillingUnit())
    local integer cnt = 0
    local integer incomeLevel = GetUnitAbilityLevel(u,TOWN_INCOME_ABILITY)
    local boolean b = IsUnitCapital(u)
    local integer i = 0
    local integer id = GetUnitTypeId(u)
    local BuildingData dat = BuildingData.get(u)
    if dat.owner >= 0 and IsPlayerAlly(p,Player(dat.owner)) then
        set p = Player(dat.owner)
    endif
    set u2 = CreateUnit(p,GetUnitTypeId(u),GetUnitX(u),GetUnitY(u),270.)
    if incomeLevel > 0 or GetUnitTypeId(u) == TRADE_DOCKS then
        call dat.attach(u2)
        if incomeLevel > 0 then
            call SetUnitAbilityLevel(u2,TOWN_INCOME_ABILITY,incomeLevel)
        endif
    else
        call StartFactory(u2,dat)
        set dat.owner = -1
    endif
    call dat.detatch(u)
    if b then
        call SetCapitalUnit(u2)
    endif
    if IsUnitInGroup(u,russianCapitals) then
        call GroupRemoveUnit(russianCapitals,u)
        call GroupAddUnit(russianCapitals,u2)
    endif
    set plyr = 7
    if id == HELSINKI then
        if p == BULGARIA and RussianRevolution_HelsinkiRiotActive() then
            call RussianRevolution_HelsinkiCaptured()
        endif
    elseif id == WARSAW then
        if p == BULGARIA and RussianRevolution_WarsawRiotActive() then
            call RussianRevolution_WarsawCaptured()
        endif
    elseif id == RIGA then
        if p == BULGARIA and RussianRevolution_RigaRiotActive() then
            call RussianRevolution_RigaCaptured()
        endif
    elseif id == KIEV then
        if p == BULGARIA and RussianRevolution_KievRiotActive() then
            call RussianRevolution_KievCaptured()
        endif
    elseif id == ATHENS then
        set pass = u2
        call GroupEnumUnitsOfType(enumGrp,"custom_h02Y",Filter(function RedirectSupplyShips))
        if p == SERBIA then
            call FakeUpgrade_Research(GREAT_BRITAIN,GREECE_ACTIVE)
            call FakeUpgrade_Research(COMMONWEALTH,GREECE_ACTIVE)
        else
            call FakeUpgrade_Unresearch(GREAT_BRITAIN,GREECE_ACTIVE)
            call FakeUpgrade_Unresearch(COMMONWEALTH,GREECE_ACTIVE)
            call FakeUpgrade_Unresearch(GREAT_BRITAIN,SHIPPING_TO_GREECE)
            call FakeUpgrade_Unresearch(COMMONWEALTH,SHIPPING_TO_GREECE)
            if GetOwningPlayer(GetCapitalUnit(LONDON)) == GREAT_BRITAIN then
                call IssueImmediateOrderById(GetCapitalUnit(LONDON),852178)
            endif
            if GetOwningPlayer(GetCapitalUnit(HALIFAX)) == COMMONWEALTH then
                call IssueImmediateOrderById(GetCapitalUnit(HALIFAX),852178)
            endif
        endif
    elseif id == PARIS then
        call FakeUpgrade_SetResearched(COMMONWEALTH,FRENCH_PARIS,p==FRANCE)
    elseif id == SCUTARI then
        call FakeUpgrade_SetResearched(OTTOMAN_EMPIRE,TURKISH_SCUTARI,p==OTTOMAN_EMPIRE)
        call FakeUpgrade_SetResearched(EAST_GERMANY,TURKISH_SCUTARI,p==OTTOMAN_EMPIRE)
        call FakeUpgrade_SetResearched(WEST_GERMANY,TURKISH_SCUTARI,p==OTTOMAN_EMPIRE)
    elseif u == docks[LONDON_DOCK_OFFSET] then
        set docks[LONDON_DOCK_OFFSET] = u2
        set pass = u2
        call GroupEnumUnitsOfType(enumGrp,"custom_h02Y",Filter(function RedirectSupplyShips))
        if p == GREAT_BRITAIN then
            call FakeUpgrade_Research(GREAT_BRITAIN,TRADE_DOCKS_ACTIVE)
        else
            call FakeUpgrade_Unresearch(GREAT_BRITAIN,TRADE_DOCKS_ACTIVE)
            call FakeUpgrade_Unresearch(GREAT_BRITAIN,SHIPPING_TO_GREECE)
            if GetOwningPlayer(GetCapitalUnit(LONDON)) == GREAT_BRITAIN then
                call IssueImmediateOrderById(GetCapitalUnit(LONDON),852178)
            endif
        endif
    elseif u == docks[HALIFAX_DOCK_OFFSET] then
        set docks[HALIFAX_DOCK_OFFSET] = u2
        set pass = u2
        call GroupEnumUnitsOfType(enumGrp,"custom_h02Y",Filter(function RedirectSupplyShips))
        if p == COMMONWEALTH then
            call FakeUpgrade_Research(COMMONWEALTH,TRADE_DOCKS_ACTIVE)
        else
            call FakeUpgrade_Unresearch(COMMONWEALTH,TRADE_DOCKS_ACTIVE)
            call FakeUpgrade_Unresearch(COMMONWEALTH,SHIPPING_TO_GREECE)
            if GetOwningPlayer(GetCapitalUnit(HALIFAX)) == COMMONWEALTH then
                call IssueImmediateOrderById(GetCapitalUnit(HALIFAX),852178)
            endif
        endif
    elseif id == LONDON then
        call FakeUpgrade_Unresearch(GREAT_BRITAIN,SHIPPING_TO_GREECE)
    elseif id == HALIFAX then
        call FakeUpgrade_Unresearch(COMMONWEALTH,SHIPPING_TO_GREECE)
    endif
    call RemoveUnit(u)
    if b then
        call GroupEnumUnitsInRect(enumGrp,gg_rct_MainlandEurope,Filter(function CapitalFilter))
        set i = Players_ToCountry(GetOwningPlayer(FirstOfGroup(enumGrp)))/6
        loop
            set u2 = FirstOfGroup(enumGrp)
            set b = i == Players_ToCountry(GetOwningPlayer(u2))/6
            exitwhen u2 == null or not b
            call GroupRemoveUnit(enumGrp,u2)
        endloop
        call GroupClear(enumGrp)
        if b then
            if i == 0 then
                call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,10.,"Germany, Austria-Hungary, Bulgaria, and the Ottoman Empire have declared their defeat. As the remaining Central-controlled areas surrender, the Central Powers crumble and the Entente Powers are victorious!")
            else
                call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,10.,"France, Italy, Russia, and the Entente Balkans have declared their defeat. As the remaining Entente countries surrender, the Entente Powers crumble and the Central Powers are victorious!")
            endif
            call TriggerSleepAction(10.)
            call EndGame(true)
        endif
    endif
    set u = null
    set u2 = null
endfunction

private function Conditions takes nothing returns boolean
    local BuildingData dat = BuildingData.get(GetTriggerUnit())
    return (GetUnitAbilityLevel(GetTriggerUnit(),TOWN_INCOME_ABILITY) > 0 or GetUnitTypeId(GetTriggerUnit()) == TRADE_DOCKS or GetUnitTypeId(GetTriggerUnit()) == BARRACKS or GetUnitTypeId(GetTriggerUnit()) == FACTORY) and dat != 0 and dat.owner >= 0
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction
endscope
