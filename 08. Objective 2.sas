/** Objective 2 **/
/** To summarized the crime type **/
proc summary data=crimedat.table4_final1 nway;
	class year;
	var violent_crime murder robbery aggravated_assault property_crime burglary larceny_theft motor_vehicle_theft sexual_assault total_crimes;
	output out=summary_year(drop=_freq_ _type_) sum=;
run;

/** To transpose the data **/
proc transpose data=summary_year out=table4_2014_trans;
	where year=2014;
run;

proc transpose data=summary_year out=table4_2015_trans;
	where year=2015;
run;

/** To rename the transposed data **/
data table4_2014_trans_v2;
	set table4_2014_trans;
	where _label_ not in ('Year','Total Crimes');
	year=2014;
	rename	_label_		=	crime_type
			col1		=	no_of_offence;
	label	_label_		=	'Crime Type'
			col1		=	'# Offence'; 
	drop _name_;
run;

data table4_2015_trans_v2;
	set table4_2015_trans;
	where _label_ not in ('Year','Total Crimes');
	year=2015;
	rename	_label_		=	crime_type
			col1		=	no_of_offence;
	label	_label_		=	'Crime Type'
			col1		=	'# Offence'; 
	drop _name_;
run;
 
/** To calculate the crime type distribution **/
proc freq data=table4_2014_trans_v2 noprint;
   where crime_type not in ('Burglary','Larceny Theft','Motor Vehicle Theft'); 
   tables year*crime_type/out=table4_2014_trans_v3;
   weight no_of_offence;
run;

proc freq data=table4_2015_trans_v2 noprint;
   where crime_type not in ('Burglary','Larceny Theft','Motor Vehicle Theft'); 
   tables year*crime_type/out=table4_2015_trans_v3;
   weight no_of_offence;
run;

/** To combine table 2014 and 2015 **/
data table4_1415_trans_v3;
  set table4_2014_trans_v3
      table4_2015_trans_v3;
run;

ods html path='/home/yeong_jin0/ODS Output/' 
         body='Overall Crimes.html';
/* Define the titles */
title 'US Crime Stats : Overall Crimes (Excluding Arson)';

/* Define pattern color for each crime type   */
pattern1 color=day;       /* Aggravated assault */
pattern2 color=mob;       /* Murder            */
pattern3 color=vibg;      /* Property Crime    */
pattern4 color=deoy;      /* Robbery           */
pattern5 color=libg;      /* Violent Crime     */
pattern6 color=dabg;      /* Sexual assault     */

legend1 label=none
        position=(bottom)
        offset=(4,)
        across=3
        order=("Aggravated Assault" "Murder" "Property Crime" "Robbery" "Sexual Assault" "Violent Crime" )
        value=(color=black)
        shape=bar(4,1.5);

/* Create the pie chart */
proc gchart data=table4_1415_trans_v3;
	pie	crime_type	/	sumvar	=	percent
						descending
						other=0
						legend=legend1
						value=none
						across=2
						value=arrow
						coutline=black
						noheading
						group=Year;
 footnote "These numbers are based on the data from FBI UCR" ;
run;
quit;
ods html close;

/* To calculate the % within property crime */
proc freq data=table4_2014_trans_v2 noprint;
   where crime_type in ('Burglary','Larceny Theft','Motor Vehicle Theft'); 
   tables year*crime_type/out=table4_2014_trans_propc;
   weight no_of_offence;
run;

proc freq data=table4_2015_trans_v2 noprint;
   where crime_type in ('Burglary','Larceny Theft','Motor Vehicle Theft'); 
   tables year*crime_type/out=table4_2015_trans_propc;
   weight no_of_offence;
run;

data table4_1415_trans_propc;
  set table4_2014_trans_propc
      table4_2015_trans_propc;
run;

ods html path='/home/yeong_jin0/ODS Output/' 
         body='Property Crimes.html';
/* Define the titles */
title 'US Crime Stats : Property Crimes';

/* Define pattern color for each crime type   */
pattern1 color=day;       /* Burglary   */
pattern2 color=mob;      /* Larceny Theft */
pattern3 color=vibg;       /* Motor Vehicle Theft           */

legend1 label=none
        position=(bottom)
        offset=(4,)
        across=3
        order=("Burglary" "Larceny Theft" "Motor Vehicle Theft" )
        value=(color=black)
        shape=bar(4,1.5);

/* Create the pie chart */
proc gchart data=table4_1415_trans_propc;
	pie	crime_type	/	sumvar	=	percent
						descending
						other=0
						legend=legend1
						value=none
						across=2
						value=arrow
						coutline=black
						noheading
						group=Year;
footnote "These numbers are based on the data from FBI UCR" ;
run;
quit;

/** To create bar chart **/
title 'US Crime Stats : Property Crimes';
proc sgplot data=work.Table4_1415_trans_propc;
	format	COUNT	comma10.;
	label	COUNT	=	'# of Offense';
	vbar	crime_type /	response=COUNT group=year groupdisplay=cluster 
	stat=sum				dataskin=gloss;
	xaxis					display=(nolabel noticks);
	yaxis					grid;
	footnote "These numbers are based on the data from FBI UCR" ;
run;
ods html close;
