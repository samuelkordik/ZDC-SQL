SELECT     dbo.FDC_Trips.g2pcrid AS PCR_ID, dbo.FDC_Trips.calldate, dbo.FDC_Trips.veh AS Unit, dbo.nature_of_call.descr AS Nature, dbo.FDC_Trips.puaddr, 
                      dbo.FDC_Trips.pucity, dbo.FDC_Trips.pust, dbo.FDC_Trips.puzip, dbo.FDC_Trips.outcome, dbo.FDC_Trips.outcomedescr, Destination.name AS Hospital, 
                      dbo.FDC_Trip_Misc.userfield3descr AS PatientStatus, dbo.v_trip_LevelofCare.descr AS LevelofCare, 
                      CASE FDC_Customers.sex WHEN '1' THEN 'Male' WHEN '2' THEN 'Female' ELSE 'Unknown' END AS sex, 
                      (CASE FDC_Customers.approximateDOB WHEN '1' THEN (CASE FDC_Customers.ageUnitsOfMeasure WHEN '3' THEN '0' WHEN '2' THEN FDC_Customers.ageUnits / 12
                       WHEN '1' THEN FDC_Customers.ageUnits END) 
                      ELSE (CASE FDC_Customers.newbornindicator WHEN '1' THEN '0' ELSE (CASE FDC_Customers.dob WHEN '1800-01-01' THEN NULL WHEN NULL THEN NULL 
                      ELSE datediff(yyyy, CAST(FDC_Customers.dob AS datetime), CAST(FDC_Trips.dispdate AS datetime)) END) END) END) AS age, dbo.FDC_Customers.weight, 
                      dbo.v_race.descr AS race, QAComments.QAMarker, QAComments.Reviewer, dbo.FDC_Trips.tdate, dbo.FDC_Trips.job, dbo.FDC_Trips.RunNumber, 
                      dbo.FDC_Trips.Addl_Crew1_Name, dbo.FDC_Trips.Addl_Crew2_Name, dbo.FDC_Trips.Addl_Crew3_Name, dbo.FDC_Trips.completedByUser, 
                      dbo.FDC_Trips.completedTime, dbo.FDC_Trips.calltime, dbo.FDC_Trips.dispdate, dbo.FDC_Trips.disptime, dbo.FDC_Trips.enrdate, dbo.FDC_Trips.enrtime, 
                      dbo.FDC_Trips.atsdate, dbo.FDC_Trips.atstime, dbo.FDC_Trips.tradate, dbo.FDC_Trips.tratime, dbo.FDC_Trips.atdtime, dbo.FDC_Trips.atddate, 
                      dbo.FDC_Trips.avldate, dbo.FDC_Trips.avltime, dbo.FDC_Shifts.crew1name, dbo.FDC_Shifts.crew2name, dbo.FDC_Shifts.crew3name, dbo.FDC_Shifts.Crew4Name, 
                      CAST(dbo.FDC_Trips.calldate + ' ' + dbo.FDC_Trips.calltime AS Datetime) AS CallReceived,
                          (SELECT     TOP (1) CAST(dateperformed + ' ' + timeperformed AS datetime) AS InterventionTime
                            FROM          dbo.Trip_Interventions
                            WHERE      (tdate = dbo.FDC_Trips.tdate) AND (job = dbo.FDC_Trips.job) AND (intervention_text LIKE 'Defib%')
                            ORDER BY InterventionTime) AS DefibTime,
                          (SELECT     TOP (1) CAST(dateperformed + ' ' + timeperformed AS datetime) AS InterventionTime
                            FROM          dbo.Trip_Interventions AS Trip_Interventions_2
                            WHERE      (tdate = dbo.FDC_Trips.tdate) AND (job = dbo.FDC_Trips.job) AND (intervention_text = 'Cardiac Monitor')
                            ORDER BY InterventionTime) AS MonitorTime,
                          (SELECT     CASE WHEN (COUNT(intervention_text) > 0) THEN 'ROSC' ELSE 'No ROSC' END AS ROSC
                            FROM          dbo.Trip_Interventions AS Trip_Interventions_1
                            WHERE      (tdate = dbo.FDC_Trips.tdate) AND (job = dbo.FDC_Trips.job) AND (intervention_text = 'ROSC')) AS ROSC
FROM         dbo.FDC_Trips INNER JOIN
                      dbo.FDC_Shifts ON dbo.FDC_Trips.shiftno = dbo.FDC_Shifts.shiftno LEFT OUTER JOIN
                      dbo.Facilities AS Destination ON dbo.FDC_Trips.dfac = Destination.code LEFT OUTER JOIN
                      dbo.FDC_Trip_Misc ON dbo.FDC_Trips.tdate = dbo.FDC_Trip_Misc.TDate AND dbo.FDC_Trips.job = dbo.FDC_Trip_Misc.Job LEFT OUTER JOIN
                      dbo.nature_of_call ON dbo.FDC_Trips.natureofcall = dbo.nature_of_call.code LEFT OUTER JOIN
                      dbo.FDC_Customers ON dbo.FDC_Trips.custno = dbo.FDC_Customers.custno LEFT OUTER JOIN
                      dbo.v_trip_LevelofCare ON dbo.FDC_Trips.LevelOfCare = dbo.v_trip_LevelofCare.code LEFT OUTER JOIN
                      dbo.v_race ON dbo.FDC_Customers.race = dbo.v_race.code LEFT OUTER JOIN
                          (SELECT     dbo.FDC_QA_COMMENT_MARKER_TYPES.Description AS QAMarker, dbo.FDC_Trip_QA_Comments.driver_code AS Reviewer, 
                                                   dbo.FDC_Trip_QA_Comment_Markers.tdate, dbo.FDC_Trip_QA_Comment_Markers.job
                            FROM          dbo.FDC_Trip_QA_Comment_Markers INNER JOIN
                                                   dbo.FDC_QA_COMMENT_MARKER_TYPES ON 
                                                   dbo.FDC_Trip_QA_Comment_Markers.QA_Marker = dbo.FDC_QA_COMMENT_MARKER_TYPES.QA_Marker_Comment_Type_ID INNER JOIN
                                                   dbo.FDC_Trip_QA_Comments ON dbo.FDC_Trip_QA_Comment_Markers.tdate = dbo.FDC_Trip_QA_Comments.tdate AND 
                                                   dbo.FDC_Trip_QA_Comment_Markers.job = dbo.FDC_Trip_QA_Comments.job AND 
                                                   dbo.FDC_Trip_QA_Comment_Markers.Comment_Seq = dbo.FDC_Trip_QA_Comments.seq
                            WHERE      (dbo.FDC_Trip_QA_Comment_Markers.Comment_Seq = 1) AND (dbo.FDC_Trip_QA_Comment_Markers.QA_Marker_Seq = 1)) AS QAComments ON 
                      QAComments.tdate = dbo.FDC_Trips.tdate AND QAComments.job = dbo.FDC_Trips.job