  function [rulebase,merk,merkmal_auswahl,verfahren,texprot,merk_archiv]=mulbaum(d_quali,code,par,baumtyp,anz_baum,merk_red,log_red_mode,nur_wurzel,interpret_merk,weights,L,type_nullregeln,anzeige,parameter_regelsuche)
% function [rulebase,merk,merkmal_auswahl,verfahren,texprot,merk_archiv]=mulbaum(d_quali,code,par,baumtyp,anz_baum,merk_red,log_red_mode,nur_wurzel,interpret_merk,weights,L,type_nullregeln,anzeige,parameter_regelsuche)
%
% Es wird ein Multibaum mit anz_baum Bäumen erzeugt
% nur Wurzelknoten gefragt?
%
% The function mulbaum is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<8) 
   nur_wurzel=0;
end;

%keine Wichtungen?
if (nargin<10) 
   weights=[];
end;

%keine Entscheidungstheorie?
if (nargin<11) 
   L=[];
end;

%kein typ_nullregeln?
if (nargin<12) 
   type_nullregeln=0;
end;

%keine Anzeige-Parameter?
if (nargin<13) 
   anzeige=1;
end;

%keine Parameter?
if (nargin<14) 
   parameter_regelsuche=[];
end;


%Anzahl der Bäume, die erstellt werden sollen, jeweils startend 
%mit der i-ten (i=1,..., anz_baum) besten Variable  
%Ziel: Erzeugung redundanter Regeln zur Schaffung von Auswahl bei der 
%Suche nach Regelbasen, Elemente einer Breitensuche
rulebase=[];

%Heuristische Merkmalsguete initialisieren
%1. Zeile: Anzahl der Aktualisierungen
%2. Zeile: durchschnittlicher Wert
merk_stat=zeros(2,par(2));

for i=1:min(anz_baum,par(2))
   %Baum generieren, baumtyp gibt ID3 (3) bzw. C4.5 (4) vor
   [rulebaum,merk_stat,texprot(i),merk_wurzel_tmp,absich]=genbaum(d_quali,code,par,1,baumtyp,merk_stat,0,interpret_merk,weights,L,anzeige,parameter_regelsuche);
   %nur bei 1. Baum Wurzel übernehmen!
   if (i==1) 
      merk_wurzel=merk_wurzel_tmp;
   end;
   
   %leerer Baum
   if (rulebaum(1,3)==0) 
      fprintf('Only %d multi trees, because %d-th tree contained only root nodes.\n',i-1,i);
      anz_baum=i-1;
      break;
   end;
   
   %Trick: beste Variable des vorherigen Baums wird temporär 
   %auf Einheitsklasse 1 gesetzt und so für den Baum unattraktiv
   d_quali(:,rulebaum(1,3))=ones(size(d_quali,1),1);
   rulebase=[rulebase;translab(rulebaum,par,absich,type_nullregeln,anzeige)];
end;


verfahren=[];
if baumtyp==1  
   verfahren=sprintf('Theoretical measure of information in\nID3-multi-tree (without statistical estimate) with %d trees\n',anz_baum);
end;
if baumtyp==2  
   verfahren=sprintf('Theoretical measure of information in\nC4.5-multi-tree (without statistical estimate) with %d trees\n',anz_baum);
end;
if baumtyp==3  
   verfahren=sprintf('Theoretical measure of information in\nID3-multi-tree (including statistical estimate) with %d trees\n',anz_baum);
end;
if baumtyp==4  
   verfahren=sprintf('Theoretical measure of information in\nC4.5-multi-tree (including statistical estimate) with %d trees\n',anz_baum);
end;
if baumtyp==5  
   verfahren=sprintf('Information measure from\nmultiple decision with %d trees\n',anz_baum);
end;

%Heuristische Merkmalsguete für Anzeigezwecke sparieren
if (~nur_wurzel) 
   merk=merk_stat(2,:)';
else          
   merk=merk_wurzel(2,:)';   
   verfahren=sprintf('%s (only root nodes)',verfahren);  
end;


%redundante Regeln löschen - nur bei Multibaum sinnvoll!        
if (log_red_mode) 
   rulebase=logred(rulebase,par);
end;

%wichtigste Merkmale raussortieren
[tmp,ind_merk]=sort(-merk);
merkmal_auswahl=ind_merk(1:merk_red)';

%Werte archivieren...
merk_archiv.guete(1,:)=merk;
merk_archiv.guete(merk_archiv.guete==0)=NaN;
merk_archiv.merkmal_auswahl=merkmal_auswahl;
merk_archiv.texprot = texprot;
merk_archiv.verfahren=verfahren;
merk_archiv=repair_merk_archiv(merk_archiv);
