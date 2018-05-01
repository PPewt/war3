//! runtextmacro EventBefore("October","1916")
    //Commonwealth gets the Arab Revolt
    call KillDestructablesRect(gg_rct_Arabs)
    call GivePlayerRect(COMMONWEALTH,gg_rct_Arabs)
    call GarrisonTrenchesRect(COMMONWEALTH,gg_rct_ArabiaTrenches1)
    call GarrisonTrenchesRect(COMMONWEALTH,gg_rct_ArabiaTrenches2)
    call DisplayRect(OTTOMAN_EMPIRE,gg_rct_Arabs)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00October 1916|r - Hoping to create a unified Arabian state, |cffffcc00Arabs on the borders of the Ottoman Empire begin to fight alongside the Entente Powers and attack the Central Powers!|r")
//! runtextmacro EventAfter()
