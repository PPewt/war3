//! runtextmacro EventBefore("August","1914")
    //Bulgaria gets Thrace
    call GivePlayerRect(BULGARIA,gg_rct_BulgarianThrace)
    call SetPlayerState(BULGARIA,PLAYER_STATE_RESOURCE_GOLD,1000)
    
    //Ottomans get Ottomans
    call KillDestructablesRect(gg_rct_OttomanTurkey)
    call KillDestructablesRect(gg_rct_OttomanPersia)
    call KillDestructablesRect(gg_rct_OttomanLevant)
    call GivePlayerRect(OTTOMAN_EMPIRE,gg_rct_OttomanTurkey)
    call GivePlayerRect(OTTOMAN_EMPIRE,gg_rct_OttomanPersia)
    call GivePlayerRect(OTTOMAN_EMPIRE,gg_rct_OttomanLevant)
    call GarrisonTrenchesRect(OTTOMAN_EMPIRE,gg_rct_OttomanTrenches1)
    call GarrisonTrenchesRect(OTTOMAN_EMPIRE,gg_rct_OttomanTrenches2)
    call GarrisonTrenchesRect(OTTOMAN_EMPIRE,gg_rct_OttomanTrenches3)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00August 1914|r - |cffffcc00The Ottoman Empire, allied with the German Empire for several years before, joins the Central Powers and declares war on the Entente Powers.|r")
    call SetPlayerState(OTTOMAN_EMPIRE,PLAYER_STATE_RESOURCE_GOLD,700)
    call DisplayRect(COMMONWEALTH,gg_rct_OttomanTurkey)
    call DisplayRect(COMMONWEALTH,gg_rct_OttomanPersia)
    call DisplayRect(COMMONWEALTH,gg_rct_OttomanLevant)
    
    //Commonwealth gets Egypt
    call GivePlayerRect(COMMONWEALTH,gg_rct_ANZACEgypt)
    call GarrisonTrenchesRect(COMMONWEALTH,gg_rct_EgyptTrenches)
    call DisplayTimedTextToPlayer(COMMONWEALTH,0.,0.,20.,"You have been granted control of |cffffcc00Egypt|r. Prepare for war with the Ottoman Empire!")
    call DisplayRect(OTTOMAN_EMPIRE,gg_rct_ANZACEgypt)
//! runtextmacro EventAfter()
