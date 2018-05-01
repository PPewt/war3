// Keeps track of who is in each trench to allow the various trench abilities
// to work correctly

library TrenchSystem
struct Trench
    unit first = null
    unit second = null
    unit trench = null
    Trigger target
    static method create takes unit tr returns thistype
        local thistype this = thistype.allocate()
        set this.trench = tr
        set this.target = Trigger.create(tr)
        call SetUnitUserData(tr,this)
        return this
    endmethod
    method onDestroy takes nothing returns nothing
        call this.target.free()
    endmethod
endstruct
private function CreateStructsFilter takes nothing returns boolean
    if GetUnitRace(GetFilterUnit()) == RACE_ORC then
        call Trench.create(GetFilterUnit())
    endif
    return false
endfunction
private function CreateStructs takes nothing returns nothing
    call GroupEnumUnitsInRect(enumGrp,bj_mapInitialPlayableArea,Filter(function CreateStructsFilter))
    call DestroyTimer(GetExpiredTimer())
endfunction
public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),0.,false,function CreateStructs)
endfunction
endlibrary
