library(scales)
library(ggplot2)

df_clean <- readRDS("data/df_clean.rds")
# --- Produktkategorier som driver högst försäljning ---
sales_by_category <- df_clean |> 
  group_by(product_category) |> 
  summarise(total_sales = sum(order_value, na.rm = TRUE)) |> 
  arrange(total_sales)

plot_category_vs_total_order_value <- ggplot(
  sales_by_category, aes(x = reorder(product_category, total_sales), y = total_sales)) +
  geom_col(fill = "#264653", width = 0.7) +
  coord_flip() +
  scale_y_continuous(labels = label_number(big.mark = " ")) +
  labs(
    title = "Produktkategorier som driver högst försäljning",
    subtitle = "Total nettoförsäljning per produktkategori",
    x = NULL,
    y = "Försäljning"
  ) +
  theme_gray(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold")
  )

# --- Samband mellan rabatt och ordervärde ---
plot_discount_vs_order <- ggplot(
  df_clean, aes(x = discount_pct, y = order_value)) +
  geom_point(alpha = 0.35, color = "#264653") +
  geom_smooth(method = "lm", se = TRUE, color = "#D95F02", linewidth = 1.1) +
  scale_x_continuous(labels = label_percent(accuracy = 1)) +
  scale_y_continuous(labels = label_number(big.mark = " ")) +
  labs(
    title = "Samband mellan rabatt och ordervärde",
    subtitle = "Varje punkt är en order",
    x = "Rabatt (%)",
    y = "Ordervärde"
  ) +
  theme_gray(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold")
  ) +
  annotate(
    geom = "label",
    x = 0.225, y = 600,
    label = "Svagt negativt samband",
    hjust = 0,
    color = "black",
    fill = "white"
  ) +
  annotate(
    geom = "segment",
    x = 0.22, y = 550,
    xend = 0.20, yend = 300,
    color = "black",
    arrow = arrow(type = "closed")
  )

# --- Returgrad per rabattnivå ---
returns_by_discount <- df_clean |> 
  group_by(discount_group) |> 
  summarise(
    return_rate = mean(returned_flag, na.rm = TRUE),
    n_orders = n(),
    .groups = "drop"
  )

returns_by_discount <- returns_by_discount |> 
  filter(n_orders > 10)

plot_returnrate_vs_discountrate <- ggplot(
  returns_by_discount, aes(x = discount_group, y = return_rate, group = 1)) +
  geom_line(color = "#264653", linewidth = 1.2) +
  geom_point(aes(size = n_orders), color = "#264653") +
  scale_size(range = c(2, 8)) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  labs(
    title = "Returgrad per rabattnivå",
    subtitle = "Punktstorlek visar antal orders i varje rabattintervall",
    x = "Rabattintervall",
    y = "Returgrad",
    size = "Antal orders"
  ) +
  theme_gray(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold")
  )

# --- Rabattprocent efter returstatus ---

means <- df_clean %>%
  group_by(returned) %>%
  summarise(mean_discount = mean(discount_pct, na.rm = TRUE))

plot_discount_vs_returned <- ggplot(
  df_clean,
  aes(x = returned, y = discount_pct)
) +
  geom_boxplot(fill = "#264653") +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  stat_summary(fun = mean, geom = "point", color = "red", size = 3) +
  geom_text(
    data = means,
    aes(
      x = returned,
      y = mean_discount,
      label = sprintf("Mean = %.3f%%", mean_discount)
    ),
    color = "red",
    vjust = -1
  ) +
  labs(
    title = "Rabattprocent efter returstatus",
    subtitle = "Fördelning av rabattprocent för returnerade respektive icke returnerade varor",
    x = "Returstatus",
    y = "Rabatt (%)"
  ) +
  scale_x_discrete(labels = c(
    "no" = "Nej (ej returnerad)",
    "yes" = "Ja (Returnerad)"
  )) +
  theme_gray(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold")
  )

ggsave(
  "plots/category_vs_total_order_value.png",
  plot_category_vs_total_order_value,
  width = 8,
  height = 5,
  dpi = 300
)
ggsave(
  "plots/discount_vs_order.png",
  plot_discount_vs_order,
  width = 8,
  height = 5,
  dpi = 300
)
ggsave(
  "plots/returnrate_vs_discountrate.png",
  plot_returnrate_vs_discountrate,
  width = 8,
  height = 5,
  dpi = 300
)


ggsave(
  "plots/discount_vs_returned.png",
  plot_discount_vs_returned,
  width = 8,
  height = 5,
  dpi = 300
)
