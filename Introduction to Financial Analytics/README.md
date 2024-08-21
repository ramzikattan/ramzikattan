Project Description: While studying Introduction to Financial Analytics, I wanted to take the concepts beyond than stationary excel sheets and create interactive scripts that would query users on what problems they wanted to solve regarding certain umbrella topics. Here are the scripts I created to achieve this. 

  Time Value of Money: This script will solve problems relating to Discounting Cash Flows, Compounding Cash Flows, Finding Effective Annual Rates, Finding Annual Interest Rates, and Finding Number of Periods. Within each section, there are subsections to refine your problem. 

  Present & Future Value: This script acts very similarly to the 'Time Value of Money' script except it accounts for more complex, multi-stage growth discounting and compounding scenarios for more realistic calculations. 

  Financial Security Valuation: This script will solve problems relating to Present Value of Discounting Annuities, Financial Securities, and Valuation of Common Stock. 

  Coupon-Paying Bond Valuation: This script will value coupons and visualize the coupon's sensitivity to interest rates by calculating the duration and modified duration, as well as DV01 and the return. This script mirrors real life coupon considerations better than the previous 'Financial Security Valuation' script. A simple for loop was executed to calculate the bond values for a predetermined range of YTMs using the other parameters given by the user for each case of interest payment frequency. Matplot was used to generate the plots.  

  Stock Intrinsic Value: This python script first queries the user for the ticker symbol, then retrieves the last closing price from yfinance. The user is then asked about the discrete periods and the years they occur in, and the loops to ask for each cash flow and discounts them within the loop. After discrete periods are completed, the user is asked how many growth periods there are. For every growth period except the last, the user is asked in what year this growth period ends and then asks for the required information to find the present value of the growth period dividends. For the last growth period, a perpetuity is found. Finally, the intrinsic value is assessed against the latestPrice and provides a recommendation based on if the stock is overvalued, undervalued, or correctly valued (roughly). Error handling is present throughout.

  Capital Budgeting: This program will provide a recommendation on whether to go through with a project or not by calculating the Net Present Value and Internal Rate of Return of a projects cash flows. This script can also calculate the Weighted Average Cost of Capital (WACC) for a company's financing. 

  
