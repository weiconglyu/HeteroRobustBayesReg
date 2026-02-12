data {
  int<lower = 1> N;                     // number of observations
  int<lower = 1> K;                     // number of predictors
  matrix[N, K] x;                       // predictor matrix
  vector[N] y;                          // outcome vector

  vector[K] mu_beta;                    // prior mean of coefficients
  vector<lower = 0>[K] sigma_beta;      // prior sd of coefficients
}

parameters {
  vector[K] beta;                       // coefficients
  real<lower = 0> sigma;                // sd of errors
}

model {
  y ~ normal(x * beta, sigma);

  beta ~ normal(mu_beta, sigma_beta);
  sigma ~ cauchy(0, 1);
}
