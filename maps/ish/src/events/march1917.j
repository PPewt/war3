//! runtextmacro EventBefore("March","1917")
    //Commonwealth gets the USA
    call KillDestructablesRect(gg_rct_ANZACUSA)
    call GivePlayerRect(COMMONWEALTH,gg_rct_ANZACUSA)
    call DisplayRect(WEST_GERMANY,gg_rct_ANZACUSA)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00March 1917|r - Frustrated by unrestricted submarine warfare and feeling unsympathetic towards Germany, |cffffcc00the United States of America declare war on the Central Powers and join the Entente Powers.|r")
    
    call RussianRevolution_CheckStart()
//! runtextmacro EventAfter()
