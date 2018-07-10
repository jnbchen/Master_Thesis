  function  [zgf,anz_term]=fuzmedian(values,anz_fuzzy,type)
% function  [zgf,anz_term]=fuzmedian(values,anz_fuzzy,type)
%
% berechnet automatisch anz_fuzzy ZGF-Stützpunkte für Werte in value
% wenn weniger Werte als anz_fuzzy, werden diese beibehalten (Annahme: kategorische Werte), anz_term dann entsprechend verringert
% default: function zgf=fuzmedian(values,anz_fuzzy,2)
% type schaltet Variante:
% Variante 1: in allen Einzugsbereichen gleich, alle unterschiedlichen Werte im Datensatz raussuchen
% Variante 2: Minimum, Maximum, dazwischen in allen Bereichen gleich, alle unterschiedlichen Werte im Datensatz raussuchen
% Variante 3: Minimum, Maximum, dazwischen in allen Bereichen gleich mit allen sortierten Werten
% Variante 4: wie Type 2, aber mit gerundeten Werten, wenn mehr Werte als anz_fuzzy vorkommen
% 
%
% The function fuzmedian is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<3) 
   type=2;
end;
if (type~=1)&&(type~=2)&&(type~=3)&&(type~=4) 
   type=2;
end;

zgf=zeros(1,anz_fuzzy);

%Variante 1: in allen Einzugsbereichen gleich, alle unterschiedlichen Werte im Datensatz raussuchen
if (type==1) 
   values=findd(values);
   indkrit=(findd(round([1:anz_fuzzy]*length(values)/(anz_fuzzy+1))));
end;

%Variante 2: Minimum, Maximum, dazwischen in allen Bereichen gleich, alle unterschiedlichen Werte im Datensatz raussuchen
if (type==2)||(type==4) 
   values=findd(values);
   indkrit=findd(min(length(values),max(1,[1 round([1:anz_fuzzy-2]*length(values)/(anz_fuzzy-1)) length(values)])));
end;

%Variante 3: Minimum, Maximum, dazwischen in allen Bereichen gleich mit allen sortierten Werten
if (type==3) 
   values=sort(values);
   indkrit=findd(min(length(values),max(1,[1 round([1:anz_fuzzy-2]*length(values)/(anz_fuzzy-1)) length(values)])));
end;

%immer: ind_krit<=anz_fuzzy Terme reinschreiben
zgf(1:length(indkrit))=values(indkrit);
anz_term=length(indkrit);

%Variante 4: wie Type 2, aber mit gerundeten Werten, wenn mehr Werte als anz_fuzzy vorkommen
if (type==4)&&(anz_term>=anz_fuzzy)
   zgf=fuzround(zgf);
end;   


%wenn letzter ZGF-Wert kleiner Null, gibt es Probleme beim ZGF-Test
%Lösung: alle Werte dahinter werden auf letzten Wert-1 gesetzt
if (max(values(indkrit)<0)) 
   ind=length(indkrit)+1:anz_fuzzy;
   if ~isempty(ind) 
      zgf(ind)=(values(length(indkrit))-1)*ones(1,length(ind));
   end;
end;
