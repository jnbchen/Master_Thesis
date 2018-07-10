  function dist_results = compute_dt_distance(d_org,dorgbez,ind_auswahl,nr_dist,parameter,anz_neighbor)
% function dist_results = compute_dt_distance(d_org,dorgbez,ind_auswahl,nr_dist,parameter,anz_neighbor)
%
% 
% function [dat_dist,list_neighbor] = compute_distance(d_org,ind_auswahl,parameter,anz_neighbor)
% compute the distance of al
% 
% 
%
% The function compute_dt_distance is part of the MATLAB toolbox Gait-CAD. 
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

switch parameter.gui.klassifikation.datdistnorm
   case 1
      %Froebnius norm (standard)
      mynorm = 'fro';
      mylength = 1;
   case 2
      %Froebnius norm (weighted to number of selected features)
      mynorm = 'fro';
      mylength = length(parameter.gui.merkmale_und_klassen.ind_em);
   case 3
      %1-norm 
      mynorm = 1;
      mylength = 1;
   case 4
      %1-norm (weighted to number of selected features)
      mynorm = 1;
      mylength = length(parameter.gui.merkmale_und_klassen.ind_em);
   case 5
      %Inf-norm (standard)
      mynorm = Inf;
      mylength = 1;
   case 6
      %Inf-norm (weighted to number of selected features)
      mynorm = Inf;
      mylength = length(parameter.gui.merkmale_und_klassen.ind_em);
end;

if size(ind_auswahl,2) > size(ind_auswahl,1)
   ind_auswahl = ind_auswahl';
end;
if size(nr_dist,2) > size(nr_dist,1)
   nr_dist = nr_dist';
end;

ind_auswahl_orig = ind_auswahl;
ind_auswahl = findd_unsort([ind_auswahl;nr_dist])';
ind_local_dist = find(ismember(ind_auswahl,nr_dist));

%normalization to mean 0 std 1
switch parameter.gui.klassifikation.normierung_merkmale
   case 1
      %Euklidisch
      d_norm = d_org(ind_auswahl,parameter.gui.merkmale_und_klassen.ind_em);
   case 2
      %0-1-Normierung
      d_norm = matrix_normieren(d_org(ind_auswahl,parameter.gui.merkmale_und_klassen.ind_em),2);
   case 3
      %Varianznormierung
      d_norm = matrix_normieren(d_org(ind_auswahl,parameter.gui.merkmale_und_klassen.ind_em),1);
   otherwise
      myerror('Problems by computing distances. Please select a different distance measure');
end;

dist_results.dat_dist = zeros(length(nr_dist),size(d_norm,1));
dist_results.ind_auswahl = ind_auswahl;
dist_results.ind_dist    = nr_dist;
%position of the original features from ind_dist
dist_results.ind_local_dist = ind_local_dist;
%position of the original features from ind_auswahl
dist_results.ind_local_orig = find(ismember(ind_auswahl,ind_auswahl_orig));

dist_results.dorgbez = dorgbez(parameter.gui.merkmale_und_klassen.ind_em,:);

if anz_neighbor == 0 && (length(ind_auswahl)==length(nr_dist)) && all(ind_auswahl == nr_dist)
   % -> all distances to all neighbours in ind_auswahl will be calculated!
   
   %short cut for completely symmetrically matrix (can only be used if nr_dist and ind_auswahl are equal)
   for i=1:size(d_norm,1)-1
      
      if rem(i,10) == 0
         fprintf('%d\n',i);
      end;
      
      for j=i+1:size(d_norm,1)
         dist_results.dat_dist(i,j) = norm(d_norm(ind_local_dist(i),:)-d_norm(j,:),mynorm)/mylength;
      end;
   end;
   dist_results.dat_dist = dist_results.dat_dist + dist_results.dat_dist';
   
else
   
   %longer way
   
   %compute norm
   for i=1:length(ind_local_dist)
      
      if rem(i,10) == 0
         fprintf('%d\n',i);
      end;
      
      for j=1:size(d_norm,1)
         dist_results.dat_dist(i,j) = norm(d_norm(ind_local_dist(i),:)-d_norm(j,:),mynorm)/mylength;
      end;
      
      
      %save neighbor list  --> then only use the nearest neighbours!
      if anz_neighbor>0
         [dist_ind_auswahl,ind] = sort(dist_results.dat_dist(i,:));
         dist_results.list_neighbor{i}.ind  = ind(1:anz_neighbor);
         dist_results.list_neighbor{i}.dist = dist_ind_auswahl(1:anz_neighbor);
      end;
      
   end;
   
end;

