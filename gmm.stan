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
}

model {
  {
    vector[N] e = y - x * beta;
    matrix[N, K] u = rep_matrix(e, K) .* x;
    matrix[1, K] U = rep_matrix(1, 1, N) * u;
    matrix[K, K] S = crossprod(u) - crossprod(U) / N;
    target += -quad_form(inverse_spd((S + S') / 2), U') / 2;
  }

  beta ~ normal(mu_beta, sigma_beta);
}
