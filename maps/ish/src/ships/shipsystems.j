// Main source file for this folder

library ShipSystems requires FerrySystem, GreeceSupplies, MerchantDocks
public function Initialize takes nothing returns nothing
    call FerrySystem_Initialize()
    call GreeceSupplies_Initialize()
    call MerchantDocks_Initialize()
endfunction
endlibrary
