library(tidyverse)
library(dplyr)
library(stringi)



df <- read_csv("data/ecommerce_orders.csv")

d <- df |>
  filter(if_any(everything(), is.na))

# ---- städar datan ----
df_clean <- df |> 
  rename_with(tolower) |> 
  mutate(
    across(
      where(is.character) & !c(order_id, customer_id),
      ~ trimws(tolower(.x))
    )
  ) |> 
  mutate(city = stri_trans_general(city, "Latin-ASCII")) |> 
  mutate(city = recode(city, "gothenburg" = "goteborg")) |> 
  mutate(campaign_source = recode(campaign_source, "social media" = "social"))

#kollar så att det är rätt distinkta värden i några kolumner
unique(df$city)
unique(df_clean$city)

unique(df$payment_method)
unique(df_clean$payment_method)


unique(df$campaign_source)
unique(df_clean$campaign_source)

# ---- intervall för min och max datum ----
range(df_clean$order_date)

# ---- Tar bort NA i discount ----
df_clean <- df_clean |> 
  filter(!is.na(discount_pct))

# ---- hanterar saknade värden för resternade kolumner ----
df_clean <- df_clean |> 
  mutate(
    payment_method = replace_na(payment_method, "unknown"),
    city = replace_na(city, "unknown"),
    campaign_source = replace_na(campaign_source, "unknown"),
    shipping_days = replace_na(shipping_days, median(shipping_days, na.rm = TRUE))
  )

# ---- skapar nya relevanta columner ----
df_clean <- df_clean |> 
  mutate(
    order_value = round(quantity * unit_price * (1 - discount_pct), 2),
    returned_flag = if_else(returned == "yes", 1, 0),
    discount_group = cut(discount_pct,
                           breaks = seq(0, 0.40, by = 0.05),
                           include.lowest = TRUE,
                           ordered_result = TRUE
    )
  )

# ---- konverterar kategoriska kolumner för analys ----
df_clean <- df_clean |> 
  mutate(
  product_category = as.factor(product_category),
  product_subcategory = as.factor(product_subcategory)
)

saveRDS(df_clean, "data/df_clean.rds")

