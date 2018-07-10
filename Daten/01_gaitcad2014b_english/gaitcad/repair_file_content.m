  function repair_file_content (file_or_dir_name, old_string, new_string,extension)
% function repair_file_content (file_or_dir_name, old_string, new_string,extension)
%
% 
% 
% repair old_string with new_string in a file with name filename
% 
%
% The function repair_file_content is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

if isdir(file_or_dir_name)
    filename = dir([file_or_dir_name filesep extension]);
else
    filename(1).name = file_or_dir_name;
end;

for i_file = 1:length(filename)
    try
        f       = fopen(filename(i_file).name,'rb');
        content = fscanf(f,'%c');
        fclose(f);
        
        content = strrep(content, old_string,new_string);
        
        f       = fopen(filename(i_file).name,'wb');
        fprintf(f,'%c',content);
        fclose(f);
        fprintf('%s corrected\n',filename(i_file).name);
    catch
        fprintf('Error in  %s\n',filename(i_file).name);
    end;
end;