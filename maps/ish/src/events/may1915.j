//! runtextmacro EventBefore("May","1915")
    //Italy gets Italy and Libya
    call KillDestructablesRect(gg_rct_Italy1)
    call KillDestructablesRect(gg_rct_ItalyLibya)
    call KillDestructablesRect(gg_rct_ItalyGreece)
    call GivePlayerRect(ITALY,gg_rct_Italy1)
    call GivePlayerRect(ITALY,gg_rct_ItalyLibya)
    call GivePlayerRect(ITALY,gg_rct_ItalyGreece)
    call GarrisonTrenchesRect(ITALY,gg_rct_ItalyTrenches1)
    call GarrisonTrenchesRect(ITALY,gg_rct_ItalyTrenches2)
    call GarrisonTrenchesRect(ITALY,gg_rct_ItalyTrenches3)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00May 1915|r - Though allied with Germany and Austria-Hungary, Italian aspirations for the Dalmatian Coast, considered by many Italians to be rightfully theirs, lead to |cffffcc00Italy declaring war on the Central Powers and joining the Entente Powers.|r")
    call SetPlayerState(ITALY,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(ITALY,PLAYER_STATE_RESOURCE_GOLD)+1500)
    call DisplayRect(AUSTRIA,gg_rct_Italy1)
    call DisplayRect(AUSTRIA,gg_rct_ItalyLibya)
    call DisplayRect(AUSTRIA,gg_rct_ItalyGreece)
//! runtextmacro EventAfter()
