/** Finalized the final data set for analysis **/
data work.table4_tmp_v1;
	set crimedat.table4(drop=property_crime);
	/** To remove the cities with >=50% missing crimes**/
	if 	(state='ARIZONA' and city='TUCSON')  	or
		(state='HAWAII' and city='HONOLULU') 	or
		(state='TEXAS' and city='TYLER')     	or
		(state='UTAH' and city='PROVO')       	or
		(state='UTAH' and city='WEST VALLEY') then delete;

  	/** to combine 2 types of rape definition **/
	if rape_revised=. and rape_legacy=. then sexual_assault=.;
	else                                     sexual_assault=sum(rape_revised,rape_legacy);

	property_crime=sum(burglary,larceny_theft,motor_vehicle_theft);

	/* To calculate the total crimes **/
	total_crimes=sum(violent_crime,property_crime);

	drop rape_revised rape_legacy arson;  
run;

/** Merge the table4 with the divion, region and state code **/
proc sort data=work.table4_tmp_v1;
  	by state;
run;

proc sort data=crimedat.region;
  	by states;
run;

data work.table4_tmp_v2;
	merge work.table4_tmp_v1(in=a)
		  /** Rename the column states to state for merging **/
          crimedat.region(in=b rename=(states=state));
	by state;
	if a;
run;

/** Assign the estimated population to year 2015 **/
proc sort data=work.table4_tmp_v2;
	by state city year;
run;

data crimedat.table4_final1;
	set work.table4_tmp_v2;
	by state city;
  
	/** Retain the population for year 2014 for the calculation **/
	retain new_population;
  
	/** Assign the 2014 population to the new column new_population **/
	if first.city then new_population=population;

	/** Based on the 2014 population and region to estimate the 2015 population **/
	else do;
		if      region='NORTHEAST' 	then new_population=round(new_population+(new_population*0.0012));
		else if region='MIDWEST' 	then new_population=round(new_population+(new_population*0.0017));
		else if region='WEST' 		then new_population=round(new_population+(new_population*0.0108));
		else if region='SOUTH' 		then new_population=round(new_population+(new_population*0.0112));
  	end;

	label	state					=	'State Name'
	     	city					=	'City'
		 	year					=	'Year'
		 	violent_crime			=	'Violent Crime'
		 	murder					=	'Murder'
		 	robbery					=	'Robbery'
		 	aggravated_assault		=	'Aggravated Assault'
		 	property_crime			=	'Property Crime'
		 	burglary				=	'Burglary'
         	larceny_theft			=	'Larceny Theft'
		 	motor_vehicle_theft		=	'Motor Vehicle Theft'
		 	sexual_assault			=	'Sexual Assault'
		 	total_crimes			=	'Total Crimes';
 
	/** New_population will be used for the following analysis and drop the original column **/
	drop population;
run;
