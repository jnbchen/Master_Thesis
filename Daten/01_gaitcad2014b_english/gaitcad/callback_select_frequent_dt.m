% Script callback_select_frequent_dt
%
% get existing code entries
%
% The script callback_select_frequent_dt is part of the MATLAB toolbox Gait-CAD. 
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

[freq_code,nr_code] = hist(code(ind_auswahl),unique(code(ind_auswahl))); 

%select all code entries with a relevant frequency
nr_code = nr_code(find(freq_code >= parameter.gui.datenvorverarbeitung.min_dt_number));

%mark all related data points
ind_auswahl_temp = zeros(length(ind_auswahl),1);
for i_code = generate_rowvector(nr_code)
   ind_auswahl_temp (find(code(ind_auswahl) == i_code))   = 1;
end;
ind_auswahl_temp = find(ind_auswahl_temp);

%select if not empty
if ~isempty(ind_auswahl_temp)
   ind_auswahl = ind_auswahl(ind_auswahl_temp);
   aktparawin;
else
   myerror('No valid data selection!');
end;


