//! runtextmacro EventBefore("November","1915")
    //Senussi Revolt Begins
    call SetPlayerTechResearched(OTTOMAN_EMPIRE,R_NOVEMBER_1915,1)
    call SetPlayerTechResearched(WEST_GERMANY,R_NOVEMBER_1915,1)
    call SetPlayerTechResearched(EAST_GERMANY,R_NOVEMBER_1915,1)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00November 1915|r - After much courting by German and Turkish diplomats, the Senussi in Libya and Egypt have declared a jihad against the Italians and British. Senussi rebels may now be recruited by some Central powers.")
//! runtextmacro EventAfter()
