% Script callback_2dhist
%
% Ausgewählte Einzelmerkmale bestimmen
%
% The script callback_2dhist is part of the MATLAB toolbox Gait-CAD. 
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

ind = get(uihd(11,14), 'value');
if (length(ind) == 1)
   mywarning('Plot of qualitative features works only for two selected features!');
   return;
end;

if (length(ind)>2) 
	mywarning('Plot of qualitative features works only for two selected features!');
	return;
end;

if (mode==1) 
   ausgabedaten=code(ind_auswahl);
end;
if (mode==2)
   ausgabedaten=ones(length(ind_auswahl),1);

end;

colorvect = color_style(get(uihd(11,9), 'value'));
recthist_kafka(d_org(ind_auswahl,ind(1)),d_org(ind_auswahl,ind(2)),ausgabedaten,colorvect,dorgbez(ind,:),0,[1 1],zgf_y_bez(par.y_choice,:));
set(gcf, 'Name', sprintf('%d: 2D histogram features %s, %s', get_figure_number(gcf),deblank(dorgbez(ind(1),:)), deblank(dorgbez(ind(2),:))), 'NumberTitle', 'off');

