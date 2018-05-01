// Allow players to maintain a camera much farther from the ground than
// typically allowed by Warcraft.

scope Camera initializer init
    globals
        private real camDistance = 1650.0
        private real camAngleOfAttack = bj_CAMERA_DEFAULT_AOA
        private real camRotation = bj_CAMERA_DEFAULT_ROTATION
        private boolean camAdjustment = true
    endglobals
    
    function camLock takes player p, boolean lock returns nothing
        if GetLocalPlayer() == p then
            set camAdjustment = lock
        endif
    endfunction

    private function camAdjust takes nothing returns nothing
        if camAdjustment and camDistance != 0.00 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, camDistance, 0.00)
            call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, camAngleOfAttack, 0.00)
            call SetCameraField(CAMERA_FIELD_ROTATION, camRotation, 0.00)
        endif
    endfunction
   
    private function camSet takes nothing returns boolean
        if SubString(GetEventPlayerChatString(), 0, 5) == "-cam " then
            set camDistance = S2R(SubString(GetEventPlayerChatString(), 5, 9))
            if not camAdjustment and camDistance == 0.00 then
                set camDistance = 1650
            endif
        elseif SubString(GetEventPlayerChatString(), 0, 6) == "-zoom " then
            set camDistance = S2R(SubString(GetEventPlayerChatString(), 6, 10))
            if not camAdjustment and camDistance == 0.00 then
                set camDistance = 1650
            endif
        endif
       
        if camAdjustment then
            if camDistance == 0.00 then
                call CameraSetSourceNoiseEx(10000.00, 1000.00, false)
            else
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, camDistance, 0.00)
                call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, camAngleOfAttack, 0.00)
                call SetCameraField(CAMERA_FIELD_ROTATION, camRotation, 0.00)
                call CameraSetSourceNoiseEx(0.00, 0.00, false)
            endif
        endif
        return false
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterPlayerChatEvent(t, GetLocalPlayer(), "-cam", false)
        call TriggerRegisterPlayerChatEvent(t, GetLocalPlayer(), "-zoom", false)
        call TriggerAddCondition(t, Condition(function camSet))
        call TimerStart(CreateTimer(), 0.50, true, function camAdjust)
        set t = null
    endfunction
endscope
