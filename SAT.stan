data {
  int<lower=0> N;
  real ssat;
  real sspend;
  real sptake;
  real msat;
  real mspend;
  real mptake;
  vector[N] z_sat;
  vector[N] z_spend;
  vector[N] z_ptake;
  int J;
}

parameters {
  real z_beta0;
  real z_beta[J];
  real<lower=0> z_sigma;
  real<lower=0> numinusone;
}
transformed parameters{
  real<lower = 0> nu;
  nu = numinusone + 1;
}
model {
  numinusone ~ exponential(1/29.0);
  z_beta0 ~ normal(0,1);
  z_beta[J] ~ normal(0,1);
  z_sigma ~ normal(0,1);
  z_sat ~ student_t(nu, z_beta0 + z_beta[1]*z_spend + z_beta[2]*z_ptake, z_sigma);
  
}

generated quantities{
  real beta0;  
  real beta[J]; 
  real<lower=0> sigma;
  sigma = ssat*z_sigma;
  beta0 = z_beta0*ssat + msat - z_beta[1]*mspend*ssat/sspend - z_beta[2]*mptake*ssat/sptake;
  beta[1] = z_beta[1]*ssat/sspend;
  beta[2] = z_beta[2]*ssat/sptake;
}

