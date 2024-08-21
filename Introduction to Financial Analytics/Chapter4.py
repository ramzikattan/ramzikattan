import math as m

''' This program will solve problems relating to Chapter 4: Time Value of Money. '''


print("Hello user! I'd like to help you solve problems relating to Chapter 4: Time Value of Money. \nWhat kind of problem would you like to solve today?")
print("1. Discounting: Pulling future cash flows into current cash flows [Includes Simple, Periodic, Continuous, Multiple Cash Flows, and Annuity Problems]")
print("2. Compounding: Pushing current cash flows into future cash flows [Includes Simple, Periodic, Continuous, Multiple Cash Flows, and Annuity Problems]")
print("3. Effective Annual Rate: Using compounding frequency to find effective annual interest rates.")
print("4. Interest Rate: Solving for the annual interest rate.")
print("5. Number of Periods: Solving for the number of periods between present and future values.")
while True:
    try:
        topic = int(input("Please type the number related to your topic: "))
        if topic in {1, 2, 3, 4, 5}:
            break
        else:
            print("That is not a valid choice!")
            topic = int(input("Please type the number related to your topic: "))
    except ValueError:
        print("Please enter a valid number!")

# Discounting
'''
1 - Simple Discounting = Increase in principal investment only. 
2 - Periodic Discounting = Compounding periodically in a time period. 
3 - Continuous Discounting = Compounding at every instant in time. 
4 - Multiple Cash Flows Discounting = Finding the future value of cash flows invested at differnet times. 
5 - Annuity = Finding the present value of fixed cash flows. 
6 - Between Periods = Finding the future value of cash flows between periods (not starting today). 
'''

if topic == 1:
    print("1 - Simple Discounting = Increase in principal investment only. ")
    print("2 - Periodic Discounting = Compounding periodically in a time period. ")
    print("3 - Continuous Discounting = Compounding at every instant in time. ")
    print("4 - Multiple Cash Flows Discounting = Finding the present value of cash flows dispersed at differnet times. ")
    print("5 - Annuity = Finding the present value of fixed cash flows. ")

    while True:
            try:
                problemtype = int(input("Please input the problem type you're looking to solve: "))
                if problemtype in {1, 2, 3, 4, 5, 6}:
                    break
                else:
                    print("That is not a valid choice!")
                    problemtype = int(input("Please input the problem type you're looking to solve: "))
            except ValueError:
                print("Please enter a valid number!")
    if problemtype == 1: 
        print("Okay! I'll need the future value, interest rate, and number of periods: ")
        FV = float(input("Future Value ($): "))
        r = float(input("Annual Interest Rate (%): "))
        n = float(input("Periods (Years): "))
        PV = FV / (1 + (r/100))**n
        print(f"The Present Value is: ${PV:,.2f}.")
    elif problemtype == 2:
        print("Okay! I'll need the future value, interest rate, number of periods, and frequency of compounding per period: ")
        FV = float(input("Future Value ($): "))
        r = float(input("Annual Interest Rate (%): "))
        n = float(input("Periods (Years): "))
        m = float(input("Frequency (Times per Year): "))
        PV = FV / (1 + (r/(m * 100)))**(n*m)
        print(f"The Future Value is: ${PV:,.2f}.")
    elif problemtype == 3: 
        print("Okay! I'll need the future value, interest rate, and number of periods: ")
        FV = float(input("Future Value ($): "))
        r = float(input("Annual Interest Rate (%): "))
        n = float(input("Periods (Years): "))
        PV = FV / m.exp((r/100)*n)
        print(f"The Present Value is: ${FV:,.2f}.")
    elif problemtype == 4: 
        PV = 0
        print("Okay! I'll need the number of cash flows, the interest rates, the number of periods, and the value of each cash flow: ")
        r = float(input("Annual Interest Rate (%): "))
        t = float(input("Total Number of Periods (Years): "))
        n = int(input("How many cash flows are there?: "))
        for i in range (n):
            CF = float(input(f"Cash Flow {i + 1} Amount ($): "))
            when = float(input(f"Year Cash Flow {i + 1} Received: "))
            PV = PV + (CF / (1 + (r / 100))**(when))
        print(f"The present value of these cash flows is: ${PV:,.2f}.")
    elif problemtype == 5:
        print("Okay! I'll need the annuity value, annual interest rate, and number of periods: ")
        CF = int(input("Annuity Value: "))
        r = float(input("Annual Interest Rate (%): "))
        t = float(input("Total Number of Periods (Years): "))
        PV = (CF*100/r) * (1 - (1 / (1 + ((r/100)))**t))
        print(f"The present value of these cash flows is: ${PV:,.2f}.")
    


# Compounding
'''
1 - Simple Compounding = Increase in principal investment only. 
2 - Periodic Compounding = Compounding periodically in a time period. 
3 - Continuous Compounding = Compounding at every instant in time. 
4 - Multiple Cash Flows Compounding = Finding the future value of cash flows invested at differnet times. 
5 - Annuity = Finding the future value of constant cash flows. 
6 - Between Periods = Finding the future value of cash flows between periods (not starting today). 
'''

if topic == 2:
    print("Looks like you want to solve a compounding problem! Here are the problems we can solve:")
    print("1 - Simple Compounding = Increase in principal investment only. ")
    print("2 - Periodic Compounding = Compounding periodically in a time period. ")
    print("3 - Continuous Compounding = Compounding at every instant in time. ")
    print("4 - Multiple Cash Flows Compounding = Finding the future value of cash flows invested at differnet times compouding annually.")
    print("5 - Annuity = Finding the future value of constant cash flows.")
    print("6 - Between Periods = Finding the future value of cash flows between periods (not starting today).")

    while True:
        try:
            problemtype = int(input("Please input the problem type you're looking to solve: "))
            if problemtype in {1, 2, 3, 4, 5}:
                break
            else:
                print("That is not a valid choice!")
                problemtype = int(input("Please input the problem type you're looking to solve: "))
        except ValueError:
            print("Please enter a valid number!")

    if problemtype == 1: 
        print("Okay! I'll need the present value, interest rate, and number of periods: ")
        PV = float(input("Present Value ($): "))
        r = float(input("Annual Interest Rate (%): "))
        n = float(input("Periods (Years): "))
        FV = PV * (1 + (r/100))**n
        print(f"The Future Value is: ${FV:,.2f}.")
    elif problemtype == 2:
        print("Okay! I'll need the present value, interest rate, number of periods, and frequency of compounding per period: ")
        PV = float(input("Present Value ($): "))
        r = float(input("Annual Interest Rate (%): "))
        n = float(input("Periods (Years): "))
        m = float(input("Frequency (Times per Year): "))
        FV = PV * (1 + (r/(m * 100)))**(n*m)
        print(f"The Future Value is: ${FV:,.2f}.")
    elif problemtype == 3: 
        print("Okay! I'll need the present value, interest rate, and number of periods: ")
        PV = float(input("Present Value ($): "))
        r = float(input("Annual Interest Rate (%): "))
        n = float(input("Periods (Years): "))
        FV = PV * m.exp((r/100)*n)
        print(f"The Future Value is: ${FV:,.2f}.")
    elif problemtype == 4: 
        FV = 0
        print("Okay! I'll need the number of cash flows, the interest rates, the number of periods, and the value of each cash flow: ")
        r = float(input("Annual Interest Rate (%): "))
        t = float(input("Total Number of Periods (Years): "))
        n = int(input("How many cash flows are there?: "))
        for i in range (n):
            CF = float(input(f"Cash Flow {i + 1} Amount ($): "))
            when = float(input(f"Year Cash Flow {i + 1} Received: "))
            FV = FV + (CF * (1 + (r / 100))**(t-(when-1)))
        print(f"The future value of these investments is: ${FV:,.2f}.")
    elif problemtype == 5:
        print("Okay! I'll need the annuity value, annual interest rate, and number of periods: ")
        CF = int(input("Annuity Value: "))
        r = float(input("Annual Interest Rate (%): "))
        t = float(input("Total Number of Periods (Years): "))
        FV = (CF*100/r) * ((1+(r/100))**t - 1)
        print(f"The future value of these cash flows is: ${FV:,.2f}.")
    elif problemtype == 6:
        print("Okay! I'll need the value, interest rate, total number of periods, and number of periods before payments start: ")
        V = float(input("Value ($): "))
        r = float(input("Annual Interest Rate (%): "))
        n = float(input("Periods (Years): "))
        m = float(input("Starting Period (Years): "))
        FV = V * (1 + (r/100))**(n - m)
        print(f"The Future Value is: ${FV:,.2f}.")

# Effective Annual Rate (EAR)

elif topic == 3: 
    print("Okay! Let's find the EAR. Please tell me the annual percent rate and number of periods per year!")
    r = float(input("APR (%): "))
    m = float(input("Periods (Years): "))
    EAR = (((1 + r/(100*m))**m) - 1) * 100
    print(f"The EAR is: {EAR:,.2f}%.")

# Solving for Interest Rate
    
elif topic == 4: 
    print("Okay! Let's find the Annual Interest Rate. Please tell me the present value, future value, and the number of periods!")
    PV = float(input("Present Value ($): "))
    FV = float(input("Future Value ($): "))
    n = float(input("Number of Periods: "))
    r = 100*((FV / PV)**(1/n) - 1)
    print(f"The Annual Interest Rate is: {r:.2f}.%")

# Solving for the Number of Periods
    
elif topic == 5: 
    print(print("Okay! Let's find the number of periods. Please tell me the present value, future value, and the annual interest rate!"))
    PV = float(input("Present Value ($): "))
    FV = float(input("Future Value ($): "))
    r = float(input("Annual Interest Rate (%): "))
    n = m.log(FV / PV) / m.log(1+r/100)
    print(f"The number of periods is: {n}.")