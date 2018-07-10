% Script autoreport_picturelist
%
% sort picture list be time
%
% The script autoreport_picturelist is part of the MATLAB toolbox Gait-CAD. 
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

picture_time =[];
for i_picture = 1: length(picture_list)
   temp = dir(picture_list(i_picture).name);
   picture_time(i_picture) = datenum (temp.date);
end;
[temp,picture_time] = sort(picture_time); 

k=0;
for i_picture = picture_time
   if (k==0) 
      fprintf(f_tex,'\n\\clearpage\n');
      fprintf(f_tex,'\n\\subsection{Figures}\n');
   end;        
   
   
   k=k+1;
   
   %jpeg file?
   if strcmp(parameter.auto_report.picture_type,'jpeg')
      %get width and height from jpeg
      mystyle = crack_jpg(picture_list(i_picture).name,parameter.auto_report.picture_style);
   else
      %hope for a standard form
      mystyle = parameter.auto_report.picture_style;
   end;                 
   %plot figure commands into tex
   plot_tex_figure(f_tex,picture_list(i_picture).name,mystyle);         
   
   %elsewhere to many floats
   if rem(k,10)==0 
      fprintf(f_tex,'\n\\clearpage\n');
   end;
end;