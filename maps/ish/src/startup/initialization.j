// Sets up initial allies, displays welcome messages, orders starting
// infantry to load into trenches (since they cannot be placed in them),
// and dose any other necessary setup.

scope Initialization
globals
    private unit pass
    timer gameTimer = CreateTimer()
    player array teams
endglobals
private function Child takes nothing returns nothing
    call GarrisonTrenchesRect(RUSSIA,gg_rct_RussiaTrenches1)
    call GarrisonTrenchesRect(RUSSIA,gg_rct_RussiaTrenches2)
    call GarrisonTrenchesRect(RUSSIA,gg_rct_RussiaTrenches3)
    call GarrisonTrenchesRect(RUSSIA,gg_rct_RussiaTrenches4)
    call GarrisonTrenchesRect(RUSSIA,gg_rct_RussiaTrenches5)
    call GarrisonTrenchesRect(RUSSIA,gg_rct_RussiaTrenches6)
    call GarrisonTrenchesRect(RUSSIA,gg_rct_RussiaTrenches7)
    
    call GarrisonTrenchesRect(FRANCE,gg_rct_FranceTrenches)
    
    call GarrisonTrenchesRect(SERBIA,gg_rct_SerbiaTrenches1)
    call GarrisonTrenchesRect(SERBIA,gg_rct_SerbiaTrenches2)
    
    call GarrisonTrenchesRect(AUSTRIA,gg_rct_AustriaTrenches1)
    call GarrisonTrenchesRect(AUSTRIA,gg_rct_AustriaTrenches2)
    call GarrisonTrenchesRect(AUSTRIA,gg_rct_AustriaTrenches3)
    
    call GarrisonTrenchesRect(HUNGARY,gg_rct_HungaryTrenches1)
    call GarrisonTrenchesRect(HUNGARY,gg_rct_HungaryTrenches2)
    
    call GarrisonTrenchesRect(EAST_GERMANY,gg_rct_EastGermanyTrenches)
    
    call GarrisonTrenchesRect(WEST_GERMANY,gg_rct_WestGermanyTrenches)
    
    call FakeUpgrade_Research(COMMONWEALTH,FRENCH_PARIS)
    call FakeUpgrade_Research(EAST_GERMANY,TURKISH_SCUTARI)
    call FakeUpgrade_Research(WEST_GERMANY,TURKISH_SCUTARI)
    call FakeUpgrade_Research(OTTOMAN_EMPIRE,TURKISH_SCUTARI)
    call DestroyTimer(GetExpiredTimer())
endfunction
private function AllyTeam takes nothing returns nothing
    local integer i = 0
    local integer j
    loop
        exitwhen i > 5
        set j = 0
        call SetPlayerState(teams[i],PLAYER_STATE_RESOURCE_GOLD,200)
        loop
            exitwhen j > 5
            call SetPlayerAllianceStateBJ(teams[i],teams[j],bj_ALLIANCE_ALLIED_VISION)
            if GetPlayerSlotState(teams[i]) == PLAYER_SLOT_STATE_EMPTY or GetPlayerController(teams[i]) == MAP_CONTROL_COMPUTER then
                call SetPlayerAlliance(teams[i],teams[j],ALLIANCE_SHARED_CONTROL,true)
                call SetPlayerAlliance(teams[i],teams[j],ALLIANCE_SHARED_ADVANCED_CONTROL,true)
                call SetPlayerState(teams[i],PLAYER_STATE_FOOD_CAP_CEILING,300)
            endif
            set j = j + 1
        endloop
        set i = i + 1
    endloop
endfunction

private function AllyTeams takes nothing returns nothing
    local integer i = 0
    local integer j
    loop
        exitwhen i > 11
        set j = 0
        loop
            exitwhen j > 11
            call SetPlayerAllianceStateBJ(teams[i],teams[j],bj_ALLIANCE_UNALLIED)
            set j = j + 1
        endloop
        set i = i + 1
    endloop
    set teams[0] = RUSSIA
    set teams[1] = FRANCE
    set teams[2] = GREAT_BRITAIN
    set teams[3] = ITALY
    set teams[4] = SERBIA
    set teams[5] = COMMONWEALTH
    call AllyTeam()
    set teams[0] = OTTOMAN_EMPIRE
    set teams[1] = BULGARIA
    set teams[2] = AUSTRIA
    set teams[3] = HUNGARY
    set teams[4] = EAST_GERMANY
    set teams[5] = WEST_GERMANY
    call AllyTeam()
    call DestroyTimer(GetExpiredTimer())
endfunction
            
public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),0.,false,function AllyTeams)
    call FogMaskEnable(false)
    call FogEnable(false)
    call FogEnable(true)
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY,12.)
    call SuspendTimeOfDay(true)
    call DisplayTimedTextToPlayer(RUSSIA,0.,0.,20.,"You are the |cffffcc00Russian Empire|r. A failing power controlling vast territory, your goal is to attempt to survive the assault from the Central Powers while aiding your allies against the various nations you border. Beware revolution; if you do not please your people it may brew!")
    call DisplayTimedTextToPlayer(FRANCE,0.,0.,20.,"You are European |cffffcc00France|r. Bordering the European superpower Germany, you and Great Britain are pitted against them to try and destroy them for many years to come.")
    call DisplayTimedTextToPlayer(GREAT_BRITAIN,0.,0.,20.,"You are the |cffffcc00British Isles|r. While you do not control your colonies, you control the mainland, and are responsible for aiding France in their struggle against Germany.")
    call DisplayTimedTextToPlayer(ITALY,0.,0.,20.,"You are |cffffcc00Italy|r, as well as controlling French West Africa. You will gain control of Italy itself, as well as Italian Libya, when you join the war in |cffffcc00May 1915|r. Your struggles will be primarily against Austria-Hungary and the Ottoman Empire, though beware Bulgaria - you may find them on your doorstep.")
    call DisplayTimedTextToPlayer(SERBIA,0.,0.,20.,"You are the |cffffcc00Entente Balkans|r of Serbia, Montenegro, and later Romania and Greece. You will additionally gain Portugal in |cffffcc00March 1916|r. Pitted against Austria-Hungary, you must try to survive their onslaughts as your allies push the Central Powers on other fronts. Beware Bulgaria's entry into the war in |cffffcc00October 1915|r, but if you can survive their onslaught then you will soon be well-fit to crush them when Greece and Romania join you.")
    call DisplayTimedTextToPlayer(COMMONWEALTH,0.,0.,20.,"You are the |cffffcc00Commonwealth|r, as well as the United States of America. Mainly focusing on the Ottoman Empire, you will gain control of Egypt in one month - be prepared for war!")
    call DisplayTimedTextToPlayer(OTTOMAN_EMPIRE,0.,0.,20.,"You are the |cffffcc00Ottoman Empire|r. A slowly collapsing Islamic power over past centuries, this is your last bid for greatness. Crush the Commonwealth in British Egypt, but beware Italy and Russia - they may prove to be thorns in your side. You will declare war in one month - at that point you will gain control of your nation.")
    call DisplayTimedTextToPlayer(BULGARIA,0.,0.,20.,"You are |cffffcc00Bulgaria|r. While your nation does not declare war until |cffffcc00October 1915|r, you will gain control of the European possessions of the Ottoman Empire in one month. Use them wisely!")
    call DisplayTimedTextToPlayer(AUSTRIA,0.,0.,20.,"You are |cffffcc00Austria|r of Austria-Hungary. At this point, no enemies are near; you will thus want to help either Germany or Hungary in their struggle against France, Great Britain, Russia, and Serbia. Beware the entry of Italy in |cffffcc00May 1915|r!")
    call DisplayTimedTextToPlayer(HUNGARY,0.,0.,20.,"You are |cffffcc00Hungary|r of Austria-Hungary. Bordering Russia and Serbia, prepare for immediate onslaught; you will likely want to request help from Austria, your counterpart. Beware Serbia's expansion to include most of the Balkans as more countries join the Entente powers.")
    call DisplayTimedTextToPlayer(EAST_GERMANY,0.,0.,20.,"You are the eastern part of the |cffffcc00German Empire|r. Pitted against Russia, you will want to crush them as quickly as possible, before they have a chance to fully industrialize. Though no other Entente powers have direct access to your borders, be wary of weak allies letting enemies slip past!")
    call DisplayTimedTextToPlayer(WEST_GERMANY,0.,0.,20.,"You are the western part of the |cffffcc00German Empire|r. Pitted against France and Great Britain, you also may be attacked by Canada or Italy. Additionally, you have one of the most powerful navies in Europe - use it wisely!")
    call TimerStart(CreateTimer(),0.,false,function Child)
    call TimerStart(gameTimer,9999999.,false,null)
    
    debug call BJDebugMsg("The game is currently in debug mode. Not intended for multiplayer play. Red and Green can press UP to gain income, and DOWN to advance the month.")
endfunction
endscope
