// Code to manage players, including both conversions from colours to player
// IDs (used for chat commnads) and logic to recolour and swap players around
// (never fully implemented, intended for autobalance and in-game lobby
// management).

library Players initializer init
globals
    playercolor array PLAYER_COLOUR
    constant integer RUSSIA_BASE_ID         = 0
    constant integer FRANCE_BASE_ID         = 1
    constant integer GREAT_BRITAIN_BASE_ID  = 2
    constant integer ITALY_BASE_ID          = 3
    constant integer SERBIA_BASE_ID         = 4
    constant integer COMMONWEALTH_BASE_ID   = 5
    constant integer OTTOMAN_EMPIRE_BASE_ID = 6
    constant integer BULGARIA_BASE_ID       = 7
    constant integer AUSTRIA_BASE_ID        = 8
    constant integer HUNGARY_BASE_ID        = 9
    constant integer EAST_GERMANY_BASE_ID   = 10
    constant integer WEST_GERMANY_BASE_ID   = 11
    constant integer NEUTRAL_BASE_ID        = 15
             
             integer RUSSIA_ID         = 0
             integer FRANCE_ID         = 1
             integer GREAT_BRITAIN_ID  = 2
             integer ITALY_ID          = 3
             integer SERBIA_ID         = 4
             integer COMMONWEALTH_ID   = 5
             integer OTTOMAN_EMPIRE_ID = 6
             integer BULGARIA_ID       = 7
             integer AUSTRIA_ID        = 8
             integer HUNGARY_ID        = 9
             integer EAST_GERMANY_ID   = 10
             integer WEST_GERMANY_ID   = 11
             integer NEUTRAL_ID        = 15
             player  RUSSIA
             player  FRANCE
             player  GREAT_BRITAIN
             player  ITALY
             player  SERBIA
             player  COMMONWEALTH
             player  OTTOMAN_EMPIRE
             player  BULGARIA
             player  AUSTRIA
             player  HUNGARY
             player  EAST_GERMANY
             player  WEST_GERMANY
             player  NEUTRAL
             
    private integer array playerIdentities
    private integer array countryAssociations
endglobals

public function Initialize takes nothing returns nothing
    set RUSSIA            = Player(RUSSIA_ID)
    set FRANCE            = Player(FRANCE_ID)
    set GREAT_BRITAIN     = Player(GREAT_BRITAIN_ID)
    set ITALY             = Player(ITALY_ID)
    set SERBIA            = Player(SERBIA_ID)
    set COMMONWEALTH      = Player(COMMONWEALTH_ID)
    set OTTOMAN_EMPIRE    = Player(OTTOMAN_EMPIRE_ID)
    set BULGARIA          = Player(BULGARIA_ID)
    set AUSTRIA           = Player(AUSTRIA_ID)
    set HUNGARY           = Player(HUNGARY_ID)
    set EAST_GERMANY      = Player(EAST_GERMANY_ID)
    set WEST_GERMANY      = Player(WEST_GERMANY_ID)
    set NEUTRAL           = Player(NEUTRAL_ID)
    
    set PLAYER_COLOUR[RUSSIA_ID]         = PLAYER_COLOR_RED
    set PLAYER_COLOUR[FRANCE_ID]         = PLAYER_COLOR_BLUE
    set PLAYER_COLOUR[GREAT_BRITAIN_ID]  = PLAYER_COLOR_CYAN
    set PLAYER_COLOUR[ITALY_ID]          = PLAYER_COLOR_PURPLE
    set PLAYER_COLOUR[SERBIA_ID]         = PLAYER_COLOR_YELLOW
    set PLAYER_COLOUR[COMMONWEALTH_ID]   = PLAYER_COLOR_ORANGE
    set PLAYER_COLOUR[OTTOMAN_EMPIRE_ID] = PLAYER_COLOR_GREEN
    set PLAYER_COLOUR[BULGARIA_ID]       = PLAYER_COLOR_PINK
    set PLAYER_COLOUR[AUSTRIA_ID]        = PLAYER_COLOR_LIGHT_GRAY
    set PLAYER_COLOUR[HUNGARY_ID]        = PLAYER_COLOR_LIGHT_BLUE
    set PLAYER_COLOUR[EAST_GERMANY_ID]   = PLAYER_COLOR_AQUA
    set PLAYER_COLOUR[WEST_GERMANY_ID]   = PLAYER_COLOR_BROWN
endfunction

public function FromString takes string s returns player
    if s == "red" or s == "russia" then
        return RUSSIA
    elseif s == "blue" or s == "france" then
        return FRANCE
    elseif s == "teal" or s == "cyan" or s == "gb" or s == "great britain" then
        return GREAT_BRITAIN
    elseif s == "purple" or s == "purp" or s == "italy" then
        return ITALY
    elseif s == "yellow" or s == "serbia" or s == "balkans" then
        return SERBIA
    elseif s == "commonwealth" or s == "orange" or s == "oj" then
        return COMMONWEALTH
    elseif s == "ottomans" or s == "ottoman empire" or s == "green" then
        return OTTOMAN_EMPIRE
    elseif s == "bulgaria" or s == "pink" then
        return BULGARIA
    elseif s == "grey" or s == "gray" or s == "austria" then
        return AUSTRIA
    elseif s == "lightblue" or s == "light blue" or s == "lb" or s == "hungary" then
        return HUNGARY
    elseif s == "dg" or s == "darkgreen" or s == "dark green" or s == "eg" or s == "east germany" then
        return EAST_GERMANY
    elseif s == "brown" or s == "wg" or s == "west germany" then
        return WEST_GERMANY
    endif
    return NEUTRAL
endfunction

public function ToCountry takes player p returns integer
    return playerIdentities[GetPlayerId(p)]
endfunction

public function FromCountry takes integer id returns player
    return Player(countryAssociations[id])
endfunction

public function UpdateIdentities takes nothing returns nothing
    set RUSSIA_ID         = countryAssociations[RUSSIA_BASE_ID]
    set FRANCE_ID         = countryAssociations[FRANCE_BASE_ID]
    set GREAT_BRITAIN_ID  = countryAssociations[GREAT_BRITAIN_BASE_ID]
    set ITALY_ID          = countryAssociations[ITALY_BASE_ID]
    set SERBIA_ID         = countryAssociations[SERBIA_BASE_ID]
    set COMMONWEALTH_ID   = countryAssociations[COMMONWEALTH_BASE_ID]
    set OTTOMAN_EMPIRE_ID = countryAssociations[OTTOMAN_EMPIRE_BASE_ID]
    set BULGARIA_ID       = countryAssociations[BULGARIA_BASE_ID]
    set AUSTRIA_ID        = countryAssociations[AUSTRIA_BASE_ID]
    set HUNGARY_ID        = countryAssociations[HUNGARY_BASE_ID]
    set EAST_GERMANY_ID   = countryAssociations[EAST_GERMANY_BASE_ID]
    set WEST_GERMANY_ID   = countryAssociations[WEST_GERMANY_BASE_ID]
endfunction

globals
    private player plyr
    private group swap1 = CreateGroup()
    private group swap2 = CreateGroup()
endglobals

private function GiveToNewOwner takes nothing returns nothing
    call SetUnitOwner(GetEnumUnit(),plyr,true)
endfunction

public function Swap takes player p1, player p2 returns nothing
    local integer p1i           = GetPlayerId(p1)
    local integer p2i           = GetPlayerId(p2)
    local integer p1Identity    = playerIdentities[p1i]
    local integer p1Association = countryAssociations[p1Identity]
    local integer p2Identity    = playerIdentities[p2i]
    local integer p2Association = countryAssociations[p2Identity]
    
    set playerIdentities[p1i]           = p2Identity
    set countryAssociations[p1Identity] = p2Association
    set playerIdentities[p2i]           = p1Identity
    set countryAssociations[p2Identity] = p1Association
    
    call UpdateIdentities()
    call Initialize()
    
    call SetPlayerColor(p1,PLAYER_COLOUR[countryAssociations[playerIdentities[p1i]]])
    call SetPlayerColor(p2,PLAYER_COLOUR[countryAssociations[playerIdentities[p2i]]])
    
    call GroupEnumUnitsOfPlayer(swap1,p1,null)
    call GroupEnumUnitsOfPlayer(swap2,p2,null)
    set plyr = p2
    call ForGroup(swap1,function GiveToNewOwner)
    set plyr = p1
    call ForGroup(swap2,function GiveToNewOwner)
    call GroupClear(swap1)
    call GroupClear(swap2)
endfunction

private function init takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i > 11
        set countryAssociations[i] = i
        set playerIdentities[i]    = i
        set i = i + 1
    endloop
    call Initialize()
endfunction
endlibrary
