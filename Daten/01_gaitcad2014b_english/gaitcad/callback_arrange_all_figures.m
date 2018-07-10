  function callback_arrange_all_figures(mode)
% function callback_arrange_all_figures(mode)
%
% 
% 
%  get all figure handles except the Gait-CAD main window
%
% The function callback_arrange_all_figures is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

if isempty(figure_handles)
   return;
end;


displacement = 25;
head_height = 90;

%screensize
local_screensize = get(0,'screensize');
pos_vector = get(figure_handles(end),'position');

%for all figures
for i_figure=1:length(figure_handles)
   
   switch(mode)
   case 1
      %Cascade   
      set(figure_handles(i_figure),'position',[1+displacement*i_figure local_screensize(4)-50-displacement*(i_figure-1)-pos_vector(4)-head_height pos_vector(3:4)]);
   
   case 2 
      %Horizontal
      figure_width = local_screensize(3)/length(figure_handles);
      set(figure_handles(i_figure),'position',[1+figure_width*(i_figure-1) 100 figure_width-10 local_screensize(4)-100-head_height]);
      
   case 3
      %Vertical
      figure_height = (local_screensize(4)-100)/length(figure_handles);
      set(figure_handles(i_figure),'position',[1 100+figure_height*(i_figure-1) local_screensize(3)-1 figure_height-head_height]);
      
   case 4
      %Position of last figure
      set(figure_handles(i_figure),'position',pos_vector);          
   end;

   
   
   %show figures
   
   figure(figure_handles(i_figure));
end; 



