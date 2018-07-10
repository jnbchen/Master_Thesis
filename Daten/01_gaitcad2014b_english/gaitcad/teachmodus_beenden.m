  function teachmodus_beenden(uihd,teach_modus, parameter)
% function teachmodus_beenden(uihd,teach_modus, parameter)
%
% Callbackstrings wiederherstellen
%
% The function teachmodus_beenden is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

for i=teach_modus.ind_callback
    set(uihd(teach_modus.indx(i),teach_modus.indy(i)),'callback',teach_modus.teach_callback(teach_modus.indx(i),teach_modus.indy(i)).text);
end;

%File mit Callbacks wieder schließen
try
    fclose(teach_modus.f);
    %löscht doppelte Einträge
    repair_makrofile;
    
catch
    fclose('all');
    mywarning('The macro file could not be closed!');
end;



%Fenster wieder aufräumen
delete(teach_modus.ha);
set(1,'color',parameter.allgemein.figure_background_color);

