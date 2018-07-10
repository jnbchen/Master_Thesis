  function gaitcad_hilfe(mode, parameter)
% function gaitcad_hilfe(mode, parameter)
%
% 
%  mode = 1: Öffnen der PDF-Datei (Pfad wird aus parameter.allgemein.pfad_gaitcad
%  gelesen, Hilfedatei ist fest gesetzt).
%  mode = 2: Öffnet Info-Fenster
% 
% 
%
% The function gaitcad_hilfe is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

switch(mode)
case 1
   hilfedatei = sprintf('%s%sdoku%sgaitcad_help.pdf', parameter.allgemein.pfad_gaitcad,filesep,filesep);
   % Hier wäre zu überlegen, den Aufruf mit einem & zu beenden. Dann kann die Kommandozeile von
   % Matlab weiter verwendet werden...
   eval(sprintf('!%s &', hilfedatei));
   clear hilfedatei;
case 2
   logo_file = sprintf('%s%slogo.png', parameter.allgemein.pfad_gaitcad,filesep);
   about_string=sprintf('\nGait-CAD Version %s\nGNU-GPL Copyright (C) %d\n[Ralf Mikut, Tobias Loose, Ole Burmeister, Johannes Stegmaier, Markus Reischl]\nInstitut für Angewandte Informatik\nKarlsruher Institut für Technologie\nhttp://www.iai.kit.edu',parameter.allgemein.version,2013);
   if (~exist(logo_file, 'file'))
      msgbox(about_string, 'About Gait-CAD', 'help', 'modal');
   else
      warning off;
	   logo = imread(logo_file, 'png');
      warning on;
      msgbox(about_string, 'About Gait-CAD', 'custom', logo, [], 'modal');
   end;
   clear logo_file about_string;
case 3
   hilfedatei = sprintf('%s%sGNU_license.txt', parameter.allgemein.pfad_gaitcad,filesep);
   eval(sprintf('!notepad %s &', hilfedatei));
end;
