# ============================================================
# 1. Läs in paket och data
# ============================================================

library(tidyverse)

# Läs in datasetet (kursens rekommenderade funktion)
df <- read_csv("data/ecommerce_orders.csv")


# ============================================================
# 2. Datasetets storlek
# ============================================================

# Antal rader och kolumner
dim(df)

# Antal rader
nrow(df)

# Antal kolumner
ncol(df)

# ============================================================
# 3. Variabler och datatyper
# ============================================================

# Snabb överblick över variablerna
glimpse(df)

# Visa de första raderna
head(df)

# ============================================================
# 4. Saknade värden (numerisk sammanfattning)
# ============================================================

# Antal saknade värden per kolumn
missing_counts <- colSums(is.na(df))
missing_counts

# Procent saknade värden per kolumn
missing_pct <- colSums(is.na(df)) / nrow(df) * 100
missing_pct

# Skapa en dataframe för visualisering (kursens metod)
missing_df <- tibble(
  kolumn = names(df),
  antal_saknade = missing_counts,
  procent_saknade =  missing_pct
)

missing_df
# En funktion som kollar svarsalternativ i kolumnen, för att undvika flera varianter av samma sak

check_alter <- function(data, col) {
  df %>%
    count({{ col }}, sort = TRUE)
}

# Kolumner som behöver en check
cat_col_in_df <- names(df)[
  sapply(df, is.character) &
    !names(df) %in% c("customer_id", "order_id", "order_date")
]

# En loop som printar ut resultat
for (col in cat_col_in_df) {
  cat("\n---", col, "---\n")
  print(check_alter(df, !!sym(col)))
}

# Kolumner som behöver fixas om är campaign_source, payment_method och city


# ============================================================
# 5. Visualisering av saknade värden (kursens version)
# ============================================================

ggplot(missing_df, aes(x = kolumn, y = antal_saknade)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Saknade värden per kolumn",
    x = "Kolumn",
    y = "Antal saknade värden"
  ) +
  theme_minimal()

