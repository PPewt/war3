// Start barracks at the start of the game.

library StartBarracks requires BuildingAutomation
private function StartFilter takes nothing returns boolean
    if GetOwningPlayer(GetFilterUnit()) != NEUTRAL then
        call StartFactory(GetFilterUnit(),0)
    endif
    return false
endfunction
private function Start takes nothing returns nothing
    call GroupEnumUnitsOfType(enumGrp,"custom_h00U",Filter(function StartFilter))
    call DestroyTimer(GetExpiredTimer())
endfunction
public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),0.,false,function Start)
endfunction
endlibrary
