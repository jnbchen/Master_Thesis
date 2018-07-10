  function show_datenauswahl(parameter,code_alle,ind_auswahl,bez_code,zgf_y_bez)
% function show_datenauswahl(parameter,code_alle,ind_auswahl,bez_code,zgf_y_bez)
%
% zeigt aktuelle Datenauswahl (ausgewählte Datentupel) an
% 
%
% The function show_datenauswahl is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

datei_name=sprintf('%s_data_selection.txt',parameter.projekt.datei);     
f=fopen(datei_name,'wt');

if f==-1
    myerror(sprintf('Error by opening of %s',datei_name));
end;

fprintf(f,'Data selection:  %d Data points\n',size(code_alle(ind_auswahl,:),1));
fprintf(f,'Existing classes:\n');

if parameter.gui.allgemein.show_few_terms_first
   %sort by the number 
   [temp,nr_of_classes] = sort(parameter.par.anz_ling_y);
else
   nr_of_classes = 1:size(bez_code,1);
end;

for i=nr_of_classes 
   ind_class_i=findd(code_alle(ind_auswahl,i));
   fprintf(f,'\ny%d: %s (%d classes)\n',i,bez_code(i,:),length(ind_class_i));
   temp = hist(code_alle(ind_auswahl,i),1:max(ind_class_i));
   for j=ind_class_i 
      fprintf(f,'%d (%s) - %d Data points\n',j,zgf_y_bez(i,j).name,temp(j));      
   end;
end; %i

fprintf(f,'\nSelected data points (with class numbers):\n');

for i=ind_auswahl' 
   fprintf(f,'DS%d:  ',i);
   fprintf(f,'%d ',code_alle(i,:));
   fprintf(f,'\n');
end;

fprintf(f,'\nSelected data points (with class codes):\n');

for i=ind_auswahl' 
   fprintf(f,'DS%d:  ',i);
   for j=1:size(code_alle,2) 
      fprintf(f,'%s ',zgf_y_bez(j,code_alle(i,j)).name);
   end;
   fprintf(f,'\n');
end;

if (f~=1) 
   fclose(f);
   viewprot(datei_name);
end; 

