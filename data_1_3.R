library(tibble)
library(mvtnorm)

N <- c(100, 200, 500, 1000)
R <- 1000
K <- 3
beta <- c(0, 1, -0.5)

V1 <- function(x) { 1 }
V2 <- function(x) { exp(x[, 2] / 2) }
V3 <- function(x) { abs(x[, 2]) }

generate <- function(V, file) {
  dat <- do.call(c, lapply(N, function(N) {
    replicate(R, simplify = F, {
      x <- cbind(1, rmvnorm(N, sigma = matrix(c(1, .5, .5, 1), 2)))
      x[, 3] <- x[, 3] > 0
      y <- (x %*% beta)[, 1] + rnorm(N) * V(x)
      lst(N, K, x, y)
    })
  }))
  saveRDS(dat, file)
}

generate(V1, 'dat1.rds')
generate(V2, 'dat2.rds')
generate(V3, 'dat3.rds')
