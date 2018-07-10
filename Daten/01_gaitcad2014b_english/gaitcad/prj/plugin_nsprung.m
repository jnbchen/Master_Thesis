  function [datenOut, ret, info] = plugin_nsprung(paras, datenIn)
% function [datenOut, ret, info] = plugin_nsprung(paras, datenIn)
%
%  Berechnet eine IIR gefilterte Zeitreihe.
%  Benötigt Parameter aus Oberfläche (übergeben in paras.iirfilter) und die Funktion
%  iirFilter.m
%  Plugin-Fkt für Gait-CAD.
%
% The function plugin_nsprung is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:07
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
info = struct('beschreibung', 'Jump to zero', 'bezeichner', 'NSprung', 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation      = strcat('set value  = 1 for a jump to zeros, and value = 0 otherwise.');

if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

%detect zero values
datenOut.dat_zr = (datenIn.dat == 0);

%detect a jump form a non-zero value to a zero value
datenOut.dat_zr(:,2:end,:) = datenOut.dat_zr(:,2:end,:) & (datenIn.dat(:,1:size(datenIn.dat,2)-1,:)~=0); % Coderevision: &/| checked!

ret.ungueltig = 0;
ret.bezeichner = 'NSprung';