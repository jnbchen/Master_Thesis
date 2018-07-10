  function [datenOut, ret, info] = plugin_normzahl_betrag(paras, datenIn)
% function [datenOut, ret, info] = plugin_normzahl_betrag(paras, datenIn)
%
% Berechne die Beschleunigungszeitreihen
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_normzahl_betrag is part of the MATLAB toolbox Gait-CAD. 
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

info = struct('beschreibung', 'Norm deviation (absolute value)', 'bezeichner', 'ND Abs', 'anz_zr',0, 'anz_em', 1, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'SF');
info.einzug_OK = 1; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation      = 'computes the mean absolute norm deviation of a time series in a segment as single feature';
info.explanation_long = '(mean value of  Eq. (3) in \cite{Wolf06} for a segment)';

if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

if (~isfield(datenIn, 'ref') || isempty(datenIn.ref))
   warning('No normative data found. Remove single feature!');
   datenOut.dat_em = zeros(paras.par.anz_dat, 1);
   ret.ungueltig = 1;
else
   j = paras.ind_zr_merkmal;
	[masz_betr,masz_richt,masz_betr0,masz_richt0,masz,vorz,vorz0] = normmasz (datenIn.dat, squeeze(datenIn.ref.my(1,paras.einzuege(1,1):paras.einzuege(1,2),j)), squeeze(datenIn.ref.mstd(1,paras.einzuege(1,1):paras.einzuege(1,2),j)) ,1);
	datenOut.dat_em = masz_betr';
	ret.ungueltig = 0;
end;

