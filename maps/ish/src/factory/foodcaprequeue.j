// Requeues any units which were originally cancelled due to the food cap.

scope FoodCapRequeue initializer init
private function init takes nothing returns nothing
    //Most of this code is in the BuildingAutomation library above
    call TimerStart(CreateTimer(),1.,true,function BuildingData.attemptRequeue)
endfunction
endscope
