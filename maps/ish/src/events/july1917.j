//! runtextmacro EventBefore("July","1917")
    local integer i = 0
    local unit sofia = GetCapitalUnit(SOFIA)
    //Serbia gets Southern Greece
    call KillDestructablesRect(gg_rct_BalkanSouthGreece)
    call GivePlayerRect(SERBIA,gg_rct_BalkanSouthGreece)
    call GarrisonTrenchesRect(SERBIA,gg_rct_SouthGreeceTrenches)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00July 1917|r - Frustrated by King Constantine I of Greece's refusal to join the war, Britain threatens bombardment of major Greek cities if Constantine does not declare war. Constantine abdicates, and his son chooses that |cffffcc00Greece declares war on the Central Powers and joins the Entente Powers.|r")
    call DisplayRect(BULGARIA,gg_rct_BalkanSouthGreece)
    
    //Enable sending supplies to Greece
    call FakeUpgrade_Research(GREAT_BRITAIN,GREECE_ACTIVE)
    call FakeUpgrade_Research(COMMONWEALTH,GREECE_ACTIVE)
    
    //France and the Commonwealth get access to Renaults
    call SetPlayerTechResearched(FRANCE,R_JULY_1917,1)
    call SetPlayerTechResearched(COMMONWEALTH,R_JULY_1917,1)
    
    //Bulgaria gets 10 infantry and a howitzer
    if GetOwningPlayer(sofia) == BULGARIA then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00Bulgaria bolsters its army to deal with this new threat.|r")
        call CreateUnit(BULGARIA,HOWITZER_PACKED,GetUnitX(sofia),GetUnitY(sofia),270.)
        loop
            exitwhen i > 9
            call CreateUnit(BULGARIA,INFANTRY[BULGARIA_ID],GetUnitX(sofia),GetUnitY(sofia),270.)
            set i = i + 1
        endloop
    endif
    set sofia = null
    
    call RussianRevolution_MinorRevolt()
//! runtextmacro EventAfter()
