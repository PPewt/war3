// Manages specially named units. Used to be much more complicated, but has
// largely been phased out.

library UnitManager requires CapitalTracker, FakeUpgrade, Players, Rawcodes
globals
    unit array docks
    constant integer LONDON_DOCK_OFFSET = 0
    constant integer HALIFAX_DOCK_OFFSET = 1
endglobals
public function Initialize takes nothing returns nothing
    set docks[LONDON_DOCK_OFFSET] = gg_unit_h02F_1557
    set docks[HALIFAX_DOCK_OFFSET] = gg_unit_h02F_1553
    call FakeUpgrade_Research(GREAT_BRITAIN,TRADE_DOCKS_ACTIVE)
    call FakeUpgrade_Research(COMMONWEALTH,TRADE_DOCKS_ACTIVE)
endfunction
endlibrary
