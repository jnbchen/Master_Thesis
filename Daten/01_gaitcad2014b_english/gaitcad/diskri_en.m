  function [phi_dis, phi_last, phi_dis_n, phi_last_n, phi_text, d, d_dis] = diskri_en(d_org, code, ind_auswahl, merk_diskri, merkmal_auswahl, par, hndl1,option_bestldf)
% function [phi_dis, phi_last, phi_dis_n, phi_last_n, phi_text, d, d_dis] = diskri_en(d_org, code, ind_auswahl, merk_diskri, merkmal_auswahl, par, hndl1,option_bestldf)
%
%  sucht Linearkombinationen der merkmal_auswahl Merkmale, die ein gutes Diskriminanzvermögen
%  aufweisen. Die Koeffizienten sind in phi_dis enthalten, d enthält die linear kombinierten
%  Merkmale, phi_text einen Erklärtungstext.
% 
%  d_org:         Datensatz (n Beispiele, s Merkmale)
%  code:          Klassenzugehörigkeiten für d_org
%  ind_auswahl: zu betrachtende Datentupel
%  merk_diskri:   Skalar der Anzahl der zu suchenden Linearkombinationen
%  berechnen: 1: Analyse durchführen, 0: Analyse anwenden
%  par:           Parametervektor aus KAFKA
%  merkmal_auswahl: Vektor zu verwendender Merkmale
%  hndl1:         Handle für Ausgabefeld: Anzahl Linearkombinationen
%  option_bestldf:     Nachoptimieren mit bestldf...
% 
%
% The function diskri_en is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


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

if nargin < 8
   option_bestldf=0;
end;
if nargin < 7
   hndl1=[];
end;
if nargin < 6
   par(2)=size(d_org,2);
end;
if nargin < 5
   merkmal_auswahl=[];
end;

if ~isempty(merkmal_auswahl)
   merkmal_auswahl_ind=merkmal_auswahl; 	% Wenn Merkmalsauswahl vorgegeben
else merkmal_auswahl_ind=1:par(2); 											% sonst verwende alle
end;

%Begrenzung der Diskriminanzwerte auf Anzahl der Merkmale
if (merk_diskri>length(merkmal_auswahl_ind))
   merk_diskri=length(merkmal_auswahl_ind);
   if ~isempty(hndl1)
      warning('Not that much features!');
      set(hndl1,'string',sprintf('%d',merk_diskri));
   end;
end;

%Diskriminanz benötigt Kovarianzmatrizen der Klassen, liefert Klassifikator-Entwurf
[tmp,tmp,s_dis,tmp,tmp]=klf_en6(d_org(ind_auswahl,merkmal_auswahl_ind),code(ind_auswahl));

%Diskriminanzanalyse
[d_dis,phi_dism,davpm]=merk_opt1(d_org(ind_auswahl,merkmal_auswahl_ind),s_dis,merk_diskri,code(ind_auswahl));

%OPTION:
if (option_bestldf)
   phi_dism=optimierte_diskriminanz(phi_dism',d_org(ind_auswahl,merkmal_auswahl_ind),code(ind_auswahl))';
end;

phi_dis=zeros(size(d_org,2),size(phi_dism,1));
phi_dis(merkmal_auswahl_ind,:)=phi_dism';

%Normierte Fassung, die unterschiedliche Varianzen korrigiert
%nur zur Anzeige, nicht zur Berechnung!!!
phi_dis_n=diag(std(d_org))*phi_dis;

%Anwendung
[d, phi_last, phi_text, phi_last_n,d_dis] = diskri_an(d_org, merk_diskri,phi_dis,phi_dis_n,option_bestldf);
