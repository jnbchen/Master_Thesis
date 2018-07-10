  function [datenOut, ret, info] = plugin_normzeitreihe_abs(paras, datenIn)
% function [datenOut, ret, info] = plugin_normzeitreihe_abs(paras, datenIn)
%
% 
% 
% 
%
% The function plugin_normzeitreihe_abs is part of the MATLAB toolbox Gait-CAD. 
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

anz_zr = 1;
info = struct('beschreibung', 'Norm deviation time series absolute value', 'bezeichner', 'NDTS ABS', 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation      = 'computes the absolute value of the norm deviation as time series.';
info.explanation_long = '(Eq. (3) in \cite{Wolf06})';


if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;
if (~isfield(datenIn, 'ref') || isempty(datenIn.ref))
   warning('No normative data found. Remove single feature!');
   datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, anz_zr);
   ret.ungueltig = 1;
else
   j = paras.ind_zr_merkmal;
   [masz_betr,masz_richt,masz_betr0,masz_richt0,masz] = normmasz (datenIn.dat, squeeze(datenIn.ref.my(1,:,j)), squeeze(datenIn.ref.mstd(1,:,j)) ,1); 
   % Lege Speicher für die neuen Zeitreihen an
   datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, anz_zr);
   datenOut.dat_zr(:,:,1)=abs(masz);
   ret.ungueltig = 0;
end;