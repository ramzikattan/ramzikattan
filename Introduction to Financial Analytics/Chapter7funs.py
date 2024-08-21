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