scope PrismaticSpray initializer init
// The main spell logic

globals
    private constant hashtable timers = InitHashtable()
endglobals

private function CastSpell takes unit caster, unit target, integer level, integer spell, integer order returns nothing
    local unit dumm = CreateUnit(GetOwningPlayer(caster), PrismaticSprayConfig_DUMMY, GetUnitX(caster), GetUnitY(caster), Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)) * bj_RADTODEG)
    call UnitApplyTimedLife(dumm, 'BTLF', 5.)
    call SetUnitExploded(dumm, true)
    call UnitAddAbility(dumm, spell)
    call SetUnitAbilityLevel(dumm, spell, level)
    call IssueTargetOrderById(dumm, order, target)
    set dumm = null
endfunction

private function RayOfFrostInitial takes unit source, unit target, integer level returns nothing
    if IsPlayerEnemy(GetOwningPlayer(target), GetOwningPlayer(source)) then
        call CastSpell(source, target, level, PrismaticSprayConfig_RAY_OF_FROST_SLOW_ID, PrismaticSprayConfig_RAY_OF_FROST_SLOW_ORDER_ID)
    endif
endfunction
private function RayOfFrostOngoing takes unit source, unit target, integer level returns nothing
    if IsPlayerEnemy(GetOwningPlayer(target), GetOwningPlayer(source)) then
        call UnitDamageTarget(source, target, PrismaticSprayConfig_RayOfFrostDamageTick(level), false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
    endif
endfunction

private function RayOfFireInitial takes unit source, unit target, integer level returns nothing
    if IsPlayerEnemy(GetOwningPlayer(target),GetOwningPlayer(source)) then
        call CastSpell(source, target, level, PrismaticSprayConfig_RAY_OF_FIRE_BURN_ID, PrismaticSprayConfig_RAY_OF_FIRE_BURN_ORDER_ID)
    endif
endfunction
private function RayOfFireOngoing takes unit source, unit target, integer level returns nothing
    if IsPlayerEnemy(GetOwningPlayer(target), GetOwningPlayer(source)) then
        call UnitDamageTarget(source, target, PrismaticSprayConfig_RayOfFireDamageTick(level), false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
    endif
endfunction

private function HolyRayOngoing takes unit source, unit target, integer level returns nothing
    if IsPlayerAlly(GetOwningPlayer(target), GetOwningPlayer(source)) then
        call SetWidgetLife(target, GetWidgetLife(target) + PrismaticSprayConfig_HolyRayHealingTick(level))
    endif
endfunction

private function DarkRayInitial takes unit source, unit target, integer level returns nothing
    if IsPlayerEnemy(GetOwningPlayer(target), GetOwningPlayer(source)) then
        if GetWidgetLife(target) < PrismaticSprayConfig_DARK_RAY_KILL_THRESHOLD then
            call UnitDamageTarget(source, target, 99999999., false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
        else
            call CastSpell(source, target, level, PrismaticSprayConfig_DARK_RAY_STUN_ID, PrismaticSprayConfig_DARK_RAY_STUN_ORDER_ID)
        endif
    endif
endfunction

private function ArcaneRayInitial takes unit source, unit target, integer level returns nothing
    if IsPlayerEnemy(GetOwningPlayer(target),GetOwningPlayer(source)) then
        call CastSpell(source, target, level, PrismaticSprayConfig_ARCANE_RAY_SLOW_ID, PrismaticSprayConfig_ARCANE_RAY_SLOW_ORDER_ID)
    elseif IsPlayerAlly(GetOwningPlayer(target), GetOwningPlayer(source)) then
        call CastSpell(source, target, level, PrismaticSprayConfig_ARCANE_RAY_HASTE_ID, PrismaticSprayConfig_ARCANE_RAY_HASTE_ORDER_ID)
    endif
endfunction

private struct Data
    unit caster
    integer level
    real angle
    boolean roundEnd
    method onDestroy takes nothing returns nothing
        set this.caster = null
    endmethod
endstruct

private function ShootRays takes Data dat returns nothing
    local real sourcex = GetUnitX(dat.caster) + PrismaticSprayConfig_EFFECT_POINT_XY_FORWARD * Cos(dat.angle) + PrismaticSprayConfig_EFFECT_POINT_XY_PERP * Cos(dat.angle + bj_PI/2.)
    local real sourcey = GetUnitY(dat.caster) + PrismaticSprayConfig_EFFECT_POINT_XY_FORWARD * Sin(dat.angle) + PrismaticSprayConfig_EFFECT_POINT_XY_PERP * Sin(dat.angle + bj_PI/2.)
    local integer numRays = PrismaticSprayConfig_RaysPerLevel(dat.level)
    local real angle = dat.angle - PrismaticSprayConfig_RAY_EFFECT_ARC / 2.
    local real angleIncrement = PrismaticSprayConfig_RAY_EFFECT_ARC / I2R(numRays - 1)
    local integer rayType
    local PrismaticSprayRays_RayEffect initialEffect
    local PrismaticSprayRays_RayEffect ongoingEffect
    local string sfx
    loop
        exitwhen numRays == 0
        set rayType = GetRandomInt(0,4)
        if rayType == 0 then //Fire
            set initialEffect = RayOfFireInitial
            set ongoingEffect = RayOfFireOngoing
            set sfx = PrismaticSprayConfig_RAY_OF_FIRE_EFFECT
        elseif rayType == 1 then //Frost
            set initialEffect = RayOfFrostInitial
            set ongoingEffect = RayOfFireOngoing
            set sfx = PrismaticSprayConfig_RAY_OF_FROST_EFFECT
        elseif rayType == 2 then //Holy
            set initialEffect = PrismaticSprayRays_NoInitialEffect
            set ongoingEffect = HolyRayOngoing
            set sfx = PrismaticSprayConfig_HOLY_RAY_EFFECT
        elseif rayType == 3 then //Dark
            set initialEffect = DarkRayInitial
            set ongoingEffect = PrismaticSprayRays_NoOngoingEffect
            set sfx = PrismaticSprayConfig_DARK_RAY_EFFECT
        elseif rayType == 4 then //Arcane
            set initialEffect = ArcaneRayInitial
            set ongoingEffect = PrismaticSprayRays_NoOngoingEffect
            set sfx = PrismaticSprayConfig_ARCANE_RAY_EFFECT
        endif
        call FireRay(dat.caster, sfx, sourcex, sourcey, angle, PrismaticSprayConfig_EFFECT_POINT_Z, dat.level, initialEffect, ongoingEffect)
        set numRays = numRays - 1
        set angle = angle + angleIncrement
    endloop
endfunction

private function TimerExpires takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local Data dat = GetTimerData(t)
    //Create rays if appropriate, then go to next iteration
    if dat.roundEnd then
        call TimerStart(t, PrismaticSprayConfig_EFFECT_POINT_TIME, false, function TimerExpires)
    else
        call ShootRays(dat)
        call TimerStart(t, PrismaticSprayConfig_EFFECT_END_TIME - PrismaticSprayConfig_EFFECT_POINT_TIME, false, function TimerExpires)
    endif
    set dat.roundEnd = not dat.roundEnd
    set t = null
endfunction

private function Actions takes nothing returns nothing
    local Data dat = Data.create()
    local timer t = NewTimer()
    local real x = GetUnitX(GetTriggerUnit())
    local real y = GetUnitY(GetTriggerUnit())
    set dat.caster = GetTriggerUnit()
    set dat.level = GetUnitAbilityLevel(dat.caster, GetSpellAbilityId())
    set dat.angle = Atan2(GetSpellTargetY() - y, GetSpellTargetX() - x)
    set dat.roundEnd = false
    call SaveTimerHandle(timers, GetHandleId(dat.caster), 0, t)
    call SetTimerData(t,dat)
    call TimerStart(t, PrismaticSprayConfig_EFFECT_POINT_TIME, false, function TimerExpires)
    set t = null
endfunction

private function EndActions takes nothing returns nothing
    local timer t = LoadTimerHandle(timers, GetHandleId(GetTriggerUnit()), 0)
    local Data dat = GetTimerData(t)
    call FlushChildHashtable(timers, GetHandleId(GetTriggerUnit()))
    call dat.destroy()
    call PauseTimer(t)
    call ReleaseTimer(t)
    set t = null
endfunction

private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == PrismaticSprayConfig_ABILITY_ID
endfunction

private function init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t, Condition(function Conditions))
    call TriggerAddAction(t, function Actions)
 
    set t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_FINISH)
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    call TriggerAddCondition(t, Condition(function Conditions))
    call TriggerAddAction(t, function EndActions)
endfunction
endscope
