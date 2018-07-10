  function [code_alle,zgf_y_bez,bez_code,y_choice,L]=addnewoutput_cluster(code_alle,zgf_y_bez,bez_code,L,pos,param,cluster_ergebnis)
% function [code_alle,zgf_y_bez,bez_code,y_choice,L]=addnewoutput_cluster(code_alle,zgf_y_bez,bez_code,L,pos,param,cluster_ergebnis)
%
% The function addnewoutput_cluster is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:56
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

anz_cluster_pos=max(pos); %wegen möglicher Clusterzuweisung zu nicht getesteten Datentupeln...
y_choice=1;
anz_cluster=cluster_ergebnis.anz_cluster;

%Ausgangsklasse anhängen ? 
switch param.clusterausgangsgroesseanhaengen
case 1 %immer
   [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,pos,sprintf('Cluster_%d',anz_cluster),cluster_ergebnis.newtermname);
   y_choice=size(code_alle,2);    
   
case 2 %neue Clusteranzahl
   %Welche Ausgangsklassen gibt es bereits? 
   [tmp,ind]=unique(bez_code,'rows');
   tmpcluster=sprintf('Cluster_%d',anz_cluster);
   [tmp,tmppos]=intersect(tmp,{tmpcluster});
   if isempty (tmppos) 
      %dann anhängen...
      [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,pos,sprintf('Cluster_%d',anz_cluster),cluster_ergebnis.newtermname);
      %und diese Klasse gleich wählen...
      y_choice=size(code_alle,2);
   else 
      %wenn es die schon gibt, dann überschreiben
      y_choice=ind(tmppos(1));
      code_alle(:,y_choice)=pos;
   end;
   
   %sonst u.U. kritisch wegen Rauschcluster oder nicht, zur Sichergheit überschreiben
   zgf_y_bez(y_choice,anz_cluster).name = cluster_ergebnis.newtermname(anz_cluster).name;
   %case 3: nie: da ist nichts zu tun...   
end;

if param.clusterausgangsgroesseanhaengen<3 
   if anz_cluster_pos>anz_cluster 
      zgf_y_bez(y_choice,anz_cluster_pos).name='nicht_getestet';
   end;
end;
