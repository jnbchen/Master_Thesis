  function [datenOut, ret, info] = plugin_timeseries_region(paras, datenIn)
% function [datenOut, ret, info] = plugin_timeseries_region(paras, datenIn)
%
% 
% 
%
% The function plugin_timeseries_region is part of the MATLAB toolbox Gait-CAD. 
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

info = struct('beschreibung', 'Value in region', 'bezeichner', 'REGION', 'anz_zr', 1, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;
info.anz_benoetigt_em = 0;
info.anz_im = 0;
info.anz_benoetigt_im = 0;
info.callback = '';

info.explanation = 'set all values in a region of a time series to 1 and all other to 0.';

info.commandline.description{1} = 'Lower threshold';
info.commandline.parameter_commandline{1} = 0;
info.commandline.tooltext{1} = 'Lower threshold for the binarization of the time series';

info.commandline.description{2} = 'Upper threshold';
info.commandline.parameter_commandline{2} = 1;
info.commandline.tooltext{2} = 'Upper threshold for the binarization of the time series';

if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

datenOut.dat_zr = ( datenIn.dat > paras.parameter_commandline{1} ) & ( datenIn.dat < paras.parameter_commandline{2} );  % Coderevision: &/| checked!
ret.bezeichner = [info.bezeichner sprintf(' in [%g,%g]',paras.parameter_commandline{1},paras.parameter_commandline{2})];
ret.ungueltig = 0;
