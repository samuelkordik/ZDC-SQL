SELECT     TOP (100) PERCENT dbo.CCEMS_ProviderTrips.ProviderCode, dbo.CCEMS_ProviderTrips.ProviderName, COUNT(dbo.CCEMS_Calls.PCR_ID) AS Trips, 
                      COUNT(CASE WHEN outcome = '107' THEN 1 ELSE NULL END) AS TreatTransport, COUNT(CASE WHEN outcome = '105' THEN 1 ELSE NULL END) AS Refusals, 
                      COUNT(CASE WHEN outcome = '114' THEN 1 ELSE NULL END) AS NoEmergency, COUNT(CASE WHEN outcome = '101' THEN 1 ELSE NULL END) AS Disregards, 
                      COUNT(CASE WHEN outcome = '102' THEN 1 ELSE NULL END) AS DOS, COUNT(CASE WHEN outcome = '127' THEN 1 ELSE NULL END) AS PublicAssists, 
                      COUNT(CASE WHEN outcome = '122' THEN 1 ELSE NULL END) AS GOA, COUNT(CASE WHEN outcome = '121' THEN 1 ELSE NULL END) AS Flights, 
                      COUNT(CASE WHEN outcome = '124' THEN 1 ELSE NULL END) AS OtherEMS, COUNT(CASE WHEN LevelofCare = 'ALS' THEN 1 ELSE NULL END) AS ALS, 
                      COUNT(CASE WHEN LevelofCare = 'BLS' THEN 1 ELSE NULL END) AS BLS, COUNT(CASE WHEN sex = 'Male' THEN 1 ELSE NULL END) AS Male, 
                      COUNT(CASE WHEN sex = 'Female' THEN 1 ELSE NULL END) AS Female, AVG(dbo.CCEMS_Calls.age) AS age, AVG(dbo.CCEMS_Calls.weight) AS weight, 
                      COUNT(CASE WHEN QAMarker = 'Documentation Complete' THEN 1 ELSE NULL END) AS QAGood, 
                      COUNT(CASE WHEN QAMarker = 'Documentation Complete' THEN NULL ELSE 1 END) AS QAProblems, COUNT(dbo.CCEMS_Calls.PCR_ID) AS TotalCalls, 
                      COUNT(CASE WHEN dbo.CCEMS_Calls.outcome IN (107, 126, 102, 131, 105, 121, 124) THEN 1 ELSE NULL END) AS Patients, 
                      COUNT(CASE WHEN dbo.CCEMS_Calls.CompletedByUser = CCEMS_ProviderTrips.ProviderCode THEN 1 ELSE NULL END) AS Charts, 
                      COUNT(CASE WHEN (datediff(hour, CAST(dbo.CCEMS_Calls.avldate + ' ' + dbo.CCEMS_Calls.avltime AS datetime), dbo.CCEMS_Calls.completedTime) > 48 AND 
                      dbo.CCEMS_Calls.CompletedByUser = CCEMS_ProviderTrips.ProviderCode) THEN 1 ELSE NULL END) AS LateCharts, 
                      COUNT(CASE WHEN dbo.CCEMS_Calls.outcome IN (107, 121, 124) THEN 1 ELSE NULL END) AS Transports
FROM         dbo.CCEMS_Calls INNER JOIN
                      dbo.CCEMS_ProviderTrips ON dbo.CCEMS_Calls.PCR_ID = dbo.CCEMS_ProviderTrips.PCR_ID
GROUP BY dbo.CCEMS_ProviderTrips.ProviderCode, dbo.CCEMS_ProviderTrips.ProviderName