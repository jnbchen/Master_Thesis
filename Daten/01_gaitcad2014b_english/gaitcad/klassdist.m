  function [maxkla, Distanz, hierch_param_hilf, DistMatrix] = klassdist(d,code, zeichnen, Distmass)
% function [maxkla, Distanz, hierch_param_hilf, DistMatrix] = klassdist(d,code, zeichnen, Distmass)
%
%  Funktion berechnet
%  Distanz      :     Maximaler Abstand von Klasse findd(code)i zu den übrigen
%  MaxKla       :     Maximum von Distanz
%  hierch_param_hilf: Parameter für Klassifikation wie Klassenmittelpunkte, Kov.mat., InvKovMat, logdetkov
%  DistMatrix   :     Distanzmatrix
%  Distmass     :     Metrik: 1: Bayes, 2: Divergenz (Kullback-Leibler), 3: min (Div, Kullb.), 4: Bhattacharyya
% 
%
% The function klassdist is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<4 
   Distmass=3; 
end;
if nargin<3 
   zeichnen=0; 
end;

Distanz=[]; 
hilf=1e100.*ones(max(code));	% Wegen späterer Minimumbildung soll in Elementen, die nicht beschrieben werden eine hohe Zahl stehen
dim=size(d,2);

% Berechne Mittelwerte und Klassenkovarianzen der einzelnen Klassen
[kl,su,s,s_invers,log_s]=klf_en6(d,code,0);

% finde die am weitesten entfernte Klasse "maxkla"
for i=findd(code)
   mui=kl(i,:); pkovi = s_invers(dim*(i-1)+1:dim*i,:);  kovi=s(dim*(i-1)+1:dim*i,:);
   for j=findd(code)
      if i<j										% Distanzmatrix ist symmetrisch, deshalb nur eine Hälfte berechnen
         muj = kl(j,:); pkovj = s_invers(dim*(j-1)+1:dim*j,:);  kovj = s(dim*(j-1)+1:dim*j,:);
         if Distmass==1  
            hilf(i,j)= min([(mui-muj)*pkovi*(mui-muj)' (mui-muj)*pkovj*(mui-muj)']);
         elseif Distmass==2 
            hilf(i,j)=0.5*trace((pkovi+pkovj)*(mui-muj)'*(mui-muj)+kovi*pkovj + kovj*pkovi - 2* eye(size(kovi)));	% Kullback-Leibler
         elseif Distmass==3 
            hilf(i,j)= min([(mui-muj)*pkovi*(mui-muj)'+trace(pkovi*kovj) (mui-muj)*pkovj*(mui-muj)'+trace(kovi*pkovj)]);
         elseif Distmass==4 
            %hilf(i,j)= (muj-mui)*pinv(0.5*(kovi+kovj))*(muj-mui)' + 0.5*log(det(/)
         end;
      
      elseif i>j
         hilf(i,j)=hilf(j,i);
      end;
   end;
   Distanz=[Distanz; min(hilf(i,:))];
end;
[maxkla, nr]=max(Distanz);

% sichern von Kovarianzmatrizen, Klassenmittelpunkten et.c
hierch_param_hilf=[{kl} {s} {s_invers} {log_s}];

% Klassenverteilung zeichnen
if zeichnen==1 
   figure; 
   hold on;
   Datensatznummern=0; 
   nummerierung=1; 
   plot_klass; 
end;

if nargout>3 
   for i=1:length(hilf) 
      hilf(i,i)=0; 
   end; 
   DistMatrix=hilf; 
end;