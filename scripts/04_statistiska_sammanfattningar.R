# Jan
# ============================================================
# Statistiska sammanfattningar 
# ============================================================

#Laddar upp tidyverse och datan
library(tidyverse)
df_clean <- readRDS("data/df_clean.rds")

# Grundläggande översikt 
n_orders <- nrow(df_clean)
n_customers <- n_distinct(df_clean$customer_id)
total_sales <- sum(df_clean$order_value, na.rm = TRUE)

spridningsmatt <- df_clean %>%
  summarise(
    mean_order = mean(order_value, na.rm = TRUE),
    median_order = median(order_value, na.rm = TRUE),
    min_order = min(order_value, na.rm = TRUE),
    max_order = max(order_value, na.rm = TRUE)
  )


# Kollar total_sales och avg_order per olika grupper


sales_per_product_category <- df_clean %>%
  group_by(product_category) %>%
  summarise(
    total_sales = sum(order_value, na.rm = TRUE),
    avg_order = mean(order_value, na.rm = TRUE), 
    n_order = n()) %>% 
    arrange(desc(total_sales))
  
sales_per_subcategory <- df_clean %>%
  group_by(product_subcategory) %>%
  summarise(
    total_sales = sum(order_value, na.rm = TRUE),
    avg_order = mean(order_value, na.rm = TRUE), 
    n_order = n()) %>% 
    arrange(desc(total_sales))

sales_per_customer_segment <- df_clean %>%
  group_by(customer_segment) %>%
  summarise(
    total_sales = sum(order_value, na.rm = TRUE),
    avg_order = mean(order_value, na.rm = TRUE),
    n_order = n()) %>% 
    arrange(desc(total_sales))

sales_per_customer_type <- df_clean %>%
  group_by(customer_type) %>%
  summarise(
    total_sales = sum(order_value, na.rm = TRUE),
    avg_order = mean(order_value, na.rm = TRUE),
    n_order = n()) %>% 
    arrange(desc(total_sales))

sales_per_region <- df_clean %>%
  group_by(region) %>%
  summarise(
    total_sales = sum(order_value, na.rm = TRUE),
    avg_order = mean(order_value, na.rm = TRUE),
    n_order = n()) %>% 
    arrange(desc(total_sales))


sales_per_city <- df_clean %>%
  group_by(city) %>%
  summarise(
    total_sales = sum(order_value, na.rm = TRUE),
    avg_order = mean(order_value, na.rm = TRUE),
    n_order = n()) %>% 
    arrange(desc(total_sales))

# Andel returer
#mean_retur <- mean(df_clean$returned == "yes", na.rm = TRUE)
mean_retur <- round(mean(df_clean$returned_flag, na.rm = TRUE) * 100, 2)

# Visar hur många ordrar har rabatt
andel_rabatt <- df_clean |>  
  summarise(andel_rabatt = mean(discount_pct > 0, na.rm = TRUE) * 100)
min_rea <- min(df_clean$discount_pct[df_clean$discount_pct > 0], na.rm = TRUE)
max_rea = max(df_clean$discount_pct, na.rm = TRUE)
mean_rea <- mean(df_clean$discount_pct[df_clean$discount_pct > 0], na.rm = TRUE)

# Andel payment_method i procent
andel_payment_method <- df_clean %>%
  group_by(payment_method) %>%
  summarise(antal = n()) %>% 
  mutate(andel_procent = (antal / sum(antal)) * 100) %>% 
  arrange(desc(andel_procent))
  
# Printar ut taebller och varaibler så de syns i run_analys
print("Antal kunder")
print(n_customers)
print("Antal order")
print(n_orders)
print("Total sales")
print(total_sales)
print("Spridningsmått")
print(spridningsmatt)
print("Average retur")
print(mean_retur)
print("Andel betalningsmetoder")
print(andel_payment_method)
print("Andel rabatt")
print(andel_rabatt)
print("Sales per kundsegment")
print(sales_per_customer_segment)
print("Sales per kundtyp")
print(sales_per_customer_type)
print("Sales per stad")
print(sales_per_city)
print("Sales per region")
print(sales_per_region)
print("Sales per produktkategori")
print(sales_per_product_category)
print("Sales per subkategori")
print(sales_per_subcategory)  
print("Min discount")
print(min_rea)
print("Max discount")
print(max_rea)
print("Average discount")
print(mean_rea)
