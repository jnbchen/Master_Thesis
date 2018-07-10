% Script repair_outputterms
%
% HANDLING OF OUTPUT TERMS
%
% The script repair_outputterms is part of the MATLAB toolbox Gait-CAD. 
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

warning_counter = 0;
for i_output=1:size(zgf_y_bez,1)
   
   %handling of empty terms, otherwise problems with []
   ind = find(all(char(zgf_y_bez(i_output,1:par.anz_ling_y(i_output)).name)' == 32));
   for i_empty = 1:length(ind)
      zgf_y_bez(i_output,ind(i_empty)).name ='';
   end;
   
   for i_term = 1:par.anz_ling_y(i_output)
      zgf_y_bez(i_output,i_term).name = kill_lz(zgf_y_bez(i_output,i_term).name);
   end;
   
   %which output terms exist
   [temp_bez,ind_bez,ind_bez_neu]=unique({zgf_y_bez(i_output,1:par.anz_ling_y(i_output)).name});
   
   
   if length(temp_bez) ~= length(ind_bez_neu) || isempty(temp_bez{1}) || isempty(temp_bez{end})
      if warning_counter == 0
         fprintf('Some terms of the output variables are double or are empty! These term names will be repaired!');
         warning_counter = 1;
      end;
      
      
      for i_term = 1:par.anz_ling_y(i_output)
         if i_term <= length(ind_bez)
            if ~isempty(temp_bez{i_term})
               zgf_y_bez(i_output,i_term).name = temp_bez{i_term};
            else
               zgf_y_bez(i_output,i_term).name = 'unknown';
            end;
         else
            zgf_y_bez(i_output,i_term).name = '';
         end;
      end;
      
      %write a decoding table for the conversion to the term numbers in all
      umkodierungstabelle=zeros(par.anz_ling_y(i_output),1);
      umkodierungstabelle(1:length(ind_bez_neu))=ind_bez_neu;
      
      %apply modified term numbers
      code_alle(:,i_output) = umkodierungstabelle(code_alle(:,i_output));
      par.anz_ling_y(i_output) = length(ind_bez);
   end;
end;

%look
if exist('var_bez','var') && ~isempty(var_bez)
   ind_empty = find(all(var_bez == 32,2));
   if ~isempty(ind_empty)
      fprintf('Some %s have an empty name! These names will be repaired!','Time series (TS)');
      temp = string2cell(var_bez);
      for i_empty = generate_rowvector(ind_empty)
          temp{i_empty} = sprintf('x%d',i_empty);
      end;
      var_bez = char(temp);
   end;   
end;

if exist('dorgbez','var') && ~isempty(dorgbez)
   ind_empty = find(all(dorgbez == 32,2));
   if ~isempty(ind_empty)
      fprintf('Some %s have an empty name! These names will be repaired!','Single features');
      temp = string2cell(dorgbez);
      for i_empty = generate_rowvector(ind_empty)
          temp{i_empty} = sprintf('x%d',i_empty);
      end;
      dorgbez = char(temp);
   end;   
end;

if exist('bez_code','var') && ~isempty(bez_code)
   ind_empty = find(all(bez_code == 32,2));
   if ~isempty(ind_empty)
      fprintf('Some %s have an empty name! These names will be repaired!','Output variables');
      temp = string2cell(bez_code);
      for i_empty = generate_rowvector(ind_empty)
          temp{i_empty} = sprintf('x%d',i_empty);
      end;
      bez_code = char(temp);
   end;   
end;


clear i_output i_empty ind temp_bez inde_bez ind_bez_neu i_term umkodierungstabelle warning_counter