  function [datenOut, ret, info] = plugin_template_timeseries(paras, datenIn)
% function [datenOut, ret, info] = plugin_template_timeseries(paras, datenIn)
%
% 
% 
% 
% 
% the number of generated new time series
%
% The function plugin_template_timeseries is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:04
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
%the number of generated new single features
anz_em = 0;
%number of necessary time series
number_of_input_time_series = 1;
%short description for the new time series
short_description = 'DOUB';
%long description for the new time series
long_description  = 'Doubled values';

%BEGIN: DO NOT CHANGE THIS PART
if anz_zr>0
    plugin_type='TS';
else
    plugin_type='SF';
end;
info = struct('beschreibung',long_description , 'bezeichner',short_description, 'anz_zr', anz_zr, 'anz_em', anz_em, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', plugin_type);
info.einzug_OK = 1; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr=number_of_input_time_series;
%only for initializing call 
if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;
%END: DO NOT CHANGE THIS PART

%here, the new time series will be computed 
datenOut.dat_zr =  2 * datenIn.dat;

%return zero for a valid result
ret.ungueltig = 0;
