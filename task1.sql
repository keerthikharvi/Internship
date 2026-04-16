SELECT * FROM `sql_task1` LIMIT 10;

CREATE TEMPORARY TABLE plant_stats AS
SELECT
    Plant,
    AVG(Temperature) AS temp_mean,
    STDDEV(Temperature) AS temp_std,
    AVG(Vibration) AS vib_mean,
    STDDEV(Vibration) AS vib_std,
    AVG(Pressure) AS press_mean,
    STDDEV(Pressure) AS press_std
FROM sql_task1
GROUP BY plant;

SELECT * FROM plant_stats;

CREATE TEMPORARY TABLE flagged_data AS
SELECT
    m.Plant,
    m.MachineID,
    
    CASE
        WHEN m.Temperature < (p.temp_mean - 3*p.temp_std)
          OR m.Temperature > (p.temp_mean + 3*p.temp_std)
          OR m.Vibration < (p.vib_mean - 3*p.vib_std)
          OR m.Vibration > (p.vib_mean + 3*p.vib_std)
          OR m.Pressure < (p.press_mean - 3*p.press_std)
          OR m.Pressure > (p.press_mean + 3*p.press_std)
        THEN 1
        ELSE 0
    END AS is_anomaly

FROM sql_task1 m
JOIN plant_stats p
    ON m.Plant = p.Plant;

SELECT * FROM flagged_data LIMIT 10;

SELECT
    Plant,
    MachineID,
    COUNT(*) AS total_records,
    SUM(is_anomaly) AS anomaly_count
FROM flagged_data
GROUP BY Plant, MachineID
ORDER BY anomaly_count DESC;
