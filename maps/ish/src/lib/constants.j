// Various global constants that need to be available everywhere

library Constants requires Rawcodes
globals
    constant integer FACTORY_WORTH        = 125 //Value that factories produce every interval
    constant integer FACTORY_INTERVAL     = 60  //Number of seconds between factory productions
    constant integer AMERICAN_TANK_WORTH  = 200 //Value paid to France when an American tank is produced
    constant integer CENTRAL_TANK_WORTH   = 200 //Value paid to Germany when an Austrian tank is produced
    
    constant real    SPAWN_SHIPS_INTERVAL = 60. //Frequency of merchant ship spawns
    constant integer SPAWN_SHIPS_CHANCE   = 8   //Per pair of trade docks there is a 1 in this much chance of spawning a ship
    constant integer SHIP_WORTH           = 40  //Gold value of a single merchant ship
endglobals
endlibrary
