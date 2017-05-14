/** Objective 3 **/
/** To summarize the population and total crimes by year and states**/
proc summary data=crimedat.table4_final1 nway;
	class year state;
	var new_population total_crimes;
	output out=summary_crime_population(drop=_freq_ _type_) sum=;
run;

/** To select only 2014 **/
data crimehigh_population_2014;
	set summary_crime_population;
	where year=2014;
	crime_rate=total_crimes/new_population;
run;

proc sort data=crimehigh_population_2014;
	by descending crime_rate;
run;

ods html path='/home/yeong_jin0/ODS Output/' 
         body='Top 3 Highest Crimes.html';
/** To print the result for the Top 3 **/
title 'US Crime Stats : Top 3 States with Highest Crime Rate (2014)';
proc print data=crimehigh_population_2014(obs=3) label style(header)={just=c foreground=black}
	style(table)	=	{width=100%};
	format	new_population	comma14.
			total_crimes	comma14.
			crime_rate		percent7.2;
	label	year			=	'Year'
			state			=	'State'
			new_population	=	'Estimated Population'
			total_crimes	=	'# of Crime'
			crime_rate		=	'% of Crime';
	var	year			/	style(data)={just=c};
	var	state			/	style(data)={just=c};
	var	new_population	/	style(data)={just=c};
	var	total_crimes	/	style(data)={just=c};
	var	crime_rate		/	style(data)={just=c};
	footnote "These numbers are based on the data from FBI UCR" ;
run;


/** To select only the top 3 2014 in the 2015 data **/
/** To summarize the population and total crimes by year and states**/
data crimehigh_population_2015;
  set summary_crime_population;
  where year=2015 and state in ('UTAH','MISSISSIPPI','WASHINGTON');

  if 		state='UTAH' 		then rank=1;
  else if 	state='MISSISSIPPI' then rank=2;
  else                             	 rank=3;
  crime_rate=total_crimes/new_population;
run;

proc sort data=crimehigh_population_2015;
  by rank;
run;

/** To print the result for the Top 3 **/
title1 'US Crime Stats : Top 3 States with Highest Crime Rate in 2014';
title2 'Crime Rate in 2015';
proc print data=crimehigh_population_2015(obs=3) label style(header)={just=c foreground=black}
	style(table)	=	{width=100%};
	format	new_population	comma14.
			total_crimes	comma14.
			crime_rate		percent7.2;
	label	year			=	'Year'
			state			=	'State'
			new_population	=	'Estimated Population'
			total_crimes	=	'# of Crime'
			crime_rate		=	'% of Crime';
	var	year			/	style(data)={just=c};
	var	state			/	style(data)={just=c};
	var	new_population	/	style(data)={just=c};
	var	total_crimes	/	style(data)={just=c};
	var	crime_rate		/	style(data)={just=c};
	footnote "These numbers are based on the data from FBI UCR" ;
run;
ods html close;
