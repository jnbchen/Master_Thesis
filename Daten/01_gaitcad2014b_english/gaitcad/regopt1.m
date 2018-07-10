  function [M,L,f]=regopt1(P,Y,weights,mode)
% function [M,L,f]=regopt1(P,Y,weights,mode)
%
%  REGOPT1 Bestimmung der optimalen Regelgewichtsmatrix M
%  mit M >=0 und sum(M)=1
%  P Matrix der Regelaktivierungen dim(P)=(regel_anz,anz_datentupel)
%  Y Matrix der fuzzifizierten Ausgangsgröße dim(Y)=(anz_terme_y,anz_datentupel)
%  L Langrangematrix dim(L)=dim(M)=(anz_terme_y,regel_anz)
%  f Frobeniusnorm der Matrix der Fehler E=MP-Y (Prognosefehler)
%  mode=2 (optional) verwendet scharfe Termzuodrnung (entspricht bei Summe benachbarten Termen =1 dem alpha-cut 0.5)
% 
%  98-10-19
% gewichtete MKQ vorbereiten
%
% The function regopt1 is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<3) 
   weights=[];
end;	
if (nargin<4) 
   mode=1;
end;	

if isempty(weights) 
   PW=P;
   WOUT=ones(size(Y));
else 
   PW=P.*(ones(size(P,1),1)*weights);
   WOUT=ones(size(Y,1),1)*weights;
end;

anz_terme_y=size(Y,1);
regel_anz=size(P,1);
warnmode=1;

%Schätzung über Diskretisierung (bei benachbarten =1 entspricht dass dem alpha-cut 0.5)
if (mode==2)
   M=1/size(Y,1)*ones(anz_terme_y,regel_anz);
   %welcher Term ist dominant - bei gleichen zufällige Auswahl über Addition Zufallszahl
   % Stets gleiche Zufallstabelle!
   randn('seed',0); 
   [tmp,ind]=max(P+1E-10*randn(size(P)),[],1);
   %y-Zählen über alle Prämissen
   for i=findd(ind)
      M(:,i)=mean(Y(:,find(ind==i)),2);
   end;
   L=zeros(size(M));
   if (nargout==3) 
      f=norm((Y-M*P).*sqrt(WOUT),'fro');
   end;
   return; 
end;


%Schätzung über Diskretisierung (Klassen)
if (mode==3)
  
   %zur Vermeidung von Numerik-Problemen (Division durch Null)
   Y=Y+1E-100;
   P=P+1E-100;
   M=Y*P'./(sum(P,2)*ones(1,size(Y,1)))';
   M=M./(ones(size(M,1),1)*sum(M,1));
   L=zeros(size(M));
   if (nargout==3) 
      f=norm((Y-M*P).*sqrt(WOUT),'fro');
   end;
   return; 
end;


% Zentriermatrix (erzwingt sum(M)=0) 
Z=(eye(anz_terme_y)-ones(anz_terme_y,anz_terme_y)/anz_terme_y);

% MKQ-Loesung mit Einhaltung der NB sum(M)=1
PP=pinv(PW*P');
M=ones(anz_terme_y,regel_anz)/anz_terme_y+Z*Y*PW'*PP;
m=M(:);

% Toleranz fuer Pruefung der Kuhn-Tucker-Bedingungen
tol=-1E-4;

% Lagrangemultiplikatoren
l=zeros(size(m));
% Indexvektor fuer Verletzung der Ungleichungsrestriktion (M>=0)
i = (m < tol);   % Setzen der aktiven Restriktionen
ind = find(i);

if ~isempty(ind)   % Verletzung von Restiktionen
   % Hilfsmatrix, ergibt sich bei Vektorisierung
   C=-1*kron(PP,Z);
   
   %eigentlich Endlosschleife, aber irgendwann ist Feierabend
   for schleife=1:10      
      l=zeros(size(l));
      ind=find(i);
      
      % Berechnung der Lagrangemultiplikatoren
      if ~isempty(ind) 
         l(ind)=pinv(C(ind,ind))*M(ind); 
      end   
      
      while 1        
         % Test auf Verletzung der KT-Bedingung bez.
         % Lagrangemultiplikatoren
         [tmp,ind_kl] = min(l);
         if tmp>tol 
            break;
         end;
         
         % deaktivieren der Restriktion die auf
         % den kleinsten (und notwendigerweise negativen) Lagrangemultiplikator fuehrt
         i(ind_kl) = 0;   
         
         % Neuberechnung der Lagrangemultiplikatoren
         ind=find(i);                            
         l=zeros(size(l));
         l(ind)=pinv(C(ind,ind))*M(ind);   
      end;
      
      % Neuberechnung der vektorisierten Regelgewichtsmatrix
      m = M(:) - C*l;       
      
      % Pruefen, ob weiterhin Restriktionen verletzt werden, wenn nicht dann raus
      [tmp,ind] = min(m);   
      if (tmp>=tol) 
         break; 
      end;
      
      %alle verletzten Restriktionen eintragen
      i=i+( m<tol );
   end;  
else schleife=0;      
end

% Pruefen, ob KT-Bedingungen erfuellt sind
if (m'*l>abs(tol))&warnmode  
   disp('Kuhn-Tucker-conditions not achieved!');
end;

%Null setzen, um numerische Probleme mit -1E-8 usw. zu vermeiden
ind=find(m<0); 
if ~isempty(ind) 
   m(ind)=zeros(size(ind));
end;
ind=find(m>1); 
if ~isempty(ind) 
   m(ind)=ones(size(ind)); 
end;

% Schleifenabbruch ?
if (schleife>9)&warnmode  
   disp('Iteration does not converge! Select suboptimal solution!'); 
end;

L=reshape(l,anz_terme_y,regel_anz);   % Lagrangematrix
M=reshape(m,anz_terme_y,regel_anz);   % Regelgewichtsmatrix

%Frobeniusnorm der Matrix der Fehler (Prognosefehler)
%nur wenn angefordert
if (nargout==3) 
   f=norm((Y-M*P).*sqrt(WOUT),'fro');
end;

