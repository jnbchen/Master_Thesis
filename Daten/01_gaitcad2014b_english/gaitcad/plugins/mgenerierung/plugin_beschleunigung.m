  function [datenOut, ret, info] = plugin_beschleunigung(paras, datenIn)
% function [datenOut, ret, info] = plugin_beschleunigung(paras, datenIn)
%
%  Berechne die Beschleunigungszeitreihen
%  Plugin-Fkt für Gait-CAD.
%
% The function plugin_beschleunigung is part of the MATLAB toolbox Gait-CAD. 
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

info = struct('beschreibung', 'Acceleration', 'bezeichner', 'A', 'anz_zr', 1, ...
   'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation      = 'computes the second time derivation of a time series.';
info.explanation_long = 'see Eq. (3.3) in \cite{Loose04}).';

info.commandline.description{1} = 'Time';
info.commandline.parameter_commandline{1} = 1;
info.commandline.popup_string{1} = 'per sample|per time';
info.commandline.tooltext{1} = 'defines the scaling (per sample point resp. per time using the sampling frequency from the GUI)';


if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

% Für welche Zeitreihe solle die neue ZR berechnet werden?
j = paras.ind_zr_merkmal;
% Berechne die Geschwindigkeit. An den Rändern wird extrapoliert.
geschw=0.5.*[datenIn.dat(:,3:size(datenIn.dat,2)) - datenIn.dat(:,1:size(datenIn.dat,2)-2)];
geschw=[2*geschw(:,1)-geschw(:,2) geschw 2*geschw(:,size(geschw,2))-geschw(:,size(geschw,2)-1)];
% Berechne die Beschleunigung. An den Rändern wird extrapoliert.
beschl=0.5.*[geschw(:,3:size(geschw,2)) - geschw(:,1:size(geschw,2)-2)];


switch paras.parameter_commandline{1}
case 2 %'pro Zeit'
   
   %handle sample time
   beschl= beschl*paras.parameter.gui.zeitreihen.abtastfrequenz^2;
   
   %handle sample time in time series name
   ret.bezeichner = [info.bezeichner sprintf(' [1/%s2]',...
         paras.parameter.gui.zeitreihen.einheit_abtastzeit_liste{paras.parameter.gui.zeitreihen.einheit_abtastfrequenz})];
end;

datenOut.dat_zr=[2*beschl(:,1)-beschl(:,2) beschl 2*beschl(:,size(beschl,2))-beschl(:,size(beschl,2)-1)];


ret.ungueltig = 0;