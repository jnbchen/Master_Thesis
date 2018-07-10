  function [mw,std_k,median_k]=mw_aut(d_org,code,par,var_bez,texprotokoll,datei,ind_katem,zgf_y_bez,uihd,showrange)
% function [mw,std_k,median_k]=mw_aut(d_org,code,par,var_bez,texprotokoll,datei,ind_katem,zgf_y_bez,uihd,showrange)
%
% The function mw_aut is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

if nargin<5 
   texprotokoll=0;
end;
if nargin<6 
   datei='tmp';
end;
if nargin<7 
   ind_katem=1:size(d_org,2);
end;
if nargin<8 
   for i=findd(code) 
      zgf_y_bez(i).name=sprintf('%d',i);
   end;
end;
if nargin<9 
   uihd=[];
end;
if nargin<10 
   showrange = 0;
end;

if texprotokoll 
   dateimw=sprintf('%s_MEANSTD.tex',datei);
else         
   dateimw=sprintf('%s_MEANSTD.txt',datei);
   
end;   

dateimw = repair_dosname(dateimw);
f=fopen(dateimw,'wt');   

%Formatstring laden (sucht hintenrum in uihd!!, hat aber Default-Varianten)...   
zahlenstring=deblank(get_zahlenstring);

%Merkmalsauswahl?
if ~isempty(uihd) 
   prottail=protkopf(f,uihd,texprotokoll,datei,'Mean values analysis');
end;

for i=findd(code)
   anz_dat(i) = length(find(code==i)); 
   mw(i,ind_katem)=mean(d_org(find(code==i),ind_katem),1);
   median_k(i,ind_katem)=median(d_org(find(code==i),ind_katem),1);
   std_k(i,ind_katem)=std(d_org(find(code==i),ind_katem),0,1);
   if (showrange>0)
      min_(i, ind_katem) = min(d_org(find(code==i), ind_katem));
      max_(i, ind_katem) = max(d_org(find(code==i), ind_katem));
      median_(i, ind_katem) = median(d_org(find(code==i), ind_katem));
   end;
end;
% Durch die Verwendung einer Matrix werden viele Zeichenketten mit Leerzeichen aufgefüllt. Die
% werden im folgenden wieder entfernt.
temp_var_bez = deblank(var_bez(ind_katem,:));
var_bez = zeros(size(d_org,2), 1);
var_bez(ind_katem,1:size(temp_var_bez,2)) = temp_var_bez;
var_bez=char(var_bez);




if ~texprotokoll 
   if (showrange<2) 
      fprintf(f,'Mean values and standard deviations:\n');   
   else
      fprintf(f,'Median and extreme values:\n');   
   end;
   fprintf(f,'Comparison of output classes\nFeature'); 
   for i=findd(code)
      switch showrange
      case 0
         fprintf(f,'\tMEAN + STD (%s) ',zgf_y_bez(i).name);
      case 1
         fprintf(f,'\tMEAN + STD (MIN -> MAX) (%s) ',zgf_y_bez(i).name);
      case 2
         fprintf(f,'\tMED (MIN -> MAX) (%s) ',zgf_y_bez(i).name);
      end;
   end;
   
   
   %number of data points
   fprintf(f,'\nNumber of data points');
   for i=findd(code) 
       fprintf(f,' \t%d  ',anz_dat(i));   
   end;
   
   
   for j=ind_katem 
      fprintf(f,'\nFeature %3d (%s)',j,var_bez(j,:));
      for i=findd(code) 
         switch showrange
         case 0
            template=sprintf(' \t%s +- %s  ',zahlenstring,zahlenstring);
            fprintf(f,template,[mw(i,j) std_k(i,j)]);
         case 1
            template=sprintf(' \t%s +- %s (%s -> %s)  ',zahlenstring,zahlenstring,zahlenstring,zahlenstring);
            fprintf(f,template,[mw(i,j) std_k(i,j) min_(i,j) max_(i,j)]);
         case 2
            template=sprintf(' \t%s (%s -> %s)  ',zahlenstring,zahlenstring,zahlenstring,zahlenstring);
            fprintf(f,template,[median_(i,j) min_(i,j) max_(i,j)]);
         end;
      end;
   end;
else
   %zusätzliche TEX-Tabelle - vorinitialisieren, sonst wirds lahm   
   tableinh=char(32*ones(1,length(ind_katem)*(size(var_bez,2)+20+par(4)*20)));
   table_z=1;
   tablezeile='';
   
   for i=findd(code) 
      tablezeile=sprintf('%s & %d',tablezeile,anz_dat(i));
   end;
      
   tablezeile=sprintf('\n Number of data points %s',tablezeile);
   tableinh(table_z+[1:length(tablezeile)])=tablezeile;
   table_z=table_z+length(tablezeile);

   
   for j=ind_katem 
      if ~rem(j,20) 
         fprintf(1,'%d\n',j);
      end;
      tablezeile='';
      for i=findd(code) 
         switch showrange
         case 0
            template=sprintf('%%s& %s +- %s ',zahlenstring,zahlenstring);
            tablezeile=sprintf(template,tablezeile,[mw(i,j) std_k(i,j)]);
         case 1
            template=sprintf('%%s& %s +- %s (%s -> %s)',zahlenstring,zahlenstring, zahlenstring, zahlenstring);
            tablezeile=sprintf(template,tablezeile,[mw(i,j) std_k(i,j) min_(i,j) max_(i,j)]);
         case 2
            template=sprintf('%%s& %s (%s -> %s)',zahlenstring,zahlenstring, zahlenstring, zahlenstring);
            tablezeile=sprintf(template,tablezeile,[median_(i,j) min_(i,j) max_(i,j)]);
         end;
      end;
      tablezeile=sprintf('\n $x_{%3d}$ (%s) %s',j,var_bez(j,:),tablezeile);
      tableinh(table_z+[1:length(tablezeile)])=tablezeile;
      table_z=table_z+length(tablezeile);
   end;
   tablekopf='';
   tableinh=sprintf('%s\n',tableinh(1:table_z));
   for i=findd(code)
      switch showrange
      case 0
         tablekopf=sprintf('%s & MEAN + STD (%s)',tablekopf,zgf_y_bez(i).name);
      case 1
         tablekopf=sprintf('%s & MEAN + STD (MIN -> MAX) (%s)',tablekopf,zgf_y_bez(i).name);
      case 2
         tablekopf=sprintf('%s & MED (MIN -> MAX) (%s)',tablekopf,zgf_y_bez(i).name);
      end;
   end;
   textable(tablekopf,tableinh,'Comparison means and standard deviations',f);
end;

if ~isempty(uihd) 
   fprintf(f,'%s',prottail);
end;

fclose(f);   
viewprot(dateimw);

%figure;bar(1:length(ind_katem),mw(:,ind_katem)');set(gca,'xtick',1:length(ind_katem));set(gca,'xticklabel',ind_katem);


