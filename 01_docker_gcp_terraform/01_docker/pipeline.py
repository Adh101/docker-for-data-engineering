import sys
import pandas as pd

print('arguments:', sys.argv)

month = int(sys.argv[1])
print(f"Running pipeline for month: {month}")

df = pd.DataFrame({"A": [1, 2, 3], "B": [4, 5, 6]})

print(df.head())

df.to_parquet(f"output_month_{sys.argv[1]}.parquet")

