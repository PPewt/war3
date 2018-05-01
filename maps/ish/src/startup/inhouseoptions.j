// Options for inhouse mode. Unfinished

library InhouseOptions initializer init requires Players
globals
    private code callbackCode
    private timer callbackTimer
    private trigger inhouseTrigger
    private string array words //Jass doesn't allow for local arrays
    private integer wordsLen
endglobals

private function ParseWords takes string s returns nothing
    local integer i = 0
    local integer len = StringLength(s)
    local string currentWord = ""
    set wordsLen = 0
    loop
        exitwhen i >= len
        if SubString(s,i,i+1) == " " then
            if currentWord != "" then
                set words[wordsLen] = currentWord
                set wordsLen = wordsLen + 1
            endif
            set currentWord = ""
        else
            set currentWord = currentWord + SubString(s,i,i+1)
        endif
        set i = i + 1
    endloop
    if currentWord != "" then
        set words[wordsLen] = currentWord
        set wordsLen = wordsLen + 1
    endif
endfunction

private function ParseCommand takes nothing returns nothing
    local player swap1
    local player swap2
    call ParseWords(StringCase(GetEventPlayerChatString(),false))
    if words[0] == "-start" and wordsLen == 1 then
        call TimerStart(callbackTimer,0.,false,callbackCode)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,10.,"|cffffcc00Get ready: game starting in 10 seconds!|r")
        call DisableTrigger(inhouseTrigger)
    elseif words[0] == "-balance" and wordsLen == 1 then //TODO
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"|cffffcc00Autobalance feature is currently unimplemented.|r")
    elseif words[0] == "-swap" then
        if wordsLen == 3 then
            set swap1 = Players_FromString(words[1])
            set swap2 = Players_FromString(words[2])
            if swap1 != NEUTRAL and swap2 != NEUTRAL then
                call Players_Swap(swap1,swap2)
            else
                call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"|cffffcc00Unrecognized players to swap.|r")
            endif
        else
            call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"|cffffcc00Swap must take exactly two players.|r")
        endif
    else
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"|cffffcc00Unrecognized command:|r " + words[0])
    endif
endfunction

public function Begin takes timer callbackT, code callbackF returns nothing
    set callbackTimer = callbackT
    set callbackCode = callbackF
    call EnableTrigger(inhouseTrigger)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"Inhouse mode detected. The initial red player may now setup game options.")
    call DisplayTimedTextToPlayer(Player(0),0.,0.,20.,"Commands: -swap player1 player2, -start, -balance")
endfunction

private function init takes nothing returns nothing
    set inhouseTrigger = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(inhouseTrigger,Player(0),"-start",    true)
    call TriggerRegisterPlayerChatEvent(inhouseTrigger,Player(0),"-swap",    false)
    call TriggerRegisterPlayerChatEvent(inhouseTrigger,Player(0),"-balance",  true)
    call TriggerAddAction(inhouseTrigger,function ParseCommand)
    call DisableTrigger(inhouseTrigger)
endfunction
endlibrary
