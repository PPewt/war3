//A list of all "known" players. This is currently unused,
//but may be used in the future to enable inhouse-specific features
//such as Captain's Mode or remaking.

library PlayerDatabase initializer init
globals
    private hashtable database = InitHashtable()
    private integer isInhouse = 0
endglobals

public function StorePlayer takes string p returns nothing
    call SaveBoolean(database,StringHash(p),0,true)
    call SaveStr(database,StringHash(p),1,p)
endfunction

public function StoreAlias takes string p, string aliasOf returns nothing
    call SaveBoolean(database,StringHash(p),0,true)
    call SaveStr(database,StringHash(p),1,aliasOf)
endfunction

public function PlayerStored takes string p returns boolean
    return LoadBoolean(database,StringHash(p),0)
endfunction

public function IsInhouse takes nothing returns boolean
    local integer i = 0
    if isInhouse == 0 then
        set isInhouse = 1
        loop
            exitwhen i > 11 or isInhouse == 2
            if GetPlayerController(Player(i)) == MAP_CONTROL_USER and SubString(GetPlayerName(Player(i)),0,6) != "Player" and not PlayerStored(StringCase(GetPlayerName(Player(i)),false)) then
                call BJDebugMsg(I2S(i))
                set isInhouse = 2
            endif
            set i = i + 1
        endloop
    endif
    return isInhouse == 1
endfunction

private function InitializeDatabase takes nothing returns nothing
    call StorePlayer("pewt")
    call StorePlayer("eagleman")
    call StorePlayer("blood.sean")
    call StorePlayer("synystergates")
    call StorePlayer("cell_destroyer")
    call StorePlayer("trench]")
    call StorePlayer("tech0ff")
    call StorePlayer("inferous")
    call StorePlayer("insidee")
    call StorePlayer("sirsirrrr")
    call StorePlayer("bsx-alpha6")
    call StorePlayer("bountykillah")
    call StorePlayer("drdgvhbh")
    call StorePlayer("xxguimxxrafael")
    call StorePlayer("booyah71")
    call StorePlayer("derdan")
    call StorePlayer("acre.")
    call StorePlayer("lulzy")
    call StorePlayer("thevinylraider")
    call StorePlayer("lookatthis")
    call StorePlayer("goldcoin")
    call StorePlayer("devils_food")
    call StorePlayer("blackjacks")
    call StorePlayer("matthewb")
    call StorePlayer("eragon12267")
    call StorePlayer("spankfurt")
    call StorePlayer("lulzy")
    call StorePlayer("pusanmeme")
    call StorePlayer("my_ass_says")
    call StorePlayer("mrthades")
    call StorePlayer("dr.carter")
    call StorePlayer("dontbantheman")
    
    call StoreAlias("bountykiller","bountykillah")
    call StoreAlias("purplepoot","pewt")
    call StoreAlias("radical_fo","lulzy")
    call StoreAlias("admiralguim","xxxguimxxxrafael")
    call StoreAlias("war4life","trench]")
endfunction

//TODO for ingame autobalance
private function InitializePlayerRankings takes nothing returns nothing
endfunction

private function init takes nothing returns nothing
    call InitializeDatabase()
    call InitializePlayerRankings()
endfunction
endlibrary
