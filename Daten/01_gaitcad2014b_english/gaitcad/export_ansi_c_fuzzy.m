  function export_ansi_c_fuzzy(datei,rulebase,zgf,var_bez,par,xfeld,inferenz,var_bez_longnames)
% function export_ansi_c_fuzzy(datei,rulebase,zgf,var_bez,par,xfeld,inferenz,var_bez_longnames)
%
% xfeld: Doku Regelbasis in Kommentar
% inferenz=3: MAX-MIN, Rückgabe Klassencode (Standard), sonst: SUM-PROD, Rückgabe defuzzifizierter Wert
% 
% Bugfixes:
% 15.1.04 Anpassung auf zgf<0, SUM-PROD-Inferenz
%
% The function export_ansi_c_fuzzy is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
% 
% This program is free software; you can redistribute it and/or modify,
% it under the terms of the GNU General Public License as published by 
% the Free Software Foundation; either version 2 of the License, or any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along with this program;
% if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
% You will find further information about Gait-CAD in the manual or in the following conference paper:
% 
% MIKUT, R.; BURMEISTER, O.; BRAUN, S.; REISCHL, M.: The Open Source Matlab Toolbox Gait-CAD and its Application to Bioelectric Signal Processing.  
% In:  Proc., DGBMT-Workshop Biosignal processing, Potsdam, pp. 109-111; 2008 
% Online available: https://sourceforge.net/projects/gait-cad/files/mikut08biosig_gaitcad.pdf/download
% 
% Please refer to this paper, if you use Gait-CAD for your scientific work.

global number_multi number_para

number_multi=0;
number_para=0;

if (nargin<7) 
   inferenz=3;
end;

if (nargin<8) 
   var_bez_longnames='';
end;


if isempty(rulebase) 
   fprintf('No rules !\n');
   return;
end;
[wert,pos]=sort(-rulebase(:,1));
rulebase=rulebase(pos,:);

%Anzeige, aber ohne Default-Regel!
ind=find(max(rulebase(:,5:size(rulebase,2))'));
ind_null=find(~max(rulebase(:,5:size(rulebase,2))'));
%Default-Regel Konklusion raussuchen
if ~isempty(ind_null) 
   default_y=rulebase(ind_null(1),4);
else
   %if no explicit default rule exist, the value is set to one
   default_y = 1;
end;
%Nullregeln entsorgen!
rulebase=rulebase(ind,:);

%Regelbasen in Kommentar schreiben
f=fopen(sprintf('%s_fuzzy.c',datei),'wt');
fprintf(f,'//Automatically generated C code of a fuzzy rulebase with %d rules\n',size(rulebase,1));
cl=clock;
fprintf(f,'//Project: %s.prj, %s, %02d:%02d \n\n',datei,date,cl(4:5));
fprintf(f,'//Default value output variable: y=%g\n',default_y);
fprintf(f,'/*Rulebase:\n');
translat9(rulebase,par,f);

if ~isempty(var_bez_longnames)
   fprintf(f,'\n\nRulebase with complete names:\n');
   translat9(rulebase,par,f,'',0,var_bez_longnames);
end;

if xfeld == 1 && ~isempty(var_bez_longnames)
   fprintf(f,'\n\nNecessary input variables:\n');
   for i=1:size(var_bez_longnames,1) 
      fprintf(f,'x[%d]: %s\n',i,var_bez_longnames(i,:));
   end;
end;



fprintf(f,'*/\n\n');

%Manipulation der Variablennamen
%keine - in den Variablen-Namen
var_bez(find(var_bez==45))=95;

if xfeld 
   var_bez=32*ones(size(var_bez));
   for i=1:size(var_bez,1) 
      tmp=sprintf('x[%d]',i);var_bez(i,1:length(tmp))=tmp;
   end;
   fprintf(f,'\n//Input variables, program definition necessary: float x[%d];\n',par(2)+1);
end;

fprintf(f,'//Output variable''s membership degrees, program definition necessary: float mu_y[%d];\n\n',par(4)+1);


fprintf(f,'//Function for partial premises and fuzzification (triangular or trapezoid MBF''s\n');
fprintf(f,'float computeTp(float tp1,float tp2)\n{\nfloat tp;\nif (tp1<tp2) tp=tp1; else tp=tp2;\nif (tp<0) tp=0;\nif (tp>1) tp=1;\nreturn tp;\n};\n');


fprintf(f,'\n//Main function fuzzy_control, return value: y (defuzzified output value)\n');
%Rückgabewert Funktion - je nach Inferenz-Verfahren
if (inferenz==3)  
   fprintf(f,'int fuzzy_control(float* x,float* mu_y)\n{\nfloat pr[%d],max_mu_y;\nint i,y;\n',size(rulebase,1)+1);
else           
   fprintf(f,'float fuzzy_control(float* x,float* mu_y)\n{\nfloat pr[%d],sum_mu_y;\nint i;\n',size(rulebase,1)+1);
   %Sum-Prod braucht noch Ausgangs-ZGF zum defuzzzifizieren 
   tmp=sprintf('%5.3f,',zgf(size(zgf,1),1:par(4)));
   fprintf(f,'float y,zgf_y[]={%s};\n\n',tmp(1:length(tmp)-1));
end;

fprintf(f,'//Fuzzification and rule premises (one step!)\n');
for j=1:size(rulebase,1)
   erster_term=1;
   m=pla2mas(rulebase(j,:),par);
   for i=1:par(2) 
      %neue Variable
      if (m(i,1)) 
         if (~erster_term) 
            fprintf(f,'*'); 
         else              
            if (j>1) 
               fprintf(f,';\n');
            end; 
            fprintf(f,'pr[%d]=',j); 
            erster_term=0;
         end;  
         
         %Endleerzeichen und mehrfache Mittelleerzeichen löschen   
         var_bez_akt=var_bez(i,:);
         var_bez_akt=var_bez_akt(find((var_bez_akt~=32)|(diff(double([var_bez_akt 32]))~=0)));   
      end;
      
      %0==beliebig, wird weggelassen
      
      %Primärterm
      if (m(i,1)>0) 
         printComputeTp(f,var_bez_akt,zgf(i,1:par(4+i)),m(i,1),m(i,1),0);
      end;
      
      %ODER-verknüpfte Primärterme
      if (m(i,1)==-1) 
         ind=find(m(i,2:size(m,2)));
         %es fehlt nur ein Term, also besser negieren
         if (length(ind)==(par(4+i)-1)) 
            ind=find(~m(i,2:size(m,2)));
            printComputeTp(f,var_bez_akt,zgf(i,1:par(4+i)),ind,ind,1); 
         else 
            printComputeTp(f,var_bez_akt,zgf(i,1:par(4+i)),min(ind),max(ind),0);
         end;
         
      end;%if m
   end;%i
   
   %Endleerzeichen und mehrfache Mittelleerzeichen bei y-Bezeichnung löschen   
   var_bez_akt=var_bez(par(2)+1,:);
   var_bez_akt=var_bez_akt(find((var_bez_akt~=32)|(diff(double([var_bez_akt 32]))~=0)));   
end; %j -Regeln

fprintf(f,';\n//Rule conclusions (always SUM-PROD-inference, no overlapping correction)');
for i=1:par(4)
   ind=find(rulebase(:,4)==i);
   if isempty(ind) 
      tmp=sprintf('00');
   else        
      tmp=sprintf('pr[%d]+',ind);
   end;   
   fprintf(f,';\nmu_y[%d]=%s',i,tmp(1:length(tmp)-1));
end;
if (inferenz==3) 
   fprintf(f,';\n//Limitation of output membership degrees (max=1) and defuzzification (maximum method) \ny=%g;max_mu_y=0;\nfor (i=1;i<%d;i++)\n{\nif (mu_y[i]>max_mu_y) {y=i;max_mu_y=mu_y[i];};\nif (mu_y[i]>1) {mu_y[i]=1;};\n',default_y,par(4)+1);
else
   fprintf(f,';\n//Sum-Prod-Inference \n sum_mu_y=0;y=0;\nfor (i=1;i<%d;i++)\n{\n y+=mu_y[i]*zgf_y[i-1];sum_mu_y+=mu_y[i];\n};\n',par(4)+1);
   number_multi=number_multi+par(4);
   number_para=number_para+par(4);
   fprintf(f,'if (sum_mu_y==0) y=%g;\n',default_y);
end;

fprintf(f,'return y;\n};\n');

fprintf(f, '\n // Number of multiplications: %d, \n // Number of parameters: %d \n;',number_multi,number_para);

fclose(f);
viewprot(sprintf('%s_fuzzy.c',datei));	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printComputeTp(f,var_bez_akt,zgf,minind,maxind,negstatus)

global number_multi number_para

%plottet ZGF-Geraden  in File
if negstatus 
   fprintf(f,'(1-');
end;
if minind==1 
   fprintf(f,'computeTp(1,');
   number_para=number_para+1;
else         
   number_multi=number_multi+1;
   if zgf(minind-1)>0  
      fprintf(f,'computeTp((%s-%f)/%f,',var_bez_akt,zgf(minind-1),zgf(minind)-zgf(minind-1));
      number_para=number_para+2;
   end;
   if zgf(minind-1)<0  
      fprintf(f,'computeTp((%s+%f)/%f,',var_bez_akt,-zgf(minind-1),zgf(minind)-zgf(minind-1));
      number_para=number_para+2;
   end;
   if zgf(minind-1)==0 
      fprintf(f,'computeTp((%s)/%f,',var_bez_akt,zgf(minind)-zgf(minind-1));
      number_para=number_para+1;
   end;
end; %if minind

if maxind==length(zgf)
   fprintf(f,'1)');
   number_para=number_para+1;
else    
   number_multi=number_multi+1;  
   if zgf(maxind+1)==0 
      fprintf(f,'(-%s)/%f)',var_bez_akt,zgf(maxind+1)-zgf(maxind));
      number_para=number_para+1;
   else                
      fprintf(f,'(%f-%s)/%f)',zgf(maxind+1),var_bez_akt,zgf(maxind+1)-zgf(maxind));
      number_para=number_para+2;
   end; %if zgf(maxind)
end;  %if maxind 
if negstatus 
   fprintf(f,')');
end;
