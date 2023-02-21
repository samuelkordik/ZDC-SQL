// replaces hospital names
Replace(Replace(Replace(Replace(
    // makes hospital name Title Case    
    ProperCase({Facilities.name}), 
    // removes "hospital" from name (redundant)    
    "Hospital", ""),
    // removes underscores and asterisks used for sorting purposes    
    "_",""),"*",""),
    // returns posessives to proper case.
    "'S","'s");
    
// gender
if {FDC_Customers.sex}=1 then
  "Male"
else if {FDC_Customers.sex}=2 then
  "Female"
else "Unknown"

// age
stringvar strDOB := "";
stringvar strAge := "";

if not isnull({FDC_Customers.approximateDOB}) and {FDC_Customers.approximateDOB} = '1' then
(
    strAge := ToText ({FDC_Customers.ageUnits});
    strDOB := "Approx. " + Left(strAge, InStr(strAge, ".")-1) + " " + {v_trip_age_units.descr}
)
else if ({FDC_Customers.newbornindicator} = 1) then
(
    strDOB := "Newborn"
)
else if ({FDC_Customers.dob} = "1800-01-01" or isnull({FDC_Customers.dob}) or length({FDC_Customers.dob}) = 0) then
    strDOB := "Unknown" 
   else
(
    strDOB := Mid({FDC_Customers.dob},6,2) + "/" + Right({FDC_Customers.dob},2) + "/" + Left({FDC_Customers.dob},4);
    if (DatePart("y", CDate({FDC_Customers.dob})) - DatePart("y", CurrentDate)) > 0 then
      strAge := CStr(Year(CurrentDate)-Year(CDate({FDC_Customers.dob})) -1)  
    else 
      strAge := CStr(Year(CurrentDate)-Year(CDate({FDC_Customers.dob})));  
      strDOB := strDOB + " (" + Left(strAge, InStr(strAge, ".")-1) + " yrs)";
);