  function myprint(fig,proz,format,name)
% function myprint(fig,proz,format,name)
%
% Beispiel: myprint(10,.66,'bmp','gang_vgl_geschw')
% druckt Figure 10 mit 66 der Größe auf dem Bildschirm in Datei gang_vgl_geschw.bmp
% Tip: besonders kleine Bilder nach Umwandlung in *.jpg mit 256 Farben!!
% epsc druckt Farbbilder !!
% 
%
% The function myprint is part of the MATLAB toolbox Gait-CAD. 
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

if (strcmp(format,'epsc') || strcmp(format,'epsc2')) 
   formatname='eps';
else 
   formatname=format;
end;
try 
   eval(sprintf('set(%d,''PaperUnits'',''Points'');',get_figure_number(fig)));
   eval(sprintf('pos=get(%d,''Position'');',get_figure_number(fig)));
   eval(sprintf('set(%d,''PaperPosition'',%f*[0 0 pos(3) pos(4)]);',get_figure_number(fig),proz));
   eval(sprintf('print -d%s -f%d -r600 %s.%s',format,get_figure_number(fig),name,formatname));
catch 
   mywarning('Error by saving an image');
end;



