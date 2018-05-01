// Main script file for this folder

library MonthEvents requires RussianRevolution, MonthTimer
public function Initialize takes nothing returns nothing
    call RussianRevolution_Initialize()
    call MonthTimer_Initialize()
endfunction
endlibrary
