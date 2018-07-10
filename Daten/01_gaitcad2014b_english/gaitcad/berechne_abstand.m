  function [u, d, S_clust]=berechne_abstand(abstandsmass, x, v, S_inv, S_inv_b, u, q, S_clust,param)
% function [u, d, S_clust]=berechne_abstand(abstandsmass, x, v, S_inv, S_inv_b, u, q, S_clust,param)
%
%  Ausgelagerte Berechnung der Distanzen für Cluster Vor- und Nach-Bearbeitung
%  während dem Clustern wird aus Geschwindigkeitsgründen diese Funktion NICHT verwendet (viele Daten in x)
%  (Berechnung sollte aber identisch sein)
%  S_clust sind Fuzzy-Kovarianz-Matrizen als array von Matrizen, können optinal mit angegeben werden
%   (dann werden sie auch nicht neu berechnet, z.B. für Cluster-Validierungen)
% 
%
% The function berechne_abstand is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<8
   S_clust=[];
end

if nargin<9
   param.noise_cluster_method = 1;
   param.noise_cluster_factor = 0;
end;


%KORREKTUR RALF:%%%%%%%%%%%%%%%%%%%%%%%%%%%
%jetzt überflüssig: if abstandsmass==13 sum_zgh=sum(sum(u.^q)); end
%ENDE:  KORREKTUR RALF:%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:size(v,2) %gehe durch alle i verschiedenen Clusterzentren
   %Berechne Differenz zwischen ALLEN Datentupeln und dem i-ten Clusterzentren:
   % d_tmp ist vorläufig berechnetes Abstandsmaß
   d_tmp=x-v(:,i)*ones(1,size(x,2));
   
   switch abstandsmass % andere Berechnung der Distanz hat Geschwindigkeitsvorteile, außer case 8
      case {1, 2,7} % schnellst Berechnungsvariante mit Diagonalmatrix
         d(:,i)=sum(S_inv_b.*(d_tmp.^2),1)';
      case {3}
         d(:,i)=diag(d_tmp'*S_inv*d_tmp); % tja, und hier die langsame ausführliche Rechnung
      case 6 % vereinfachter GK
         tmp = sum( (ones(size(x,1),1)*(u(:,i).^q)').*d_tmp.^2 , 2);
         S_inv_gk{i} = diag( prod(tmp)^(1/size(x,1)) ./ tmp );
         d(:,i)=diag(d_tmp'*S_inv_gk{i}*d_tmp);
      case {4,5} % GG und GK
         if size(S_clust)<i
            %avoid numeriacl induced problems
            S_clust{i} = real( d_tmp*diag(u(:,i).^q)*d_tmp' ) / ( sum(u(:,i).^q)  ); % Fuzzy-Kovarianz
            %regularization
            S_clust{i} = S_clust{i} + 1E-99*eye(size(S_clust{i}));
         end
         switch abstandsmass
            case 4 %  % Gustafson-Kessel, GK
               S_inv_gk{i}=(det(S_clust{i})^(1/size(x,1)))*pinv(S_clust{i});
               % Abstand gemäß Cluster-internen Metrik:
               d(:,i)=diag(d_tmp'*S_inv_gk{i}*d_tmp);
            case 5 % GK
               % Wahrscheinlichkeit des Auftretens eines DS innerhlb eines Clusters:
               
               %KORREKTUR RALF:%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %ALT: P_i=sum(u(:,i).^q) /  sum_zgh ; leider falsche Formel...
               P_i=sum(u(:,i)) /  sum(sum(u));
               %ENDE:  KORREKTUR RALF:%%%%%%%%%%%%%%%%%%%%%%%%%%%
               
               % Reziproke Wahrscheinlichkeitsverteilung:
               d(:,i)= (  sqrt( det(S_clust{i}) ) / P_i ) * min(exp( 0.5* diag(d_tmp' * pinv(S_clust{i}) * d_tmp ) ) , 1E+100);
               
         end % switch im switch
   end % switch abstandsmass
end %i

%Abstand genau Null gibt numerische Probleme, wird auf fast Null gesetzt
ind=find(d==0);
d(ind)=1E-10;
ind=find(d>1E+10);
d(ind)=1E+10;

% Das letzte Cluster ist immer das rauschcluster, dessen Abstand ist immer konstant
if param.noise_cluster_factor>0 && param.noise_cluster_method>1
   switch param.noise_cluster_method
      case 2 %Median
         d(:,end) = param.noise_cluster_factor * median(median(d(:,1:size(d,2)-1)));
      case 3 %Mittelwert
         d(:,end) = param.noise_cluster_factor * mean(mean(d(:,1:size(d,2)-1)));
   end;
end;


% d gewichten: (wird für Clusterkriterium nochmals verwendet, daher speichern in neue Variable d_gew):
if q>1
   d_gew= d.^(1/(1-q));
   d_alle_clust= ( d_gew )*ones(size(v,2),1); %Addiere die (gewichteten .^(1/(1-q)) ) Abstände zu allen Clustern auf
   u=( d_gew ) .* ( (1./d_alle_clust) *ones(1,size(v,2)));
else
   %k-means
   u = zeros(size(d));
   %positions of the minima
   [temp,cl_min] = min(d,[],2);
   for i_cl= generate_rowvector(unique(cl_min))
      u(find(cl_min == i_cl),i_cl) = 1;
   end;
end;

%for safety reasons - avoid complex u,
u = real(u);
d = real(d);