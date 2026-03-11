# Azure DATA Full Stack — Apple Global Sales Intelligence Platform
> **ElectroTrend** | Plateforme analytique Azure complète | 2022–2024

---

## Description du projet

ElectroTrend, entreprise internationale de distribution tech, a mandaté notre équipe Data pour concevoir et implémenter une **plateforme analytique Azure complète** permettant d'analyser les ventes mondiales Apple sur la période 2022–2024.

---

##  Architecture

```
CSV Source
    ↓
Azure Blob Storage (Landing Zone)
    ↓
Azure Data Factory (ADF) — Orchestration
    ↓
ADF Mapping Data Flow — Nettoyage ETL
    ↓
Azure SQL Database — Staging (staging_sales)
    ↓
Star Schema (Data Warehouse)
    ├── Dim_Date
    ├── Dim_Product
    ├── Dim_Geography
    ├── Dim_Channel
    ├── Dim_CustomerSegment
    └── Fact_Sales
```

---

##  Dataset

| Propriété | Valeur |
|-----------|--------|
| **Source** | Apple Global Product Sales Dataset |
| **Transactions** | 11 500 |
| **Pays** | 47 |
| **Villes** | 514+ |
| **Produits** | 43 |
| **Colonnes** | 27 |
| **Période** | 2022 – 2024 |

---

## Services Azure utilisés

| Service | Rôle |
|---------|------|
| **Azure Blob Storage** | Landing Zone — stockage du CSV brut |
| **Azure Data Factory** | Orchestration des pipelines |
| **ADF Mapping Data Flow** | ETL — nettoyage et transformation |
| **Azure SQL Database** | Staging + Data Warehouse (Star Schema) |

---

## Structure du projet

```
📁 ElectroTrend_Azure_Project/
├── 📁 sql/
│   ├── 📄 01_checks.sql              ← Vérifications qualité données
│   ├── 📄 02_nettoyage.sql           ← Nettoyage et imputation
│   ├── 📄 03_star_schema.sql         ← CREATE TABLE Dim + Fact
│   └── 📄 04_insert_data.sql         ← INSERT INTO Dim + Fact
├── 📁 adf/
│   └── 📄 pipeline_apple_sales.json  ← Pipeline ADF exporté
├── 📁 architecture/
│   └── 📄 architecture_diagram.png
├── 📁 rapport/
│   └── 📄 rapport_azure_services.pdf
└── 📄 README.md
```

---

## Étapes ETL — Nettoyage des données

### Vérifications effectuées :
- ✅ Détection et suppression des doublons
- ✅ Vérification des valeurs NULL par colonne
- ✅ Imputation `customer_rating` par moyenne (segment + année)
- ✅ Vérification des valeurs aberrantes (revenue, discount, units)
- ✅ Validation de la cohérence des colonnes calculées
- ✅ Vérification des types de données
- ✅ Validation des dates (2022–2024)

---

## Star Schema — Data Warehouse

### Tables de dimensions :

| Table | Colonnes clés |
|-------|--------------|
| **Dim_Date** | date_id, full_date, year, quarter, month |
| **Dim_Product** | product_id, product_name, category, storage, color |
| **Dim_Geography** | geography_id, country, region, city |
| **Dim_Channel** | channel_id, sales_channel, payment_method |
| **Dim_CustomerSegment** | segment_id, customer_segment, age_group |

### Table de faits :

| Table | Métriques |
|-------|-----------|
| **Fact_Sales** | revenue_usd, units_sold, discount_pct, customer_rating, return_status |
