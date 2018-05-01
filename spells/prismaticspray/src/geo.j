library PrismaticSprayGeometry requires PrismaticSprayConfig
// A reasonably efficient implementation of some needed geometry helpers for
// Prismatic Ray

struct Rectangle
    real p1x
    real p2x
    real p3x
    real p4x
    real p1y
    real p2y
    real p3y
    real p4y
 
    real x12diff
    real x23diff
    real x34diff
    real x41diff
    real y12diff
    real y23diff
    real y34diff
    real y41diff
 
    //1 and 3 (and also 2 and 4) are opposite corners
    static method create takes real x1, real y1, real x2, real y2, real x3, real y3, real x4, real y4 returns thistype
        local thistype this = thistype.allocate()
        set this.p1x = x1
        set this.p2x = x2
        set this.p3x = x3
        set this.p4x = x4
        set this.p1y = y1
        set this.p2y = y2
        set this.p3y = y3
        set this.p4y = y4
        set this.x12diff = x2 - x1
        set this.x23diff = x3 - x2
        set this.x34diff = x4 - x3
        set this.x41diff = x1 - x4
        set this.y12diff = y2 - y1
        set this.y23diff = y3 - y2
        set this.y34diff = y4 - y3
        set this.y41diff = y1 - y4
        return this
    endmethod
 
    static method createFacing takes real px, real py, real width, real length, real angle returns thistype
        local real perpAngle = angle + bj_PI/2.
        local real offsetCosP = width/2. * Cos(perpAngle)
        local real offsetSinP = width/2. * Sin(perpAngle)
        local real lenCos = length * Cos(angle)
        local real lenSin = length * Sin(angle)
        local real p1x = px - offsetCosP
        local real p1y = py - offsetSinP
        local real p2x = px + offsetCosP
        local real p2y = py + offsetSinP
        return thistype.create(p1x, p1y, p2x, p2y, p2x + lenCos, p2y + lenSin, p1x + lenCos, p1y + lenSin)
    endmethod
 
    method containsPoint takes real px, real py returns boolean
      return (py - this.p1y) * this.x12diff <= (px - this.p1x) * this.y12diff and (py - this.p2y) * this.x23diff <= (px - this.p2x) * this.y23diff and (py - this.p3y) * this.x34diff <= (px - this.p3x) * this.y34diff and (py - this.p4y) * this.x41diff <= (px - this.p4x) * this.y41diff
    endmethod
endstruct

//Requires Count >= 2
function DisplayEffectInLine takes string model, real px, real py, real distance, real angle, real height, integer count returns nothing
    local real dx = px + distance * Cos(angle)
    local real dy = py + distance * Sin(angle)
    local real dist = SquareRoot((dx - px) * (dx - px) + (dy - py) * (dy - py))
    local real vx = distance/I2R(count - 1) * Cos(angle)
    local real vy = distance/I2R(count - 1) * Sin(angle)
    local unit u
    loop
        set count = count - 1
        exitwhen count <= 0
        set u = CreateUnit(Player(15), PrismaticSprayConfig_DUMMY, px, py, 270.)
        call UnitApplyTimedLife(u, 'BTLF', 2.)
        call SetUnitFlyHeight(u, height, 0.)
        call SetUnitExploded(u, true)
        call DestroyEffect(AddSpecialEffectTarget(model, u, "origin"))
        set px = px + vx
        set py = py + vy
    endloop
    set u = null
endfunction
endlibrary
