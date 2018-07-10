  function  [masze_baum,py,pu,puy,entr,ent_dec_y]=entropall(cl,class,anz,weights,L,parameter_regelsuche)
% function  [masze_baum,py,pu,puy,entr,ent_dec_y]=entropall(cl,class,anz,weights,L,parameter_regelsuche)
%
%   berechnet informationstheoretische Maße für Entscheidungsbaum
%   masze_baum (ID3 ohne Abschätzung, C4.5 ohne Abschätzung, Id3 mit Abschätzung, C4.5 mit Abschätzung)
%   Ausgangsverteilung py, Eingangsverteilung pu, Verbundwahrscheinlichkeiten puy
%   und Entropien entr=[hu,hud;hy,hyd;huy,huyd;hu_y,huyd;hybedu,huyd;hubedy,huyd];
%   hu Eingangs-, hy Ausgangs-, huy Gesamtentropie, hu_y Transinformation
%   hybedu Irrelevanz, hubedy Rückschlußentropie, hud, hyd, huyd Vertrauensintervalle
%   für qualitatives Datenmaterial in cl-Matrix (2 Spalten)
%   class gibt Klassenanzahl in beiden Spalten an,
%   anzeige (default nicht besetzt) zeigt Entropien an
%   L - struct Entscheidungstheorie (optional)
% 
%
% The function entropall is part of the MATLAB toolbox Gait-CAD. 
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

if size(cl,2)~=2 
   myerror('Format is incompatible');
end;

if (nargin<4) 
   weights=ones(size(cl,1),1);
end;

if (nargin<5) 
   L=[];
end;

if isempty(L) 
   ent_dec_y=[];
end;

if (nargin<6) 
   parameter_regelsuche=[];
end;   

if isempty(parameter_regelsuche)
   sicherheitsintervall=1;
else 
   sicherheitsintervall=5/(100-parameter_regelsuche.stat_absich);
end;

%Anzahl Datentupel
N=sum(weights);

% Änderung Sebastian:
% Verhindert, dass decision_opt_cost mit pu-Vektor kürzer als 
% Anzahl Klassen aufgerufen wird.
% ACHTUNG! Was passiert, wenn 2. Klasse in class(2) nicht die Ausgangsklasse ist??
%if ~isempty(L) class(2)=max(class(2),size(L.ld,2));end; 
% Änderung Ende
%Verbundwahrscheinlichkeiten
%Zeilen u
%Spalten 
%ypuy=zeros(class(1),class(2));

%Rückänderung Ralf (5.9. nach langer Suche!!!)
%die vorherige Variante verurscacht heilloses Chaos,weil sich da die statistische Absicherung ändert!!!!
%class(2) muss also bleiben und nur puy in der Größe angepasst werden
if isempty(L) 
   class_size=class;
else       
   class_size(2)=max(class(2),size(L.ld,2));
end;

%Verbundwahrscheinlichkeiten
%Zeilen u
%Spalten 
puy=zeros(class_size(1),class_size(2));

cl1=cl(:,1);
cl2=cl(:,2); %umständlicher, aber schneller!!
for i=1:class(1) 
   ind=find(cl1==i);
   if ~isempty(ind) 
      for j=1:class(2) 
         puy(i,j)=sum( (cl2(ind)==j).*weights(ind) );
      end;
   end;
end;
puy=puy/sum(sum(puy));

%Klassenwahrscheinlichkeiten u
pu=sum(puy');
%Klassenwahrscheinlichkeiten y
py=sum(puy);

%Gesamtentropie
%alle Werte ungleich Null, alle anderen sind Null wegen Grenzübergang fuer Wahrscheinlichkeit ->0
ind=find(puy);
huye=puy;
huye(ind)=-puy(ind).*log2(puy(ind));
%Durchschnitt
huy=sum(sum(huye));

%Eingansentropie
%alle Werte ungleich Null, alle anderen sind Null wegen Grenzübergang fuer Wahrscheinlichkeit ->0
ind=find(pu);
hue=pu;
hue(ind)=-pu(ind).*log2(pu(ind));
%Durchschnitt
hu=sum(hue);

%Ausgansentropie
%alle Werte ungleich Null, alle anderen sind Null wegen Grenzübergang fuer Wahrscheinlichkeit ->0
ind=find(py);
hye=py;
hye(ind)=-py(ind).*log2(py(ind));
%Durchschnitt
hy=sum(hye);

%Transinformation
hu_y=hu+hy-huy;

%Irrelevanz
hybedu=huy-hu;

%Rückschlußentropie
hubedy=huy-hy;

%Anzahl Klassen (für statistische Abschätzungen)	
anz_class=[length(unique(cl(:,1))) length(unique(cl(:,2)))];

%Abschaetzung Vertrauensintervall Eingangsentropie
hud=(anz_class(1)-1)/2/N/log(2);

%Abschaetzung Vertrauensintervall Ausgangsentropie
hyd=(anz_class(2)-1)/2/N/log(2);

%Abschaetzung Vertrauensintervall Gesamtentropie
huyd=prod(anz_class-1)/2/N/log(2);

masze_baum=zeros(1,7);
%Transinformation / Ausgangsentropie 
if hy>0
   masze_baum(1)=hu_y/hy;
end;

%Transinformation  / Eingangsentropie 
if hu>0 
   masze_baum(2)=hu_y/hu;
end;

%Transinformation (nach unten abgeschätzt mit doppeltem Intervall) / Eingangsentropie (nach oben abgeschätzt mit doppeltem Intervall)
if (hy+2*hyd)>0 
   masze_baum(3)=(hu_y-sicherheitsintervall*huyd)/(hy+sicherheitsintervall*hyd);
end;

%Transinformation (nach unten abgeschätzt mit doppeltem Intervall) / Eingangsentropie (nach oben abgeschätzt mit doppeltem Intervall)
if (hu+2*hud)>0 
   masze_baum(4)=(hu_y-sicherheitsintervall*huyd)/(hu+sicherheitsintervall*hud);
end;

%Entscheidungstheoretische Kostenbewertung
if ~isempty(L)
   py_bed_u=puy'./(ones(class_size(2),1)*pu+1E-99);
   [tmp,cost_offen,relevanz]=decision_opt_cost(L,1,py_bed_u,pu,L.ind_merkmal);
   masze_baum(5:7)=[relevanz.guete_relativ relevanz.guete_relativ_merkmale relevanz.guete_relativ_merkmale_prod];
   
   %Entscheidung mit 1-Prämisse, Vorschlag ET
   ent_dec_y=relevanz.dec_y;
end;

if (nargin>2) 
   if (anz==1)
      fprintf('Classes: %d %d with maximum %d<%d ? \n',class,prod(class),N/10);
      fprintf('Hu                  = %5.3f +- %5.3f\n',hu,hud);
      fprintf('Hy                  = %5.3f +- %5.3f\n',hy,hyd);
      fprintf('Huy                 = %5.3f +- %5.3f\n',huy,huyd);
      fprintf('Mutual information    = %5.3f +- %5.3f\n',hu_y,huyd);
      fprintf('Irrelevance          = %5.3f +- %5.3f\n',hybedu,huyd);
      fprintf('Conclusion entropy   = %5.3f +- %5.3f\n',hubedy,huyd);
      fprintf('Mutual information/Hy (ID3)  = %5.3f +- %5.3f\n',masze_baum(1),masze_baum(1)-masze_baum(3));
      fprintf('Mutual information/Hu (C4.5) = %5.3f +- %5.3f\n',masze_baum(2),masze_baum(2)-masze_baum(4));
      if ~isempty(L)
         fprintf('Costs              = %5.3f (instead of %5.3f) \n',cost_offen,cost_0);
         fprintf('Weighting of costs     = %5.3f \n',masze_baum(5));
      end;%L
   end;%anz
end;%nargin

entr=[hu,hud;hy,hyd;huy,huyd;hu_y,huyd;hybedu,huyd;hubedy,huyd];
