// A simple damage detection systemused for merchant ships and trenche.s
// Merchant ships are automatically killed when hit by submarines.
// Trenches are debuffed when hit by gas.

library DamageDetect
globals
    Trigger trig = 0
endglobals
struct Trigger
    trigger source = CreateTrigger()
    integer maxunits = 0
    integer units = 0
    private static constant integer UNIT_CAP = 50
    method free takes nothing returns nothing
        set this.units = this.units - 1
        if this.units == 0 and this.maxunits > 10 then
            if this==trig then
                set trig = 0
            endif
            call DestroyTrigger(this.source)
            call this.destroy()
        endif
    endmethod
    static method Execute takes nothing returns boolean
        local unit u = GetTriggerUnit()
        local unit u2 = GetEventDamageSource()
        local real r = GetEventDamage()
        local integer i = GetUnitTypeId(u2)
        local boolean b = i==GAS_DUMMY
        local unit d
        if GetWidgetLife(u)-r>.405 and GetUnitRace(u) == RACE_ORC and (i == HOWITZER or i == GAS_HOWITZER or i == HEAVY_HOWITZER or b) then
            if b or GetUnitAbilityLevel(u,'B006') == 0 then
                set d = CreateUnit(GetOwningPlayer(u2),DUMMY,GetUnitX(u),GetUnitY(u),0)
                call UnitAddAbility(d,'A00X')
                if b then
                    call SetUnitAbilityLevel(d,'A00X',2)
                endif
                call IssueTargetOrder(d,"cripple",u)
                call UnitApplyTimedLife(d,'BTLF',1)
                call SetUnitExploded(d,true)
                set d = CreateUnit(GetOwningPlayer(u2),DUMMY,GetUnitX(u),GetUnitY(u),0)
                call UnitAddAbility(d,'A00Y')
                if b then
                    call SetUnitAbilityLevel(d,'A00Y',2)
                endif
                call IssueTargetOrder(d,"acidbomb",u)
                call UnitApplyTimedLife(d,'BTLF',1)
                call SetUnitExploded(d,true)
                set d = null
            endif
        elseif GetWidgetLife(u)-r>.405 and (GetUnitTypeId(u) == MERCHANT_SHIP or GetUnitTypeId(u) == SUPPLY_SHIP) and (i == SUBMARINE or i == SUBMARINE_SUBMERGED or i == UBOAT or i == UBOAT_SUBMERGED) then
            call UnitDamageTarget(u2,u,1000.,true,false,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,null)
        endif
        set u = null
        set u2 = null
        return false
    endmethod
    static method onInit takes nothing returns nothing
        set trig = thistype.allocate()
        call TriggerAddCondition(trig.source,Condition(function thistype.Execute))
    endmethod
    static method create takes unit reg returns thistype
        if trig == 0 or trig.maxunits >= thistype.UNIT_CAP then
            set trig = thistype.allocate()
            call TriggerAddCondition(trig.source,Condition(function thistype.Execute))
        endif
        set trig.units = trig.units + 1
        set trig.maxunits = trig.maxunits + 1
        call TriggerRegisterUnitEvent(trig.source,reg,EVENT_UNIT_DAMAGED)
        return trig
    endmethod
endstruct
endlibrary
