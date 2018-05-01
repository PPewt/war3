// Responsible for firing the various month events

library MonthTimer initializer init requires IncomeTimer
globals
    private timer T = CreateTimer()
    private constant real INTERVAL = 60.
    private timerdialog td
    private string array months
    private integer month = 6
    private integer year = 1914
    private hashtable eventHash = InitHashtable()
endglobals
private function MonthToInteger takes string themonth returns integer
    local integer i = 0
    loop
        exitwhen i > 11
        if StringCase(months[i],false) == StringCase(themonth,false) then
            return i
        endif
        set i = i + 1
    endloop
    return 12
endfunction
public function RegisterEvent takes string themonth, string theyear returns nothing
    call SaveStr(eventHash,MonthToInteger(themonth),S2I(theyear),themonth+theyear+"_Actions")
endfunction
private function MonthTick takes nothing returns nothing
    local integer i = 0
    local string s
    set month = month + 1
    if month == 12 then
        set month = 0
        set year = year + 1
    endif
    call IncomeTimer_GiveIncome()
    call TimerDialogSetTitle(td,months[month] + " " + I2S(year))
    set s = LoadStr(eventHash,month,year)
    if s != "" then
        call ExecuteFunc(s)
    endif
endfunction
private function InitMonthTimer takes nothing returns nothing
    call TimerStart(T,INTERVAL,true,function MonthTick)
    set td = CreateTimerDialog(T)
    call TimerDialogSetTitle(td,months[month] + " " + I2S(year))
    call TimerDialogDisplay(td,true)
    call DestroyTimer(GetExpiredTimer())
endfunction
private function init takes nothing returns nothing
    debug local trigger t = CreateTrigger()
    debug call TriggerRegisterPlayerEvent(t,Player(0),EVENT_PLAYER_ARROW_DOWN_DOWN)
    debug call TriggerRegisterPlayerEvent(t,Player(6),EVENT_PLAYER_ARROW_DOWN_DOWN)
    debug call TriggerAddAction(t,function MonthTick)
    
    set months[0] = "January"
    set months[1] = "February"
    set months[2] = "March"
    set months[3] = "April"
    set months[4] = "May"
    set months[5] = "June"
    set months[6] = "July"
    set months[7] = "August"
    set months[8] = "September"
    set months[9] = "October"
    set months[10] = "November"
    set months[11] = "December"
endfunction
public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),0.,false,function InitMonthTimer)
endfunction
endlibrary
