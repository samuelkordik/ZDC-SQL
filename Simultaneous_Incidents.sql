SELECT 
	T1.CreatedDate, 
	T1.IncidentNumber, 
	T1.Nature,
	T1.LocationAddress,
	T1.LocationCity,
	T1.County,
	T1.LocationZip,
	count(DISTINCT T2.IncidentNumber) as SimultaneousIncidents
FROM
(SELECT 
	cad.FireIncident.CreatedDate,
	cad.FireIncident.IncidentNumber,
	adm.Nature.Description as Nature,
	cad.IncidentLocation.LocationAddress,
	cad.IncidentLocation.LocationCity,
	cad.IncidentLocation.County,
	cad.IncidentLocation.LocationZip,
	adm.Unit.UnitName,
	adm.UnitType.UnitTypeDescription,
	cad.AssignmentFireLog.DispatchedTime,
	cad.AssignmentFireLog.AvailableTime
FROM
	cad.FireIncident
	
	JOIN cad.Assignment on cad.FireIncident.FireIncidentID = cad.Assignment.FireIncidentID
	JOIN cad.Roster on cad.Assignment.RosterID = cad.Roster.RosterID
	JOIN cad.AssignmentFireLog on cad.Assignment.AssignmentID = cad.AssignmentFireLog.AssignmentID
	JOIN adm.Unit on cad.Roster.UnitID = adm.Unit.UnitID
		JOIN adm.Agency on adm.Unit.AgencyID = adm.Agency.AgencyID
		JOIN adm.UnitUnitType on adm.Unit.UnitID = adm.UnitUnitType.UnitID
		JOIN adm.UnitType on adm.UnitUnitType.UnitTypeID = adm.UnitType.UnitTypeID

	JOIN adm.Nature on cad.FireIncident.NatureID = adm.Nature.NatureID
	JOIN cad.IncidentLocation on cad.FireIncident.IncidentLocationID =cad.IncidentLocation.IncidentLocationID
WHERE
	adm.Agency.AgencyID = 24 --STAFFORD FD
	AND adm.Nature.Description <> 'CAD TEST CALL') T1,
(SELECT 
	cad.FireIncident.CreatedDate,
	cad.FireIncident.IncidentNumber,
	adm.Nature.Description as Nature,
	cad.IncidentLocation.LocationAddress,
	cad.IncidentLocation.LocationCity,
	cad.IncidentLocation.County,
	cad.IncidentLocation.LocationZip,
	adm.Unit.UnitName,
	adm.UnitType.UnitTypeDescription,
	cad.AssignmentFireLog.DispatchedTime,
	cad.AssignmentFireLog.AvailableTime
FROM
	cad.FireIncident
	
	JOIN cad.Assignment on cad.FireIncident.FireIncidentID = cad.Assignment.FireIncidentID
	JOIN cad.Roster on cad.Assignment.RosterID = cad.Roster.RosterID
	JOIN cad.AssignmentFireLog on cad.Assignment.AssignmentID = cad.AssignmentFireLog.AssignmentID
	JOIN adm.Unit on cad.Roster.UnitID = adm.Unit.UnitID
		JOIN adm.Agency on adm.Unit.AgencyID = adm.Agency.AgencyID
		JOIN adm.UnitUnitType on adm.Unit.UnitID = adm.UnitUnitType.UnitID
		JOIN adm.UnitType on adm.UnitUnitType.UnitTypeID = adm.UnitType.UnitTypeID

	JOIN adm.Nature on cad.FireIncident.NatureID = adm.Nature.NatureID
	JOIN cad.IncidentLocation on cad.FireIncident.IncidentLocationID =cad.IncidentLocation.IncidentLocationID
WHERE
	adm.Agency.AgencyID = 24 --STAFFORD FD
	AND adm.Nature.Description <> 'CAD TEST CALL') T2

	WHERE (T1.DispatchedTime BETWEEN T2.DispatchedTime and T2.AvailableTime) AND T1.IncidentNumber <> T2.IncidentNumber
		
	GROUP BY T1.CreatedDate, 
	T1.IncidentNumber, 
	T1.Nature,
	T1.LocationAddress,
	T1.LocationCity,
	T1.County,
	T1.LocationZip
