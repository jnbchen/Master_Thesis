% Script callback_separate_fileterms
%
% The terms of the selected output variable are interpreted as filenames with complete pathes.
% They are used to add additional output variables consisting of all directories and the filename itself.
%
% The script callback_separate_fileterms is part of the MATLAB toolbox Gait-CAD. 
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

switch mode 
case 1
   separator_list = {filesep};
case 2
   separator_list = {filesep,'.'};
end;

[temp_code_alle,temp_zgf_y_bez,temp_bez_code] = get_klassen_complete({zgf_y_bez(par.y_choice,code_alle(:,par.y_choice)).name},1:par.anz_dat,separator_list);

for i_code=1:size(temp_code_alle,2)
   newcode = temp_code_alle(:,i_code);
   newtermname = temp_zgf_y_bez(i_code,1:max(newcode));
   newcodename  = temp_bez_code(i_code,:);
   [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,newcodename,newtermname);
   aktparawin;
end;

clear temp_code_alle temp_zgf_y_bez temp_bez_code separator_list