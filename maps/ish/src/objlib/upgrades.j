//This is where you set which upgrades should be available/unavailable to each player

library Upgrades requires Rawcodes, Players
public function Initialize takes nothing returns nothing
    call SetPlayerTechMaxAllowed(RUSSIA,         R_HEAVY_ARTILLERY,   0)
    call SetPlayerTechMaxAllowed(FRANCE,         R_HEAVY_ARTILLERY,   1)
    call SetPlayerTechMaxAllowed(GREAT_BRITAIN,  R_HEAVY_ARTILLERY,   1)
    call SetPlayerTechMaxAllowed(ITALY,          R_HEAVY_ARTILLERY,   0)
    call SetPlayerTechMaxAllowed(SERBIA,         R_HEAVY_ARTILLERY,   0)
    call SetPlayerTechMaxAllowed(COMMONWEALTH,   R_HEAVY_ARTILLERY,   0)
    call SetPlayerTechMaxAllowed(OTTOMAN_EMPIRE, R_HEAVY_ARTILLERY,   0)
    call SetPlayerTechMaxAllowed(BULGARIA,       R_HEAVY_ARTILLERY,   0)
    call SetPlayerTechMaxAllowed(AUSTRIA,        R_HEAVY_ARTILLERY,   1)
    call SetPlayerTechMaxAllowed(HUNGARY,        R_HEAVY_ARTILLERY,   1)
    call SetPlayerTechMaxAllowed(EAST_GERMANY,   R_HEAVY_ARTILLERY,   1)
    call SetPlayerTechMaxAllowed(WEST_GERMANY,   R_HEAVY_ARTILLERY,   1)
    
    call SetPlayerTechMaxAllowed(RUSSIA,         R_FIAT,   0)
    call SetPlayerTechMaxAllowed(FRANCE,         R_FIAT,   0)
    call SetPlayerTechMaxAllowed(GREAT_BRITAIN,  R_FIAT,   0)
    call SetPlayerTechMaxAllowed(ITALY,          R_FIAT,   1)
    call SetPlayerTechMaxAllowed(SERBIA,         R_FIAT,   0)
    call SetPlayerTechMaxAllowed(COMMONWEALTH,   R_FIAT,   0)
    call SetPlayerTechMaxAllowed(OTTOMAN_EMPIRE, R_FIAT,   0)
    call SetPlayerTechMaxAllowed(BULGARIA,       R_FIAT,   0)
    call SetPlayerTechMaxAllowed(AUSTRIA,        R_FIAT,   0)
    call SetPlayerTechMaxAllowed(HUNGARY,        R_FIAT,   0)
    call SetPlayerTechMaxAllowed(EAST_GERMANY,   R_FIAT,   0)
    call SetPlayerTechMaxAllowed(WEST_GERMANY,   R_FIAT,   0)
    
    call SetPlayerTechResearched(AUSTRIA,        R_HEAVY_ARTILLERY, 1)
    call SetPlayerTechResearched(HUNGARY,        R_HEAVY_ARTILLERY, 1)
    call SetPlayerTechResearched(EAST_GERMANY,   R_HEAVY_ARTILLERY, 1)
    call SetPlayerTechResearched(WEST_GERMANY,   R_HEAVY_ARTILLERY, 1)
endfunction
endlibrary
