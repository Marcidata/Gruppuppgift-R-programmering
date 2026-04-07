# ==============================
# 1. Läs in paket och data
# ==============================
library(tidyverse)

# Läs in datasetet (filen måste ligga i din working directory)
df <- read.csv("ecommerce_orders.csv")

# ==============================
# 2. Datasetets storlek
# ==============================
# Visar hur stort datasetet är
dim(df)      # antal rader och kolumner
nrow(df)     # antal rader
ncol(df)     # antal kolumner

# ==============================
# 3. Variabler och datatyper
# ==============================
# Ger en snabb överblick över variablerna
glimpse(df)

# Visar de första raderna i datasetet
head(df)

# ==============================
# 4. Saknade värden
# ==============================
# Antal saknade värden per kolumn
colSums(is.na(df))

# Procent saknade värden per kolumn
colSums(is.na(df)) / nrow(df) * 100

# ==============================
# 5. Visualisera saknade värden
# ==============================
# install.packages("naniar")  # kör bara första gången
library(naniar)

# Grafisk översikt över saknade värden
vis_miss(df)
