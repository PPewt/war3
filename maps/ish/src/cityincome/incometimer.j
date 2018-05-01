// Distributes income every month

library IncomeTimer initializer init
globals
    private integer cnt
endglobals

private function GoldFilter takes nothing returns boolean
    set cnt = cnt + GetUnitAbilityLevel(GetFilterUnit(),TOWN_INCOME_ABILITY)
    return false
endfunction
public function GiveIncome takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i > 11
        set cnt = 0
        call GroupEnumUnitsOfPlayer(enumGrp,Player(i),Filter(function GoldFilter))
        call SetPlayerState(Player(i),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(i),PLAYER_STATE_RESOURCE_GOLD)+cnt)
        call DisplayTimedTextToPlayer(Player(i),0.,0.,10.,I2S(cnt) + "$ in taxes have been collected.")
        debug call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"Player " + I2S(i) + " - " + I2S(cnt) + "$ in taxes have been collected.")
        set i = i + 1
    endloop
endfunction

private function init takes nothing returns nothing
    debug local trigger t = CreateTrigger()
    debug call TriggerRegisterPlayerEvent(t,Player(0),EVENT_PLAYER_ARROW_UP_DOWN)
    debug call TriggerRegisterPlayerEvent(t,Player(6),EVENT_PLAYER_ARROW_UP_DOWN)
    debug call TriggerAddAction(t,function GiveIncome)
endfunction
endlibrary
