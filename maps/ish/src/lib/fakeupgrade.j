//Upgrades in Warcraft can't be unresearched, so if we need a tech requirement
//which can be unresearched on demand it's instead a dummy unit with the appropriate
//name hiding on the corner of the map.

library FakeUpgrade requires Rawcodes, Players
globals
    private hashtable fakeUpgradeHash = InitHashtable()
    private constant real X = 15500.
    private constant real Y = 15300.
endglobals

public function Research takes player p, integer id returns nothing
    local unit u = LoadUnitHandle(fakeUpgradeHash,Players_ToCountry(p),id)
    if u == null then
        set u = CreateUnit(p,id,X,Y,0.)
        call SaveUnitHandle(fakeUpgradeHash,Players_ToCountry(p),id,u)
    endif
    set u = null
endfunction

public function Unresearch takes player p, integer id returns nothing
    local unit u = LoadUnitHandle(fakeUpgradeHash,Players_ToCountry(p),id)
    if u != null then
        call SetUnitOwner(u,NEUTRAL,false)
        call SetUnitExploded(u,true)
        call KillUnit(u)
        call SaveUnitHandle(fakeUpgradeHash,Players_ToCountry(p),id,null)
        set u = null
    endif
endfunction

public function SetResearched takes player p, integer id, boolean b returns nothing
    if b then
        call Research(p,id)
    else
        call Unresearch(p,id)
    endif
endfunction

public function IsResearched takes player p, integer id returns boolean
    return LoadUnitHandle(fakeUpgradeHash,Players_ToCountry(p),id) != null
endfunction
endlibrary
