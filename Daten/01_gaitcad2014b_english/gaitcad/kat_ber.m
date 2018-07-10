  function [code_em, zgf_em_bez]=kat_ber(dorgbez,zgf_y_bez,par,bez_code,istzeitreihe)
% function [code_em, zgf_em_bez]=kat_ber(dorgbez,zgf_y_bez,par,bez_code,istzeitreihe)
%
%  HIER: NUR eine Matrix mit (partieller, "ist Element von ") Zugehörigkeit erstellen, ohne Auswahlfunktion
%  Element=0 bedeutet, nein, gehört nicht dazu. Element=1, 2, 3, ... in der Reihenfolge, wie in kat.name angegeben,
%    z.B. sagit=1, front=2, trans=3;
% 
%  Berechnet zugehörige Kategorie der EM und gibt eine Ausgangsmatrix (s x k) zurück (s=Anzahl Merkmale, k=Anzahl Kategoroien)
%  Idee: solche Kategorien wie Seite (R-, L-), oder auch (Stand-Schwung-Phase??) sind einfach
%    d.h. einfach schauen, ob Merkmal dazugehört und dementsprechend 1(=ja, gehört dazu) oder 2(=nein) setzen
%    dies kann unvollständig sein wie's will
%  Bei z.B. Sagittaler Seite MUSS alles vollständig sein, weil diese Kategorie aus fest definierten Merkmalen besteht, nicht mehr, nicht weniger
%
% The function kat_ber is part of the MATLAB toolbox Gait-CAD. 
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

for i=1:size(dorgbez,1) %wandle alle ANK und ANG in QNK bzw. QNG um (stört bei Detektion A-ZR, V-ZR)
   dorgbez(i,strfind(dorgbez(i,:),'ANK'))='Q'; %Q wird nun wirklich nicht gebraucht! 
   dorgbez(i,strfind(dorgbez(i,:),'ANG'))='Q'; % Tip: strfind liefert nur Anfangsindex, d.h. aus ANG wird QNG
   dorgbez(i,strfind(dorgbez(i,:),'Abd'))='Q';
   dorgbez(i,strfind(dorgbez(i,:),'Add'))='Q'; % Bei Schulter kommt ein Add vor
   dorgbez(i,strfind(dorgbez(i,:),'STRI'))='Q'; % Tip: "STRI" und "ST" haben was gemeinsam! 
   dorgbez(i,strfind(dorgbez(i,:),'ABS'))='Q'; % Tip: "STRI" und "ST" haben was gemeinsam!
end

%Sammlung aller Kategorien
kat.bez=char('Plane', 'Joint', 'Body side', 'Additional time series', 'Norm TS', 'Phase', 'Type of feature','TS with absolute value','Type of measured signal');

%in der ersten Zeile kat(x,1).name steht die spätere Bezeichnung
%ALLE Bezeichnungen zum Thema: Ebene (bei den ersten Namen wurde schon weitergedacth! z.B. norm_alle2)
kat(1,1).name=char('sagit', 'front','trans','unknown'); %zu sagit gehört: Fwd-Tilt, Flex; front: Lat-Tilt, Abd; trans: Rotation, Rot
kat(1,2).name=char('Fwd-Tilt', 'Lat-Tilt','Rotation',' '); 
kat(1,3).name=char('Flex', 'Qbd','Rot',' '); 
kat(1,4).name=char('Elbow', 'Qdd','Foot-Orientation',' '); %gehört ja auch zur transversalen Ebene, bei Elbow bin ich unsicher???
kat(1,5).name=char('DorsiPlanFlex', 'AbAdduct','ProgressAnglez',' ');
kat(1,6).name=char('FlexExt', 'ValgVar',' ',' ');
kat(1,7).name=char('PelvicTilt','Obliquity',' ',' ');
kat(1,8).name=char('TrunkTilt',' ',' ',' ');


%ALLE Bezeichnungen zum Thema: Gelenk
kat(2,1).name=char('PEL','HIP','KNE','ANK','Shl','Elbow','Trunk','unknown'); %für Bezeichner
kat(2,2).name=char('Pelvis','HIP','KNEE','QNK',' ',' ',' ',' '); %Vergiß nicht Foot Orientation
kat(2,3).name=char('Pelvic','Hip','Knee','Foot-Orientation',' ',' ',' ',' '); 
kat(2,4).name=char(' ',' ',' ','Foot',' ',' ',' ',' '); 
kat(2,5).name=char(' ',' ',' ','DorsiPlanFlex',' ',' ',' ',' '); 
%kat(2,6).name=char(' ',' ',' ','Ankle',' ',' ',' ',' '); 

%ALLE Bezeichnungen zum Thema: ZR
kat(3,1).name=char('R-', 'L-', 'S+', 'S-', 'SDiff', 'SMean','unknown');
kat(3,2).name=char('Right', 'Left', ' ', ' ', ' ', ' ',' ');
kat(3,3).name=char('Right', 'Left', ' ', ' ', ' ', ' ',' ');


% Kombination ZRSTD mit anderen ZR-Derivaten sind nicht zulässig! Sowie ABS-ZR in Kombination nur mit NZR! 
% Zusatzbedingungen: (diese stehen nicht immer explizit in den Merkmalsbezeichner, z.B. STRI in Zeitreihen, oder O-ZR, usw.)
kat(4,1).name=char('O-TS ', 'V-TS', 'ATS', 'A/DTS', 'J-TS','TSSTD'); %Vergiß nicht die O-ZR! Die Leerzeile am Anfang hat Auswirkung auf Nummerierung, d.h. bei O-ZR ist code_em=1
kat(4,2).name=char(' ', ' V', ' A', ' A/D', ' J','TSSTD'); %Vergiß nicht die O-ZR! Die Leerzeile am Anfang hat Auswirkung auf Nummerierung, d.h. bei O-ZR ist code_em=1
kat(4,3).name=char(' ', '_V', '_A', '_A/D', '_J',' '); %Vergiß nicht die O-ZR! Die Leerzeile am Anfang hat Auswirkung auf Nummerierung, d.h. bei O-ZR ist code_em=1

kat(5,1).name=char('O-TS', 'NDTS'); %Vergiß nicht die O-ZR! 
kat(5,2).name=char(' ', 'NDTS'); %Vergiß nicht die O-ZR! %wenn keine Alternative, muss NZR nochmals angegeben werden (oder etwas was er nicht findet)

kat(6,1).name=char(' QTRI',' ST',' SW',' IC',' LR',' MSt',' TSt',' PSw',' ISw',' MSw',' TSw');% ZR sind immer STRI
kat(6,2).name=char('_QTRI','_ST','_SW','_IC','_LR','_MSt','_TSt','_PSw','_ISw','_MSw','_TSw');% ZR sind immer STRI

kat(7,1).name=char('Time series','MIN', 'MAX', 'MIPO', 'MAPO', 'MEAN', 'ROM', 'SFSTD', 'ND Abs', 'ND Dir', 'ND Abs0', 'ND Dir0', 'CORR', 'NDSign', 'NDSign0','PC-SF','DA-SF','TS->SF'); % Nur bei EM

kat(8,1).name=char('O-TS', 'ABS'); %nur für Bezeichnung 
kat(8,2).name=char(' ', 'QBS'); %Vergiß nicht die O-ZR! nur zur Suche

kat(9,1).name=char('Moment','Power','EMG','unknown'); %nur für Bezeichnung 
kat(9,2).name=char('Moment','Power','Env]','unknown'); %nur für Bezeichnung 

%HIER können weitere Kategorien eingefügt werden: 
%  (die nachfolgende Ausgangsklassen-Kategorie sind variabel programmiert)

% weitere Kategorien: Ausgangsklasse dabei? (z.B. bei Merekmale trennen) 
tmp_anz_kat=size(kat,1);
for i=1:par.anz_y
   kat(tmp_anz_kat+i,1).name=char('O-Daten, not separated', char(zgf_y_bez(i,1:par.anz_ling_y(i)).name) );
   kat(1,1).bez=char( char(kat(1,1).bez) , bez_code(i,:) ); 
end
zgf_em_bez(1,1).katbez=kat(1,1).bez;
%hier sind die Positionene der Ausgangsklassen gespeichert, wichtig wenn nicht getrennt wird, dann werden sie später wieder gelöscht
ind_kat_ausgkl=tmp_anz_kat + 1:size(kat,1); 

k=size(kat(1,1).bez,1);
code_em=zeros(size(dorgbez,1),k);

%Hinweis zu den Schleifen:      kat( ober_kat, alt_bez ).name( kategorie, : ) 
fprintf('Search category: \n');
for ober_kat=1:k %gehe durch alle Spalten von code_em, also alle Kategorie-Oberbegriffe, wie Ebene, Gelenk, ...
   fprintf('%s\n',kat(1,1).bez(ober_kat,:));
   for alt_bez=1:size(kat,2) %gehe durch in dorgbez alle alternativ-Bezeichner
      tmp_bez_mat=char(kat(ober_kat,alt_bez).name);
      if ~isempty(tmp_bez_mat)
         for kategorie=1:size(tmp_bez_mat,1) %gehe durch alle versch. Kategorien und suche nach Bezeichner
            
            tmp_bez=tmp_bez_mat(kategorie,:);
            if ~min(abs(tmp_bez)==32) %wenn in einer Zeile nur Leerzeichen stehen (kein Eintrag in kat.name), dann überspringen
               tmp_ind=find_merk(kill_lz(tmp_bez),dorgbez,2);
               if tmp_ind 
                  code_em(tmp_ind,ober_kat)=kategorie; 
               end;
            end % if ~min
            
         end % for kategorie
      end %if ~isempty()
   end %for alt_bez
   
   %OBACHT: AB hier ist's nicht hyper-getestet: 
   %  %letzteres wegen Zeitreihen, sie sind alle über STRI! (bei ober_kat==7)
   %  ersteres für die Ausgangsklassen
   if max(ober_kat==ind_kat_ausgkl)||(ober_kat==4)||(ober_kat==5)||(ober_kat==6)||(ober_kat==7)||(ober_kat==8)
      code_em(find(code_em(:,ober_kat)==0),ober_kat)=1; %setze pauschal alle 0 auf eins mit der Hoffnung, dass es die O-ZR sind 
   end % if
   
   fehler_detek=1; %dies schaltet für =1 Fehlerdetektion aus, d.h. es unbekannte Merkmale berücksichtigt
   if fehler_detek 
      code_em(find(code_em(:,ober_kat)==0),ober_kat)=size(kat(ober_kat,1).name,1); 
   end; %wenn hier noch Null gefunden, dann setzte auf unbekannt
   
   %zgf_em_bez anlegen
   % Wenn's nachfolgend kracht, dann sind im code_em noch 0 enthalten (als Fehlerdetektion, muss aber oben als "fehler_detek=0" aktiviert werden) 
   zahler=0; %zum Umsortieren von code_em, z.B. wenn ein Eintrag zwischendrin fehlt
   for i=findd(code_em(:,ober_kat))           %1:size(kat(ober_kat,1).name,1) %hier nochmals separat durchzählen und zwar nur durch alle vorhandenen Kategorien
      zahler=zahler+1;
      code_em(find(code_em(:,ober_kat)==i),ober_kat)=zahler;
      if ober_kat==6 
         kat(6,1).name=char('STRI','ST','SW','IC','LR','MSt','TSt','PSw','ISw','MSw','TSw'); 
      end; % Für Bezeichner
      zgf_em_bez(ober_kat,zahler).name=kat(ober_kat,1).name(i,:);
   end
   %erst hier ist code_em(:,ober_kat) fertig
   zgf_em_bez(ober_kat,1).auswahl=findd(code_em(:,ober_kat));
end %for ober_kat


fprintf('%d features could not been categorized (0 in code_em).\n',sum(code_em(:)==0));
