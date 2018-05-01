// Main source file for this folder

library TrenchesAndAbilities requires AddBarbedWire
public function Initialize takes nothing returns nothing
    call AddBarbedWire_Initialize()
    call TrenchSystem_Initialize()
endfunction
endlibrary
