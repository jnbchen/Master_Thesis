  function [zgf,anz_term]=fuzcluster(values,anz_fuzzy)
% function [zgf,anz_term]=fuzcluster(values,anz_fuzzy)
%
% The function fuzcluster is part of the MATLAB toolbox Gait-CAD. 
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

zgf=zeros(1,anz_fuzzy);
anz_term=anz_fuzzy;

%Probleme bei wenige Termen, bei denen der größte kleiner Null ist...
if (max(values)<0) 
   zgf=max(values-1);
end;

%alle Werte im Datensatz - und nur die werden übergeben!!
tmp=findd(values)';

if (length(tmp)>anz_fuzzy)
   %Clustern, wenn mehr Werte als Stützpunkte - jetzt mit definierter Verteilung!!
   %1 []:    keine Zeitreihen 
   %2 tmp:   Daten
   param.anz_c_zentr_vek=anz_fuzzy;
   param.max_iteration=50;
   param.video=1;
   param.c_zentr_opt = 2;
   cluster_ergebnis=clusterkafka([], tmp, ones(length(tmp),1),param);
   zgf=sort(cluster_ergebnis.cluster_zentren);
else 
   anz_term=length(tmp);
   zgf(1:length(tmp))=tmp;   
end;

