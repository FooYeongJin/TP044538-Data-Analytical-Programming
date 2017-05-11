/** Objective 1 **/
ods html body='/home/yeong_jin0/ODS Output/Overall United States.htm' style=HTMLBlue;

title 'US Crime Stats : Overall Crimes by Year';
proc tabulate data=crimedat.table4_final1 S=[foreground=black cellwidth=200 just=c];
	class year;
	var  new_population total_crimes;
	table year='', new_population='Estimated Population'*sum=''*f=comma14. total_crimes='# of Crimes'*sum=''*f=comma14. total_crimes='% of Crimes'*pctsum<new_population>=''*f=8.2;
	footnote "These numbers are based on the data from FBI UCR" ;
run;

title 'US Crime Stats : Overall Crimes by Year & Region';
proc tabulate data=crimedat.table4_final1 S=[foreground=black cellwidth=200 just=c];
	class year region;
	var  new_population total_crimes;
	table year=''*region='', new_population='Estimated Population'*sum=''*f=comma14. total_crimes='# of Crimes'*sum=''*f=comma14. total_crimes='% of Crimes'*pctsum<new_population>=''*f=8.2;
	footnote "These numbers are based on the data from FBI UCR" ;
run;

title 'US Crime Stats : Overall Crimes by Year, Region & Division';
proc tabulate data=crimedat.table4_final1 S=[foreground=black cellwidth=200 just=c];
	class year region division;
	var  new_population total_crimes;
	table year=''*region=''*division='', new_population='Estimated Population'*sum=''*f=comma14. total_crimes='# of Crimes'*sum=''*f=comma14. total_crimes='% of Crimes'*pctsum<new_population>=''*f=8.2;
	footnote "These numbers are based on the data from FBI UCR" ;
run;
ods html close;