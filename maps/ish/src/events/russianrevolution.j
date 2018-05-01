// Manages the various phases of the Russian revolution
// This code is still fairly messy and probably isn't improving further any time soon

library RussianRevolution requires Globals, CapitalTracker, Players
globals
    private boolean revolutionActive = false
    group russianCapitals = CreateGroup()
    private integer russianStartingCapitalCount = 0
    private boolean riotsActive = false
    
    private group revolutionEnumGroup = CreateGroup()
    
    private boolean warsawRiotSucceeded = false
    private boolean kievRiotSucceeded = false
    private boolean rigaRiotSucceeded = false
    private boolean helsinkiRiotSucceeded = false
    
    private unit revolutionDummy
endglobals

private function RevolutionAdd takes nothing returns boolean
    local unit u = GetFilterUnit()
    local player p = BULGARIA //Player to give Russian revolters to
    local Trench dat
    if GetOwningPlayer(u) == RUSSIA and GetUnitAbilityLevel(u,TOWN_INCOME_ABILITY) > 0 then
        call UnitDamageTarget(revolutionDummy,u,9999,true,true,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL,null)
    elseif GetOwningPlayer(u) == RUSSIA then
        call SetUnitOwner(u,p,true)
        call StartFactory(u,BuildingData.get(u))
        if GetUnitRace(u) == RACE_ORC then
            set dat = GetUnitUserData(u)
            if dat.first != null then
                call KillUnit(dat.first)
                call ShowUnit(dat.first,false)
                call CreateUnit(p,INFANTRY[Players_ToCountry(p)],GetUnitX(dat.first),GetUnitY(dat.first),GetUnitFacing(dat.first))
            endif
            if dat.second != null then
                call KillUnit(dat.second)
                call ShowUnit(dat.second,false)
                call CreateUnit(p,INFANTRY[Players_ToCountry(p)],GetUnitX(dat.second),GetUnitY(dat.second),GetUnitFacing(dat.second))
            endif
            call KillUnit(u)
        elseif GetUnitTypeId(u) == INFANTRY[RUSSIA_ID] then
            call KillUnit(u)
            call ShowUnit(u,false)
            call CreateUnit(p,INFANTRY[Players_ToCountry(p)],GetUnitX(u),GetUnitY(u),GetUnitFacing(u))
        endif
    endif
    set u = null
    return false
endfunction

private function IsCapital takes nothing returns boolean
    return IsUnitCapital(GetFilterUnit())
endfunction

public function CheckStart takes nothing returns nothing
    local integer numCities = 0
    local unit u
    call GroupEnumUnitsOfPlayer(enumGrp,RUSSIA,Filter(function IsCapital))
    loop
        set u = FirstOfGroup(enumGrp)
        exitwhen u == null
        set numCities = numCities + 1
        call GroupRemoveUnit(enumGrp,u)
    endloop
    set revolutionActive = numCities <= russianStartingCapitalCount
    if not revolutionActive then
        loop
            set u = FirstOfGroup(russianCapitals)
            exitwhen u == null or GetOwningPlayer(u) != RUSSIA
            call GroupRemoveUnit(enumGrp,u)
        endloop
        set revolutionActive = u != null
        set u = null
    endif
    call GroupClear(russianCapitals)
    call DestroyGroup(russianCapitals)
    set russianCapitals = null
    
    if revolutionActive then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"With the Russian populace dangerously antagonistic to the government and the war, bourgeois aristocrats seize control of the government, contested by an elected Soviet. |cffffcc00The Russian Revolution begins.|r")
    endif
endfunction

private function CreateRebels takes nothing returns nothing
    local integer i = 0
    local real x = GetUnitX(GetEnumUnit())
    local real y = GetUnitY(GetEnumUnit())
    loop
        exitwhen i > 11
        call CreateUnit(BULGARIA,INFANTRY[BULGARIA_ID],x,y,270.)
        set i = i + 1
    endloop
endfunction

public function HelsinkiRiotActive takes nothing returns boolean
    return riotsActive and not helsinkiRiotSucceeded
endfunction

public function KievRiotActive takes nothing returns boolean
    return riotsActive and not kievRiotSucceeded
endfunction

public function RigaRiotActive takes nothing returns boolean
    return riotsActive and not rigaRiotSucceeded
endfunction

public function WarsawRiotActive takes nothing returns boolean
    return riotsActive and not warsawRiotSucceeded
endfunction

public function HelsinkiCaptured takes nothing returns nothing
    local integer i = 0
    local unit u = GetCapitalUnit(HELSINKI)
    set helsinkiRiotSucceeded = true
    loop
        exitwhen i > 11
        call CreateUnit(BULGARIA,INFANTRY[BULGARIA_ID],GetUnitX(u),GetUnitY(u),270.)
        set i = i + 1
    endloop
    set u = null
    call GroupEnumUnitsInRect(revolutionEnumGroup,gg_rct_Finland,Filter(function RevolutionAdd))
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00Finland has declared independence from Russia and begins to fight for freedom against them!|r")
endfunction

public function KievCaptured takes nothing returns nothing
    local integer i = 0
    local unit u = GetCapitalUnit(KIEV)
    set kievRiotSucceeded = true
    loop
        exitwhen i > 11
        call CreateUnit(BULGARIA,INFANTRY[BULGARIA_ID],GetUnitX(u),GetUnitY(u),270.)
        set i = i + 1
    endloop
    set u = null
    call GroupEnumUnitsInRect(revolutionEnumGroup,gg_rct_Ukraine,Filter(function RevolutionAdd))
    call GroupEnumUnitsInRect(revolutionEnumGroup,gg_rct_Ukraine2,Filter(function RevolutionAdd))
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00Ukraine has declared independence from Russia and begins to fight for freedom against them!|r")
endfunction

public function RigaCaptured takes nothing returns nothing
    local integer i = 0
    local unit u = GetCapitalUnit(RIGA)
    set rigaRiotSucceeded = true
    loop
        exitwhen i > 11
        call CreateUnit(BULGARIA,INFANTRY[BULGARIA_ID],GetUnitX(u),GetUnitY(u),270.)
        set i = i + 1
    endloop
    set u = null
    call GroupEnumUnitsInRect(revolutionEnumGroup,gg_rct_Baltics,Filter(function RevolutionAdd))
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00The Baltic states have declared independence from Russia and begin to fight for freedom against them!|r")
endfunction

public function WarsawCaptured takes nothing returns nothing
    local integer i = 0
    local unit u = GetCapitalUnit(WARSAW)
    set warsawRiotSucceeded = true
    loop
        exitwhen i > 11
        call CreateUnit(BULGARIA,INFANTRY[BULGARIA_ID],GetUnitX(u),GetUnitY(u),270.)
        set i = i + 1
    endloop
    set u = null
    call GroupEnumUnitsInRect(revolutionEnumGroup,gg_rct_Poland,Filter(function RevolutionAdd))
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00Poland has declared independence from Russia and begins to fight for freedom against them!|r")
endfunction

public function MinorRevolt takes nothing returns nothing
    if revolutionActive then
        set revolutionDummy = CreateUnit(BULGARIA,'e000',15500.,15300.,0.)
        set riotsActive = true
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"Discontented by the self-proclaimed provisional government's disastrous continuation of the war with Germany and Austria, revolts break loose. Minor bolsheviks and other radicals take the chance to attempt to overthrow the government. |cffffcc00Russian capitals are under attack!|r")
        call GroupEnumUnitsOfPlayer(revolutionEnumGroup,RUSSIA,Filter(function IsCapital))
        call ForGroup(revolutionEnumGroup,function CreateRebels)
    endif
endfunction

public function MajorRevolt takes nothing returns nothing
    if revolutionActive then
        set riotsActive = false
        set revolutionActive = false
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00November 1917|r - Bolshevik radicals seize control of the government, proclaiming Russia to be Communist, and seize control of a large part of central western Russia in the November Revolution.|r")
        call KievCaptured()
        call WarsawCaptured()
        call HelsinkiCaptured()
        call RigaCaptured()
        call SetUnitExploded(revolutionDummy,true)
        call UnitApplyTimedLife(revolutionDummy,'BTLF',1.)
        set revolutionDummy = null
    endif
endfunction

private function CountRussianCapitalsEnum takes nothing returns nothing
    set russianStartingCapitalCount = russianStartingCapitalCount + 1
endfunction

private function CountRussianCapitals takes nothing returns nothing
    call GroupEnumUnitsOfPlayer(russianCapitals,RUSSIA,Filter(function IsCapital))
    call ForGroup(russianCapitals,function CountRussianCapitalsEnum)
    call DestroyTimer(GetExpiredTimer())
endfunction

public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),0.,false,function CountRussianCapitals)
endfunction
endlibrary
