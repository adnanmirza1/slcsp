# SLCSP Calculator

This Ruby script calculates the second lowest cost silver plan (SLCSP) for a group of ZIP codes based on provided input CSV files.

## Usage

1. Make sure you have the following input CSV files in the same directory as this script:
    - `slcsp.csv` - Contains ZIP codes.
    - `plans.csv` - Contains health insurance plans.
    - `zips.csv` - Maps ZIP codes to rate areas.

2. Run the script by executing the following command in your terminal:

   ```bash
   ruby calculate_slcsp.rb
