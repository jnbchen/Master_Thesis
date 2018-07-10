  function mywarning(warningtext)
% function mywarning(warningtext)
%
%  öffnet errorfenster und bricht Ausführung ab
%
% The function mywarning is part of the MATLAB toolbox Gait-CAD. 
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

persistent warn_state

if isempty(warn_state)
   warn_state=1;
end;

%read macro and path information from base workspace
evalin('base','get_gaitbatch_information');
gaitbatch_state = evalin('base','gaitbatch_state');

if strcmp(get(1,'userdata'),'gaitdebug')
   fprintf('%s\n',warningtext);
   fprintf('%s\n%s\n','Warning in Gait-CAD batch file. Please check the reason with the debugger.','The execution can be continued with return.');
   if warn_state == 1
      keyboard;
   end;
end;


if strcmp(get(1,'userdata'),'IgnoreErrors')
   
   %adding stack information
   temp_stack = dbstack;
   stack_string = sprintf('\n, Stack protocol with files (last command line): ');
   for i_stack = 1:length(temp_stack)
      stack_string = strcat(stack_string,sprintf('%s (%d); ',temp_stack(i_stack).name,temp_stack(i_stack).line));
   end;
   warning_text_message = strcat(warningtext,stack_string(1:end-1));
   
   error_message_batch(gaitbatch_state.path,gaitbatch_state.myproject,strcat('mywarning alert',sprintf(' (Macro: %s): ',gaitbatch_state.makro_datei),warning_text_message));
   lasterr('');
   warn_state=0;
end;


if warn_state==1
   button=questdlg(warningtext,'Warning','Continue','Cancel','Ignore all warnings','Continue');
else
   button='Continue';
end;

switch button
   case 'Continue'
      warning(warningtext);
   case 'Cancel'
      pointer(3);
      error(strcat(sprintf('Canceled by user!\n'),warningtext));
   case 'Ignore all warnings'
      warn_state=0;
      warning off;
end;
