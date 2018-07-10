  function [datenOut, ret, info] = plugin_iirfilter(paras, datenIn)
% function [datenOut, ret, info] = plugin_iirfilter(paras, datenIn)
%
% Berechnet eine IIR gefilterte Zeitreihe.
% Benötigt Parameter aus Oberfläche (übergeben in paras.iirfilter) und die Funktion
% iirFilter.m
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_iirfilter is part of the MATLAB toolbox Gait-CAD. 
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
info = struct('beschreibung', 'IIR filter', 'bezeichner', 'IIR', 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation      = strcat('applies a digital lowpass filter $x_f [k+1] = a * x_f [k]  + (1-a) * x [k]$.');

info.commandline.description{1} = 'Parameter a';
info.commandline.parameter_commandline{1} = [0.98];
info.commandline.tooltext{1} = 'to 0: no smoothing, to 1: strong smoothing';
info.commandline.wertebereich{1} = {0, 1};

if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;


% ACHTUNG: iirFilter verwendet die normale filter-Funktion. Die arbeitet
% Spaltenweise bei Matrizen. Diese Matrix enthält in den Spalten aber die
% verschiedenen Realisierungen, in den Zeilen stehen die Daten einzelner
% Realisierungen. Also transponieren und Ergebnis wieder zurück drehen...
datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, anz_zr);
% Init-Werte bestimmen:
zi = datenIn.dat(:,1)';
datenOut.dat_zr = (IIRFilter(datenIn.dat', paras.parameter_commandline{1}, zi))';

ret.ungueltig = 0;
ret.bezeichner = sprintf('IIR %0.4f', paras.parameter_commandline{1});