library PrismaticSprayRays requires PrismaticSprayGeometry, PrismaticSprayConfig
// Handles drawing rays and applying their effects. Ray effects are mainly
// handled via callbacks, and have an effect that's applied the first
// time a unit is hit (the initial effect) and one that's applied every time
// a unit is hit again (the ongoing effect).

globals
    private constant hashtable rays     = InitHashtable()
    private constant timer     T        = CreateTimer()
    private constant group     G        = CreateGroup()
    private          integer   numRays  = 0
 
    private constant real      RADIUS   = 2.*RMaxBJ(PrismaticSprayConfig_RAY_EFFECT_LENGTH, PrismaticSprayConfig_RAY_EFFECT_WIDTH)
endglobals

public function interface RayEffect takes unit source, unit target, integer level returns nothing

public function NoInitialEffect takes unit source, unit target, integer level returns nothing
endfunction
public function NoOngoingEffect takes unit source, unit target, integer level returns nothing
endfunction

private struct RayStruct
    Rectangle rayRect
    unit owner
    real lifespan
    group targetedUnits
    integer level
    RayEffect callbackInitial
    RayEffect callbackOngoing
    static method create takes nothing returns thistype
        local thistype this = thistype.allocate()
        set this.targetedUnits = CreateGroup()
        return this
    endmethod
    method onDestroy takes nothing returns nothing
        call GroupClear(this.targetedUnits)
        call DestroyGroup(this.targetedUnits)
        set this.targetedUnits = null
        set this.owner = null
        call this.rayRect.destroy()
    endmethod
endstruct

private function RayTimerLoop takes nothing returns nothing
    local RayStruct current
    local integer i = 0
    local unit u
    loop
        exitwhen i == numRays
        set current = LoadInteger(rays,i,0)
        call GroupEnumUnitsInRange(G, current.rayRect.p1x, current.rayRect.p1y, RADIUS, Filter(function PrismaticSprayConfig_TargetFilter))
        loop
            set u = FirstOfGroup(G)
            exitwhen u == null
            if current.rayRect.containsPoint(GetUnitX(u), GetUnitY(u)) then
                if not IsUnitInGroup(u, current.targetedUnits) then
                    call current.callbackInitial.evaluate(current.owner, u, current.level)
                    call GroupAddUnit(current.targetedUnits, u)
                endif
                call current.callbackOngoing.evaluate(current.owner, u, current.level)
            endif
            call GroupRemoveUnit(G,u)
        endloop
        set current.lifespan = current.lifespan - PrismaticSprayConfig_RAY_TIMER_TICK
        if current.lifespan <= 0. then
            call current.destroy()
            call SaveInteger(rays, i, 0, LoadInteger(rays, 0, numRays - 1))
            set numRays = numRays - 1
            call FlushChildHashtable(rays, numRays)
        else
            set i = i + 1
        endif
    endloop
    if numRays == 0 then
        call PauseTimer(T)
    endif
endfunction

function FireRay takes unit owner, string sfx, real sourcex, real sourcey, real angle, real height, integer level, RayEffect initialEffect, RayEffect ongoingEffect returns nothing
    local RayStruct ray = RayStruct.create()
    set ray.rayRect = Rectangle.createFacing(sourcex, sourcey, PrismaticSprayConfig_RAY_EFFECT_WIDTH, PrismaticSprayConfig_RAY_EFFECT_LENGTH, angle)
    set ray.owner = owner
    set ray.callbackInitial = initialEffect
    set ray.callbackOngoing = ongoingEffect
    set ray.lifespan = PrismaticSprayConfig_RAY_EFFECT_DURATION
    set ray.level = level
    call DisplayEffectInLine(sfx, sourcex, sourcey, PrismaticSprayConfig_RAY_EFFECT_LENGTH, angle, PrismaticSprayConfig_RAY_EFFECT_HEIGHT, PrismaticSprayConfig_RAY_EFFECT_COUNT)
 
    call SaveInteger(rays, numRays, 0, ray)
    set numRays = numRays + 1
    if numRays == 1 then
        call TimerStart(T, PrismaticSprayConfig_RAY_TIMER_TICK, true, function RayTimerLoop)
    endif
endfunction
endlibrary
