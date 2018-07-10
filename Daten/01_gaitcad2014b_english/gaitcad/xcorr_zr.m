  function [cxcorr, mcxcorr, zeit] = xcorr_zr(d_orgs,ta,ind1,ind2,scaling_type)
% function [cxcorr, mcxcorr, zeit] = xcorr_zr(d_orgs,ta,ind1,ind2,scaling_type)
%
%  Berechnet f�r die �bergeben Zeitreihen die Kreuz- und
%  Autokorrelationsfunktionen.
%  ta ist optionale Eingabe: Verschiebungen werden in s ausgedr�ckt
%  R�ckgaben:
%  cxcorr: Kreuzkorrelationsfunktionen. Matrix der Gr��e #ZR x #ZR x #DS x 2*Samplepunkte-1
%  mcxcorr: cxcorr �ber die dritte Dimension gemittelt.
%  zeit: Verschiebungsvektor f�r Anzeige
% 
%
% The function xcorr_zr is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

if (nargin < 2)
   ta = [];
end;

anz_zr = size(d_orgs,3);

cxcorr  = zeros(anz_zr, anz_zr, size(d_orgs,1), 2*size(d_orgs,2)-1);
mcxcorr = zeros(anz_zr, anz_zr, 2*size(d_orgs,2)-1);
for j=ind1
   for k=ind2 
      for i=1:size(d_orgs,1)
         [cxcorr(j, k, i, :), zeit] = myxcorr(squeeze(d_orgs(i, :, [j k])), 0,[], [], [], ta,scaling_type);
      end; %i
   end; %k
   % �ber die ausgew�hlten Datentupel mitteln
   mcxcorr(j,k,:) = squeeze(mean(cxcorr(j,k,:,:), 3));
end; %j

% Wenn Abtastzeit �bergeben wurde, zeit umrechnen
if ~isempty(ta)
   zeit = zeit.*ta;
end;
