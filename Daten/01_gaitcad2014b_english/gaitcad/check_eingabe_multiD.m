  function boolean_eingabe = check_eingabe_multiD(eingabe)
% function boolean_eingabe = check_eingabe_multiD(eingabe)
%
% 
% 
%
% The function check_eingabe_multiD is part of the MATLAB toolbox Gait-CAD. 
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

try
    boolean_eingabe = 1;
    % Check for content
    
    %at least two variables must exist
    if isempty(eingabe.var1_ind) || ~isnumeric(eingabe.var1_ind)
        boolean_eingabe = 0;
    end;
    
    %if second variable exist, it has to be numeric
    if ~isempty(eingabe.var2_ind) && ~isnumeric(eingabe.var2_ind)
        boolean_eingabe = 0;
    end;
    
    %variable values hast no be numeric and need a consistent data format
    %for the range
    if ~isempty(eingabe.konst_ind)
        if isempty(eingabe.konst_val) || ~isnumeric(eingabe.konst_ind) || ~isnumeric(eingabe.konst_val) 
            boolean_eingabe = 0;
        end;
        if size(eingabe.range,2) ~= 2 || ~isnumeric(eingabe.range)
            boolean_eingabe = 0;
        end;
    end;
    
   
catch
    myerror('In the GUI, 1-2 variables have to be selected with x, 0-1 variables with y. All other variables must be numeric!')
end;

