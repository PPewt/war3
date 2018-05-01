// Can be used to assign income values to cities

library SetCityIncome requires Globals, CapitalTracker
globals
    private integer town
    private integer city
    private player plyr
    private boolean reset
endglobals
private function SetIncomeRectFilter takes nothing returns boolean
    if GetOwningPlayer(GetFilterUnit()) == plyr and (reset or GetUnitAbilityLevel(GetFilterUnit(),TOWN_INCOME_ABILITY) == 1) then
        if GetUnitTypeId(GetFilterUnit()) == TOWN then
            call SetUnitAbilityLevel(GetFilterUnit(),TOWN_INCOME_ABILITY,town)
        elseif GetUnitTypeId(GetFilterUnit()) == CITY then
            call SetUnitAbilityLevel(GetFilterUnit(),TOWN_INCOME_ABILITY,city)
        endif
        call BuildingData.get(GetFilterUnit())
    endif
    return false
endfunction
function SetIncomeRect takes rect r, player p, integer townIncome, integer cityIncome returns nothing
    set town = townIncome
    set city = cityIncome
    set plyr = p
    set reset = false
    call GroupEnumUnitsInRect(enumGrp, r, Filter(function SetIncomeRectFilter))
endfunction
function ResetIncomeRect takes rect r, player p, integer townIncome, integer cityIncome returns nothing
    set town = townIncome
    set city = cityIncome
    set plyr = p
    set reset = true
    call GroupEnumUnitsInRect(enumGrp, r, Filter(function SetIncomeRectFilter))
endfunction
function SetCapitalIncome takes integer id, integer income returns nothing
    local unit u = GetCapitalUnit(id)
    call SetUnitAbilityLevel(u,TOWN_INCOME_ABILITY,income)
    call BuildingData.get(u)
    set u = null
endfunction
endlibrary
