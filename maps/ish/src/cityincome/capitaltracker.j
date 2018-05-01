// Keeps track of the various specially named towns on the map

library CapitalTracker requires Rawcodes
globals
    private hashtable capitalHash = InitHashtable()
    private integer uid
endglobals
private function InitializeCapitalUnit takes nothing returns boolean
    if GetUnitTypeId(GetFilterUnit()) == uid and GetWidgetLife(GetFilterUnit()) > 0. then
        call SaveUnitHandle(capitalHash,uid,0,GetFilterUnit())
    endif
    return false
endfunction
function GetCapitalUnit takes integer id returns unit
    if LoadUnitHandle(capitalHash,id,0) == null then
        set uid = id
        call GroupEnumUnitsInRect(enumGrp,bj_mapInitialPlayableArea,Filter(function InitializeCapitalUnit))
        if LoadUnitHandle(capitalHash,id,0) == null then
            debug call BJDebugMsg("DEBUG WARNING: Could not find capital " + I2S(id) + "!")
        endif
    endif
    return LoadUnitHandle(capitalHash,id,0)
endfunction
function SetCapitalUnit takes unit u returns nothing
    call SaveUnitHandle(capitalHash,GetUnitTypeId(u),0,u)
endfunction
function IsUnitCapital takes unit u returns boolean
    return GetUnitAbilityLevel(u,TOWN_INCOME_ABILITY) > 0 and not (GetUnitTypeId(u) == TOWN or GetUnitTypeId(u) == CITY)
endfunction
endlibrary
