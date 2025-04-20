#!/bin/bash

# Set the path to your CSV file
CSV_FILE="db/data/db.airport-Airport.csv"

# Task 1: Calculate Average Elevation per Country
avg_elevation_by_country() {
    echo "=== Average Elevation per Country ==="
    awk -F ',' 'BEGIN { print "Country,Average Elevation (feet)" }
    NR > 1 {
        sum[$6] += $7;
        count[$6]++;
    }
    END {
        for (country in sum) {
            printf "%s,%.2f\n", country, sum[country]/count[country];
        }
    }' "$CSV_FILE" | sort
}

# Task 2: Find Airports Without IATA Codes
airports_without_iata() {
    echo "=== Airports Without IATA Codes ==="
    echo "ICAO,Name,City,Country"
    awk -F ',' 'NR > 1 && $2 == "" {
        printf "%s,%s,%s,%s\n", $1, $3, $4, $6;
    }' "$CSV_FILE"
}

# Task 3: Determine the 10 Most Common Time Zones
common_timezones() {
    echo "=== 10 Most Common Time Zones ==="
    echo "Count,Timezone"
    awk -F ',' 'NR > 1 {
        count[$10]++;
    }
    END {
        for (tz in count) {
            printf "%d,%s\n", count[tz], tz;
        }
    }' "$CSV_FILE" | sort -nr | head -10
}

# Check if file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: CSV file not found at $CSV_FILE"
    exit 1
fi

# Execute all tasks
avg_elevation_by_country > script/results/results_avg_elevation.csv
airports_without_iata > script/results/results_missing_iata.csv
common_timezones > script/results/results_common_timezones.csv

echo "Analysis complete. Results saved to:"
echo "- script/results/results_avg_elevation.csv"
echo "- script/results/results_missing_iata.csv"
echo "- script/results/results_common_timezones.csv"
