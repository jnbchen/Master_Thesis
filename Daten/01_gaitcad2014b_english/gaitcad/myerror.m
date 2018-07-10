  function myerror(errortext)
% function myerror(errortext)
%
% öffnet errorfenster und bricht Ausführung ab
%
% The function myerror is part of the MATLAB toolbox Gait-CAD. 
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

hndl=findobj('userdata','Configuration');
if ~isempty(hndl)
   close(hndl);
end;

%read macro and path information from base workspace
evalin('base','get_gaitbatch_information');
gaitbatch_state = evalin('base','gaitbatch_state');

%im Base-Workspace Makros resetten
evalin('base','check_for_open_macro;');
evalin('base','makro_lern=[];makro_test=[];');

pointer(3);
if isempty(strfind(errortext,sprintf('\n\nThe processing of the current Gait-CAD function was stopped.')))
   errortext=strcat(errortext,sprintf('\n\nThe processing of the current Gait-CAD function was stopped.'));
   errortext=strcat(errortext,sprintf(' Often it is possible to continue the work with the toolbox'));
   
end;

if strcmp(get(1,'userdata'),'gaitdebug')
   fprintf('%s\n',errortext);
   fprintf('%s\n%s\n','Error in Gait-CAD batch file. Please check the reason with the debugger.','The execution can be continued with return.');
   keyboard;
end;


if ~strcmp(get(1,'userdata'),'IgnoreErrors')
   fclose('all');
   errordlg(errortext,'Error','modal');
else
   
   %adding stack information
   temp_stack = dbstack;
   stack_string = sprintf('\n, Stack protocol with files (last command line): ');
   for i_stack = 1:length(temp_stack)
      stack_string = strcat(stack_string,sprintf('%s (%d); ',temp_stack(i_stack).name,temp_stack(i_stack).line));
   end;
   errortext = strcat(errortext,stack_string(1:end-1));
   
   
   error_message_batch(gaitbatch_state.path,gaitbatch_state.myproject,strcat('myerror alert',sprintf(' (Macro: %s): ',gaitbatch_state.makro_datei),errortext));
end;

error(errortext);
lasterr('');