import Chapter7funs as c7
from tabulate import tabulate

''' This program will solve problems relating to Chapter 7: The Techniques of Captial Budgeting. '''

print("\n1. NPV\n2. PI\n3. IRR\n4. WACC")
try: 
    sectionlist = []
    titlelist = []
    answerlist = []

    while True: 
        sectionlist.append(int(input("Please select a section or type stop: ")))
except: 
    for i in range(len(sectionlist)): 

        if sectionlist[i] == 1: 
            npv = c7.NPV()
            print(f"\nThe net present value is: ${npv:,.2f}.\n")
            titlelist.append(f"NPV Project {i+1}")
            answerlist.append(f"${npv:,.2f}")

        elif sectionlist[i] == 2: 
            PI = c7.PI()
            print(f"\nThe profitability index is: {PI:.4f}.")
            titlelist.append(f"PI Project {i+1}")
            answerlist.append(f"{PI:.4f}")

        elif sectionlist[i] == 3:
            IRR = c7.IRR()
            print(f"\nThe internal rate of return is: {IRR:,.3f}%.\n")
            titlelist.append(f"IRR Project {i+1}")
            answerlist.append(f"{IRR:,.3f}%")
        
        elif sectionlist[i] == 4:
            WACC = c7.WACC()
            print(f"\nThe weighted average cost of capital is: {WACC:,.2f}%.\n")
            titlelist.append(f"WACC {i+1}")
            answerlist.append(f"{WACC:,.2f}%")

data = [titlelist, answerlist]
table = tabulate(data, headers='firstrow')
print("\n", table, "\n")