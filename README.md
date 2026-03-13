# Monte Carlo Option Pricing in R

## Overview

This project implements a Monte Carlo simulation to price European call options and compares the results to the analytical Black–Scholes formula.

The goal is to demonstrate how stochastic simulation can approximate option prices derived from financial theory.

---

## Financial Model

The stock price is modeled using Geometric Brownian Motion

$$
dS_t = \mu S_t dt + \sigma S_t dW_t
$$

where

- \($$S_t$$\) is the stock price
- \($$\sigma$$\) is volatility
- \($$W_t$$\) is Brownian motion

---

## Black–Scholes Price

The price of a European call option is

$$
C = S_0 N(d_1) - K e^{-rT} N(d_2)
$$

where

$$
d_1 = \frac{\ln(S_0/K)+(r+\sigma^2/2)T}{\sigma\sqrt{T}}
$$

$$
d_2 = d_1 - \sigma\sqrt{T}
$$

---

## Monte Carlo Estimation

The option price can also be estimated via simulation

$$
C = e^{-rT} E[\max(S_T-K,0)]
$$

This expectation is approximated by

$$
C_{MC} = e^{-rT} \frac{1}{N} \sum_{i=1}^N \max(S_T^{(i)}-K,0)
$$
