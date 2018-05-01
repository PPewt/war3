// Can be included to include important libraries in this folder

library CitiesAndIncome requires SetInitialIncome, IncomeTimer
public function Initialize takes nothing returns nothing
    call SetInitialIncome_Initialize()
endfunction
endlibrary
