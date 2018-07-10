  function [mneu,wspruch]=dempster(m1,m2)
% function [mneu,wspruch]=dempster(m1,m2)
%
% Diese Funktion berechnet nach Dempsters- Rule of Combination die Massefunktion mneu aus den beiden massefunktionen m1 und m2
% m1 und m2 muessen Spaltenvekoren sein. Die Summe über die Spaltenvektoren muss 1 Betragen.
% Beispiel: [mneu,wspruch]=dempster(dempster([0;0.6;0.4],[0.7;0;0.3]),[0.3;0.4;0.3])
%
% The function dempster is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Sebastian Beck, Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

anz_pot=size(m1,1);
anz_klass=log2(anz_pot+1);

if size(m1,1)~=size(m2,1) 
   myerror('Incompatible mass function format'); 
end;
if size(m1,2)~=size(m2,2) 
   myerror('Incompatible mass function format'); 
end;
if mod(log2(anz_pot+1),1)~=0  
   myerror('Incomplete mass functions'); 
end;
if (abs(sum(m1)-1)>1E-7)||(abs(sum(m2)-1)>1E-7)
   myerror('Sum for mass function not 1'); 
end;

mneu=zeros(size(m1)); % Initialisierung kombinierte Evidenz 

wspruch=zeros(1,size(m1,2));        % Fläche der Widersprüchlichen Informationen    % Initalisieren zu kombinierenden Eviden

for i=1:anz_pot % Schleife über alle möglichen Kombinationen der Fokalen Elemente Evidenz m1
   for k=1:anz_pot % Schleife über alle möglichen Kombinationen der Fokalen Elemente Evidenz m2
      deck=intersect(find(dec2bin(i,anz_klass)==49),find(dec2bin(k,anz_klass)==49));    % Bestimmung der Schnittmenge für Konflikte
      % in deck stehen die Stellen (binär) in denen sich die Evidenzen überlappen: z.n A kombiniert mit A oder B ...
      if isempty(deck) 
         wspruch=wspruch+m1(i,:).*m2(k,:); % Wenn keine Schnittmenge, dann Konflikt / Aufsummieren der Konflikte
      else
         zeile=0; 
         for j=1:size(deck,2) 
            zeile=zeile+2^(anz_klass-deck(j)); 
         end; % Bestimmung der Zeile für das Ergebnis aus der Dualzahl 
         mneu(zeile,:)=mneu(zeile,:)+m1(i,:).*m2(k,:); % Eigentliche Rechnung
      end;
   end;
end;
mneu=mneu./(ones(anz_pot,1)*(1-wspruch+1E-250)); % Dempsters Rule
