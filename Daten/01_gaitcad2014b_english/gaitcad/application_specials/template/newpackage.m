  function newpackage(package_name,parameter)
% function newpackage(package_name,parameter)
%
% 
% 
% generated microarrays files for a new package called
% package_name by copying all microarrays files to the new package
% It include:
% - making new directories if neccesary
% - renaming files
% - renaming file content microarrays -> package_name (incl. tags,
%   functions...)
% 
%
% The function newpackage is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:04
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

package_name = strrep(package_name,' ','_');
package_name_lower=lower(package_name);
package_name_lower = package_name_lower(1:min(12,length(package_name_lower)));
 
%make directories, if necessary (dos commands!)
eval(strrep(sprintf('!md %s\\application_specials\\%s',parameter.allgemein.pfad_gaitcad,package_name_lower),'\',filesep));
eval(strrep(sprintf('!md %s\\application_specials\\%s\\plugins',parameter.allgemein.pfad_gaitcad,package_name_lower),'\',filesep));
eval(strrep(sprintf('!md %s\\application_specials\\%s\\plugins\\einzuggenerierung',parameter.allgemein.pfad_gaitcad,package_name_lower),'\',filesep));
eval(strrep(sprintf('!md %s\\application_specials\\%s\\plugins\\mgenerierung',parameter.allgemein.pfad_gaitcad,package_name_lower),'\',filesep));
eval(strrep(sprintf('!md %s\\application_specials\\%s\\standardmakros',parameter.allgemein.pfad_gaitcad,package_name_lower),'\',filesep));

%look for all recent template files
template_file = getsubdir(strrep([parameter.allgemein.pfad_gaitcad '\application_specials\template'],'\',filesep),'*.*',1);

for i=1:length(template_file)
   
   if ~isempty(template_file(i).name) && isempty(strfind(template_file(i).name,[filesep 'CVS'])) && isempty(strfind(template_file(i).name,'newpackage.m')) && ...
         isempty(strfind(template_file(i).name,'.svn')) && isempty(strfind(template_file(i).name,'built-in'))
      %opening template files and read the content
      f_temp=fopen(template_file(i).name,'rt');
      temp_content = fscanf(f_temp,'%c');
      fclose(f_temp);
      
      %renaming all template variables names by the lower style of package_name
      temp_content = strrep(temp_content,'template',package_name_lower);
      
      %Filename: template -> package (also for the path!!)
      f_name_newpackage = strrep(template_file(i).name,'template',package_name_lower);
      
      %renaming all template variables names by the (optionally upper style) of package_name
      temp_content = strrep(temp_content,'Template',package_name);
      
      %making the new file
      f_newpackage=fopen(f_name_newpackage,'wt');
      if f_newpackage>-1
         %copy content
         fprintf(f_newpackage,'%c',temp_content);
         fclose(f_newpackage);
      end;  
   end;
   
end;