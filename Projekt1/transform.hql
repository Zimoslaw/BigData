CREATE DATABASE IF NOT EXISTS projekt1;

USE projekt1;

CREATE TABLE IF NOT EXISTS airports(iata_code STRING, airport STRING, city STRING, state STRING, country STRING, latitude FLOAT, longitude FLOAT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION "${input_dir4}";

CREATE EXTERNAL TABLE IF NOT EXISTS delays(iata_code STRING, year INT, month INT, landings INT, delay FLOAT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ' ' STORED AS TEXTFILE LOCATION "${input_dir3}";

CREATE TABLE IF NOT EXISTS results(year INT, month INT, state STRING, avg_delay FLOAT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe' STORED AS TEXTFILE
LOCATION "${output_dir6}";

WITH avg_delays AS (
    SELECT
        d.year,
        d.month,
        a.state,
        AVG(d.delay / d.landings) AS avg_delay
    FROM
        delays d, airports a WHERE d.iata_code = a.iata_code
    GROUP BY
        a.state,
        d.year,
        d.month
),
ranked_delays AS (
    SELECT
        ad.state,
        ad.month,
        ad.year,
        ad.avg_delay,
        RANK() OVER (PARTITION BY ad.year, ad.month ORDER BY ad.avg_delay DESC) AS state_rank
    FROM
        avg_delays ad
)
INSERT OVERWRITE TABLE results
SELECT
    rd.year,
    rd.month,
    rd.state,
    rd.avg_delay
FROM
    ranked_delays rd
WHERE
    rd.state_rank <= 3
ORDER BY
    rd.year,
    rd.month,
    rd.avg_delay DESC;
