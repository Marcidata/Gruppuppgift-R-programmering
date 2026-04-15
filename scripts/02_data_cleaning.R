# Dariel
# 02_data_cleaning.R – Datastädning & förberedelse
# ══════════════════════════════════════════======

# 1: Vi laddar paket
library(tidyverse)

# 2: Läser in data
#df <- read_csv("ecommerce_orders.csv")

# 3: Utforskar datan
#glimpse(df)
#summary(df)
#head(df)

# 4: Hanterar saknade värden
#colSums(is.na(df))

# 5: Skapar nya variabler
# order_value = faktiskt betalt belopp per order (kvantitet * pris efter rabatt)
# Använder detta i analysen för att jämföra ordervärden mellan kategorier och rabattnivåer
df <- df |>
  mutate(
    order_value = quantity * unit_price * (1 - discount_pct)
  )

head(df$order_value) # kollar lite att det fungerade det ovan
# output:
# [1] 110.92  89.90 190.22 138.49  94.55     NA

# 6: Hanterar/Blir av med saknade värden
df <- df |>
  drop_na()

# kollar lite att det fungerade det ovan
nrow(df)  # [1] 879  -- ser bra ut
colSums(is.na(df))  # ser bra ut


# Funktion som trimmar mellanslag och gör till små bökstäver
clean_text_col <- function(x) { 
  trimws(tolower(x))
}

# Använder det på kolumner som behövde fixas 
df$city <- clean_text_col(df$city)
df$campaign_source <- clean_text_col(df$campaign_source)
df$payment_method <- clean_text_col(df$payment_method)


# Recodear allt till små bökstäver utan svenska tecken för att undvika förvirring
df <- df %>%
  mutate(
    city = recode(city,
                  "stockholm" = "stockholm",
                  "uppsala" = "uppsala",
                  "halmstad" = "halmstad",
                  "linkoping" = "linkoping",
                  "vasteras" = "vasteras",
                  "boras" = "boras",
                  "helsingborg" = "helsingborg",
                  "gothenburg" = "goteborg",
                  "malmo" = "malmo",
                  "orebro" = "orebro",
                  "norrkoping" = "norrkoping",
                  "lund" = "lund"
    )
  )

df <- df %>%
  mutate(
    campaign_source = recode(campaign_source,
                             "social media" = "social",
                             "social" = "social",
                             "paid search" = "paid search",
                             "email" = "email",
                             "direct" = "direct",
                             "organic" = "organic",
                             "affiliate" = "affiliate"
    )
  )
df <- df %>%
  mutate(across(
    c(region, product_category, product_subcategory,
      customer_type, customer_segment),
    ~ trimws(tolower(.))
  ))



# 7: Sparar städad data
write_csv(df, "data/ecommerce_orders_clean.csv")

