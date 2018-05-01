//This is technical stuff for the month code that follows and should not be modified,
//at the risk of horribly breaking everything

library EventMacros
//! textmacro EventBefore takes MONTH, YEAR
scope $MONTH$$YEAR$ initializer init
private function init takes nothing returns nothing
    call MonthTimer_RegisterEvent("$MONTH$","$YEAR$")
endfunction

public function Actions takes nothing returns nothing
//! endtextmacro

//! textmacro EventAfter
endfunction
endscope
//! endtextmacro
endlibrary
