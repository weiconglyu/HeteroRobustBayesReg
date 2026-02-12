library(estimatr)
library(tibble)
library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

model_nlm <- stan_model('nlm.stan')
model_mhm <- stan_model('mhm.stan')
model_gmm <- stan_model('gmm.stan')

estimate <- function(model, dat) {
  iter <- 5000
  repeat {
    fit <- sampling(model, dat, iter = iter)
    est <- summary(fit)$summary
    if (max(est[, 'Rhat'], na.rm = T) < 1.05)
      break
    iter <- iter + 5000
  }
  summary(fit, 'beta')$summary[, c(1, 3, 4, 8)]
}

dats <- readRDS('dat.rds')
for (i in 1:length(dats)) {
  dat <- dats[[i]]
  N <- dat$N
  K <- dat$K
  x <- dat$x
  y <- dat$y

  fit.ols <- lm(y ~ x[, -1])
  result.ols <- cbind(summary(fit.ols)$coefficients[, 1:2], confint(fit.ols))

  fit.hc2 <- lm_robust(y ~ x[, -1], se_type = 'HC2')
  result.hc2 <- summary(fit.hc2)$coefficients[, c(1:2, 5:6)]

  dat.w <- c(dat, list(mu_beta = rep(0, K), sigma_beta = rep(5, K), mu_gamma = rep(0, K), sigma_gamma = rep(2, K)))
  dat.i <- c(dat, list(mu_beta = c(0, 1, -0.5), sigma_beta = rep(0.5, K), mu_gamma = rep(0, K), sigma_gamma = rep(2, K)))

  result.nlmw <- estimate(model_nlm, dat.w)
  result.nlmi <- estimate(model_nlm, dat.i)

  result.mhmw <- estimate(model_mhm, dat.w)
  result.mhmi <- estimate(model_mhm, dat.i)

  result.gmmw <- estimate(model_gmm, dat.w)
  result.gmmi <- estimate(model_gmm, dat.i)

  result <- list(ols = result.ols, hc2 = result.hc2,
                 nlmw = result.nlmw, nlmi = result.nlmi,
                 mhmw = result.mhmw, mhmi = result.mhmi,
                 gmmw = result.gmmw, gmmi = result.gmmi)
  saveRDS(result, paste0('result_', i, '.rds'))
}
