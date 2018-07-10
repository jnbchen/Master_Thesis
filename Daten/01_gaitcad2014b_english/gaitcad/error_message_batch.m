  function error_message_batch(errorpath,projectname,message_text)
% function error_message_batch(errorpath,projectname,message_text)
%
% 
% 
% error_message_batch(gaitcad_extern.path,gaitcad_extern.project{gaitcad_extern.i_project}.project_list(gaitcad_extern.i_file).name,message_text)
% error_message_batch(pwd,parameter.projekt,message_text)
% 
%
% The function error_message_batch is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(projectname)
   projectname = 'empty';
else
   [temp,projectname,extension] = fileparts(projectname);
   if isempty(extension)
      projectname = [projectname '.prjz'];
   else
      projectname = [projectname extension];
   end;
end;

%add error protocol
f_err = fopen([errorpath filesep 'error.log'],'at');
errtime = clock;
if ~isempty(strfind(message_text,' was successfully executed!'))
   fboth(f_err, '\n\nMessage in file\n%s \n%02d.%02d.%02d, %02d:%02d:%02.0f\n(%s:%s) \n',...
      projectname,errtime([3 2 1 4 5 6]),kill_lz(message_text),kill_lz(get(0,'errormessage')));
else
   if ~isempty(strfind(message_text,'mywarning alert'))
      fboth(f_err, '\n\nWarning in file \n%s \n%02d.%02d.%02d, %02d:%02d:%02.0f\n(%s:%s) \n',...
      projectname,errtime([3 2 1 4 5 6]),kill_lz(message_text),kill_lz(get(0,'errormessage')));
   else 
      fboth(f_err, '\n\nError in file  \n%s \n%02d.%02d.%02d, %02d:%02d:%02.0f\n(%s:%s) \n',...
      projectname,errtime([3 2 1 4 5 6]),kill_lz(message_text),kill_lz(get(0,'errormessage')));
   end;
end;

fclose(f_err);

if ~isempty(strfind(get(0,'errormessage'),'Interrupt'))
   error('Interrupt!');
end;

lasterr('');
