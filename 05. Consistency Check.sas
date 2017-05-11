
/** To understand the data consistency **/

/** Summarized the data by year and crime **/
proc summary data=work.all_crimes nway;
	class year;
	/**Sum the population and crime type **/
	var population violent_crime murder robbery aggravated_assault property_crime burglary 
      	larceny_theft motor_vehicle_theft arson sexual_assault;
	output out=work.summary_all_crimes(drop=_freq_ _type_) sum=;
run;

/** To retain 2014 population and calculate the crime type **/
data work.crime_consistency;
	length new_population 8;
	set work.summary_all_crimes;
	retain new_population;
	if population ne . then new_population=population;
  
	/** To calculate the % of each crime type **/
	p_violent_crime			=	violent_crime/new_population;
	p_murder				=	murder/new_population;
	p_robbery				=	robbery/new_population;
	p_aggravated_assault	=	aggravated_assault/new_population; 
	p_property_crime		=	property_crime/new_population;
	p_burglary				=	burglary/new_population;
	p_larceny_theft			=	larceny_theft/new_population;
	p_motor_vehicle_theft	=	motor_vehicle_theft/new_population;
	p_arson					=	arson/new_population;
	p_sexual_assault		=	sexual_assault/new_population;
run;

/** To print the consistency result **/
title 'Data Consistency';
proc print data=work.crime_consistency label;
	label	year					=	'Year'
			p_violent_crime			=	'Violent Crime'
			p_murder				=	'Murder'
			p_robbery				=	'Robbery'
			p_aggravated_assault	=	'Aggravated Assault'
			p_property_crime		=	'Property Crime'
			p_burglary				=	'Burglary'
			p_larceny_theft			=	'Larceny Theft'
			p_motor_vehicle_theft	=	'Motor Vehicle Theft'
			p_arson					=	'Arson'
			p_sexual_assault		=	'Sexual Assault';	
	format	p_violent_crime			percent10.2
			p_murder				percent10.2
			p_robbery				percent10.2
			p_aggravated_assault	percent10.2
			p_property_crime		percent10.2
			p_burglary				percent10.2
			p_larceny_theft			percent10.2
			p_motor_vehicle_theft	percent10.2
			p_arson					percent10.2
			p_sexual_assault		percent10.2;
	var year p_violent_crime p_murder p_robbery p_aggravated_assault p_property_crime p_burglary p_larceny_theft 
        p_motor_vehicle_theft p_arson p_sexual_assault;
	footnote "These numbers are based on the data from FBI UCR" ;
run;
