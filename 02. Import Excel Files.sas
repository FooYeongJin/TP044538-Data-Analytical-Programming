
/** Import Excel tables into SAS dataset*/
%macro import(xlsfile,name);
proc import datafile="/home/yeong_jin0/Raw Data/&xlsfile..xls"
 dbms=xls replace
 out=crimedat.&name;
 getnames=yes;
run;
%mend import;
%import(Table_4_Cleaned,table4);
%import(Region,region);
%import(Table_78_2014_Cleaned,employee2014);
%import(Table_78_2015_Cleaned,employee2015);