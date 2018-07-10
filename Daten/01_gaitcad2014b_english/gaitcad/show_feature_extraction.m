  function show_feature_extraction(bez_timeseries,parameter,grenzen)
% function show_feature_extraction(bez_timeseries,parameter,grenzen)
%
% 
% 
%
% The function show_feature_extraction is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<3
   grenzen = [];
end;

errorcode = 1;
%load file
load([parameter.projekt.pfad '\' parameter.projekt.datei '.plugpar'],'-mat');

%avoid problems with blanks especially in older files
for i_blanks = 1:length(plugin_parameter.time_series)
   plugin_parameter.time_series{i_blanks} = kill_lz(plugin_parameter.time_series{i_blanks});
end;

%for all time series
for ind_ts=1:size(bez_timeseries,1)
   
   %localize timeseries in the feature list
   
   
   ind_ts_feat = find(ismember(plugin_parameter.time_series,kill_lz(bez_timeseries(ind_ts,:))));
   
   if isempty(ind_ts_feat)
      fprintf('No related features for %s found.\n',kill_lz(bez_timeseries(ind_ts,:)));
   else
      errorcode = 0;
      
      %for all features
      for ind_entry=ind_ts_feat
         
         switch plugin_parameter.beschreibung{ind_entry}
            case 'TS->PC SF'
               %PCA (for a segment)
               figure;
               temp = str2num(plugin_parameter.einzuege{ind_entry});
               stairs(temp(1):temp(2),plugin_parameter.features{ind_entry});
               axis([temp(1) temp(2) -1 1]);
               xlabel('Sample points');
               ylabel('Value of the transformation vector');
            case 'TS->FUZZY SF MEAN'
               plklzgf(plugin_parameter.features{ind_entry},1,kill_lz(bez_timeseries(ind_ts,:)),[],grenzen);
         end;
         
         %get the title and figure name
         title_string = [plugin_parameter.beschreibung{ind_entry} ' (Time segment: ' plugin_parameter.einzuege{ind_entry} ')'];
         title(title_string);
         figurename=sprintf('%d: %s für %d',get_figure_number(gcf),title_string,kill_lz(bez_timeseries(ind_ts,:)));
         set(gcf,'numbertitle','off','name',figurename);
      end;
   end;
end;


if errorcode == 1
   temp = bez_timeseries';
   myerror(sprintf('No related features for %s found.\n',kill_lz(temp(:))));
end;
