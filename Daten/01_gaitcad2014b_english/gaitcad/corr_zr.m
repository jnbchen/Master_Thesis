  function [czr, mczr] = corr_zr(d_orgs, tau, statistikoptionen)
% function [czr, mczr] = corr_zr(d_orgs, tau, statistikoptionen)
%
% Berechnet die paarweisen Korrelationskoeffizienten aller übergebenen
% Zeitreihen und der übergebenen Datentupel.
% tau gibt die Verschiebung an
% Rückgabe:
% czr: Matrix der Größe #ZR x #ZR x #DS mit den Korrelationskoeffizienten (obere Dreiecksmatrix)
% mczr: Matrix der Größe #ZR x #ZR mit den gemittelten Korrelationskoeffizienten
%
% The function corr_zr is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<3)
    statistikoptionen = [];
end;
if ~isempty(statistikoptionen)
    corr_type = statistikoptionen.type_liste{statistikoptionen.corr_type};
else
    corr_type = 'Spearman';
end;

anz_zr = size(d_orgs,3);
ind_auswahl = [1:size(d_orgs,1)];
if (size(ind_auswahl,2) == 1)
    ind_auswahl = ind_auswahl';
end;

czr = zeros(anz_zr, anz_zr, length(ind_auswahl));
for j=1:anz_zr
    fprintf('%d of %d\n',j,anz_zr);
    for k=j:anz_zr
        for i=ind_auswahl
            if (tau < 0)
                jmod=k;
                kmod=j;
            else
                jmod=j;
                kmod=k;
            end;
            temp = mycorrcoef([squeeze(d_orgs(i, 1:end-abs(tau), jmod))' squeeze(d_orgs(i, 1+abs(tau):end, kmod))'],corr_type);
            czr(j, k, i) = temp(1,2);
            czr(k, j, i) = temp(1,2);
        end; %i
        %fprintf('%g-%s \t - %g-%s \t Korr: %f\n',ind_zr(j),deblank(var_bez(ind_zr(j),:)),ind_zr(k),deblank(var_bez(ind_zr(k),:)),mean(czr(ind_zr(j),ind_zr(k),:)) )
    end; %k
end; %j

% Über die ausgewählten Datentupel mitteln
mczr = mean(czr, 3);
