  function [Q]=guete_bestldf(parameter, code, d_org, optionen)
% function [Q]=guete_bestldf(parameter, code, d_org, optionen)
%
% Gütefunktion
%
% The function guete_bestldf is part of the MATLAB toolbox Gait-CAD. 
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

if nargin < 4
   optionen=[]; 
end;

d=d_org*parameter;

tmp=[]; 
for i=1:size(parameter,2) 
   tmp=[tmp find(parameter(:,i))'];
end;		% suche besetzte Zeilen
tmp=findd(tmp);

phi_dis_red=zeros(length(tmp),size(parameter,2));
phi_dis_red(:)=parameter(find(parameter));

d_org_red=d_org(:,tmp);  % Achtung, wenn ein parameter 0 ist, dann Fehler

[kl,su,s,s_invers,log_s]=klf_en6(d_org_red,code,0); 

AnzahlKlassen=max((code));								% AChtung, wenn Klassen fehlen !!!!
Dimension=size(phi_dis_red,2);

Erg=1e100;
for i=1:AnzahlKlassen-1
   for j=i+1:AnzahlKlassen
      zaehler=0;
      for k=1:size(phi_dis_red,2)
      	zaehler=zaehler+(phi_dis_red(:,k)'*(kl(i,:)-kl(j,:))')^2;
      end;
      nenneri=0;
      for k=1:Dimension
         s_einz=(s((i-1)*size(s,2)+1:i*size(s,2),:));
         nenneri=nenneri+(phi_dis_red(:,k)'*s_einz*phi_dis_red(:,k));
      end;
      nennerj=0;
      for k=1:Dimension
         s_einz=(s((j-1)*size(s,2)+1:j*size(s,2),:));
         nennerj=nennerj+(phi_dis_red(:,k)'*s_einz*phi_dis_red(:,k));
      end;
		Erg=min([zaehler/nenneri zaehler/nennerj Erg]);
   end;
end;
Q=1/Erg;



