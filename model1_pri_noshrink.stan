data {
  int<lower=0> N;
  real ssat;
  real sspend;
  real sptake;
  real msat;
  real mspend;
  real mptake;
  real mint;
  real sint;
  int J;
  real<lower=0> spend[N];
  real<lower=0> ptake[N];
  real<lower=0> inter[N]; 
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
  z_beta0 ~ student_t(10,0,1);
  z_beta[J] ~ student_t(10,0,1);
  z_sigma ~ normal(0,1);
}

generated quantities{
  real beta0;  
  real beta[J]; 
  real<lower=0> sigma;
  real y_fake[N];
  sigma = ssat*z_sigma;
  beta0 = z_beta0*ssat + msat - z_beta[1]*mspend*ssat/sspend - z_beta[2]*mptake*ssat/sptake - z_beta[3]*mint*ssat/sint;
  beta[1] = z_beta[1]*ssat/sspend;
  beta[2] = z_beta[2]*ssat/sptake;
  beta[3] = z_beta[3]*ssat/sint;
  for (i in 1:N) {
    y_fake[i] = student_t_rng(nu, beta0 + beta[1]*spend[i] + beta[2]*ptake[i] + beta[3]*inter[i], sigma);
  }
}

