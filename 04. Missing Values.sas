/** To understand the data and identify the missing values vertically **/
proc means data=crimedat.table4 n nmiss;
	class year;
	var _numeric_;
run;

/** To understand the data and identify the missing values horizontally **/
data work.miss_crimes work.all_crimes;
	set crimedat.table4;

	/** To combine 2 types of rape definition avoid the inaccurate missing value due to the change of definition **/
	if rape_revised=. and rape_legacy=. then sexual_assault=.;
	else                                     sexual_assault=sum(rape_revised,rape_legacy);
	drop rape_revised rape_legacy;

	/** To calcultate number of missing in each crime **/
	all_crimes=sum(violent_crime=.,murder=.,robbery=.,aggravated_assault=.,property_crime=.,
                   burglary=.,larceny_theft=.,motor_vehicle_theft=.,arson=.,sexual_assault=.);
  
	/** To derive the missing % **/
	crimes_miss_rate=all_crimes/10;

	/** To output all observations to all_crimes **/
	output work.all_crimes;

	/** To output the row with missing %>=50% **/
	if crimes_miss_rate>=0.5 then output work.miss_crimes;
run;

/** To print the row with missing %>=50% **/
title 'Missing Crime Info ( > 50%)';
proc print data=work.miss_crimes label;
	format crimes_miss_rate percent10.2;
	label crimes_miss_rate='Missing Crime %';
	var year state city crimes_miss_rate;
	footnote "These numbers are based on the data from FBI UCR" ;
run;
