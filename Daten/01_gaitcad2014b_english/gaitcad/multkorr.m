  function [phi_mkorr,merkmal_auswahl,ydach,rele,verfahren]=multkorr(d_org,ykont,anz_merk,quad,var_bez,f,var_nr)
% function [phi_mkorr,merkmal_auswahl,ydach,rele,verfahren]=multkorr(d_org,ykont,anz_merk,quad,var_bez,f,var_nr)
%
% berechnet multiple (lineare+evtl. quadratische zentrierte) Regressionsfaktoren
% d_org - Datensatz
% ykont - kont. Ausgangsgröße
% ind1  - Eingangsgröße
% quad  - quadratische Terme einbeziehn (=1) oder nicht (=0)
% f     - File-Nr. für Dokumentation - 1 Bildschirm
% var_bez  - Variablenbezeichnung
% var_nr  - Variablen-Nummerierung (optional)
% 
%
% The function multkorr is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<7 
   var_nr=1:size(d_org,2);
end;

fprintf('\nCompute multiple regression coefficients...\n');

verfahren=['Univariate multiple regression factors  ';'Multivariate multiple regression factors'];

if (anz_merk==0)
   ydach=ones(size(ykont))*mean(ykont);   
   merkmal_auswahl=[];
   rele=zeros(2,size(d_org,2));
   phi_mkorr=[mean(ykont); zeros(2*size(d_org,2),1)];   
   return;
end;

base=size(d_org,2)+1;
ind1=[1:size(d_org,2)];
ind2=[0:size(d_org,2)];

y=[ykont d_org];
my=mean(y);
y=y-ones(size(y,1),1)*mean(y);

% Quadratische Terme
if (quad>0) 
   for i=1:size(d_org,2) 
      y(:,size(y,2)+1)=y(:,i+1).^2; 
   end;
   my=mean(y);
   y=y-ones(size(y,1),1)*my;
end;

anz_merk=min(anz_merk,size(y,2)-1); 

if anz_merk==0 
   myerror('No selected features or the selected single features are identical to the output variable!');
end;

[g3,n0,rele]=regrred2(y',1,2:size(y,2),anz_merk);

%Wurzel ziehen, damit entsprechen die Relevanzen Korrelationskoeffizienten!
rele=sqrt(abs(rele));  

%Merkmalsrelevanzen aufbereiten
rele=rele+cumsum(rele==0)+(ones(size(rele,1),1)*max(rele)).*(rele==0);
rele=rele([1 size(rele,1)],2:size(d_org,2)+1);


if (quad>0) 
   par1=[base+ind2 2*base+ind1];
else     
   par1=[base+ind2];
end;

a=zeros(anz_merk,anz_merk+1);
for i=1:anz_merk
   a(i,1:i)=y(:,1)'/y(:,n0(1:i,1))';
   y1(:,1)=(a(i,1:i)*y(:,n0(1:i,1))')';
   a(i,anz_merk+1)=1-norm(y(:,1)-y1(:,1),2)^2/norm(y(:,1),2)^2;
end;
a=[[1:anz_merk]' a];   

%Transformationsvektor berechnen
phi_mkorr=zeros(2*size(d_org,2)+1,1);   
X=[ones(size(d_org,1),1) d_org d_org.^2];
X=X(:,[1 n0(:,1)']);
adach=(pinv(X'*X)*X'*ykont);
phi_mkorr([1 n0(:,1)'])=adach; %n0(:,2)   
ydach=X*adach;
merkmal_auswahl=n0(:,1)'-1;

%Dokumentation
if (f)
   linqu=char('(linear)     ','(quadratic)');
   fprintf(f,'\n\nImportance of linear dependencies of %s :\n',var_bez(size(var_bez,1),:));
   ind=rem(par1(n0(1,1)),base);
   fprintf(f,'               %4s (%5d) %s : %+4.3f\n',var_bez(ind,:),var_nr(ind),linqu(floor (par1(n0(1,1))/base),:),n0(1,2));
   for i=2:size(n0,1) 
      ind=rem(par1(n0(i,1)),base);
      fprintf(f,'and additionally %4s (%5d) %s : %+4.3f\n',var_bez(ind,:),var_nr(ind),linqu(floor (par1(n0(i,1))/base),:),n0(i,2));
   end;            
   fprintf(f,'\n');
   
   fprintf(f,'Number of terms;');
   for i=1:size(n0,1) 
      fprintf(f,' %d (%s);    ',var_nr(rem(par1(n0(i,1)),base)),linqu(floor (par1(n0(i,1))/base),2));
   end;            
   fprintf(f,'   Degree of determination R^2\n');
   for i=1:anz_merk 
      fprintf(f,'%13d ',i);
      fprintf(f,'%+9.8f ',a(i,2:size(a,2)));
      fprintf(f,'\n');
   end;
end; %Doku   

fprintf('Offset: %5.3f\n',phi_mkorr(1)); 
fprintf('Ready. \n');

% Unterfunktionen 
function [rk,ret,rele]=regrred2(d,i,j,anz)
%function rk=regrred2(d,i,j)

y=d(i,:)-mean(d(i,:));
n0=[];
for anz1=1:anz 
   dims=[2:anz1+1];
   clear rk;p=1;
   for n=j 
      x=d([n0 n],:);
      s=[y;x]*[y' x'];
      rk(p)=s(1,dims)*pinv(s(dims,dims))*s(dims,1)/s(1,1);p=p+1;
   end;
   [m,ind]=max(rk);
   rele(anz1,j)=rk;      
   n0=[n0 j(ind)]; 
   ret(anz1,:)=[j(ind) sqrt(m)];
   j(ind)=[];
end;

rk=sqrt(rk);

