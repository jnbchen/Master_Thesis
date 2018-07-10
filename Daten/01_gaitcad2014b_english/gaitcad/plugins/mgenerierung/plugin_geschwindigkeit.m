  function [datenOut, ret, info] = plugin_geschwindigkeit(paras, datenIn)
% function [datenOut, ret, info] = plugin_geschwindigkeit(paras, datenIn)
%
% Berechne die Beschleunigungszeitreihen
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_geschwindigkeit is part of the MATLAB toolbox Gait-CAD. 
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
info = struct('beschreibung', 'Velocity', 'bezeichner', 'V', 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation      = strcat('computes the first time derivation of a time series.',' The result is a single time series.',' Here, an acausal filter is used.');
info.explanation_long = 'see Eq. (3.2) in \cite{Loose04})';

info.commandline.description{1} = 'Time';
info.commandline.parameter_commandline{1} = 1;
info.commandline.popup_string{1} = 'per sample|per time';
info.commandline.tooltext{1} = 'defines the scaling (per sample point resp. per time using the sampling frequency from the GUI)';




if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

% Berechne die Geschwindigkeit. An den Rändern wird extrapoliert.
geschw=0.5.*[datenIn.dat(:,3:size(datenIn.dat,2)) - datenIn.dat(:,1:size(datenIn.dat,2)-2)];
geschw=[2*geschw(:,1)-geschw(:,2) geschw 2*geschw(:,size(geschw,2))-geschw(:,size(geschw,2)-1)];


switch paras.parameter_commandline{1}
case 2 %'pro Zeit'
   %handle sample time
   geschw = geschw*paras.parameter.gui.zeitreihen.abtastfrequenz;
   
   %handle sample time  in time series name
   ret.bezeichner = [info.bezeichner sprintf(' [1/%s]',...
         paras.parameter.gui.zeitreihen.einheit_abtastzeit_liste{paras.parameter.gui.zeitreihen.einheit_abtastfrequenz})];
end;

% Lege Speicher für die neuen Zeitreihen an
datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, anz_zr);
% Kopiere die Beschleunigung in die Übergabematrix
datenOut.dat_zr(:,:,1)=geschw;
            
ret.ungueltig = 0;