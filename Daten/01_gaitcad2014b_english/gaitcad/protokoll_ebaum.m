  function protokoll_ebaum(dectree,datei)
% function protokoll_ebaum(dectree,datei)
%
% script protokoll_ebaum
% Visualisiert Entscheidungsbaum-Interna in TEX-Datei
%
% The function protokoll_ebaum is part of the MATLAB toolbox Gait-CAD. 
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

f_baum_name=sprintf('%s_tree.tex',datei);
f_baum=fopen(f_baum_name,'wt');
fprintf(f_baum,'\\clearpage\n\\section{Decision trees}\n');
fprintf(f_baum,'Tree design: %s\n\n',dectree.verfahren_baum);
for i=1:size(dectree.texprot,2) 
   if ~isempty(strfind(dectree.verfahren_baum,'Class-specific')) && (i>1)
      dectree.texprot(i).name=sprintf('%s ($B_1:=\\bar{B_{%d}}, B_2:=B_{%d} $)',dectree.texprot(i).name,i-1,i-1);
   end;
   %immer mit Supertab - sonst Chaos!!
   textable(dectree.texprot(i).kopf,dectree.texprot(i).tabtext,dectree.texprot(i).name,f_baum,1);
end;
fclose(f_baum);
viewprot(f_baum_name);
