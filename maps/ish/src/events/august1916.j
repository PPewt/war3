//! runtextmacro EventBefore("August","1916")
    //Serbia gets Northern Greece
    call KillDestructablesRect(gg_rct_BalkanNorthGreece)
    call GivePlayerRect(SERBIA,gg_rct_BalkanNorthGreece)
    call GarrisonTrenchesRect(SERBIA,gg_rct_NorthGreeceTrenches1)
    call GarrisonTrenchesRect(SERBIA,gg_rct_NorthGreeceTrenches2)
    call GarrisonTrenchesRect(SERBIA,gg_rct_NorthGreeceTrenches3)
    call GarrisonTrenchesRect(SERBIA,gg_rct_NorthGreeceTrenches4)
    call DisplayRect(BULGARIA,gg_rct_BalkanNorthGreece)
    
    //Serbia gets Romania
    call KillDestructablesRect(gg_rct_BalkanRomania)
    call GivePlayerRect(SERBIA,gg_rct_BalkanRomania)
    call GarrisonTrenchesRect(SERBIA,gg_rct_RomaniaTrenches1)
    call GarrisonTrenchesRect(SERBIA,gg_rct_RomaniaTrenches2)
    call GarrisonTrenchesRect(SERBIA,gg_rct_RomaniaTrenches3)
    call GarrisonTrenchesRect(SERBIA,gg_rct_RomaniaTrenches4)
    call DisplayRect(BULGARIA,gg_rct_BalkanRomania)
    
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00August 1916|r - Under pressure from the Entente Powers, |cffffcc00Romania enters the war on the side of the Entente Powers and declares war on the Central Powers.|r A pro-Entente coup based in Thessaloniki leads to Greece splitting in half, and |cffffcc00Northern Greece declares war on the Central Powers and joins the Entente Powers.|r")
//! runtextmacro EventAfter()
