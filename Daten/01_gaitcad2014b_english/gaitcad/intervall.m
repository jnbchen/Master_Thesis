  function [stat_rele,p]=intervall(p_mean,N,absich)
% function [stat_rele,p]=intervall(p_mean,N,absich)
%
% schätzt das Vertrauensintervall p der Wahrscheinlichkeit einer
% binomialverteilten Größe mit einer Schätzung p_mean (z.B. M Erfolgen / N Versuchen)
% bei insgesamt N Versuchen
% 
% Relevanz stat_rele gegenüber der letzten Regel entweder positiv (Regel ist
% signifikante positive Regel), negativ (Regel ist signifikante negative Regel)
% oder Null (keine signifikanten Unterschiede)
%
% The function intervall is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<3) 
   absich=0.05;
end;
if max(p_mean>1)||max(p_mean<0)||max(N<0)||(absich<0)||(absich>1) 
   myerror('Wrong operation value!');
end;         

%Runden, sonst numerisches Chaos!!
p_mean=round(p_mean.*N)./max(N,1);

%Vertrausensintervall alpha berechnen 
%Division durch 2 rausgenommen, um Kompatibilität zu binofit zu erhalten
if absich<0.5 
   s_niv=1-absich;
else
   s_niv=absich;
end;

s_niv_links =1-((1-s_niv) -2*(0.5-p_mean)*(1-s_niv));
s_niv_rechts=1-((1-s_niv) +2*(0.5-p_mean)*(1-s_niv));


% Quantile der Standardnormalverteilung
%gamma  =[1 .99    .98    .975  .95    .9     .8    .7     .6   .5];
%u_gamma=[5 2.3263 2.0537 1.96  1.6449 1.2816 0.8416 .5244 0.2533 0];
n_gamma  =[0 0.5 0.6    0.7    0.8    0.9    0.95   0.975 0.98   0.99   0.999  0.9999 0.99999 0.999999 0.999999 0.999999 1]';
u_gamma=  [0 0   0.2533 0.5244 0.8416 1.2816 1.6449 1.96  2.0537 2.3263 3.0902 3.7190 4.2649  4.7534   5.1993   5.6120   7.6520 ]';
%Schranken berechnen (links)
uges=interp1q(n_gamma,u_gamma,[s_niv_links s_niv_rechts]')';

%in M-N-Form überführen
M=N.*p_mean;

%Übergabewerte initialisieren
p=[zeros(1,length(N));ones(1,length(N))];
stat_rele=zeros(size(N));

%untere Schranke berechnen
u=uges(1:length(s_niv_links));
c=(u.^2-3)/6;

%dabei unsinnige Werte verhindern, die auf Nenner<=0 , neg. Wurzekln usw. führen 
ind=find((M>=1)&(N>1));  % Coderevision: &/| checked!

%Hilfsgroessen
n1=2*(N(ind)-M(ind)+1);
n2=2*M(ind);
d=1./(n1-1)+1./(n2-1);
e=1./(n1-1)-1./(n2-1);
a=sqrt(2*d+c(ind).*d.^2);
b=2*e.*(c(ind)+5/6-d/3);
F1=exp(u(ind).*a-b);
p(1,ind)=M(ind).*1./F1./(N(ind)-M(ind)+1+M(ind)./F1);

%obere Schranke berechnen, 
u=uges(length(s_niv_links)+1:length(uges));
c=(u.^2-3)/6;

%dabei unsinnige Werte verhindern, die auf Nenner<=0 , neg. Wurzeln usw. führen 
ind=find((M<=(N+1))&(N>1));   % Coderevision: &/| checked!
%Hilfsgroessen
n1=2*(M(ind)+1);
n2=2*(N(ind)-M(ind));
d=1./(n1-1)+1./(n2-1);
e=1./(n1-1)-1./(n2-1);
a=sqrt(2*d+c(ind).*d.^2);
b=2*e.*(c(ind)+5/6-d/3);
F2=exp(u(ind).*a-b);
p(2,ind)=(M(ind)+1).*F2./(N(ind)-M(ind)+(M(ind)+1).*F2);

%positive Regeln
nenner=p(2,length(N))-p(1,:)+p_mean-p_mean(length(N));
ind=find(nenner&(p_mean>p_mean(length(N))));
stat_rele(ind)=1-1./max(1,(p_mean(ind)-p_mean(length(N)))./nenner(ind));

%negative Regeln
nenner=p(2,:)-p(1,length(N))-p_mean+p_mean(length(N));
ind=find(nenner&(p_mean<p_mean(length(N))));
stat_rele(ind)=stat_rele(ind)+1./max(1,(p_mean(length(N))-p_mean(ind))./nenner(ind))-1;
