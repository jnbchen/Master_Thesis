% Script callback_datenauswahl
%
% CALLBACK_DATENAUSWAHL - Holt ausgewählte Datentupel in den Workspace.
%
% The script callback_datenauswahl is part of the MATLAB toolbox Gait-CAD. 
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

ind_auswahl=ones(par.anz_dat,1);
titelzeile='';
bez_code_cell = cellstr(bez_code);

for i=1:size(code_alle,2)
	ind = sort(get(figure_handle(i+1,1),'value'));
	tmp_titel = get(figure_handle(i+1,1),'string');
	tmp_titel = cellstr(tmp_titel(ind,:));
    % Mit cellstrings deutlich einfacher!
	titelzeile = kill_lz(sprintf('%s %s: %s,',titelzeile, bez_code_cell{i}, tmp_titel{:}));
	if ind(1)>1
      %deselect data points of nonselected terms step by step to avoid problems with very large projects
      
      %number correction - 1 means all;  2, 3 etc. terms 1, 2 etc..
      ind = ind-1;
      
      %data points with code smaller as the first one
      if ind(1)>1 
         ind_auswahl(code_alle(:,i)<ind(1)) = 0;
      end;
      
      %data points with nonselecetd code (look for compact regions)
      ind_non_compact = find(diff(ind)>1);
      for i_nc = 1:length(ind_non_compact)
         ind_auswahl( (code_alle(:,i)>ind(ind_non_compact(i_nc))) & (code_alle(:,i)<ind(ind_non_compact(i_nc)+1) )) = 0;  % Coderevision: &/| checked!
      end;
      
      %data points with code greater than the last one
      if ind(end)<par.anz_ling_y(i)
         ind_auswahl(code_alle(:,i)>ind(end)) = 0;
      end;      
      
	end;
end;
ind_auswahl=find(ind_auswahl);
% Mit strrep einfacher
titelzeile = strrep(titelzeile, 'unknown', '');
% Letztes Komma entfernen
if (strcmp(titelzeile(end),',') == 1)
   titelzeile = titelzeile(1:length(titelzeile)-1);
end;
