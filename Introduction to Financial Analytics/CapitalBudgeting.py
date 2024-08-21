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

import math as m
import sympy as s
import numpy as np

def NPV():
    print("\nNPV")
    type = input("\nAre the cash flows even or uneven: ")
    Inv = float(input("Investment Cost ($): "))
    if type.capitalize() == 'Even': 
        print('Annuity')
        CF = float(input("Cash Flow Amount ($): "))
        r = float(input("Required Rate of Return (%): ")) / 100 
        n = int(input("Periods (Yrs): "))
        PV = (CF / r) * (1 - (1 / (1+r)**n))

    elif type.capitalize() == 'Uneven': 
        print('Uneven')
        PV = 0
        n = int(input("How many cash flows are there?: "))
        t = float(input("Total Number of Periods (Years): "))
        r = float(input("Required Rate of Return (%): "))
        g = float(input("Growth Rate (%): ")) / 100
        for i in range (n):
            CF = float(input(f"Cash Flow {i + 1} Amount ($): "))
            when = float(input(f"Year Cash Flow {i + 1} Received: "))
            PV = PV + (CF * (1 + g) / (1 + (r / 100))**(when))
    
    npv = PV - abs(Inv)
    return npv

def PI():
    print("\nProfitability Index")
    type = input("\nAre the cash flows even or uneven: ")
    Inv = float(input("Investment Cost ($): "))
    if type.capitalize() == 'Even': 
        print('Annuity')
        CF = float(input("Cash Flow Amount ($): "))
        r = float(input("Required Rate of Return (%): ")) / 100 
        n = int(input("Periods (Yrs): "))
        PVA = (CF / r) * (1 - (1 / (1+r)**n))

    elif type.capitalize() == 'Uneven': 
        print('Uneven')
        PVA = 0
        n = int(input("How many cash flows are there?: "))
        t = float(input("Total Number of Periods (Years): "))
        r = float(input("Required Rate of Return (%): "))
        for i in range (n):
            CF = float(input(f"Cash Flow {i + 1} Amount ($): "))
            when = float(input(f"Year Cash Flow {i + 1} Received: "))
            PVA = PVA + (CF / (1 + (r / 100))**(when))
    PI = PVA / abs(Inv)

    return PI

def IRR(): 
    print("\nInternal Rate of Return")
    PVA = 0
    Inv = float(input("Investment Cost ($): "))
    r = s.Symbol('r')
    n = int(input("How many cash flows are there?: "))
    t = float(input("Total Number of Periods (Years): "))
    for i in range (n):
        CF = float(input(f"Cash Flow {i + 1} Amount ($): "))
        when = float(input(f"Year Cash Flow {i + 1} Received: "))
        PVA = PVA + (CF / (1 + (r / 100))**(when))
    IRR = float(s.nsolve(PVA-abs(Inv), r, 10))
    
    return IRR

def WACC():
    Equitylist = []
    Costlist = []
    print("\nWeighted Average Cost of Capital")
    securities = int(input("How many forms of security are there: "))
    for i in range(securities):
        Equitylist.append(float(input(f"Percent in Equity {i+1}: "))/100)
        Costlist.append(float(input(f"Cost of Equity {i+1}: ")))
    WACC = np.matmul(np.array(Equitylist), np.array(Costlist)) * 100
    
    return WACC
