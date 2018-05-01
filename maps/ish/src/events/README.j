// To create a new month event, follow the following steps:
// 
// 1) Create a new trigger with the name of the month and year you want
// 2) Convert it to custom text
// 3) Write the following boilerplate code:
// 
// //! runtextmacro EventBefore("Month","Year")
//     Code
// //! runtextmacro EventAfter
// 
// 5) Replace "Code" with your code, "Month" with the month, and "Year" with the year.
//     Make sure everything is spelled correctly or things might crash ingame.
//     See existing months for examples. You may find the following functions useful:
//     * GivePlayerRect(p,r)                 : Give all neutral units in rect r to player p
//     * KillDestructablesRect(r)            : Remove all pathing blockers (other than for mountains) in rect r
//     * GarrisonTrenchesRect(p,r)           : Order all trenches in rect r owned by player p to garrison
//     * SetPlayerTechMaxAllowed(p,id,max)   : Restrict or unrestrict production of certain units by certain players
//     * SetPlayerTechResearched(p,id,level) : Research new tech (mostly month-named techs)
