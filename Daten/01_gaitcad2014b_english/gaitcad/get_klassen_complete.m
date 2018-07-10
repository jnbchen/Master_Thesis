  function [code_alle,zgf_y_bez,bez_code] = get_klassen_complete(mystring_cell,old_code,separator_list_cell) 
% function [code_alle,zgf_y_bez,bez_code] = get_klassen_complete(mystring_cell,old_code,separator_list_cell) 
%
% 
% 
%
% The function get_klassen_complete is part of the MATLAB toolbox Gait-CAD. 
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

class_cell = {};
for i_mystring= 1:length(mystring_cell)
   
   if ~rem(i_mystring,20) 
      fprintf('%d \n',i_mystring);   
   end;
   
   mystring = mystring_cell{i_mystring};
   
   for i_sep=1:length(separator_list_cell)
      mystring = strrep (mystring,separator_list_cell{i_sep},'*');
   end;
      
   temp = get_klassen(mystring,'*');
   
   for i_temp=1:length(temp)
      class_cell{i_mystring,i_temp} = temp{i_temp};
   end;
end;

for i=1:size(class_cell,1) 
   for j=1:size(class_cell,2)
      if isempty(class_cell{i,j})
         class_cell{i,j} = 'unknown';
      end;      
   end;
end;


code_alle = zeros(length(mystring_cell),size(class_cell,2));

bez_code = '';
for i_cell = 1:size(class_cell,2)
   
   [zgf_names,b,code_alle(:,i_cell)]= unique(class_cell(:,i_cell));
   for i_zgf=1:length(zgf_names)
      zgf_y_bez(i_cell,i_zgf).name = zgf_names{i_zgf};
   end;  
   bez_code = strvcatnew(bez_code,sprintf('y%d',i_cell));
   
end;

code_alle = code_alle(old_code,:);