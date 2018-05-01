//This is where you set which abilities are available/unavailable to each player

library Abilities requires Rawcodes
public function Initialize takes nothing returns nothing
    call SetPlayerAbilityAvailable(RUSSIA,         SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(FRANCE,         SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(GREAT_BRITAIN,  SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(ITALY,          SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(SERBIA,         SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(COMMONWEALTH,   SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(OTTOMAN_EMPIRE, SEND_SENUSSI_REBELS,  true)
    call SetPlayerAbilityAvailable(BULGARIA,       SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(AUSTRIA,        SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(HUNGARY,        SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(EAST_GERMANY,   SEND_SENUSSI_REBELS, false)
    call SetPlayerAbilityAvailable(WEST_GERMANY,   SEND_SENUSSI_REBELS, false)
    
    call SetPlayerAbilityAvailable(RUSSIA,         SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(FRANCE,         SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(GREAT_BRITAIN,  SEND_GOLD_TO_GREECE,  true)
    call SetPlayerAbilityAvailable(ITALY,          SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(SERBIA,         SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(COMMONWEALTH,   SEND_GOLD_TO_GREECE,  true)
    call SetPlayerAbilityAvailable(OTTOMAN_EMPIRE, SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(BULGARIA,       SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(AUSTRIA,        SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(HUNGARY,        SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(EAST_GERMANY,   SEND_GOLD_TO_GREECE, false)
    call SetPlayerAbilityAvailable(WEST_GERMANY,   SEND_GOLD_TO_GREECE, false)
    
    call SetPlayerAbilityAvailable(RUSSIA,         CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(FRANCE,         CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(GREAT_BRITAIN,  CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(ITALY,          CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(SERBIA,         CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(COMMONWEALTH,   CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(OTTOMAN_EMPIRE, CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(BULGARIA,       CHANGE_TRANSPORT,  true)
    call SetPlayerAbilityAvailable(AUSTRIA,        CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(HUNGARY,        CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(EAST_GERMANY,   CHANGE_TRANSPORT, false)
    call SetPlayerAbilityAvailable(WEST_GERMANY,   CHANGE_TRANSPORT, false)
endfunction
endlibrary
