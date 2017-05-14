/** Objective 5 **/
/** Merge the law enforcement data to the dataset **/
data employee2014;
	set crimedat.employee2014;

	/** the city in table4 is upper case **/
	city=upcase(city);

	/** create a year for the merging **/
	year=2014;

	/** drop the duplicate or additional columns **/
	drop population;
run;
data employee2015;
	set crimedat.employee2015;

	/** the data in table4 is upper case **/
	city=upcase(city);

	/** create a year for the merging **/
	year=2015;
  
	/** drop the duplicate or additional columns **/
	drop population g h i j k l;
run;

proc sort data=employee2014 out=employee2014_tmp(keep=state city);
	by state city;
run;

proc sort data=employee2015 out=employee2015_tmp(keep=state city);
	by state city;
run;

/** Create a lookup table and only select the cities that have 2 years of records **/
data employee_lookup;
	merge employee2014_tmp(in=a)
    	  employee2015_tmp(in=b);
	by state city;
	if a and b;
run;

/** Combine 2014 and 2015 law enforcement table **/
data total_employee;
	set employee2014
        employee2015;
run;

proc sort data=total_employee;
	by state city;
run;

/** Select the cities that have 2 years of records based on the lookup table **/
data total_employee_final;
	merge total_employee(in=a)
          employee_lookup(in=b);
	by state city;
	if a and b;
run;

proc sort data=total_employee_final;
	by state city year;
run;

proc sort data=crimedat.table4_final1 out=table4_final1_tmp;
	by state city year;
run;

/** Merge with the transformed table4 and create the final data for analysis **/
data crimedat.table4_final2;
	merge table4_final1_tmp(in=a)
          total_employee_final(in=b);
	by state city year;
	if a and b;
run;

/** Summarized the population total officers total crimes by year and state **/
proc summary data=crimedat.table4_final2 nway;
	class year state;
	var new_population total_officers total_crimes;
	output out=summary_police_population(drop=_freq_ _type_) sum=;
run;

/** Select the highest top 3 and lowest top 3 states**/
data police_population;
  set summary_police_population;
  if state in ('UTAH','MISSISSIPPI','WASHINGTON','IDAHO','NEW YORK','NORTH DAKOTA');
  if      state='UTAH'         then rank=1;
  else if state='MISSISSIPPI'  then rank=2;
  else if state='WASHINGTON'   then rank=3;
  else if state='NORTH DAKOTA' then rank=4;
  else if state='NEW YORK'     then rank=5;
  else                              rank=6;
run;

proc sort data=police_population;
  by rank year;
run;

ods html path='/home/yeong_jin0/ODS Output/' 
         body='Police.html';
/** Print the result **/
title 'US Crime Stats : Police Employee Ratio';
proc tabulate data=police_population S=[foreground=black cellwidth=200 just=c];
	class state rank year;
	var  new_population total_crimes total_officers;
	table rank=''*state='',year=''*total_crimes='# of Crimes'*sum=''*f=comma14. year=''*total_officers='# of Police Employee'*sum=''*f=comma14.  year=''*total_crimes='% of Crimes'*pctsum<new_population>=''*f=8.2 year=''*total_officers='% of Police Employee'*pctsum<new_population>=''*f=8.2;
	footnote "These numbers are based on the data from FBI UCR" ;
run;
ods html close;
