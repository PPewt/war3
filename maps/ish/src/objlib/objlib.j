// Can be included to include every object data library, and is responsible for
// initializing all of them.

library ObjectDataLibraries requires Rawcodes, Players, Abilities, Units, Upgrades
public function Initialize takes nothing returns nothing
    call Players_Initialize()
    call Rawcodes_Initialize()
    call Units_Initialize()
    call Abilities_Initialize()
    call Upgrades_Initialize()
endfunction
endlibrary
