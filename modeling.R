library(tidyverse)
library(DBI)
library(rstan)
rstan_options(auto_write = TRUE)
library(coda)

con <- dbConnect(odbc::odbc(), "Postgres (local)")

# Pull data from db using dplyr
df <- tbl(con, "forecast") %>%
  transmute(temp_lag = lag(temp), 
            temp,
            pred_time) %>%
  filter(!is.na(temp_lag)) %>%
  collect()

# Input Data
X <- model.matrix(~temp_lag, df)
y <- df$temp

# Data for predicting new y^s
new_X <- model.matrix(~temp_lag, 
                      data.frame(temp_lag = seq(floor(min(df$temp)), 
                                                ceiling(max(df$temp)))))

#the model
m_norm <- stan(file = here::here("reg_model.stan"),
               data = list(N = length(y) , N2 = nrow(new_X), K = 2, 
                           y = y, X = X, new_X = new_X),
               pars = c("beta","sigma","y_pred"))
post_beta <- As.mcmc.list(m_norm, pars = "beta")

jpeg(here::here("plots", 'beta_plot.jpg'))
plot(post_beta)
dev.off()

