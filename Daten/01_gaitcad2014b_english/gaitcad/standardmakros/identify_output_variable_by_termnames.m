  function myoutputname = identify_output_variable_by_termnames(termlist,bez_code,zgf_y_bez,par)
% function myoutputname = identify_output_variable_by_termnames(termlist,bez_code,zgf_y_bez,par)
%
% 
% myoutputname = identify_output_variable_by_termnames(termlist,bez_code,zgf_y_bez,par)
% returns the name of the output variable that contains all linguistic terms
% in termlist. If more than one output variable fulfils this condition, the
% function returns the first one
% Example: 
% identify_output_variable_by_termnames({'GFP','RFP','Y3'},bez_code,zgf_y_bez,par)
% 
%
% The function identify_output_variable_by_termnames is part of the MATLAB toolbox Gait-CAD. 
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

myoutputname = '';
for i=1:size(zgf_y_bez,1)
   ind = min(ismember(termlist,{zgf_y_bez(i,1:par.anz_ling_y(i)).name}));
   if ind == 1
      myoutputname = deblank(bez_code(i,:));
      return;
   end;
end;


