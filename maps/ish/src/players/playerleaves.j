// Share control if a player quits

scope PlayerLeaves initializer init
private function Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer i = 0
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,GetPlayerName(p) + " has left the game!")
    loop
        exitwhen i > 11
        if IsPlayerAlly(p,Player(i)) then
            call SetPlayerAlliance(p,Player(i),ALLIANCE_SHARED_CONTROL,true)
            call SetPlayerAlliance(p,Player(i),ALLIANCE_SHARED_ADVANCED_CONTROL,true)
        endif
        set i = i + 1
    endloop
endfunction
private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i > 11
        call TriggerRegisterPlayerEvent(t,Player(i),EVENT_PLAYER_LEAVE)
        set i = i + 1
    endloop
    call TriggerAddAction(t,function Actions)
endfunction
endscope
