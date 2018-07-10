% Script execute_multid_gui_eingabe
%
% The script execute_multid_gui_eingabe is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

for i_fill=1:length(eingabe.x)
    switch eingabe.x{i_fill}
        case 'x'
            if ~isfield(eingabe,'var1_ind')
                eingabe.var1_ind = i_fill;
            else
                if ~isfield(eingabe,'var2_ind')
                    eingabe.var2_ind = i_fill;
                else
                    myerror('In the GUI, 1-2 variables have to be selected with x, 0-1 variables with y. All other variables must be numeric!');
                end;
            end;
        case 'y'
            if ~isfield(eingabe,'var2_ind')
                eingabe.var2_ind = i_fill;
            else
                myerror('In the GUI, 1-2 variables have to be selected with x, 0-1 variables with y. All other variables must be numeric!');
            end;
        otherwise
            eingabe.konst_ind(i_fill) = i_fill;
            eingabe.konst_val(i_fill) = eingabe.x{i_fill};
    end;
end;

%else
if isfield(eingabe,'konst_val')
    eingabe.konst_val = eingabe.konst_val(eingabe.konst_ind~=0);
    eingabe.konst_ind = eingabe.konst_ind(eingabe.konst_ind~=0);
else
    eingabe.konst_val = [];
    eingabe.konst_ind = [];
end;
%end;

if ~isfield(eingabe,'var2_ind')
    eingabe.var2_ind = [];
end;


mode_visu_regression=5;
callback_visu_regression

clear i_fill start_ce rang_ce i_num