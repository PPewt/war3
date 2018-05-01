// Small parts of the factory and barracks system that need to be globally
// available so that they can be called by various parts of the code.

library BuildingAutomation requires Rawcodes, Players
struct BuildingData
    integer tick  //used for tracking time
    integer count //used for counting, notably size of production queues
    integer owner //used for keeping track of the owner of the building.
                  //if the building is not capturable, then this should be -1
    boolean visibleTT
    texttag tt
    
    integer lastBuilt // For requeueing when a player drops below 300 gold
    
    unit uowner
    
    private static group    req = CreateGroup() // Factories that need to requeue
    private static hashtable ht = InitHashtable()
    static method create takes unit u returns thistype
        local thistype this = thistype.allocate()
        set this.tick = 0
        set this.count = 0
        set this.owner = -1
        set this.tt = null
        set this.visibleTT    = true
        call this.attach(u)
        return this
    endmethod
    method onDestroy takes nothing returns nothing
        if this.tt != null then
            call DestroyTextTag(this.tt)
            set this.tt = null
        endif
        call this.detatch(this.uowner)
    endmethod
    static method createOwner takes unit u returns thistype
        local thistype this = thistype.create(u)
        set this.owner = Players_ToCountry(GetOwningPlayer(u))
        return this
    endmethod
    static method get takes unit u returns thistype
        local thistype this = LoadInteger(thistype.ht,GetHandleId(u),0)
        local integer id = GetUnitTypeId(u)
        if this <= 0 then
            if id == FACTORY or id == BARRACKS then
                set this = thistype.create(u)
            elseif GetUnitAbilityLevel(u,TOWN_INCOME_ABILITY) > 0 or id == TRADE_DOCKS then
                set this = thistype.createOwner(u)
            endif
        endif
        return this
    endmethod
    method attach takes unit u returns nothing
        call SaveInteger(thistype.ht,GetHandleId(u),0,this)
        if GetUnitTypeId(u) == FACTORY then
            set this.tt = CreateTextTag()
            call SetTextTagPermanent(this.tt, true)
            call SetTextTagVisibility(this.tt, GetLocalPlayer() == GetOwningPlayer(u) and this.visibleTT)
            call SetTextTagPos(this.tt,GetUnitX(u)-2.5*(FACTORY_PROGRESS_LEN/4),GetUnitY(u),100.)
        endif
        set this.uowner = u
    endmethod
    method detatch takes unit u returns nothing
        call FlushChildHashtable(thistype.ht,GetHandleId(u))
        if this.uowner == u then
            set this.uowner = null
        endif
    endmethod
    method setConstructing takes boolean b returns nothing
        if b then
            call DestroyTextTag(this.tt)
            set this.count = 100
        else
            set this.count = 0
            set this.tt = CreateTextTag()
            call SetTextTagPermanent(this.tt, true)
            call SetTextTagVisibility(this.tt, GetLocalPlayer() == GetOwningPlayer(this.uowner) and this.visibleTT)
            call SetTextTagPos(this.tt,GetUnitX(this.uowner)-2.5*(FACTORY_PROGRESS_LEN/4),GetUnitY(this.uowner),100.)
        endif
    endmethod
    method buildUnit takes integer id returns boolean
        local integer foodneeded = 1
        if id == FREE_MORTAR then
            set foodneeded = 2
        endif
        if (GetPlayerState(GetOwningPlayer(this.uowner),PLAYER_STATE_RESOURCE_FOOD_CAP) - GetPlayerState(GetOwningPlayer(this.uowner),PLAYER_STATE_RESOURCE_FOOD_USED)) >= foodneeded then
            call IssueImmediateOrderById(this.uowner,id)
            set this.lastBuilt = 0
            return true
        endif
        call GroupAddUnit(thistype.req, this.uowner)
        set this.lastBuilt = id
        return false
    endmethod
    
    static method attemptRequeueUnit takes nothing returns nothing
        local BuildingData this = BuildingData.get(GetEnumUnit())
        if this.buildUnit(this.lastBuilt) then
            call GroupRemoveUnit(thistype.req, this.uowner)
        endif
    endmethod
    static method attemptRequeue takes nothing returns nothing
        call ForGroup(thistype.req, function thistype.attemptRequeueUnit)
    endmethod
endstruct


function StartFactory takes unit u, BuildingData dat returns nothing
    local player p = GetOwningPlayer(u)
    local integer i = GetPlayerState(p,PLAYER_STATE_RESOURCE_FOOD_CAP)
    //This should be extended to barracks if they're ever automated in this manner
    if GetUnitTypeId(u) == FACTORY or GetUnitTypeId(u) == BARRACKS then
        if dat == 0 and GetWidgetLife(u) > 0. then
            set dat = BuildingData.get(u)
        else
            call dat.attach(u)
        endif
        if GetUnitTypeId(u) == BARRACKS then
            call dat.buildUnit(INFANTRY[Players_ToCountry(p)])
        endif
    endif
endfunction

function IssueRallyPointOrder takes unit u, unit rally returns nothing
    local location l = GetUnitRallyPoint(rally)
    local unit u2 = GetUnitRallyUnit(rally)
    if u2 != null and u2 != rally then
        call IssueTargetOrder(u,"patrol",u2)
    elseif l != null then
        call IssuePointOrderLoc(u,"attack",l)
    endif
    if l != null then
        call RemoveLocation(l)
        set l = null
    endif
    set u2 = null
endfunction
endlibrary
