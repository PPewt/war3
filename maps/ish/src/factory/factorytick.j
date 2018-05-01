// Register various gerneric events to do with factories

scope FactoryTick initializer init
private function Enum takes nothing returns nothing
    local unit u = GetEnumUnit()
    local BuildingData dat = BuildingData.get(u)
    local player p = GetOwningPlayer(u)
    local string text
    local integer len
    if dat.count <= 0 then
        set dat.tick = dat.tick + 1
        if dat.tick >= FACTORY_INTERVAL then
            set dat.tick = dat.tick - FACTORY_INTERVAL
            call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+FACTORY_WORTH)
            call DisplayIncomeTextTag(u,FACTORY_WORTH)
        endif
        set len = FACTORY_PROGRESS_STEP*R2I(I2R(dat.tick)/(I2R(FACTORY_INTERVAL-1)/I2R(FACTORY_PROGRESS_LEN)))
        set text = "|cffffcc00" + SubString(FACTORY_PROGRESS,0,len) + "|r" + SubString(FACTORY_PROGRESS,len,FACTORY_PROGRESS_LEN*FACTORY_PROGRESS_STEP)
        call SetTextTagText(dat.tt, text, .01)
    endif
    set u = null
endfunction

private function FactoryAlive takes nothing returns boolean
    return GetWidgetLife(GetFilterUnit()) > 0.
endfunction

private function Tick takes nothing returns nothing
    call GroupEnumUnitsOfType(enumGrp,"custom_h00V",Filter(function FactoryAlive))
    call ForGroup(enumGrp,function Enum)
endfunction

private function FactoryStart takes nothing returns boolean
    local BuildingData dat = BuildingData.get(GetTriggerUnit())
    if GetUnitTypeId(GetTriggerUnit()) == FACTORY then
        set dat.count = dat.count + 1
    endif
    return false
endfunction

private function FactoryFinish takes nothing returns boolean
    local BuildingData dat = BuildingData.get(GetTriggerUnit())
    if GetUnitTypeId(GetTriggerUnit()) == FACTORY then
        set dat.count = dat.count - 1
    endif
    return false
endfunction

private function FactoryDeath takes nothing returns boolean
    local BuildingData dat = BuildingData.get(GetTriggerUnit())
    if GetUnitTypeId(GetTriggerUnit()) == FACTORY and dat != 0 and dat.owner < 0 then
        call dat.destroy()
    endif
    return false
endfunction

private function ToggleTTVisibility takes nothing returns boolean
    local BuildingData dat = BuildingData.get(GetTriggerUnit())
    if GetSpellAbilityId() == 'A018' and dat != 0 then
        set dat.visibleTT = not dat.visibleTT
        call SetTextTagVisibility(dat.tt, GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) and dat.visibleTT)
    endif
    return false
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_TRAIN_START)
    call TriggerAddCondition(t, Condition(function FactoryStart))
    
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_TRAIN_CANCEL)
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_TRAIN_FINISH)
    call TriggerAddCondition(t, Condition(function FactoryFinish))
    
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(t, Condition(function FactoryDeath))
    
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t, Condition(function ToggleTTVisibility))
    
    call TimerStart(CreateTimer(),1.,true,function Tick)
endfunction
endscope
