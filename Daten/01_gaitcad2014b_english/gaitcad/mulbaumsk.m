  function [rulebase,merk,merkmal_auswahl,verfahren,texprot]=mulbaumsk(d_quali,code,par,baumtyp,merk_red,log_red_mode,nur_wurzel,interpret_merk,weights,L,type_nullregeln,anzeige,parameter_regelsuche)
% function [rulebase,merk,merkmal_auswahl,verfahren,texprot]=mulbaumsk(d_quali,code,par,baumtyp,merk_red,log_red_mode,nur_wurzel,interpret_merk,weights,L,type_nullregeln,anzeige,parameter_regelsuche)
%
% Es wird ein Standardbaum  und für jede Klasse ein Spezialbaum erzeigt
% Ziel: Erzeugung redundanter Regeln zur Schaffung von Auswahl bei der
% Suche nach Regelbasen rulebase, Elemente einer Breitensuche
% ACHTUNG! Option nur_wurzel wird derzeit nicht ausgewertet!!
% 
% keine Wichtungen?
%
% The function mulbaumsk is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<9)
   weights=[];
end;

%keine Entscheidungstheorie?
if (nargin<10)
   L=[];
   L_2_2=[];
end;

%kein typ_nullregeln?
if (nargin<11)
   type_nullregeln=0;
end;

%keine Anzeige-Parameter?
if (nargin<12)
   anzeige=1;
end;

%keine Anzeige-Parameter?
if (nargin<13)
   parameter_regelsuche=[];
end;


%ACHTUNG !!!
% L für KLASSENSPEZIFISCHE BÄUME???

%Heuristische Merkmalsguete initialisieren
%1. Zeile: Anzahl der Aktualisierungen
%2. Zeile: durchschnittlicher Wert
merk_stat=zeros(2,par(2));

%Standardbaum
[rulebaum,merk_stat,texprot(1),tmp,absich]=genbaum(d_quali,code,par,1,baumtyp,merk_stat,0,interpret_merk,weights,L,anzeige,parameter_regelsuche);
rulebase=translab(rulebaum,par,absich,type_nullregeln,anzeige);
par_temp=par;
par_temp(4)=2;

for i=findd(code)
   %ACHTUNG !!!
   % L für KLASSENSPEZIFISCHE BÄUME???
   if ~isempty(L)
      L_2_2=L;
      %2-2 Matrix, aber
      L2_2.ld=[0 mean(L.ld([1:i-1 i+1:par(4)],i)); mean(L.ld(i,[1:i-1 i+1:par(4)])) 0];
   end;
   
   %Baum zur Unterscheidung i-te Ausgangsklasse und alle anderen Ausgangsklassen
   %generieren, baumtyp gibt ID3 (3) bzw. C4.5 (4) vor
   [rulebaum,merk_stat,texprot(i+1),tmp,absich]=genbaum(d_quali,1+(code==i),par_temp,1,baumtyp,merk_stat,0,interpret_merk,weights,L_2_2,anzeige,parameter_regelsuche);
   
   %kein leerer Baum
   if (rulebaum(1,3)~=0)
      tmp=translab(rulebaum,par_temp,absich,type_nullregeln,anzeige);
      %richtige Klasse ?
      ind=find(tmp(:,4)==2);
      if ~isempty(ind)
         tmp(ind,4)=i*ones(length(ind),1);
         rulebase=[rulebase;tmp(ind,:)];
      end;
   end;
   
   %Heuristische Merkmalsguete für Anzeigezwecke sparieren
   merk=merk_stat(2,:)';
   
   verfahren=[];
   if baumtyp==1  
      verfahren=sprintf('Theoretical measure of information in\nclass specific ID3-multi-tree (without statistical estimate)\n');
   end;
   if baumtyp==2  
      verfahren=sprintf('Theoretical measure of information in\nclass specific C4.5-multi-tree (without statistical estimate)\n');
   end;
   if baumtyp==3  
      verfahren=sprintf('Theoretical measure of information in\nclass specific ID3-multi-tree (including statistical estimate)\n');
   end;
   if baumtyp==4  
      verfahren=sprintf('Theoretical measure of information in\nclass specific C4.5-multi-tree (including statistical estimate)\n');
   end;
   if baumtyp==5  
      verfahren=sprintf('Theoretical measure of information in\nclass specific decision-theory multi-tree\n');
   end;
end;


%redundante Regeln löschen - nur bei Multibaum sinnvoll!
if (log_red_mode) 
   rulebase=logred(rulebase,par);
end;

%wichtigste Merkmale raussortieren
[tmp,ind_merk]=sort(-merk);
merkmal_auswahl=ind_merk(1:merk_red)';

