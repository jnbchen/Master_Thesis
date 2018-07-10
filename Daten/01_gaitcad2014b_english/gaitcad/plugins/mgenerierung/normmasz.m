  function [masz_betr,masz_richt,masz_betr0,masz_richt0,masz_zr,vorz,vorz0]=normmasz(d_orgs_auswahl,my,mstd,n)
% function [masz_betr,masz_richt,masz_betr0,masz_richt0,masz_zr,vorz,vorz0]=normmasz(d_orgs_auswahl,my,mstd,n)
%
%  Berechnet Maß für Abstand von d_orgs zu Normkurven
%  (beschrieben durch Strukt ref, mit ref.my=Mittelwert, ref.mstd=Standardabw.)
% 
%  masz_betr    =   summiert Betrag aller Abstandsmaße über Abtastzeitpunkte (der Zeitreihe) auf
%  masz_richt   =   summiert alle Abstandsmaße über Abtastzeitpunkte (der Zeitreihe) auf
%  Bewertung nur der Werte der Zeitreihe d_orgs, die aus dem Normkorridor (der Strand.abw.) hinausgehen
%  masz_betr0   =   Summe aller Beträge
%  mas_richt0   =   Summe über Werte
%  vorz         =   Berechnet Patientenkurve ober/unterhalb von NormMITTELWERT
%  vorz0        =   Berechnet Patientenkurve ober/unterhalb von NormKORRIDOR, im Korridor=0
% 
%
% The function normmasz is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

if (nargin>4) 
   mstd=n*mstd;
end;

if size(my,1)~=1 
   my=my';
end;     %my muss in einer (1,anz_samples) vorliegen
if size(mstd,1)~=1 
   mstd=mstd';
end;

%Mittelwerte berechnen und durch n*Standardabweichungen teilen
masz=( d_orgs_auswahl-ones(size(d_orgs_auswahl,1),1)*my ) ./ ( ones(size(d_orgs_auswahl,1),1)* mstd);
indnan=find(isnan(masz));
masz(indnan)=zeros(size(indnan));
masz_zr=masz;

masz_richt=sum(masz')/size(d_orgs_auswahl,2);
masz_betr=sum(abs(masz)')/size(d_orgs_auswahl,2);
vorz=sum(sign(masz'))/size(d_orgs_auswahl,2);

%für Bewertung nur der Werte der Zeitreihe d_orgs, die aus dem Normkorridor (der Strand.abw.) hinausgehen
ind=find(abs(masz)<1);masz(ind)=zeros(size(ind));
ind=find(masz>=1);    masz(ind)=masz(ind)-1;
ind=find(masz<=-1);   masz(ind)=masz(ind)+1;
masz_richt0=sum(masz')/size(d_orgs_auswahl,2);
masz_betr0=sum(abs(masz)')/size(d_orgs_auswahl,2);
vorz0=sum(sign(masz'))/size(d_orgs_auswahl,2);
