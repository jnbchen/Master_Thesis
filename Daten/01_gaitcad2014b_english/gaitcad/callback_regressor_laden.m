% Script callback_regressor_laden
%
% The script callback_regressor_laden is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(next_function_parameter)
    datei_load_regr_single = next_function_parameter;
end;
if ~exist('datei_load_regr_single','var')
   datei_load_regr_single = [];
end;

regr_single=load_gaitcad_struct(parameter,{dorgbez,var_bez},par,'Load regression model','regr_single',datei_load_regr_single);
clear datei_load_regr_single;

if ~isempty(regr_single)
   %für die Anwendung auf den betroffenen Klassifikator umschalten
   %parameter.gui.klassifikation.klassifikator=klass_single(1).entworfener_klassifikator.nummer;
   %parameter.gui.klassifikation.mehrklassen  =klass_single(1).entworfener_klassifikator.mehrklassen;
   %	in GUI eintragen
   inGUI;
end;

aktparawin;