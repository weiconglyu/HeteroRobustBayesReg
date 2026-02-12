# Heteroskedasticity-Robust Inference in Bayesian Linear Regression via the Generalized Method of Moments
### Stan models
- **nlm.stan**  
  Bayesian linear regression with a normal likelihood, assuming homoskedastic errors.

- **mhm.stan**  
  Multiplicative heteroskedasticity model, where the error variance depends on covariates.

- **gmm.stan**  
  Bayesian GMM model, providing inference that is robust to both heteroskedasticity and nonnormal errors.

### R scripts
- **data_1_3.R**  
  Generates simulation data for Cases 1–3.

- **data_4.R**  
  Generates simulation data for Case 4.

- **estimate.R**  
  Fits different models (OLS, HC2, NLM, MHM, and GMM) and saves estimation results.
