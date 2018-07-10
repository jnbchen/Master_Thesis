  function [string,info,callback,auswahl] = callback_extract_features(plugins,parameter,auswahl)
% function [string,info,callback,auswahl] = callback_extract_features(plugins,parameter,auswahl)
%
% 
% 
% extract features
% 
% 
%
% The function callback_extract_features is part of the MATLAB toolbox Gait-CAD. 
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

if ~isfield(auswahl,'gen')
   auswahl.gen = [];
end;

%initialize with the selected time series if no other initialization is given
if(~parameter.allgemein.makro_ausfuehren) && ~iscell(auswahl.gen) 
   auswahl.gen(1,1:length(parameter.gui.merkmale_und_klassen.ind_zr))=parameter.gui.merkmale_und_klassen.ind_zr;
end;

%string for new features
add_string3 = ['|' deblank(char(plugins.mgenerierung_plugins.string(3,:)))];
string3 = '';
ind_str = [strfind(add_string3,'|') length(add_string3)+1];

%use only the shown plugins
for i = plugins.mgenerierung_plugins.typ_beschreibung.show_now
   string3 = [string3 add_string3(ind_str(i):ind_str(i+1)-1)];
end;
string(1:2,:) = plugins.mgenerierung_plugins.string(1:2,:);
string(3,1:length(string3)-1) = string3(2:end);

info=plugins.mgenerierung_plugins.info_auswahlfenster;
callback=plugins.mgenerierung_plugins.callback;