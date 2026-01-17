from pathlib import Path
import pandas as pd

print("RUNNING UPDATED FILE ")

import pandas as pd
from pathlib import Path

# ================================
# 1. LOAD RAW DATA
# ================================
raw_path = Path("C:/Users/dell/Desktop/Revenue-Leakage-Analysis/SampleSuperstore.csv")
df = pd.read_csv(raw_path, encoding="latin1")


# ================================
# 2. BASIC DATA CLEANING
# ================================
df.drop_duplicates(inplace=True)

df['Order Date'] = pd.to_datetime(df['Order Date'])
df['Ship Date'] = pd.to_datetime(df['Ship Date'])

# ================================
# 3. STANDARDIZE COLUMN NAMES
# ================================
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("-", "_")
)

# ================================
# 4. REVENUE & LEAKAGE METRICS
# ================================
df['gross_revenue'] = df['sales']
df['discount_loss'] = df['sales'] * df['discount']
df['net_revenue'] = df['gross_revenue'] - df['discount_loss']

# ================================
# 5. LOGISTICS COST
# ================================
logistics_rate = {
    'Central': 0.06,
    'East': 0.08,
    'South': 0.07,
    'West': 0.10
}

df['logistics_cost'] = df.apply(
    lambda x: x['sales'] * logistics_rate.get(x['region'], 0.08),
    axis=1
)

# ================================
# 6. OPERATIONAL COST
# ================================
operational_rate = {
    'Furniture': 0.12,
    'Office Supplies': 0.06,
    'Technology': 0.08
}

df['operational_cost'] = df.apply(
    lambda x: x['sales'] * operational_rate.get(x['category'], 0.08),
    axis=1
)

# ================================
# 7. TOTAL COST & TRUE PROFIT
# ================================
df['total_cost'] = df['logistics_cost'] + df['operational_cost']
df['true_profit'] = df['net_revenue'] - df['total_cost']

# ================================
# 8. LEAKAGE FLAG
# ================================
df['leakage_flag'] = df['true_profit'].apply(
    lambda x: "Loss" if x < 0 else "Profit"
)

# ================================
# 9. SAVE PROCESSED DATA
# ================================
output_path = Path("data/processed/superstore_cleaned.csv")
output_path.parent.mkdir(parents=True, exist_ok=True)

df.to_csv(output_path, index=False)

print(" superstore_cleaned.csv created successfully!")
