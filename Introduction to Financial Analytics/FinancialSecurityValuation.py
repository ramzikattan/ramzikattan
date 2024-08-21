import math as m
import sympy as s

''' This program will solve problems relating to Chapter 5: The Valuation of Financial Securities. '''

section = int(input("\n1. Discounting Annuities.\n2. Financial Securities.\n3. Valuation of Common Stock.\n Please select which section you'd like: "))

if section == 1: 
    print("\nDiscounting Annuities")
    selection = int(input("\n1. Present Value of Common Annuities.\n2. Special Annuities.\n Please select which option you'd like: "))

    if selection == 1: 
        print("\nPresent Value of Common Annuities")
        CF = float(input("Cash Flow Amount ($): "))
        r = float(input("Interest Rate (%): ")) / 100 
        n = int(input("Periods (Yrs): "))
        PVA = (CF / r) * (1 - (1 / (1+r)**n))
        print(f"\nThe present value of the annuity is: ${PVA:,.2f}.\n")
    elif selection == 2: 
        type = int(input("\nSpecial Annuities\n1. Perpetuities.\n2. Constant Growth Perpetuities.\n3. Annuities Starting Beyond Period One.\n Please select which option you'd like: "))
        if type == 1:
            print("\nPerpetuity")
            CF = float(input("Cash Flow Amount ($): "))
            r = float(input("Interest Rate (%): ")) / 100 
            PVP = CF / r
            print(f"\nThe present value of the perpetuity is: ${PVP:,.2f}.\n")
        elif type == 2:
            print("\nConstant Growth Perpetuity")
            CF = float(input("Cash Flow Amount ($): "))
            CFtype = int(input("CF0 (0) or CF1 (1): "))
            r = float(input("Interest Rate (%): ")) / 100 
            g = float(input("Growth Rate (%): ")) / 100 
            if CFtype == 0: 
                PVCCGP = CF*(1 + g) / (r - g)
            elif CFtype == 1: 
                PVCGP = CF / (r - g)
            print(f"\nThe present value of the constant growth perpetuity is: ${PVCGP:,.2f}.\n")
        elif type == 3: 
            PV = 0
            print("\nAnnuities Starting Beyond Period 1")
            CF = float(input("Cash Flow Amount ($): "))
            r = float(input("Interest Rate (%): ")) / 100 
            numpay = int(input("Number of Payments: "))
            n = int(input("Number of years before first payment: "))
            for i in range (numpay): 
                PV = PV + (1 / (1 + r)**(i+1))
            PV = PV * (CF / (1+r)**n)
            print(f"\nThe present value of the offset annuity is: ${PV:,.2f}.\n")
elif section == 2: 
    print("\nFinancial Securities")
    selection = int(input("\n1. U.S. Treasury Bills.\n2. Coupon-Paying Bonds.\n3. Yield to Maturity.\n Please select the option you'd like: "))

    if selection == 1: 
        type = int(input("\nU.S. Treasury Bills.\n1. Present Value of T-Bill.\n2. T-Bill Interest Rate Determination.\n3. Bank Discount Yield.\n4. Actual Yield\n Please select a question type: "))
        if type == 1: 
            print("\nPresent Value of T-Bill")
            CF = float(input("Cash Flow Amount ($): "))
            r = float(input("Interest Rate (%): ")) / 100 
            n = float(input("Length (Days): ")) / 364
            PV = CF / (1 + r)**n
            print(f"\nThe present value of the T-Bill is: ${PV:,.2f}.\n")
        elif type == 2: 
            print("\nT-Bill Interest Rate Determination")
            CF = float(input("Cash Flow Amount ($): "))
            PV = float(input("Present Value ($): "))
            n = float(input("Length (Days): ")) / 364
            r = ((CF / PV)**(1/n) - 1) * 100
            print(f"\nThe interest rate of the T-Bill is: {r:,.2f}%.\n")
        elif type == 3: 
            print("\nBank Discount Yield")
            Par = float(input("Par Value ($): "))
            Purchase = float(input("Purchase Price ($): "))
            Days = int(input("Days to Maturity: "))
            BDY = ((Par - Purchase) / Par) * (360 / Days) * 100
            print(f"\nThe bank discount yield of the T-Bill is: {BDY:,.2f}%.\n")
        elif type == 4: 
            print("\nActual Yield")
            BDY = float(input("Bank Discount Yield (%): ")) / 100
            Days = int(input("Days to Maturity: "))
            ACT = 100 * (365 * BDY) / (360 - (BDY * Days))
            print(f"\nThe actual yield of the T-Bill is: {ACT:,.2f}%.\n")
    elif selection == 2:
        print("\nCoupon-Paying Bonds")
        type = input("\n1. Annual Interest Payments.\n2. Semi-Annual Interest Payments.\n Please select a question type: ")
        Par = input("Par Value ($): ")
        
        if type == "":
            type = 2

        if Par == "":
            Par = 1000.00
            
        if type == 1: 
            print("\nAnnual Interest Payments")
            CIR = float(input("Coupon Interest Rate (%): ")) / 100
            r = float(input("Yield to Maturity (%): ")) / 100
            n = float(input("Term to Maturity (Yrs): "))
            BV = ((CIR * Par / r) * (1 - (1 / (1 + r)**n))) + (Par / (1 + r)**n)
            print(f"\nThe bond value is: ${BV:,.2f}.\n")
        if type == 2: 
            print("\nSemi-Annual Interest Payments")
            CIR = float(input("Coupon Interest Rate (%): ")) / 200
            r = float(input("Yield to Maturity (%): ")) / 200
            n = float(input("Term to Maturity (Yrs): ")) * 2
            BV = ((CIR * Par / r) * (1 - (1 / (1 + r)**n))) + (Par / (1 + r)**n)
            print(f"\nThe bond value is: ${BV:,.2f}.\n")
    elif selection == 3:
        print("\nYield to Maturity")
        type = int(input("\n1. Annual Interest Payments.\n2. Semi-Annual Interest Payments.\n Please select a question type: "))

        if type == 1:
            print("\nAnnual Interest Payments")
            r = s.Symbol('r')
            Par = float(input("Par Value ($): "))
            BV = float(input("Bond Value ($): "))
            CIR = float(input("Coupon Interest Rate (%): ")) / 100
            n = float(input("Years until maturity (Yrs): "))
            BVeqn = ((CIR * Par / r) * (1 - (1 / (1 + r)**n))) + (Par / (1 + r)**n)
            rval = float(s.nsolve(BVeqn - BV, r, CIR)) * 100
            print(f"\nThe interest rate is: {rval:,.3f}%.\n")
        if type == 2:
            print("\nSemi-Annual Interest Payments")
            r = s.Symbol('r')
            Par = float(input("Par Value ($): "))
            BV = float(input("Bond Value ($): "))
            CIR = float(input("Coupon Interest Rate (%): ")) / 100 / 2
            n = float(input("Years until maturity (Yrs): ")) * 2
            BVeqn = ((CIR * Par / r) * (1 - (1 / (1 + r)**n))) + (Par / (1 + r)**n)
            rval = float(s.nsolve(BVeqn - BV, r, CIR)) * 2003
            print(f"\nThe interest rate is: {rval:,.3f}%.\n")
elif section == 3:
    print("\nThe Valuation of Common Stock")
    selection = int(input("\n1. Discounted Cash Flow Model.\n2. Special Discounted Cash Flow Model.\n Please select the option you'd like: "))

    if selection == 1: 
        print("\nDiscounted Cash Flow Model")
        type = int(input("\n1. Valuing Common Stock.\n2. Interest Rate Calculation.\n Please select a question type: "))

        if type == 1: 
            print("\nValuing Common Stock")
            PV = 0
            r = float(input("Market Interest Rate (%): ")) / 100
            n = int(input("Number of Holding Periods (Yrs): "))
            P = float(input("Estimated Stock Price ($): "))
            for i in range(n):
                DIV = float(input(f"Dividend in year {i+1}: "))
                PV = PV + DIV / (1+r)**(i+1)
            PV = PV + P / (1+r)**n
            print(f"\nThe stock value is: ${PV:,.2f}.\n")
        elif type == 2: 
            print("\nInterest Rate Calculation")
            P0 = float(input("Current Stock Price ($): "))
            P = float(input("Estimated Stock Price ($): "))
            DIV = int(input("Dividend ($): "))
            r = 100 * (DIV + P - P0) / P0
            print(f"\nThe interest rate is: {r:,.2f}%.\n")
    if selection == 2: 
        print("\nSpecial Discounted Cash Flow Model")
        type = int(input("\n1. No Growth in Dividends.\n2. Constant Growth in Dividends.\n Please select a question type: "))

        if type == 1: 
            print("\nNo Growth in Dividends")
            DIV = float(input("Dividend Payment ($): "))
            r = float(input("Market Interest Rate (%): ")) / 100
            P0 = DIV / r
            print(f"\nThe stock value is: ${P0:,.2f}.\n")
        elif type == 2: 
            print("\nConstant Growth in Dividends")
            pick = int(input("\n1. Present Stock Value.\n2. Interest Rate Calculation.\n3. Growth Rate Calculation.\n Please pick an option: "))
            
            if pick == 1:
                print("\nPresent Stock Value")
                DIV = float(input("Dividend Payment in Year 1 ($): "))
                r = float(input("Market Interest Rate (%): ")) / 100
                g = float(input("Dividend Growth Rate (%): ")) / 100
                P0 = DIV / (r-g)
                print(f"\nThe stock value is: ${P0:,.2f}.\n")
            elif pick == 2: 
                print("\nInterest Rate Calculation")
                P0 = float(input("Stock Price ($): "))
                DIV = float(input("Dividend Payment in Year 1 ($): "))
                g = float(input("Dividend Growth Rate (%): ")) / 100
                r = (g + DIV / P0) * 100
                print(f"\nThe interest rate is: {r:,.2f}%.\n")
            elif pick == 3: 
                print("\nGrowth Rate Calculation")
                PR = float(input("Plowback Ratio (%): ")) / 100
                ROE = float(input("Accounting Rate of Return on Equity (%): ")) / 100
                g = PR * ROE * 100
                print(f"\nThe growth rate is: {g:,.2f}%.\n")
