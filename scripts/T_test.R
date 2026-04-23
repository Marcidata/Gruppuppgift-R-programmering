df_clean <- readRDS("data/df_clean.rds")


t.test(discount_pct ~ returned, data = df_clean)

