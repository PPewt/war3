// Displays a text tag which mimics the "gold income" text tags in Warcraft III

library TextTags initializer init
globals
             string  FACTORY_PROGRESS      = ""
    constant integer FACTORY_PROGRESS_LEN  = 100 //Actual length is len * step
    constant integer FACTORY_PROGRESS_STEP = 2
endglobals
function DisplayIncomeTextTagSuffix takes unit u, integer worth, string suffix returns nothing
    local texttag tt = CreateTextTag()
    local string text = "+" + I2S(worth)
    if suffix != "" then
        set text = text + " (" + suffix + ")"
    endif
    call SetTextTagText(tt,text,.023)
    call SetTextTagColor(tt,0xFF,0xCC,0x00,0xFF)
    call SetTextTagPermanent(tt,false)
    call SetTextTagVisibility(tt,true)
    call SetTextTagFadepoint(tt,2.)
    call SetTextTagLifespan(tt,5.)
    call SetTextTagVelocity(tt,0.,.71/32.)
    call SetTextTagPos(tt,GetUnitX(u),GetUnitY(u),90.)
endfunction

function DisplayIncomeTextTag takes unit u, integer worth returns nothing
    call DisplayIncomeTextTagSuffix(u,worth,"")
endfunction

private function init takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= FACTORY_PROGRESS_LEN
        set FACTORY_PROGRESS = FACTORY_PROGRESS + "||"
        set i = i + 1
    endloop
endfunction
endlibrary
