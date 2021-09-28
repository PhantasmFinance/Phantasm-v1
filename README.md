# 👻 Phantasm Finance 👻
## defi doesn't have to be scary

The goal of Phantasm Finance is to further modularize leveraged long and short positions in crypto, make them more accessible, and make use of floating-rate bonds to secure them against market conditions. That's a lot of words, so let's dissect it.

A long position is initiated with Coin X and Stablecoin Y. To do so Imagine a pair that lets you use Coin X as collateral to take out a loan for USDC.

1. You deposit $100 of Coin X
2. You take out a loan of $60 in USDC against that $100 in coin X 
3. You buy more Coin X with that $60
4. Deposit the Coin X you just bought as collateral

Then, if Coin X moons you have $200 of collateral (Assuming the $160 of collateral appreciated in value $40), but only owe the lending provider $60 of USDC, so you can repay the debt to claim your collateral, which is worth $40 more than just holding the Coin X

The reverse can be done to create a short position, where debt is owed in Coin X to collect the stablecoin collateral (Coin X is assumed to decrease in value, so it can be bought back for less).

Phantasm Finance does this using Kashi and Sushiswap of the Sushi family, for their ease of incorporation across multiple chains, and End to End integration, but built with other providers in mind.

## Demo

Test out a demo yourself at [Demo.net](). DO NOT USE REAL ETH, this is a Ropstein Testnet deployment.

## Secure Shorts/Longs with Floating-Rate Bonds

A floating-rate bond is debt to someone holding collateral in a lending pool. Since the debt is fixed, a sudden spike in APR would increase the value of the bond greatly. Conversely, lenders close to their limits would be closer to liquidation. As Long/Short postions require lending if they buy a FRB on a pool which they are lending from, or similar pool, the bond would appreciate with any spike in APR, which would allow for them to 'insulate' their short position against the movemements of the lending market.

## Future Plans

I plan to continue work on Phantasm Finance after the hackathon ends, with some of the improvements outlined below 

- Launch on Polygon bringing the gas cost to a reasonable level. 

- UI/UX Improvements
