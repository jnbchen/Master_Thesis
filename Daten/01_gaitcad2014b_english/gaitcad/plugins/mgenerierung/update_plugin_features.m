  function [features,info] = update_plugin_features(paras,features,info,mode)
% function [features,info] = update_plugin_features(paras,features,info,mode)
%
% 
% 
% prepare data structure for save feature extraction
%
% The function update_plugin_features is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:07
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

filename_parameter = [paras.parameter.projekt.datei '.plugpar'];
plugin_parameter.time_series  = {};
plugin_parameter.beschreibung = {};
plugin_parameter.features     = {};
plugin_parameter.bezeichner   = {};
plugin_parameter.einzuege     = {};


%names of time series
if length(paras.ind_zr_merkmal)~=1
   myerror('Invalid number of time series at loading of features!')
else
   bez_timeseries = kill_lz(paras.var_bez(paras.ind_zr_merkmal,:));
end;

%segment -> strings (for an easier comparison)
einzuege = sprintf('%d %d',paras.einzuege);

%find file
if exist(filename_parameter,'file')
   try
      load(filename_parameter,'-mat');
      
      %avoid problems with blanks especially in older files 
      for i_blanks = 1:length(plugin_parameter.time_series)
         plugin_parameter.time_series{i_blanks} = kill_lz(plugin_parameter.time_series{i_blanks});
      end;
      
       for i_blanks = 1:length(plugin_parameter.beschreibung)
         plugin_parameter.beschreibung{i_blanks} = kill_lz(plugin_parameter.beschreibung{i_blanks});
      end;
         
   catch
      myerror('File *.plugpar with extraction parameters for features in plugins could not be opened!');
   end;
   
else
   if strcmp(mode,'load_parameter')
      myerror('File *.plugpar with extraction parameters for features in plugins not found!');
   end;
end;

%localize timeseries
ind_ts = find(ismember(plugin_parameter.time_series,bez_timeseries));
%localize features
ind_feat = find(ismember(plugin_parameter.beschreibung,info.beschreibung));
%localize segments
ind_einzuege = find(ismember(plugin_parameter.einzuege,einzuege));
%and all?
ind_entry = intersect(ind_ts,ind_feat);

%einzuege (German for segments) are only checked if the ignore_segments
%option is switched on, ignoring used e.g. for fuzzy sets
if ~isfield(paras,'ignore_segments') || paras.ignore_segments == 0
   ind_entry = intersect(ind_entry,ind_einzuege);
end;

switch mode
   case 'save_parameter'
      
      if isempty(ind_entry)
         %add entry at the end
         ind_entry = length(plugin_parameter.time_series)+1;
      end;
      
      %write entry
      plugin_parameter.time_series{ind_entry}  = bez_timeseries;
      plugin_parameter.beschreibung{ind_entry} = info.beschreibung;
      plugin_parameter.features{ind_entry}     = features;
      plugin_parameter.bezeichner{ind_entry}   = info.bezeichner;
      plugin_parameter.einzuege{ind_entry}     = einzuege;
      save(filename_parameter,'plugin_parameter',...
         char(paras.parameter.gui.allgemein.liste_save_mode_matlab_version(...
         paras.parameter.gui.allgemein.save_mode_matlab_version)));
      
      
   case 'load_parameter'
      if isempty(ind_entry)
         %add entry at the end
         myerror(sprintf('Extraction rule for %s not found in *.plugpar file!',deblank(bez_timeseries)));
      else
         bez_timeseries = plugin_parameter.time_series{ind_entry};
         
         %read entry
         info.beschreibung = plugin_parameter.beschreibung{ind_entry};
         features = plugin_parameter.features{ind_entry} ;
         info.bezeichner = plugin_parameter.bezeichner{ind_entry};
      end;
end;






