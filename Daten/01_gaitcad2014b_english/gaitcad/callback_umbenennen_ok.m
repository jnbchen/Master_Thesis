% Script callback_umbenennen_ok
%
% Was ist ausgewählt ?
%
% The script callback_umbenennen_ok is part of the MATLAB toolbox Gait-CAD. 
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

for i=2:5 
   ind(i)=get(figure_handle(i,1),'value'); 
end;
new_name=get(figure_handle(6,1),'string'); 

ind_handle_ausgang=12;

%Ergebnisse reinplotten
switch ind(2)
case 1 
   dorgbez=strvcatnew(dorgbez(1:ind(3)-1,:),new_name,dorgbez(ind(3)+1:size(dorgbez,1),:));   
case 2
   zgf_bez(ind(3),ind(4)).name=new_name;
case 3
   bez_code=strvcatnew(bez_code(1:ind(3)-1,:),new_name,bez_code(ind(3)+1:size(bez_code,1),:));       
case 4
   zgf_y_bez(ind(3),ind(4)).name=new_name;
case 5
   var_bez=strvcatnew(var_bez(1:ind(3)-1,:),new_name,var_bez(ind(3)+1:size(var_bez,1),:));   
case 6 %Entscheidungskosten: ldalle und aktuelles ld aktualisieren!!!
   tmp=sscanf(new_name,'%g'); 
   if isnumeric(tmp) 
      L.ld_alle(ind(3)).ld(ind(4),ind(5))=tmp; 
      L.ld=L.ld_alle(get(uihd(11,ind_handle_ausgang),'value')).ld; 
   end; 
case 7
   tmp=sscanf(new_name,'%g'); 
   if isnumeric(tmp) 
      L.lcl(ind(3))=tmp; 
   end;
end;

%Anzeigen aufräumen
if ~isempty(strfind(get(gco,'string'),'Apply'))
   for i=2:5 
      eval(get(figure_handle(i,1),'callback')); 
   end;
end;


