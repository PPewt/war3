// Sets up the value of various named and unnamed cities at the start of
// the game.

library SetInitialIncome requires CapitalTracker, SetCityIncome
private function InitializeCapitalIncome takes nothing returns nothing
    //Russia
    call SetCapitalIncome(MOSCOW,40)
    call SetCapitalIncome(ST_PETERSBURG,40)
    call SetCapitalIncome(WARSAW,35)
    call SetCapitalIncome(HELSINKI,15)
    call SetCapitalIncome(RIGA,20)
    call SetCapitalIncome(KIEV,25)
    call SetCapitalIncome(SEVASTOPOL,25)
    
    //France
    call SetCapitalIncome(PARIS,60)
    call SetCapitalIncome(RABAT,10)
    call SetCapitalIncome(TOULOUSE,25)
    call SetCapitalIncome(MARSEILLE,35)
    
    //Great Britain
    call SetCapitalIncome(LONDON,50)
    call SetCapitalIncome(DUBLIN,20)
    call SetCapitalIncome(GLASGOW,20)
    call SetCapitalIncome(BRUSSELS,50)
    
    //Italy
    call SetCapitalIncome(ALGIERS,25)
    call SetCapitalIncome(TUNIS,15)
    call SetCapitalIncome(BENGHAZI,11)
    call SetCapitalIncome(SYRACUSE,15)
    call SetCapitalIncome(TRIPOLI,10)
    call SetCapitalIncome(ROME,35)
    
    //Serbia
    call SetCapitalIncome(BELGRADE,75)
    call SetCapitalIncome(DURRES,55)
    call SetCapitalIncome(LISBON,50)
    call SetCapitalIncome(THESSALONIKI,25)
    call SetCapitalIncome(BUCHAREST,75)
    call SetCapitalIncome(ATHENS,75)
    
    //Commonwealth
    call SetCapitalIncome(PORT_SAID,50)
    call SetCapitalIncome(HALIFAX,25)
    call SetCapitalIncome(WASHINGTON,75)
    
    //Ottoman Empire
    call SetCapitalIncome(SCUTARI,100)
    call SetCapitalIncome(DAMASCUS,20)
    call SetCapitalIncome(BEIRUT,20)
    
    //Bulgaria
    call SetCapitalIncome(CONSTANTINOPLE,75)
    call SetCapitalIncome(SOFIA,75)
    
    //Austria
    call SetCapitalIncome(VIENNA,75)
    call SetCapitalIncome(PRAGUE,50)
    call SetCapitalIncome(SARAJEVO,50)
    
    //Hungary
    call SetCapitalIncome(BUDAPEST,75)
    
    //East Germany
    call SetCapitalIncome(BERLIN,100)
    
    //West Germany
    call SetCapitalIncome(MUNICH,115)
    call SetCapitalIncome(STRASBOURG,50)
    call SetCapitalIncome(HAMBURG,85)
    
    //Netherlands
    call SetCapitalIncome(AMSTERDAM,75)
    
    //Denmark
    call SetCapitalIncome(AALBORG,50)
    call SetCapitalIncome(COPENHAGEN,50)
endfunction

private function InitializeCityIncome takes nothing returns nothing
    //Russia
    call SetIncomeRect(gg_rct_Finland,RUSSIA,5,10)
    call SetIncomeRect(gg_rct_Poland,RUSSIA,5,15)
    call SetIncomeRect(gg_rct_Baltics,RUSSIA,5,15)
    call SetIncomeRect(gg_rct_Ukraine,RUSSIA,7,15)
    call SetIncomeRect(gg_rct_Ukraine2,RUSSIA,7,15)
    call SetIncomeRect(gg_rct_Russia,RUSSIA,5,10)
    
    //France
    call SetIncomeRect(gg_rct_France,FRANCE,5,15)
    call SetIncomeRect(gg_rct_Morocco,FRANCE,5,0)
    
    //Great Britain
    call SetIncomeRect(gg_rct_Ireland,GREAT_BRITAIN,5,0)
    call SetIncomeRect(gg_rct_Scotland,GREAT_BRITAIN,5,10)
    call SetIncomeRect(gg_rct_Belgium,GREAT_BRITAIN,0,25)
    call SetIncomeRect(gg_rct_GreatBritainCapitals,GREAT_BRITAIN,5,20)
    
    //Italy
    call SetIncomeRect(gg_rct_ItalyBarbary,ITALY,2,7)
    call SetIncomeRect(gg_rct_ItalyLibya,NEUTRAL,2,0)
    call SetIncomeRect(gg_rct_ItalyGreece,NEUTRAL,10,0)
    call SetIncomeRect(gg_rct_ItalySardinia,NEUTRAL,5,10)
    call SetIncomeRect(gg_rct_ItalySicily,NEUTRAL,3,9)
    call SetIncomeRect(gg_rct_ItalyNaples,NEUTRAL,4,10)
    call SetIncomeRect(gg_rct_Italy1,NEUTRAL,10,20)
    
    //Serbia
    call SetIncomeRect(gg_rct_BalkanPortugal,NEUTRAL,10,20)
    call SetIncomeRect(gg_rct_BalkanSouthGreece,NEUTRAL,10,20)
    call SetIncomeRect(gg_rct_BalkanNorthGreece,NEUTRAL,10,20)
    call SetIncomeRect(gg_rct_BalkanRomania,NEUTRAL,10,20)
    call SetIncomeRect(gg_rct_BalkanSerbia,SERBIA,20,30)
    
    //Commonwealth
    call SetIncomeRect(gg_rct_ANZACCanada,COMMONWEALTH,5,10)
    call SetIncomeRect(gg_rct_ANZACUSA,NEUTRAL,5,15)
    call SetIncomeRect(gg_rct_Arabs,NEUTRAL,5,10)
    call SetIncomeRect(gg_rct_ANZACEgypt,NEUTRAL,10,20)
    call SetIncomeRect(gg_rct_ANZACGibraltar,COMMONWEALTH,25,35)
    call SetIncomeRect(gg_rct_ANZACMalta,COMMONWEALTH,25,35)
    call SetIncomeRect(gg_rct_ANZACCyprus,COMMONWEALTH,25,35)
    
    //Bulgaria
    call SetIncomeRect(gg_rct_Bulgaria,NEUTRAL,15,20)
    call SetIncomeRect(gg_rct_BulgarianThrace,NEUTRAL,15,0)
    
    //Ottomans
    call SetIncomeRect(gg_rct_OttomanPersia,NEUTRAL,5,10)
    call SetIncomeRect(gg_rct_OttomanLevant,NEUTRAL,5,10)
    call SetIncomeRect(gg_rct_OttomanTurkey,NEUTRAL,10,15)
    
    //Austria
    call SetIncomeRect(gg_rct_AustrianCzechoslovakia1,AUSTRIA,5,10)
    call SetIncomeRect(gg_rct_AustrianCzechoslovakia2,AUSTRIA,5,10)
    call SetIncomeRect(gg_rct_AustrianBalkans,AUSTRIA,15,0)
    call SetIncomeRect(gg_rct_Austria,AUSTRIA,10,20)
    
    //Hungary
    call SetIncomeRect(gg_rct_Hungary,HUNGARY,15,30)
    
    //East Germany
    call SetIncomeRect(gg_rct_EastGermany,EAST_GERMANY,15,30)
    
    //West Germany
    call SetIncomeRect(gg_rct_WestGermany,WEST_GERMANY,20,40)
    
    //Netherlands
    call SetIncomeRect(gg_rct_Netherlands,NEUTRAL,20,40)
    
    //Denmark
    call SetIncomeRect(gg_rct_Denmark1,NEUTRAL,20,40)
    call SetIncomeRect(gg_rct_Denmark2,NEUTRAL,20,40)
    call SetIncomeRect(gg_rct_Denmark3,NEUTRAL,20,40)
    call SetIncomeRect(gg_rct_Iceland,NEUTRAL,5,15)
endfunction

private function SetInitialIncome takes nothing returns nothing
    call InitializeCapitalIncome()
    call InitializeCityIncome()
endfunction

public function Initialize takes nothing returns nothing
    call TimerStart(CreateTimer(),1.,false,function SetInitialIncome)
endfunction
endlibrary
