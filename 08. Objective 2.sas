/** Objective 2 **/
/** To summarized the crime type **/
proc summary data=crimedat.table4_final1 nway;
	class year;
	var  murder robbery aggravated_assault burglary larceny_theft motor_vehicle_theft sexual_assault total_crimes;
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
   tables year*crime_type/out=table4_2014_trans_v3;
   weight no_of_offence;
run;

proc freq data=table4_2015_trans_v2 noprint;
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
pattern1 color=vliv;       /* Aggravated assault 	*/
pattern2 color=deypk;      /* Burglary            	*/
pattern3 color=vigb;       /* Larceny Theft    		*/
pattern4 color=bio;        /* Motor Vehicle Theft   */
pattern5 color=bippk;      /* Murder     			*/
pattern6 color=gry;        /* Robbery     			*/
pattern7 color=daol;       /* Sexual assault        */

legend1 label=none
        position=(bottom)
        offset=(4,)
        across=3
        order=("Aggravated Assault" "Burglary" "Larceny Theft" "Motor Vehicle Theft" "Murder" "Robbery" "Sexual Assault")
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


/** To create bar chart **/
title 'US Crime Stats : Overall Crimes #';
proc sgplot data=work.table4_1415_trans_v3;
    where crime_type in ("Aggravated Assault", "Burglary", "Larceny Theft");
	format	COUNT	comma10.;
	label	COUNT	=	'# of Offense';
	vbar	crime_type /	response=COUNT group=year groupdisplay=cluster 
	stat=sum				dataskin=gloss;
	xaxis					display=(nolabel noticks);
	yaxis					grid;
	footnote "These numbers are based on the data from FBI UCR" ;
run;
ods html close;
