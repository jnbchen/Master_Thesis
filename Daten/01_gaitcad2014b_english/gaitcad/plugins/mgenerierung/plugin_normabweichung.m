  function [datenOut, ret, info] = plugin_normabweichung(paras, datenIn)
% function [datenOut, ret, info] = plugin_normabweichung(paras, datenIn)
%
% Berechnet die Abweichung zur eigenen Norm.
% Benötigt Parameter aus Oberfläche (übergeben in paras.iirfilter, paras.iirfilter_stdschaetzer)
% und die Plugins plugin_iirfilter und plugin_iirfilter_stdschaetzer
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_normabweichung is part of the MATLAB toolbox Gait-CAD. 
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

info = struct('beschreibung', 'Individual norm deviation', 'bezeichner', 'NABW', 'anz_zr', 1, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.commandline.explanation = 'computes the norm deviation  (distance to corridor with mean and standard deviation)';
info.explanation_long        = 'Here, the plugins IIR (Parameter aF) and StdTS are used for the estimation';


info.commandline.description{1} = 'Parameters aFast aSlow aSigma';
info.commandline.parameter_commandline{1} = [0.98 0.995 0.995];
info.commandline.tooltext{1} = strcat('to 0: no smoothing, to 1: strong smoothing.',' aSlow must be greater than aFast.');
info.commandline.wertebereich{1} = {0, 1};


if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

%mean value estimator needs only the first parameter and cannot handle the rest
temp_parameters_save = paras.parameter_commandline;
paras.parameter_commandline{1} = paras.parameter_commandline{1}(1);
[tempIIR, dummy] = plugin_iirfilter(paras, datenIn);
tempIIR = tempIIR.dat_zr;

% Standardabweichung über IIR-Filter schätzen:
paras.parameter_commandline = temp_parameters_save;

[tempIIRStd, dummy] = plugin_iirfilter_stdschaetzer(paras, datenIn);
tempIIRStd = tempIIRStd.dat_zr;

% Nun die Abweichung bestimmen
datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, 1);
datenOut.dat_zr = (datenIn.dat - tempIIR) ./ tempIIRStd;
% Unrealistische Werte abschneiden:
% datenOut.dat_zr = min(10, max(-10, datenOut.dat_zr));

ret.ungueltig = 0;