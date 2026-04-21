# Gruppuppgift – R-programmering

Grupprojekt i kursen R-programmering för dataanalys.  
Datasetet innehåller e-handelsordrar och analysens flödet är:  
import → förståelse → städning → statistik → visualisering → analys.

---

## Hur man kör projektet

1. Öppna "Gruppuppgift-R-programmering.Rproj" i RStudio
2. Kör "run_analys.R" för att köra hela flödet i ordning

---

## Vad varje skript gör

01_data_forstaelse.R  

- Läser in rådata med "read_csv()"  
- Undersöker struktur med "glimpse()", "head()", "dim()"  
- Räknar och visualiserar saknade värden per kolumn  
- Identifierar felstavning i kolumner  

02_data_cleaning.R  

- Standardiserar text (lowercase, trimws, svenska tecken)  
- Åtgärdar felstavning i "city", "campaign_source", "payment_method"  
- Tar bort rader där "discount_pct" saknas  
- Ersätter övriga saknade värden med "unknown" eller median  
- Skapar nya variabler: "order_value", "returned_flag", "discount_group" 
- Sparar städad data som "data/df_clean.rds"  

04_statistiska_sammanfattningar.R

- Beräknar totalt antal ordrar, kunder och försäljning  
- Spridningsmått för "order_value" (mean, median, min, max)  
- Försäljning grupperat per kategori, subkategori, stad, region, kundsegment och kundtyp  
- Returandel och rabattanalys  
- Betalningsmetoder i procent  

05_plots.R

- Stapeldiagram: försäljning per produktkategori  
- Scatterplot: samband mellan rabatt och ordervärde (med linjär trend)  
- Linjediagram: returgrad per rabattnivå  
- Alla diagram sparas som PNG i "plots" mappen

T_test.R

- T-test för att undersöka statistiskt signifikanta skillnader i data

---

## Grupp

- Marziyeh – Dataförståelse & analys av saknade värden  
- Dariel – Datastädning (ursprungsversion)  
- Jan – Datastädning (uppdaterad version) & Statistiska sammanfattningar
- Simon – Visualiseringar & statistisk analys (T-test)  
- Isabel – Quarto-rapport & presentation
