#!/usr/bin/env python3
"""
Downloads 2022 NYC TLC high-volume FHV trip records (Parquet format) into ./data/.
Total size ~5.2 GB. Skips files already present.
Source: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
"""
import os
import urllib.request

output_dir = "data"
os.makedirs(output_dir, exist_ok=True)

year = 2022
for month in range(1, 13):
    filename = f"fhvhv_tripdata_{year}-{month:02}.parquet"
    url = f"https://d37ci6vzurychx.cloudfront.net/trip-data/{filename}"
    path = os.path.join(output_dir, filename)
    if not os.path.exists(path):
        print(f"Downloading {filename}...")
        urllib.request.urlretrieve(url, path)
    else:
        print(f"Already present: {filename}")

print("Done.")
