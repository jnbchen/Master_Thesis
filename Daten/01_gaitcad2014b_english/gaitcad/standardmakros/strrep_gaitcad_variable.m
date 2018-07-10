  function gaitcad_name = strrep_gaitcad_variable(gaitcad_name,name_old,name_new)
% function gaitcad_name = strrep_gaitcad_variable(gaitcad_name,name_old,name_new)
%
% 
% dorgbez = strrep_gaitcad_variable(dorgbez,'MEDIAN DT ' ,'')
% 
% special function for zgf_y_bez
%
% The function strrep_gaitcad_variable is part of the MATLAB toolbox Gait-CAD. 
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

if isstruct(gaitcad_name) && isfield(gaitcad_name,'name')
   for i=1:size(gaitcad_name,1)
      for j=1:size(gaitcad_name,2)
         if ~isempty(gaitcad_name(i,j).name)
            gaitcad_name(i,j).name = strrep(gaitcad_name(i,j).name,name_old,name_new);
         end;
      end;
   end;
   return;
end;


%available for dorgbez, var_bez beZ_code etc.
temp = string2cell(gaitcad_name);
for i=1:length(temp)
   temp{i} = strrep(temp{i},name_old,name_new);
end;
gaitcad_name = char(temp);
