  function cluster_ergebnis = clustermatlab(d_orgs,d_org,code,parameter)
% function cluster_ergebnis = clustermatlab(d_orgs,d_org,code,parameter)
%
% 
% 
%
% The function clustermatlab is part of the MATLAB toolbox Gait-CAD. 
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

switch parameter.gui.clustern.merkmalsklassen
case 1
   d=d_orgs; 
case 2
   d=d_org;
otherwise
   myerror('A simultaneous clustering of single features and time series using the Statistic Toolbox is not implemented.');
end;

%Trick: einfach Merkmal doppeln, sonst stürzt die Statistik-Toolbox ab!
if size(d,2) == 1
   d=[d d];
end;

%Abstände
switch(parameter.gui.clustern.abstandsmass)
case 1
   c_dist = 'euclid';
case 2
   d = matrix_normieren(d,1);
   c_dist = 'euclid';
case 3
   c_dist = 'mahal';
otherwise
   myerror('This distance measure is not implemented in the Statistic Toolbox'); 
end;

%Fusion für Cluster
switch(parameter.gui.clustern.fusion)
case 1
   fusion = 'single';
case 2
   fusion = 'complete';
case 3
   fusion = 'average';
case 4
   fusion = 'centroid';
case 5
   fusion = 'ward';
end;

if length(parameter.gui.clustern.anzahl_cluster)>1
   parameter.gui.clustern.anzahl_cluster = parameter.gui.clustern.anzahl_cluster(1);
   mywarning(sprintf('For the Statistics Toolbox, the numbers of cluster must be fixed. The number is set to %d.',parameter.gui.clustern.anzahl_cluster));
end;


%Hierarchisches Clustern durchführen
cluster_ergebnis.pdist   = pdist(d,c_dist); 
cluster_ergebnis.linkage = linkage(cluster_ergebnis.pdist,fusion);
[h,t] = dendrogram(cluster_ergebnis.linkage,parameter.gui.clustern.anzahl_cluster);
close(gcf);


%Ergebnis in kompatible Matrix für Fuzzy-Cluster schreiben
cluster_ergebnis.cluster_zgh = zeros(size(d,1),parameter.gui.clustern.anzahl_cluster);
for i=1:parameter.gui.clustern.anzahl_cluster
   cluster_ergebnis.cluster_zgh(find(t==i),i) = 1;
end;
cluster_ergebnis.anz_cluster = max(t);

%Namen für Ausgangsterme
for i=1:cluster_ergebnis.anz_cluster
   cluster_ergebnis.newtermname(i).name  =  sprintf('Cluster %d/%d',i,cluster_ergebnis.anz_cluster); 
end;
%evtl. noch ein unbekanntes Zusatz-Cluster
cluster_ergebnis.newtermname(cluster_ergebnis.anz_cluster+1).name  =  'unknown'; 