# ============================================================
# 1. Läs in paket och data
# ============================================================

library(tidyverse)

# Läs in datasetet (kursens rekommenderade funktion)
df <- read_csv("ecommerce_orders.csv")


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
  antal_saknade = missing_counts
)

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

