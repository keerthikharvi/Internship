SELECT
    MachineID,
    AVG(Temperature) AS AvgTemp,
    AVG(Vibration) AS AvgVib,
    AVG(Pressure) AS AvgPressure,
    AVG(EnergyConsumption / NULLIF(ProductionUnits,0)) AS AvgEnergyPerUnit,
    SUM(DefectCount) AS TotalDefects,
    SUM(MaintenanceFlag) AS MaintenanceCount
FROM sql_task1
GROUP BY MachineID;

SELECT
    MachineID,
    AvgTemp,
    AvgVib,
    AvgPressure,
    AvgEnergyPerUnit,
    TotalDefects,
    MaintenanceCount,
    NTILE(10) OVER (ORDER BY SeverityScore DESC) AS severity_bucket
FROM (
    SELECT
        MachineID,
        AVG(Temperature) AS AvgTemp,
        AVG(Vibration) AS AvgVib,
        AVG(Pressure) AS AvgPressure,
        AVG(EnergyConsumption / NULLIF(ProductionUnits,0)) AS AvgEnergyPerUnit,
        SUM(DefectCount) AS TotalDefects,
        SUM(MaintenanceFlag) AS MaintenanceCount,
        (AVG(Temperature) + AVG(Vibration)) AS SeverityScore
    FROM sql_task1
    GROUP BY MachineID
) ranked;

SELECT
    MachineID,
    AvgTemp,
    AvgVib,
    AvgPressure,
    AvgEnergyPerUnit,
    TotalDefects,
    MaintenanceCount,
    CASE
        WHEN severity_bucket = 1 THEN 'Critical'
        ELSE 'Normal'
    END AS ConditionBucket
FROM (
    SELECT
        MachineID,
        AVG(Temperature) AS AvgTemp,
        AVG(Vibration) AS AvgVib,
        AVG(Pressure) AS AvgPressure,
        AVG(EnergyConsumption / NULLIF(ProductionUnits,0)) AS AvgEnergyPerUnit,
        SUM(DefectCount) AS TotalDefects,
        SUM(MaintenanceFlag) AS MaintenanceCount,
        NTILE(10) OVER (
            ORDER BY (AVG(Temperature) + AVG(Vibration)) DESC
        ) AS severity_bucket
    FROM sql_task1
    GROUP BY MachineID
) ranked;


CREATE VIEW sensor_condition_2025 AS
SELECT
    MachineID,
    AvgTemp,
    AvgVib,
    AvgPressure,
    AvgEnergyPerUnit,
    TotalDefects,
    MaintenanceCount,
    CASE
        WHEN severity_bucket = 1 THEN 'Critical'
        ELSE 'Normal'
    END AS ConditionBucket
FROM (
    SELECT
        MachineID,
        AVG(Temperature) AS AvgTemp,
        AVG(Vibration) AS AvgVib,
        AVG(Pressure) AS AvgPressure,
        AVG(EnergyConsumption / NULLIF(ProductionUnits,0)) AS AvgEnergyPerUnit,
        SUM(DefectCount) AS TotalDefects,
        SUM(MaintenanceFlag) AS MaintenanceCount,
        NTILE(10) OVER (
            ORDER BY (AVG(Temperature) + AVG(Vibration)) DESC
        ) AS severity_bucket
    FROM sql_task1
    GROUP BY MachineID
) ranked;

SELECT * FROM sensor_condition_2025;