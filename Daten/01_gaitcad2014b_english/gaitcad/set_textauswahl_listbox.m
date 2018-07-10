  function set_textauswahl_listbox(uihd_element,auswahl_text)
% function set_textauswahl_listbox(uihd_element,auswahl_text)
%
% 
% 
%
% The function set_textauswahl_listbox is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

if uihd_element==0
   myerror('Invalid uihd element!');
   return;
end;

uihd_element_userdata = get(uihd_element,'UserData');
if ~ischar(uihd_element_userdata)
   uihd_element_userdata = 'unknown';
end;

fieldname_err  = sprintf('Element: %s',uihd_element_userdata);
   

if ~strcmp(get(uihd_element,'style'),'listbox') && ~strcmp(get(uihd_element,'style'),'popupmenu')
   mywarning(strcat('The control element is neither a listbox nor a popup menu!',fieldname_err));
   return;
end;

if ~iscell(auswahl_text) || isempty(auswahl_text)
   myerror(strcat('auswahl_text has to be a non-empty cell element!',fieldname_err));
   return;
end;
  
%Stringfeld raussuchen
element_string=get(uihd_element,'string');
if iscell(element_string)
   element_string = char(element_string);
end;



if isempty(element_string)
   myerror(strcat('The element cannot be empty!',fieldname_err));
   return;
end;

%Zahlen entsorgen: 
%1. gibt es vor durchgehende Leerzeichen, Bindestriche oder Ziffern
%wenn ja, dann weg!
ind=find(any( (element_string~=' ') & (element_string~='-') & ( (abs(element_string) <48) | (abs(element_string) >57) ),1)); % Coderevision: &/| checked!
if ~isempty(ind) 
   element_string=element_string(:,ind(1):end);
end;

%avoid problems with empty characters
element_string (find(element_string == 0)) = 32;

%welche Elemente sollen ausgewählt werden ? 
try 
   %necessary for identical behavior for MATLAB 2013a ff. compared to
   %previous behavior
   [muell,ind_auswahl_text,ind_c]=intersect(element_string,char(auswahl_text),'rows','legacy');
catch
   %necessary for downward compatibility for MATLAB 2012b and earlier
   [muell,ind_auswahl_text,ind_c]=intersect(element_string,char(auswahl_text),'rows');
end;


if length(ind_auswahl_text)~=length(auswahl_text)
   awf_errmsg = sprintf('Searching for option figures:\n');
   
   ind_missing  = 1:length(auswahl_text); 
   ind_missing(ind_c) = [];
   
   awf_errmsg = strcat(awf_errmsg,sprintf('%s\n',char(auswahl_text(ind_missing))'));
   awf_errmsg = strcat(awf_errmsg,sprintf('\nin a configuration window with values:\n'));
   awf_errmsg = strcat(awf_errmsg,sprintf('%s\n',element_string'));
   awf_errmsg = strcat(awf_errmsg,fieldname_err);
   awf_errmsg = kill_lz(awf_errmsg);
   if ~strcmp(get(1,'userdata'),'IgnoreErrors')
      save('error_log_selection.mat','element_string','auswahl_text');
      fprintf(1,'%c',awf_errmsg);
      error_message_batch(pwd,'',awf_errmsg);
      myerror(['Inconsistent selection fields (see MATLAB command window for further details)!'...
             'Additional information in the variables element_string and auswahl_text in file error_log_selection.mat.']);
   else
     myerror(['Inconsistent selection fields (see MATLAB command window for further details)!' awf_errmsg]); 
   end;
   
   return;
end;


%avoid an alphabetic sorting of the selected items and restore the original order 
ind_sorted = [];
ind_sorted(ind_c) = ind_auswahl_text;
set(uihd_element,'value',ind_sorted);
