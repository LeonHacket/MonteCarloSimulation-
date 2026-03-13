library(quantmod)

getSymbols("AAPL", from = "2020-01-01")
prices <- Cl(AAPL)

#Log returns
returns <- dailyReturn(prices, type="log")

#Current stock price 
S0 <- as.numeric(last(prices))

#Standart deviation
sigma_daily <- sd(returns)

#Annual volatility
sigma <- sigma_daily * sqrt(252)

#Strike price 
K_values <- c(0.9*S0, S0, 1.1*S0)

#Maturity in Years
T <- 1 

#Risk-free rate 
r <- 0.03

K_values <- c(0.9*S0, S0, 1.1*S0)

N_values <- c(100, 500, 1000, 5000, 10000, 50000, 100000)

results <- data.frame(
  Strike = numeric(),
  Simulations = numeric(),
  MonteCarlo = numeric(),
  BlackScholes = numeric(),
  Error = numeric()
)

for(K in K_values){

  d1 <- (log(S0/K) + (r + sigma^2/2)*T) / (sigma*sqrt(T))
  d2 <- d1 - sigma*sqrt(T)

  price_BS <- S0 * pnorm(d1) - K * exp(-r*T) * pnorm(d2)

  for(N in N_values){

    Z <- rnorm(N)

    ST <- S0 * exp((r - 0.5*sigma^2)*T + sigma*sqrt(T)*Z)

    payoff <- pmax(ST - K, 0)

    price_MC <- exp(-r*T) * mean(payoff)

    error <- abs(price_MC - price_BS)

    results <- rbind(results,
                     data.frame(
                       Strike = K,
                       Simulations = N,
                       MonteCarlo = price_MC,
                       BlackScholes = price_BS,
                       Error = error
                     ))
  }
}

print(results)

png("convergence_multiple_K.png")

plot(NULL,
     xlim=range(N_values),
     ylim=range(results$MonteCarlo),
     xlab="Number of Simulations",
     ylab="Option Price",
     main="Monte Carlo Convergence for Different Strikes")

colors <- c("blue","darkgreen","purple")

for(i in 1:length(K_values)){

  subset_data <- results[results$Strike == K_values[i],]

  lines(subset_data$Simulations,
        subset_data$MonteCarlo,
        type="b",
        col=colors[i],
        pch=16)
}

legend("topright",
       legend=paste("K =", round(K_values,2)),
       col=colors,
       pch=16)

dev.off()








