library PrismaticSprayConfig
//===========================================================================================
//=                                      Configuration                                      =
//===========================================================================================
globals
    public constant integer ABILITY_ID = 'A000'
    public constant integer DUMMY = 'e000'
 
    //The point after the beginning of the animation at which the rays should fire (animation-based)
    public constant real EFFECT_POINT_TIME = 0.45
    //The point after which each "round" of the spell ends
    //The spell duration should be a multiple of this
    public constant real EFFECT_END_TIME = 1.208
    //The offset towards the target from the centre of the hero where the effect should begin (model-based)
    public constant real EFFECT_POINT_XY_FORWARD = 75.
    //The offset perpendicular to the target from the centre of the model where the effect should begin (model-based)
    public constant real EFFECT_POINT_XY_PERP = 0.
    //The height at which the effect should begin (model-based)
    public constant real EFFECT_POINT_Z = 30.
 
    //The number of SFX displayed in a line per ray
    public constant integer RAY_EFFECT_COUNT = 15
    //The length of each ray
    public constant real RAY_EFFECT_LENGTH = 500.
    //The width of each ray's effect
    public constant real RAY_EFFECT_WIDTH = 100.
    //The elevation of each ray's special effects
    public constant real RAY_EFFECT_HEIGHT = 30.
    //The length of time that each ray applies its effect
    //.9s is appropriate for most sfx.
    public constant real RAY_EFFECT_DURATION = .9
    //Frequency at which ray effects are checked
    public constant real RAY_TIMER_TICK = .03
 
    //The size of the arc (in radians) in which rays are emitted
    public constant real RAY_EFFECT_ARC = bj_PI/2.
 
    //Enemies below this much health die instantly when hit by a dark ray.
    public constant real DARK_RAY_KILL_THRESHOLD = 200.
 
    //Special effect models
    public constant string RAY_OF_FIRE_EFFECT = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
    public constant string RAY_OF_FROST_EFFECT = "Abilities\\Weapons\\ZigguratFrostMissile\\ZigguratFrostMissile.mdl"
    public constant string HOLY_RAY_EFFECT = "Abilities\\Weapons\\FaerieDragonMissile\\FaerieDragonMissile.mdl"
    public constant string DARK_RAY_EFFECT = "Abilities\\Weapons\\BansheeMissile\\BansheeMissile.mdl"
    public constant string ARCANE_RAY_EFFECT = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl"
 
    //Spell IDs and OrderIDs
    public constant integer ARCANE_RAY_HASTE_ID  = 'A001'
    public constant integer ARCANE_RAY_SLOW_ID   = 'A002'
    public constant integer RAY_OF_FROST_SLOW_ID = 'A003'
    public constant integer RAY_OF_FIRE_BURN_ID  = 'A004'
    public constant integer DARK_RAY_STUN_ID     = 'A005'
 
    public constant integer ARCANE_RAY_HASTE_ORDER_ID  = 852101
    public constant integer ARCANE_RAY_SLOW_ORDER_ID   = 852075
    public constant integer RAY_OF_FROST_SLOW_ORDER_ID = 852226
    public constant integer RAY_OF_FIRE_BURN_ORDER_ID  = 852662
    public constant integer DARK_RAY_STUN_ORDER_ID     = 852095
endglobals

//Level-based effects
public function RayOfFrostDamageTick takes integer level returns real
    return 2. + I2R(level)
endfunction
public function RayOfFireDamageTick takes integer level returns real
    return 3. + 2.*I2R(level)
endfunction
public function HolyRayHealingTick takes integer level returns real
    return 5. + 3.*I2R(level)
endfunction

//You can use GetRandomInt to randomize the number of rays somewhat
public function RaysPerLevel takes integer level returns integer
    return GetRandomInt(3,5) + level
endfunction

public function TargetFilter takes nothing returns boolean
    return GetWidgetLife(GetFilterUnit()) > 0. and not (IsUnitType(GetFilterUnit(), UNIT_TYPE_FLYING) or IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE))
endfunction
endlibrary
