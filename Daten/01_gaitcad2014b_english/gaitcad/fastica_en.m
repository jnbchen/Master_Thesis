  function [phi_ica, phi_last, phi_ica_n, phi_last_n, phi_text, d, d_ica] = fastica_en(d_org, ind_auswahl, merk_diskri, hk_anzahl, merkmal_auswahl, par, var_norm)
% function [phi_ica, phi_last, phi_ica_n, phi_last_n, phi_text, d, d_ica] = fastica_en(d_org, ind_auswahl, merk_diskri, hk_anzahl, merkmal_auswahl, par, var_norm)
%
% 
%  [phi_ica, phi_last, phi_ica_n, phi_last_n, phi_text, d, d_ica] = fastica_en(d_org, ind_auswahl, merk_diskri, hk_anzahl, merkmal_auswahl, par, var_norm)
%  [phi_ica, phi_last, phi_ica_n, phi_last_n, phi_text, d, d_ica] = fastica_en(d_org, ind_auswahl, 2, 5, merkmal_auswahl, par, 0)
% 
%  Entwirft den Transformationsvektor für eine Independent Component Analysis
% 
%  d_org:             Datenmatrix
%  ind_auswahl:   Ausgewählte Elemente
%  merkmal_auswahl:Anzahl ausgewählter Merkmale
%  merk_diskri:       Anzahl der Independent Komponenten
%  hk_anzahl:     Anzahl zu verwendender Hauptkomponenten
%  var_norm:      Binär: Sollen Varianzen normiert werden
% 
%
% The function fastica_en is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(merkmal_auswahl)
   if isempty(merkmal_auswahl) 
      error ('No features selected!');
   end;
   merkmal_auswahl_ind=merkmal_auswahl; 
else 
   merkmal_auswahl_ind=1:par(2);
end;

%Begrenzung der Diskriminanzwerte auf Anzahl der Merkmale
if (merk_diskri>length(merkmal_auswahl_ind)) 
   merk_diskri=length(merkmal_auswahl_ind);
   warning('Not that much features!');
end;

if (hk_anzahl>length(merkmal_auswahl_ind)) 
   hk_anzahl=length(merkmal_auswahl_ind);
   warning('Not that much features!');
end;

fprintf('Independent Component Analysis \n(FastICA for Matlab 5.x, Version 2.1, \nCopyright (c) Hugo Gävert, Jarmo Hurri, Jaakko Särelä, and Aapo Hyvärinen\n');
fprintf('Number of eigenvalues (as for PCA): %d, Number of features for  ICA: %d\n ',hk_anzahl,merk_diskri);                    

%Startschätzung HKA
init_guess=hauptk_ber(d_org(ind_auswahl,merkmal_auswahl_ind),var_norm);
[d_ica,tmp,phi_icam]=fastica(d_org(ind_auswahl,merkmal_auswahl_ind)','lastEig',hk_anzahl,'numOfIC',merk_diskri,'displayMode','off','initGuess',init_guess);
d_ica=d_ica';
phi_ica=zeros(size(d_org,2),size(phi_icam,1));
phi_ica(merkmal_auswahl_ind,:)=phi_icam';
clear tmp phi_icam merkmal_auswahl_ind init_guess;

% Normierung, so dass der Betrag des größten Elements = 1 ist.
tmp=find(abs(phi_ica(:))==max(abs(phi_ica(:)))); phi_ica=phi_ica./phi_ica(tmp)*((phi_ica(tmp)>0)-0.5).*2;

%Berechnung nur möglich, wenn Eigenvektoren zum Datenmaterial passen und
%mindestens soviele Eigenvektoren wie geforderte Merkmale zur Verfügung stehen
if (size(d_org,2)==size(phi_ica,1)) && (size(phi_ica,2)>=merk_diskri) 
   d_ica=d_org*phi_ica(:,1:merk_diskri);
else 
   myerror('Incompatible format data eigenvectors for ICA!\n');
end; 	 	 	

%Aktuelle Daten aus Diskriminanz
d=d_ica;

%Letzte Transformation
phi_last=phi_ica(:,1:merk_diskri);
phi_text=sprintf('ICA from  %d to  %d aggregated feature',size(phi_ica,1),merk_diskri);

%Normierte Fassung, die unterschiedliche Varianzen korrigiert
%nur zur Anzeige, nicht zur Berechnung!!!
phi_ica_n=diag(std(d_org))*phi_ica;

%und wieder Betrag des Vektors 1 erzwingen
phi_ica_n=phi_ica_n./(ones(size(phi_ica_n,1),1)*sqrt(sum(phi_ica_n.^2)));
phi_last_n=phi_ica_n;