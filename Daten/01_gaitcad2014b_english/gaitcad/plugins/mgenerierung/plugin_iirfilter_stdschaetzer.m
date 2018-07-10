  function [datenOut, ret, info] = plugin_iirfilter_stdschaetzer(paras, datenIn)
% function [datenOut, ret, info] = plugin_iirfilter_stdschaetzer(paras, datenIn)
%
% Schätze die Standardabweichung.
% Benötigt einige Parameter aus der Oberfläche und die Funktion
% Standardabweichung.m.
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_iirfilter_stdschaetzer is part of the MATLAB toolbox Gait-CAD. 
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
info = struct('beschreibung', 'Estimate standard deviation', 'bezeichner', 'StdTS', 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation      = 'applies different digital lowpass filters $x_f [k+1] = a * x_f [k]  + (1-a) * x [k]$ with parameters aFast, aSlow and aSigma to compute the standard deviation.';
info.explanation_long = 'see Eq. (2-6) in \cite{Reischl02} with aF = aSigma, aL = aSlow, aS = aFast.';


info.commandline.description{1} = 'Parameters aFast aSlow aSigma';
info.commandline.parameter_commandline{1} = [0.98 0.995 0.995];
info.commandline.tooltext{1} = strcat('to 0: no smoothing, to 1: strong smoothing.',' aSlow must be greater than aFast.');
info.commandline.wertebereich{1} = {0, 1};

if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

if length(paras.parameter_commandline{1})~=3
   myerror('3 parameters were expected!');
end;


% Die bisherige Implementierung von Standardabweichung.m lässt keine Matrizen als Dateneingabe zu.
% Also muss die Berechnung in einer for-Schleife gemacht werden:
datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, anz_zr);
for i = 1:size(datenOut.dat_zr,1)
	datenOut.dat_zr(i, :, 1) = Standardabweichung(squeeze(datenIn.dat(i, :))', paras.parameter_commandline{1}(1), paras.parameter_commandline{1}(2), 1/paras.abtastfrequenz, paras.parameter_commandline{1}(3), 0);
end;

ret.ungueltig = 0;