% Script callback_makro_bearbeiten
%
% makro_ausführen
% 
% Original-Pfad merken, wird u.U. durch Makro verstellt
%
% The script callback_makro_bearbeiten is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

org_path=pwd;

%Datei laden, wenn es noch keine gibt
switch mode
    case 1
        [makro_datei,pfad]=uigetfile('*.makrog','Load macro');
    case 2
        [makro_datei,pfad]=uigetfile('*.m','Load M-file');
    case 3
        [makro_datei,pfad]=uigetfile('*.batch','Load Gait-CAD batch file');        
end;

if (makro_datei==0)
    makro_datei=[];
end;

%Datei im Editor öffnen
if ~isempty(makro_datei)
    cd(pfad);
    eval(sprintf('edit ''%s''',which(makro_datei)));
end;

%Original-Pfad wiederherstellen
cd(org_path);
clear org_path makro_datei;
