  function [plugin_info,error_string] = check_plugin_info(plugin_info_raw)
% function [plugin_info,error_string] = check_plugin_info(plugin_info_raw)
%
% 
% 
% initializing error string
%
% The function check_plugin_info is part of the MATLAB toolbox Gait-CAD. 
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

error_string = '';

%guarantee a unified order of plugin_info -
%unless a different order in the plugin and plugin_info_raw

try
   %this information has to be contained in a plugin
   plugin_info.beschreibung       = plugin_info_raw.beschreibung;
   plugin_info.bezeichner         = plugin_info_raw.bezeichner;
   plugin_info.anz_zr             = plugin_info_raw.anz_zr;
   plugin_info.anz_em             = plugin_info_raw.anz_em;
   plugin_info.laenge_zr          = plugin_info_raw.laenge_zr;
   plugin_info.typ                = plugin_info_raw.typ;
   plugin_info.einzug_OK          = plugin_info_raw.einzug_OK; 
   plugin_info.richtung_entfernen = plugin_info_raw.richtung_entfernen;
   plugin_info.anz_benoetigt_zr   = plugin_info_raw.anz_benoetigt_zr;
   
   if ~isfield(plugin_info_raw,'explanation')
      plugin_info.explanation = '';
   else
      plugin_info.explanation = plugin_info_raw.explanation;
   end;
   
   if ~isfield(plugin_info_raw,'explanation_long')
      plugin_info.explanation_long = '';
   else
      plugin_info.explanation_long = plugin_info_raw.explanation_long;
   end; 
   
   if ~isfield(plugin_info_raw,'anz_benoetigt_em')
      plugin_info.anz_benoetigt_em = 0;
   else
      plugin_info.anz_benoetigt_em = plugin_info_raw.anz_benoetigt_em;
   end;
   
   if ~isfield(plugin_info_raw,'anz_im')
      plugin_info.anz_im = 0;
      plugin_info.anz_benoetigt_im = 0;
      plugin_info.callback = '';
   else
      plugin_info.anz_im            = plugin_info_raw.anz_im;
      plugin_info.anz_benoetigt_im  = plugin_info_raw.anz_benoetigt_im;
      plugin_info.callback          = plugin_info_raw.callback;      
   end;
   
   if ~isfield(plugin_info_raw,'commandline')
      plugin_info.commandline = {};
   else
      plugin_info.commandline = plugin_info_raw.commandline;
   end;
   
   if ~isempty(plugin_info.commandline)
      for i_plugcom=1:length(plugin_info.commandline.parameter_commandline)
         if isfield(plugin_info.commandline,'popup_string') && length(plugin_info.commandline.popup_string) >= i_plugcom ...
               && ~isempty(strfind(plugin_info.commandline.popup_string{i_plugcom},'|'))
            plugin_info.commandline.ispopup{i_plugcom} = 1;
         else
            plugin_info.commandline.ispopup{i_plugcom} = 0;
         end;
         
      end;
   end;
   
   % Sowohl Zeitreihen als auch Einzelmerkmale??
   if (plugin_info.anz_zr ~= 0 && plugin_info.anz_em ~= 0)
      str = 'A plugin cannot compute time series and single features at the same time!!';
   end;
   % Werden genügend Bezeichner übergeben?
   if ( (plugin_info.anz_zr > 0 && size(plugin_info.bezeichner,1) ~= plugin_info.anz_zr) ...
         || (plugin_info.anz_em > 0 && size(plugin_info.bezeichner,1) ~= plugin_info.anz_em) ...
         || (plugin_info.anz_im > 0 && ~isinf(plugin_info.anz_im) && size(plugin_info.bezeichner,1) ~= plugin_info.anz_im) )
      str = 'Not enough names!!!';
   end;
   
catch
   
   str = 'Program error inside a plugin (e.g. non existing variable)';
end;
