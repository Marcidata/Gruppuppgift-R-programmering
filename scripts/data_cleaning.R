library(tidyverse)
library(dplyr)
library(stringi)

df <- read_csv("data/ecommerce_orders.csv")

# ---- städar datan ----
df_clean <- df |> 
  rename_with(tolower) |> 
  mutate(
    across(
      -c(order_id, customer_id),
      ~ {
        if (is.character(.x)) trimws(tolower(.x)) else .x
      }
    )
  ) |> 
  mutate(city = stri_trans_general(city, "Latin-ASCII")) |> 
  mutate(city = recode(city, "gothenburg" = "goteborg")) |> 
  mutate(campaign_source = recode(campaign_source, "social media" = "social"))

#kollar så att det är rätt distinkta värden i varje kolumn
unique(df$city)
unique(df_clean$city)

unique(df$payment_method)
unique(df_clean$payment_method)


unique(df$campaign_source)
unique(df_clean$campaign_source)

# ---- intervall för min och max datum ----
range(df_clean$order_date)

# ---- Tar bort NA i discount ----
df_clean <- df_clean %>%
  filter(!is.na(discount_pct))

# ---- Ändrar NA värdena för resternade kolumner ----
df_clean <- df_clean |> 
  mutate(
    discount_pct = replace_na(discount_pct, 0),
    payment_method = replace_na(payment_method, "unknown"),
    city = replace_na(city, "unknown"),
    campaign_source = replace_na(campaign_source, "unknown"),
    shipping_days = replace_na(shipping_days, median(shipping_days, na.rm = TRUE))
  )

# ---- skapar två ny relevanta columner ----
df_clean <- df_clean |> 
  mutate(
    net_revenue = quantity * unit_price * (1 - discount_pct),
    discount_group = case_when(
      discount_pct <= quantile(discount_pct, 0.33) ~ "låg",
      discount_pct <= quantile(discount_pct, 0.67) ~ "medel",
      TRUE ~ "hög"
    )
    
    )

# ---- faktoriserar kategoriska kolumner som kommer användas i analysen ----
df_clean <- df_clean |> 
  mutate(
  product_category = as.factor(product_category),
  product_subcategory = as.factor(product_subcategory),
  discount_group = as.factor(discount_group)
)

