// By default "share control" in Warcraft doesn't allow certain features (such
// as building things on that player's behalf). This turns on proper sharing.

scope FullSharedAlliance initializer init
globals
    private force shareForce = CreateForce()
    private boolean share = false
    private boolean all = false
    private player plyr
endglobals
private function Conditions takes nothing returns boolean
    return StringCase(SubString(GetEventPlayerChatString(),0,7),false) == "-share " or StringCase(SubString(GetEventPlayerChatString(),0,9),false) == "-unshare "
endfunction

private function ShareControlEnum takes nothing returns nothing
    local player target = GetEnumPlayer()
    if IsPlayerAlly(plyr,target) and not (plyr == target) then
        if share then
            if not GetPlayerAlliance(plyr,target,ALLIANCE_SHARED_CONTROL) then
                call SetPlayerAlliance(plyr,target,ALLIANCE_SHARED_CONTROL,true)
                call SetPlayerAlliance(plyr,target,ALLIANCE_SHARED_ADVANCED_CONTROL,true)
                call DisplayTextToPlayer(plyr,0.,0.,"Shared control with " + GetPlayerName(target) + ".")
                call DisplayTextToPlayer(target,0.,0.,GetPlayerName(plyr) + " shared control with you.")
            elseif not all then
                call DisplayTextToPlayer(plyr,0.,0.,"You already have shared control with " + GetPlayerName(target) + ".")
            endif
        elseif GetPlayerAlliance(plyr,target,ALLIANCE_SHARED_CONTROL) then
            call SetPlayerAlliance(plyr,target,ALLIANCE_SHARED_CONTROL,false)
            call SetPlayerAlliance(plyr,target,ALLIANCE_SHARED_ADVANCED_CONTROL,false)
            call DisplayTextToPlayer(plyr,0.,0.,"Stopped sharing control with " + GetPlayerName(target) + ".")
            call DisplayTextToPlayer(target,0.,0.,GetPlayerName(plyr) + " stopped sharing control with you.")
        else
            call DisplayTextToPlayer(plyr,0.,0.,"You already weren't sharing control with " + GetPlayerName(target) + ".")
        endif
    elseif plyr == target and not all then
        call DisplayTextToPlayer(plyr,0.,0.,"You can't unshare yourself.")
    elseif not all then
        call DisplayTextToPlayer(plyr,0.,0.,"You can't share control with enemies.")
    endif
endfunction

private function Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer i = 0
    local integer offset
    local string s
    local player target
    set plyr = p
    if StringCase(SubString(GetEventPlayerChatString(),0,7),false) == "-share " then
        set offset = 7
    else
        set offset = 9
    endif
    set s = StringCase(SubString(GetEventPlayerChatString(),offset,StringLength(GetEventPlayerChatString())),false)
    set target = Players_FromString(s)
    call ForceClear(shareForce)
    set all = false
    set share = offset == 7
    if s == "all" then
        loop
            exitwhen i > 1
            call ForceAddPlayer(shareForce,Player(i))
            set i = i + 1
        endloop
        set all = true
    elseif target != NEUTRAL then
        call ForceAddPlayer(shareForce,target)
    else
        call DisplayTextToPlayer(p,0.,0.,"Unrecognized player.")
        return
    endif
    call ForForce(shareForce,function ShareControlEnum)
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i > 11
        call TriggerRegisterPlayerChatEvent(t,Player(i),"-share ",false)
        call TriggerRegisterPlayerChatEvent(t,Player(i),"-unshare ",false)
        set i = i + 1
    endloop
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction
endscope
