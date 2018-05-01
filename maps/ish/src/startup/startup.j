// Runs game startup during a black screen. Staggers various loading phases to
// minimize lag spike intensity and make sure we don't go over the op limit.

library Startup initializer init requires ObjectDataLibraries, GeneralLibraries, CitiesAndIncome, MonthEvents, TrenchesAndAbilities, PlayerManagement, ShipSystems, PathingBlockerManager, InhouseOptions
globals
    private boolean secondGame = false
    private boolean inhouse = false
endglobals

private function EnableControl takes boolean enabled returns nothing
    local integer i = 0
    loop
        exitwhen i > 11
        call SetPlayerAlliance(Player(i),Player(i),ALLIANCE_SHARED_CONTROL,enabled)
        call SetPlayerAlliance(Player(i),Player(i),ALLIANCE_SHARED_ADVANCED_CONTROL,enabled)
        set i = i + 1
    endloop
endfunction

private function FinishGameStartup takes nothing returns nothing
    call DisplayCineFilter(false)
    call EnableControl(true)
    call ExecuteFunc("MonthEvents_Initialize")
    call ExecuteFunc("FactorySystem_Initialize")
    call ExecuteFunc("ShipSystems_Initialize")
    call DestroyTimer(GetExpiredTimer())
endfunction

private function IntermediateGameStartup takes nothing returns nothing
    call ExecuteFunc("CitiesAndIncome_Initialize")
    call SetCineFilterEndColor(0,0,0,0)
    call SetCineFilterDuration(5.)
    call DisplayCineFilter(true)
    call TimerStart(GetExpiredTimer(),5.,false,function FinishGameStartup)
endfunction

private function StartGameStartup takes nothing returns nothing
    
    if secondGame then
        call PathingBlockerManager_Load()
        call ExecuteFunc("CreateAllUnits")
    endif
    
    
    call ExecuteFunc("ObjectDataLibraries_Initialize")
    call ExecuteFunc("GeneralLibraries_Initialize")
    call ExecuteFunc("Initialization_Initialize")
    call ExecuteFunc("TrenchesAndAbilities_Initialize")
    call ExecuteFunc("PlayerManagement_Initialize")
    
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,20.,"|cffffcc00The game will begin in 10 seconds.|r Good luck!")
    
    call TimerStart(GetExpiredTimer(),5.,false,function IntermediateGameStartup)
    set secondGame = true
endfunction

private function GameStartup takes nothing returns nothing
    
    call SetCineFilterTexture("ReplaceableTextures\\CameraMasks\\Black_mask.blp")
    call SetCineFilterBlendMode(BLEND_MODE_BLEND)
    call SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    call SetCineFilterStartColor(0,0,0,255)
    call SetCineFilterEndColor(0,0,0,255)
    call SetCineFilterStartUV(0, 0, 1, 1)
    call SetCineFilterEndUV(0, 0, 1, 1)
    call SetCineFilterDuration(99999.)
    call DisplayCineFilter(true)
    call EnableControl(false)
    
    if false and PlayerDatabase_IsInhouse() then
        call InhouseOptions_Begin(GetExpiredTimer(),function StartGameStartup)
    else
        call TimerStart(GetExpiredTimer(),0.,false,function StartGameStartup)
    endif
endfunction

public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),0.,false,function GameStartup)
endfunction

private function init takes nothing returns nothing
    call Initialize()
endfunction
endlibrary
