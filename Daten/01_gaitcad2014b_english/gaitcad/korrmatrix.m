  function values = korrmatrix(d_org,ind_auswahl, merkmal_auswahl,statistikoptionen,vorberechnete_koeffizienten,names,variable_names)
% function values = korrmatrix(d_org,ind_auswahl, merkmal_auswahl,statistikoptionen,vorberechnete_koeffizienten,names,variable_names)
%
% Korrelationskoeffizienten berechnen
%
% The function korrmatrix is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(statistikoptionen) 
    corr_type = statistikoptionen.type_liste{statistikoptionen.corr_type};
else
    corr_type = 'Pearson';
end;

if nargin<5
   vorberechnete_koeffizienten=[];
end;

if nargin<6 || isempty(names)
   names.axis='Features';
   names.title=sprintf('%s (%s)','Correlation visualization of features',corr_type);
end;

anz_features = length(merkmal_auswahl);
xticklabelnames = merkmal_auswahl;
if nargin<7
   yticklabelnames = merkmal_auswahl;   
else
   yticklabelnames = [num2str([merkmal_auswahl]') ones(anz_features,1)*': ' variable_names(merkmal_auswahl,:)];
end;

if (length(merkmal_auswahl)<2)
   mywarning('Please select more features!');
   return;   
end;

if isempty(vorberechnete_koeffizienten)
   values=mycorrcoef(d_org(ind_auswahl,merkmal_auswahl),corr_type);
else
   values=vorberechnete_koeffizienten(merkmal_auswahl,merkmal_auswahl);
end;

%values(abs(values)<c_krit)=0;
for i=1:size(values,2)
   for j=i+1:size(values,2) 
      values(i,j)=0;
   end;
end;

%eigentliche Korrelationsmatrix plotten
plot_korrmatrix(values,0);

%Achsen
xlabel(names.axis);
ylabel(names.axis);
set(gca,'xtick',1:length(merkmal_auswahl));
set(gca,'ytick',1:length(merkmal_auswahl));
set(gca,'xticklabel',xticklabelnames);
set(gca,'yticklabel',yticklabelnames);

axis([0 size(values,2)+1 0 size(values,2)+1]);
set(gcf, 'Name', sprintf('%d: %s', get_figure_number(gcf),names.title), 'NumberTitle', 'off');


