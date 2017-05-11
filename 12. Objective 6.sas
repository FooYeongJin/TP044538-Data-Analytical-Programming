
/** Objective 6 **/
/** To summarize the population and total crimes by year and states**/
proc summary data=crimedat.table4_final1 nway;
    where state in ('WASHINGTON', 'MONTANA', 'NORTH DAKOTA', 'ARIZONA', 'NEW MEXICO', 'TEXAS');
	class year state;
	var new_population total_crimes;
	output out=summary_crime_border(drop=_freq_ _type_) sum=;
run;

/** Assign the border to each states**/
data crime_border_v2;
  set summary_crime_border;
  length border $6.;
  if state in ('WASHINGTON', 'MONTANA', 'NORTH DAKOTA') then border='CANADA';
  else                                                       border='MEXICO';
run;

ods html path='/home/yeong_jin0/ODS Output/' 
         body='Border.html';
/** Print the result **/
title 'US Crime Stats : Mexico Border Vs. Canada Border';
proc tabulate data=crime_border_v2 S=[foreground=black cellwidth=200 just=c];
	class  year border;
	var  new_population total_crimes;
	table border='',year=''*total_crimes='# of Crimes'*sum=''*f=comma14.  year=''*total_crimes='% of Crimes'*pctsum<new_population>=''*f=8.2 ;
	footnote "These numbers are based on the data from FBI UCR" ;
run;

/** Print the result **/
title 'US Crime Stats : Mexico Border Vs. Canada Border (States)';
proc tabulate data=crime_border_v2 S=[foreground=black cellwidth=200 just=c];
	class  year border state;
	var  new_population total_crimes;
	table border=''*state='',year=''*total_crimes='# of Crimes'*sum=''*f=comma14.  year=''*total_crimes='% of Crimes'*pctsum<new_population>=''*f=8.2 ;
	footnote "These numbers are based on the data from FBI UCR" ;
run;
ods html close;