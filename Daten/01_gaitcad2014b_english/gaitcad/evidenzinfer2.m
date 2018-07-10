  function [pos,mu_y_dempster,w_dempster]=evidenzinfer2(konklusion,par,glaub_roh,default)
% function [pos,mu_y_dempster,w_dempster]=evidenzinfer2(konklusion,par,glaub_roh,default)
%
% Berechnet Inferenz nach "dempsters rule of combination"
% Default: Defaultregel in Regelbasis? Wenn nicht von Extern gesetzt dann nicht (Default Wert = 0).
% Anzeige: Default_Wert=1 -> Anzeige ist aktiviert. Wenn extern auf 0 dann Anzeige aus.
%
% The function evidenzinfer2 is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Sebastian Beck, Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


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

if (nargin<4) 
   default=0;
end;

pos=zeros(size(glaub_roh,2),1);

%----------------------------------------------------------------------------------------------------------
% 1. Schritt : Initialisierung
%----------------------------------------------------------------------------------------------------------

doubt_max=0.5; % z.B. 0.33
w_max=0.5; %z.b. 0.5
m=zeros(2^par(4)-1,size(glaub_roh,2)); % Feld mit den Gewichtsfunktionen für alle Beispiele
m(2^par(4)-1,:)=ones(1,size(glaub_roh,2)); % Startwerte: Völlige Unwissenheit über alle Datentupel

%----------------------------------------------------------------------------------------------------------
% 2. Schritt : Berechnung über Dempster´s Rule of Combination
%----------------------------------------------------------------------------------------------------------
w=zeros(size(1,size(glaub_roh,2))); 	% Initialisierung des Feldes für die Widerspruchinformation
if (default) 
   anz_rule=size(konklusion,1)-1;
else 
   anz_rule=size(konklusion,1);
end;

for j=1:anz_rule % Sonst Regel wird nicht berücksichtigt, da hier keine "aktive" Information vorliegt.
   w_alt=w; 				% Initialisieren des Wiederspruchsfeldes
   mneu=zeros(2^par(4)-1,size(glaub_roh,2));
   mneu(2^(konklusion(j)-1),:)=glaub_roh(j,:)*0.99999999;
   mneu(2^par(4)-1,:)=1-mneu(2^(konklusion(j)-1),:);
   [m,w]=dempster(m,mneu);
   m(2^par(4)-1,find(w==1))=1; % Bei vollem Widerspruch wird auf volle ungewissheit zurückgesetzt. 
   w=max(w,w_alt);		% Speicher für den Maximal aufgetretenen Widerspruch zwischen zwei, Evidenzen
end;

%-----------------------------------------------------------------------------------------------------------------------------------
%3. Schritt Berechnung der Inferenz a) Über Kern der Massefunktion
%-----------------------------------------------------------------------------------------------------------------------------------   

ent=(2^par(4)-1)*ones(1,size(glaub_roh,2)); % zunächst Entscheidung für alle Elemente auf 'all classes'
core=zeros(1,size(glaub_roh,2)); 			  % Initialisieren von core auf Null
for j=1:par(4) 
   core=core+m(2^(j-1),:); 
end;	% Addieren der Masse, die Fokalen Elementen zugeordnet ist.
doubt=1-core;	
for j=1:par(4)
   verhaeltnis=m(2^(j-1),:)./(core+1E-250);
   ent(find((doubt<doubt_max)&(w<w_max)&(verhaeltnis>0.5)))=2^(j-1);  % Coderevision: &/| checked!
end;

%-----------------------------------------------------------------------------------------------------------------------------------
%3. Schritt Berechnung der Inferenz b) Über Plausibilitätsfunktion
%-----------------------------------------------------------------------------------------------------------------------------------
ent2=(2^par(4)-1)*ones(1,size(glaub_roh,2));
comb=dec2bin([1:1:2^par(4)-1],par(4))==49; 	%Berechnung der kombinationsmatrix. In den Zeilen stehen die Elemente der Potenzmenge, 
%in den Spalten steht eine 1, wenn die Masse für die Plausibiltätsfunktion mitgezählt werden muss. 
pl=comb'*m;												% Berechnung der Plausibilitätsfunktion 

[wert,index]=max(pl); % Bestimmung der Maxima der pl -Funktion. 
index=par(4)-(index-1);	% Index Umdrehen wegen Reihenfolge der bin-Zahlen
ent2(find((doubt<doubt_max)&(w<w_max)))=2.^(index(find((doubt<doubt_max)&(w<w_max)))-1); % Direkte Klassenzuordnung, wenn doubt< wert und widerspruch kleiner w_max % Coderevision: &/| checked!
doubt_pos=find(sum(comb,2)>1); % Index der Kombinationen aus Klassen z.b a oder b an stelle 3.
[tmp,index]=max(m(doubt_pos,find(doubt>=doubt_max)),[],1); % Bestimmung der Kombination mit der Größten Masse
ent2(find(doubt>=doubt_max))=doubt_pos(index); % Entscheidung schreiben

%-----------------------------------------------------------------------------------------------------------------------------------
%4. Sortierung und Schritt Berechnung der Fehlklassifikationen
%-----------------------------------------------------------------------------------------------------------------------------------

%ACHTUNG! Klassen-Nummerierung in ent stimmt nicht mit Nummerierung in pos überein!!!
ent=ent';
ind_sort=[];
for i=1:par(4)
   ind_sort_neu=find(ent==2^(i-1));
   pos(ind_sort_neu)=i; % Direkte Klassenzuordnung wird vorgezogen
   ind_sort=[ind_sort;ind_sort_neu];
end;
rest=setdiff([1:size(glaub_roh,2)]',ind_sort);
pos(rest)=par(4)-ceil(log2(ent(rest)+1))+ent(rest);

mu_y_dempster=m; 	% Unsicherheiten übergeben;
w_dempster=w;   	% Widersprüche übergeben;





