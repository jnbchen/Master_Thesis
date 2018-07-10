  function save_feature_relevances(merk,dorgbez_neu,type,anz_cv,nr_cv,parameter,feature_relevance_file)
% function save_feature_relevances(merk,dorgbez_neu,type,anz_cv,nr_cv,parameter,feature_relevance_file)
%
% 
% 
% Beispiel: save_feature_relevances(merk,var_bez,'ANOVA',$\alpha=0.2$',0,0,parameter,'')
%
% The function save_feature_relevances is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(feature_relevance_file)
   feature_relevance_file = 'my_feature_relevances.prjz';
end;

if ~isfield(parameter.projekt,'data_selection')
   parameter.projekt.data_selection  = 'unknown';
end;


parameter.gui.allgemein.remove_old_data_point = 1;

if exist(feature_relevance_file,'file')
   load(feature_relevance_file,'-mat');
else
   %hier wird ein komplett neues Projekt initialisiert
   zgf_y_bez(1,1).name = parameter.projekt.datei;
   zgf_y_bez(2,1).name = type;
   zgf_y_bez(3,1).name = '0';
   zgf_y_bez(4,1).name = '0';
   zgf_y_bez(5,1).name = parameter.projekt.data_selection;  
   par.anz_ling_y = ones(1,size(zgf_y_bez,1));
   par.anz_dat = 0;
   code_alle = zeros(1,size(zgf_y_bez,1));
   dorgbez = dorgbez_neu;
   d_org = zeros(0,size(dorgbez_neu,1));
   bez_code = strvcatnew('Project','Relevance','CV run','CV No.','Data point selection');
end;

text_code(1).text = parameter.projekt.datei;
text_code(2).text = type;
text_code(3).text = sprintf('%d',anz_cv);
text_code(4).text = sprintf('%d',nr_cv);
text_code(5).text = parameter.projekt.data_selection;  


%Datentupel == Auswerteergebnisse
%Einzelmerkmale == Merkmale

%Ausgangsklassen bestimmen
% 1 - Projekt
% 2 - Art Merkmalsrelevanz
% 3 - Nr. Crossvalidierungsdurchlauf (n-fache Crossvalidierung, 0:keine)
% 4 - Versuchsanzahl Crossvalidierung (0:keine)
% 5 - optional: Art Datenauswahl

for i_code = 1:length(text_code)
   temp = find(ismember({zgf_y_bez(i_code,1:par.anz_ling_y(i_code)).name},text_code(i_code).text));
   if ~isempty(temp)
      code_neu(i_code) = temp;
   else
      par.anz_ling_y(i_code) = par.anz_ling_y(i_code)+1;
      code_neu(i_code)      = par.anz_ling_y(i_code);
      zgf_y_bez(i_code,par.anz_ling_y(i_code)).name = text_code(i_code).text;
   end;
end;


%je nach Einstellung altes Datentupel überschreiben, wenn es den gleichen Klassencode hat
ind_old_data_point =    find ( (code_alle(:,1) == code_neu(1)) & (code_alle(:,2) == code_neu(2)) & ...   % Coderevision: &/| checked!
   (code_alle(:,3) == code_neu(3)) & (code_alle(:,4) == code_neu(4)) &  (code_alle(:,5) == code_neu(5)));% Coderevision: &/| checked!
if ~isempty(ind_old_data_point) && parameter.gui.allgemein.remove_old_data_point;
   ind_write = ind_old_data_point(1);
else
   par.anz_dat = par.anz_dat+1;
   ind_write = par.anz_dat;
end;

%Match names
%welche Merkmale kommen in beiden Bezeichnermatrizen vor und wo befinden sie sich
[dorgbez,ind_bez,ind_bez_neu]=intersect(cellstr(dorgbez),cellstr(dorgbez_neu));
%Merkmale und Klassen reinschreiben
code_alle(ind_write,:) = code_neu;
d_org(ind_write,ind_bez) = merk(ind_bez_neu)';

%neue Bezeichner und neue Reihenfolge
dorgbez = char(dorgbez);
d_org = d_org(:,ind_bez);


%Speichern
save(feature_relevance_file,'zgf_y_bez','code_alle','par','d_org','dorgbez');

