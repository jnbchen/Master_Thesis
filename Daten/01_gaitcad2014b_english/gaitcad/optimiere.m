  function parameter = optimiere(parameter,change, code, d_org, Schrittweite, Zielfunktion, Ausgabe, Q_end, optionen)
% function parameter = optimiere(parameter,change, code, d_org, Schrittweite, Zielfunktion, Ausgabe, Q_end, optionen)
%
%    Aufruf:
%      change_param=find(par(:,1))*ones(1,size(par,2));              Parameter, die optimiert werden dürfen
%      par=optimiere(par,change_param, code, d, 1, 'guete_svm');                     neuen Transformationsvektor aus altem TV berechnen
%    parameter=optimiere(parameter,change)
%    parameter:Parametervektor oder -matrix
%    change:    Elemente des Vektors parameter, an denen geändert werden darf
%    Schrittweite: Parameteränderung in Prozent
%    Zielfunktion: Guetekriterium
%
% The function optimiere is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<5
    Schrittweite=1; 
end;
if nargin<6 
    Zielfunktion='guete_bestklass_g'; 
end;
if nargin<7 
    Ausgabe=1; 
end;
if nargin<8 
    Q_end=1E-3; 
end;
if nargin<9 
    optionen=[]; 
end;

%Startgütewert
Q_old=1E100;

if ~isempty(change)
   
   % einzelne Spaltenvektoren werden optimiert, gesamte Parametermatrix wird übergeben
   for i=1:size(parameter,2)	
      %ÄNDERUNG Sebastian (30.09.05): Strukt optionen enthält Distanzmaß
      %parameter = opt_lokal_grad(parameter,size(parameter,1)*(i-1)+change(:,i), code, d_org, Schrittweite, Zielfunktion, Ausgabe, Q_end);
      parameter = opt_lokal_grad(parameter,size(parameter,1)*(i-1)+change(:,i), code, d_org, Schrittweite, Zielfunktion, Ausgabe, Q_end, optionen);
      if (Ausgabe==1) 
         fprintf('\n%i.th vector optimised\n', i);   
      end;
   end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%% Modifiziere Parametersatz %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=opt_lokal_grad(x, change, code, d_org, Schrittweite, Zielfunktion, Ausgabe, Q_end, optionen)	%ÄNDERUNG Sebastian (30.09.05): Strukt optionen enthält Distanzmaß
% x=opt_lokal_grad(x,change)
% x: 			Parametervektor bzw. -matrix
% change: 	Elemente des Vektors x, an denen geändert werden darf

Q_start=1E250;			% Startgütewert
Q_old=berechne_guete(x, code, d_org, Zielfunktion, optionen);

spaltenzaehler=0;


% Solange Fortschritt vorhanden
while (Q_start-Q_old)>Q_end 
   Q_start=Q_old;
   v=ones((size(x)));								% relativer Änderungsgradient
   for j=1:length(change)
      i = change(j);									% Nur mit den Elementen arbeiten, die optimiert werden dürfen
      
      %ein Stück größer
      xmod1=x;
      xmod1(i)=xmod1(i)*(1+Schrittweite/100);
      Q(1)=berechne_guete(xmod1, code, d_org, Zielfunktion, optionen);	
      
      %ein Stück kleiner
      xmod2=x;
      xmod2(i)=xmod2(i)*(1-Schrittweite/100);
      Q(2)=berechne_guete(xmod2, code, d_org, Zielfunktion, optionen);	
      
      %Vorzeichenumkehr
      xmod3=x;
      xmod3(i)=xmod3(i)*(-1);
      Q(3)=berechne_guete(xmod3, code, d_org, Zielfunktion, optionen);		      
      
      if isempty(find(min(Q))) 
         warning('Performance value in Optimiere.m is declined on equal value respectively zero');  
      end;
      
      
      [Q_old,ind]=min([Q_old Q(1:3)]);
      
      %Werte anzeigen
      if (Ausgabe==1) 
         if ind~=1 
            fprintf('Fitness value: %1.3f\n',Q(find(min(Q)))); 
            spaltenzaehler=0;
            save opt_backup.dat -mat x; 
         else
            fprintf('.');
            spaltenzaehler=spaltenzaehler+1;
            if spaltenzaehler==20 
               fprintf('\n');
               spaltenzaehler=0;
            end;
         end;    
      end;
            
      
      if ind==2 
         x=xmod1;
         v(i)=(1+Schrittweite/100);
      end;
      
      if ind==3 
         x=xmod2;
         v(i)=(1-Schrittweite/100);
      end;
      
      if ind==4 
         x=xmod3;
         v(i)=-1;         
      end;
   end;  
   
   grad=1;
   
   while grad ==1				% Solange in dieselbe Richtung laufen, wie sich Ergebnis verbessert
      xmod=x.*v;
      %ÄNDERUNG Sebastian (30.09.05): Strukt optionen enthält Distanzmaß
      Q=berechne_guete(xmod, code, d_org, Zielfunktion, optionen);
      
      deltaQ=Q_old-Q; 
      
      [Q_old,ind]=min([Q_old Q]);
      
      if ((ind==1) || ((ind==2) && (deltaQ<Q_end))) 
         grad=0; 	% wenn sich nichts verändert oder Änderung zu klein
      else 
         x=xmod; 
      end;				
   end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gütefunktion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Q]=berechne_guete(parameter, code, d_org, Zielfunktion, optionen)	
% [Q]=berechne_guete(parameter, code, d_org, Zielfunktion, optionen)	

eval(sprintf('Q=%s(parameter,code,d_org,optionen);', Zielfunktion));

