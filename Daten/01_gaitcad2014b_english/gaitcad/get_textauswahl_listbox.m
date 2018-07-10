  function [auswahl_text,auswahl_text_var]=get_textauswahl_listbox(uihd_element)
% function [auswahl_text,auswahl_text_var]=get_textauswahl_listbox(uihd_element)
%
% 
% 
%
% The function get_textauswahl_listbox is part of the MATLAB toolbox Gait-CAD. 
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

if uihd_element==0
   mywarning('Invalid uihd element!');
   return;
end;

if ~strcmp(get(uihd_element,'style'),'listbox') && ~strcmp(get(uihd_element,'style'),'popupmenu')
   auswahl_text = '{}';
   mywarning('The control element is neither a listbox nor a popup menu!');
   return;
end;

%Stringfeld raussuchen
element_string=get(uihd_element,'string');
if iscell(element_string)
   element_string = char(element_string);
end;

%Zahlen entsorgen: 
%1. gibt es vor durchgehende Leerzeichen, Bindestriche oder Ziffern
%wenn ja, dann weg!
ind=find(any( (element_string~=' ') & (element_string~='-') & ( (abs(element_string) <48) | (abs(element_string) >57) ),1)); % Coderevision: &/| checked!
if ~isempty(ind) 
   element_string=element_string(:,ind(1):end);
end;


%welche Elemente sollen ausgewählt werden ? 
ind=get(uihd_element,'value');

auswahl_text='{';
for i=1:length(ind)
   
   if ~isempty(element_string) 
      add_text = deblank(element_string(ind(i),:));
   else 
      add_text = '';
   end;
   
   if isempty(add_text)
      auswahl_text = '{}';
      return;
   end;
   
   
   ind_start  = find(any( (add_text~=' ') & (add_text~='-'),1));  % Coderevision: &/| checked!
   
   %avoid problems if all elements are numbers
   if isempty(ind_start)
      ind_start = 1:size(add_text,2);
   end;
   
   add_text=add_text(:,ind_start(1):end);

   
   auswahl_text=strcat(auswahl_text,sprintf('''%s'',',add_text));
   auswahl_text_var{i}=add_text;
   
end;
auswahl_text=strcat(auswahl_text(1:length(auswahl_text)-1),'}');


