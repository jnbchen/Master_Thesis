  function list_of_figure_names = callback_plot_all_figures(parameter)
% function list_of_figure_names = callback_plot_all_figures(parameter)
%
% 
% 
%  get all figure handles except the Gait-CAD main window
%
% The function callback_plot_all_figures is part of the MATLAB toolbox Gait-CAD. 
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

figure_handles = setdiff(findobj('type','figure'),1);
if size(figure_handles,1)>size(figure_handles,2)
   figure_handles = figure_handles';
end;

%list of all figure names to avoid overwritten files 
list_of_figure_names = {};

%for all figures
for i_figure=figure_handles
   
   %clear defined pause between images - otherwise problems with wrong order for report 
   pause(0.1);
    
   figure_name = get(i_figure,'name');
   ind_doublepoint = strfind(figure_name,':');
   
   %delete figure number from string
   if ~isempty(ind_doublepoint)  
      if ind_doublepoint(1)<length(figure_name-1) 
         figure_name = figure_name (ind_doublepoint(1)+1:end);
      end;      
   end;
   
    
   %plot all figures in files
   figure_name = repair_dosname(sprintf('%s_%s',parameter.projekt.datei,figure_name));
   figure_name = figure_name (find ( figure_name~=' ' & figure_name~=',' & figure_name~='.')); % Coderevision: &/| checked!
   
   %look for multiple figure names
   
   if any(ismember(figure_name,list_of_figure_names))
      figure_name = [figure_name sprintf('_%d',i_figure)];
   end;
      
   myprint(i_figure,.8,parameter.gui.allgemein.file_type_image,figure_name); 
   list_of_figure_names{end+1} = [figure_name '.' parameter.gui.allgemein.file_type_image]; 
   
end; 



