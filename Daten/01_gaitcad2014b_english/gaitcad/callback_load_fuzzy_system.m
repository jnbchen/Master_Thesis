% Script callback_load_fuzzy_system
%
% look for an externally given file name
%
% The script callback_load_fuzzy_system is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(next_function_parameter)
    fuzzy_system_name = next_function_parameter;
end;
if ~exist('fuzzy_system_name','var')
    fuzzy_system_name = [];
end;

%load complete fuzzy system
fuzzy_system=load_gaitcad_struct(parameter,dorgbez,par,'Load fuzzy system','fuzzy_system',fuzzy_system_name);

if mode == 2 && ~isempty(fuzzy_system) 
    %load only membership functions of a pre-designed fuzzy system
    
    %prepare fix parameterization for membership functions
    parameter.gui.klassifikation.fuzzy_system.zgf = fuzzy_system.zgf_all(1:fuzzy_system.par_kafka_all(2),:);
    fuzzy_system.rulebase = [];
    fuzzy_system.output   = [];
    
    % Type of MBF to fix
    set_textauswahl_listbox(gaitfindobj('CE_Fuzzy_TypeZGF'),{'Fix'});eval(gaitfindobj_callback('CE_Fuzzy_TypeZGF'));
    
end;

% Auswahl Ausgangsgröße
% {'Type'}
if ~isempty(fuzzy_system) && isfield(fuzzy_system,'output') && ~isempty(fuzzy_system.output)
    try 
        %temporary saving of fuzzy system (changed output is here o.k.)
        temp_fuzzy_system = fuzzy_system;
        set_textauswahl_listbox(gaitfindobj('CE_Auswahl_Ausgangsgroesse'),{fuzzy_system.output});eval(gaitfindobj_callback('CE_Auswahl_Ausgangsgroesse'));
        %loading of temporary saved fuzzy system (changed output is here o.k.)
        fuzzy_system = temp_fuzzy_system;
    catch
        myerror(sprintf('Output variable  %s does not exist!',fuzzy_system.output));
    end;
end;

clear fuzzy_system_name temp_fuzzy_system;
