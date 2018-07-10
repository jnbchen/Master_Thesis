  function [datenOut, ret, info] = plugin_discr_zr(paras, datenIn)
% function [datenOut, ret, info] = plugin_discr_zr(paras, datenIn)
%
% 
% 
%
% The function plugin_discr_zr is part of the MATLAB toolbox Gait-CAD. 
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

bezeichner = strcat('TERMQ');
info = struct('beschreibung', 'TS->DISCR TS MEAN', 'bezeichner', bezeichner, 'anz_zr', 1, 'anz_em', 0, 'laenge_zr', 0, 'typ', 'TS');
info.einzug_OK = 1; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation       = 'computes a discretized time series with a tunable number of terms for discretization.';

info.commandline.description{1} = 'Number of terms';
info.commandline.parameter_commandline{1} = 5;
info.commandline.tooltext{1} = 'Number of terms for discretization';
info.commandline.wertebereich{1} =  {1 Inf };


%unusual form - look to the corresponding control element in the GUI to
%avoid problems 
id_mbf = find(ismember({paras.parameter.gui.control_elements.tag},'CE_Fuzzy_TypeZGF'));
info.commandline.parameter_commandline{2} = paras.parameter.gui.control_elements(id_mbf).default;
info.commandline.description{2} = paras.parameter.gui.control_elements(id_mbf).name;
info.commandline.popup_string {2} = paras.parameter.gui.control_elements(id_mbf).listen_werte;
info.commandline.tooltext{2} = paras.parameter.gui.control_elements(id_mbf).tooltext;


if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

%overwrite number of terms and type of fuzzy set generation
paras.parameter.gui.klassifikation.fuzzy_system.anz_fuzzy = paras.parameter_commandline{1};
paras.parameter.gui.klassifikation.fuzzy_system.type_zgf  = paras.parameter_commandline{2};

mode_fuzzy_plugin_em='SF';
mode_fuzzy_plugin_em_aggr='MEAN DISCR TS';
fuzdiscr_for_plugin;
ret.ungueltig = 0;

