  function b=m_to_tex(a,format,file,varname)
% function b=m_to_tex(a,format,file,varname)
%
% druckt Matrix a als MATLAB-Formel in align-Umgebung mit Variablenname varname in file f
% und verwendet dabei das Zahlenformat format, z.B. Flieﬂkommazahl '5.3f'
% Beispiel:  m_to_tex(eye(2),'5.3f',1,'a');
%
% The function m_to_tex is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<3)
   file=1;
end;
if (nargin<4)
   varname='x';
end;

fprintf(file,'\\begin{align}\n');
fprintf(file,'\\bm{%s}=\n',varname);
fprintf(file,'\\begin{pmatrix}\n');
for i=1:size(a,1)
   eval(sprintf('fprintf(file,''%%%s & '',a(i,1:size(a,2)-1));',format));
   eval(sprintf('fprintf(file,''%%%s '',a(i,size(a,2)));',format));
   fprintf(file,'\\\\ \n');
end;
fprintf(file,'\\end{pmatrix}\n');
fprintf(file,'\\end{align}\n');