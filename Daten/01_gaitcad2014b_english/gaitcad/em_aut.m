  function em_aut(code_alle_ausw,zgf_y_bez,bez_code,d_org_ausw,dorgbez_ausw,ind_auswahl,parameter,merk_relev_ausw)
% function em_aut(code_alle_ausw,zgf_y_bez,bez_code,d_org_ausw,dorgbez_ausw,ind_auswahl,parameter,merk_relev_ausw)
%
% zeigt ausgewählte Einzelmerkmale in Datei an
%
% The function em_aut is part of the MATLAB toolbox Gait-CAD. 
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

ind_index_auswahl = 1:length(ind_auswahl);


%list sorting using the first selected single feature
switch parameter.gui.anzeige.list_sorting
case 1
   %descending
   [tmp,ind_index_auswahl] = sort(-d_org_ausw  (:,parameter.gui.merkmale_und_klassen.ind_em(1)));
   ind_index_auswahl = ind_index_auswahl';
case 2
   [tmp,ind_index_auswahl] = sort(d_org_ausw  (:,parameter.gui.merkmale_und_klassen.ind_em(1)));
   ind_index_auswahl = ind_index_auswahl';
   %ascending
   %otherwise change nothing...
end;

%all features? 
if parameter.gui.anzeige.featurenumber_list_check == 0
   ind_index_auswahl = ind_index_auswahl(1:min(length(ind_index_auswahl),parameter.gui.anzeige.feature_number));
end;


if nargin<8
   merk_relev_ausw=[]; 
end

code_alle_ausw = code_alle_ausw(ind_index_auswahl,:);
d_org_ausw   = d_org_ausw  (ind_index_auswahl,parameter.gui.merkmale_und_klassen.ind_em);
dorgbez_ausw = dorgbez_ausw(parameter.gui.merkmale_und_klassen.ind_em,:);
ind_auswahl = ind_auswahl(ind_index_auswahl);

ind_tmp=strfind(dorgbez_ausw(:)','%'); 
dorgbez_ausw(ind_tmp)='§'; 


if parameter.gui.anzeige.tex_protokoll
   filename = sprintf('%s_feature_values.tex',parameter.projekt.datei);
   spalten_trenn=[' &'];
else
   filename = sprintf('%s_feature_values.txt',parameter.projekt.datei);
   spalten_trenn=sprintf('\t'); %hier ist ein TAB und Leerzeichen! 
end;
f=fopen(repair_dosname(filename),'wt');

kopf=['Data points' spalten_trenn];
beschrift='Single features';

%Erstelle Titelzeile aus Ausgangsklassen
losch=[];
switch parameter.gui.anzeige.output4em
case 1
   %All
   ind_output = 1:size(code_alle_ausw,2);
case 2
   %Selected
   ind_output = parameter.gui.merkmale_und_klassen.ausgangsgroesse;
case 3
   %None
   ind_output = [];
end;




for i=1:length(ind_output)
   kl=findd(code_alle_ausw(:,ind_output(i)));
   if length(kl)==1 % wenn nur eine Ausgangsklasse vorhanden, braucht sie ja nicht extra in Tab aufgeführt, sondern nur im Titel
      beschrift=sprintf('%s with %s=%s', beschrift,bez_code(ind_output(i),:),zgf_y_bez(ind_output(i),kl).name);
      losch=[losch i]; %vermerke die zu Löschende Ausgangsklasse
   else
      kopf=sprintf('%s%s %s', kopf,bez_code(ind_output(i),:),spalten_trenn);
   end %if
end %for

%löschen der Einträge, weil nicht in Tab erscheinen sollen
if ~isempty(losch)
   ind_output(losch) = [];
end;


%Hänge EM-Bezeichner an Titelzeile an
for i=1:size(dorgbez_ausw,1)
   if isempty(merk_relev_ausw)
      kopf=sprintf('%s%s (x%d) %s', kopf,kill_lz(dorgbez_ausw(i,:)),parameter.gui.merkmale_und_klassen.ind_em(i),spalten_trenn); 
   else
      kopf=sprintf('%s%s (x%d) (%1.3f) %s', kopf,kill_lz(dorgbez_ausw(i,:)),parameter.gui.merkmale_und_klassen.ind_em(i),merk_relev_ausw(i),spalten_trenn); 
   end;
end;
kopf(length(kopf))=[]; % das letzte '&' löschen

% Erstelle Tab Inhalt, 
tmp=[]; 

anz_zeilen=size(d_org_ausw,1);

%Data points
spalt=sprintf('''%d'',',ind_auswahl); 
spalt=eval(sprintf('char(%s)',spalt(1:length(spalt)-1)));
tmp=[tmp spalt ones(anz_zeilen,1)*abs(spalten_trenn)];

for j=ind_output %gehe durch alle (noch vorhandenen) Ausgangsklassen
   tmp= [tmp char(zgf_y_bez(j,code_alle_ausw(:,j)).name) ones(anz_zeilen,1)*abs(spalten_trenn)]; 
end; % Ausgkl

for i=1:size(d_org_ausw,2) 
   spalt=sprintf('''%1.3f'',',d_org_ausw(:,i)'); 
   spalt=eval(sprintf('char(%s)',spalt(1:length(spalt)-1)));
   
   if parameter.gui.anzeige.german_decimal_numbers == 1
       spalt(spalt=='.') = ',';
   end;
   tmp=[tmp spalt ones(anz_zeilen,1)*abs(spalten_trenn)];
end;


if parameter.gui.anzeige.tex_protokoll == 1
   tmp(:,size(tmp,2))=ones(size(tmp,1),1)*abs(sprintf('\n'));
   tmp=tmp';
   tmp=tmp(:)';
%   tmp = sprintf(tmp);
   textable(kopf,tmp,beschrift,f,0);
else
   kopf=kill_lz(kopf);
   tmp=char(beschrift, kopf, tmp);
   tmp=[tmp ones(size(tmp,1),1)*abs(sprintf('\n'))];
   %tmp(:,size(tmp,2))=ones(size(tmp,1),1)*abs(sprintf('\n'));
   fprintf(f,'%c',tmp');
end;

fclose(f);   
viewprot(repair_dosname(filename));


