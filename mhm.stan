data {
  int<lower = 1> N;                     // number of observations
  int<lower = 1> K;                     // number of predictors
  matrix[N, K] x;                       // predictor matrix
  vector[N] y;                          // outcome vector

  vector[K] mu_beta;                    // prior mean of coefficients for the outcome
  vector<lower = 0>[K] sigma_beta;      // prior sd of coefficients for the outcome

  vector[K] mu_gamma;                   // prior mean of coefficients for log error var
  vector<lower = 0>[K] sigma_gamma;     // prior sd of coefficients for log error var
}

parameters {
  vector[K] beta;                       // coefficients for the outcome
  vector[K] gamma;                      // coefficients for log error var
}

model {
  y ~ normal(x * beta, exp(x * gamma / 2));

  beta ~ normal(mu_beta, sigma_beta);
  gamma ~ normal(mu_gamma, sigma_gamma);
}
