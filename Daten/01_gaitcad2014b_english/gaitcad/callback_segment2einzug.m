% Script callback_segment2einzug
%
% hängt das aktuelle Zeitreihensegment temporär für die jeweilige Session an den Einzug dran
% 
% hinten einen neuen Plugin anhängen
%
% The script callback_segment2einzug is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

plugins.einzuege_plugins(end+1).ueberschrift='Time series segment from project';
plugins.einzuege_plugins(end).einzug.start=parameter.gui.zeitreihen.segment_start;
plugins.einzuege_plugins(end).einzug.stop=parameter.gui.zeitreihen.segment_ende;
plugins.einzuege_plugins(end).bezeichner=sprintf('Samples %d-%d',plugins.einzuege_plugins(end).einzug.start,plugins.einzuege_plugins(end).einzug.stop);
plugins.einzuege_plugins(end).kurzbezeichner=sprintf('K%d-%d',plugins.einzuege_plugins(end).einzug.start,plugins.einzuege_plugins(end).einzug.stop);

%String für Auswahlfenster muss angepasst werden
if isempty(parameter.gui.ganganalyse.einzug_links_rechts) || (parameter.gui.ganganalyse.einzug_links_rechts~=1)
   plugins.mgenerierung_plugins.string(2,:)=32*ones(1,size(plugins.mgenerierung_plugins.string,2));
   tmp=poplist_popini(char(plugins.einzuege_plugins.bezeichner));
   plugins.mgenerierung_plugins.string(2,1:length(tmp))=tmp;
end;



