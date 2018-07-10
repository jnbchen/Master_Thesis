  function [c2,newrule]=c2_compp(rule_dat,par,plaus)
% function [c2,newrule]=c2_compp(rule_dat,par,plaus)
%
%   berechnet c2-Matrix für Regelbasis rule_dat (Nullspalten werden weggelassen)
%   mit Regelplausibilitäten plaus und gibt erweiterte Regelbasis mit überdeckenden Teilregeln zurück
%   ACHTUNG !
%     - Regelbasis muß vorher mittels plaus2plav in volle Regelstruktur umgewandelt werden !!!
%     - plaus==0 bedeutet eine automatische Berechnung von Regelplausibilitäten, bei der
%       Default-Regeln eine Plausibilität von Null, alle anderen Regel eine Plausibilität von Eins erhalten
% 
%    plaus==0 bedeutet eine automatische Berechnung von Regelplausibilitäten, bei der
%    Default-Regeln eine Plausibilität von Null, alle anderen Regel eine Plausibilität von Eins erhalten
%    Default-Regeln sind durch Eins-Zeilen gekennzeichnet !
%
% The function c2_compp is part of the MATLAB toolbox Gait-CAD. 
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

if (plaus==0) plaus=~min(rule_dat')'+1E-100; 
              end; 

%UND-Verknüpfung über Variablen wird vorbereitet, indem eine Matrix form aufgestellt wird
%Im Ergebnis wird später elementeweise (alle Terme aller Variablen) multipliziert
%(z.B. U1=MI in Regelprämisse und als fuzzifiziertes Meßergebnis).
%Bei Regeln mit abgeleiteten Termen (z.B. U1=MI ODER GR in Regelprämisse und im fuzzifizierten Meßwert)
%sind die Teilergebnisse zu addieren (=1, wenn Meßwert zwischen MI und GR)
%(Kronecker-Multiplikation erzeugt die Formmatrix zur Addition)
%i.-te  Spalte hat Einsen zwischen (max. Anzahl Terme)*(i-1)+1 und (max. Anzahl Terme)*i, sonst Nullen 
form=sparse(1:size(rule_dat,2),kron([1:par(2)],ones(1,size(rule_dat,2)/par(2))),1,size(rule_dat,2),par(2));

%C2-Matrix, zunächst Einheitsmatrix nach Regelanzahl
c2=eye(size(rule_dat,1));

%ANSATZ für sparse-Behandlung ist ausgeklammert !!
%c2=sparse(1:size(rule_dat,1),1:size(rule_dat,1),ones(size(rule_dat,1),1));

%immer dann, wenn Schnittmenge nicht leer, wird neue Spalte an C2-Matrix angehangen 
%und neue Regel für die Schnittmenge gebildet
%kombi_ind ist Nr. der maximalen beteiligten Regel in den Schnittmengen
%c2_kombi ist anzuhängender Teil an die c2-Matrix
%Start mit originaler Regelbasis in kombi, Nummer der Regel in kombi_ind und c2 in c2_kombi
kombi=rule_dat;
kombi_ind=[1:size(rule_dat,1)];
c2_kombi=c2;

rule_dat_neu=[];


%j - Anzahl beteiligter (Basis-)Regeln in Schnittmengen der alten Regeln
for j=1:size(rule_dat,1) 

      %Regeln mit j+1 Kombinationen werden aufgebaut
      kombi_neu=zeros(size(rule_dat,1)^2,size(kombi,2));
      kombi_ind_neu=[];

      %Anzahl neuer, kombinierter Regeln in kombi
      l=1;

      %hinten versuchsweise neue Regel anhängen, immer nur mit höherer Regel-Nr.
      %Ausgangspunkt: alle Regeln der vorhergenden Generation in kombi (Zähler i)
      %neu angehangen: alle Regeln mit Nummern > kombi_ind(i) (Zähler k)
      for i=1:size(kombi,1)
          for k=kombi_ind(i)+1:size(rule_dat,1)  

              %Nr. neue Regel (k), alte UND-Verknüpfung (i) mit j Kombinationen
              %Vorbereitung für neue UND-Verknüpfung und C2-Berechnung
              kombi_ind_neu(l,:)=[k i];                 %Indizes merken 
              kombi_neu(l,:)=kombi(i,:).*rule_dat(k,:); %neue Regel
              l=l+1; 
              end;
          end;  

      %Abbruch (keine komplexeren UND-Verknüpfungen, wenn 
      % - alle Terme enthalten l==1 oder
      % - kombi_neu ist leer 
      if (l==1) break;end;
      kombi_neu=kombi_neu(1:l-1,:);
      
      %wo gibt es nicht leere Mengen?
      var_besetzung=kombi_neu*form;
      %Fallunterscheidung MATLAB-Bug, wenn nur noch eine ling. Variable
      if size(var_besetzung,2)>1 tmp=find(prod(var_besetzung'));
         else                    tmp=find(var_besetzung');
         end;
         
      %Abbruch (keine komplexeren UND-Verknüpfungen, wenn 
      % - bereits vorherige Menge leer isempty(tmp)   
      if isempty(tmp) break;end;

      %neue c2-Teilmatrix mit j+1 Kombinationen, aber noch ohne Wichtung
      %Werte in c2_kombi werden eingetragen (neue Regeln in den Schnittmengen mit j+1 Regeln)
      %nur eine Besetztheitsstruktur mit Werten 0-1
      c2_kombi=(c2_kombi(:,kombi_ind_neu(tmp,2))>0)+sparse(kombi_ind_neu(tmp,1),1:length(tmp),ones(size(tmp)),size(c2_kombi,1),length(tmp));
 
      %neue Generation 
      kombi=kombi_neu(tmp,:);
      kombi_ind=kombi_ind_neu(tmp,1);
      rule_dat_neu=[rule_dat_neu;kombi]; 

      %neue Spalten anhängen und mit Werten versehen
      %dabei werden abzuziehende Werte mit den inversen Plausibilitäten versehen 
      %und es wird auf Gesamt-Plausibilitäten aller beteiligten Regeln von Eins 
      %gewichtet
      c2_kombi=c2_kombi.*(1./plaus*ones(1,size(c2_kombi,2)));
      c2_kombi=c2_kombi./( ones(size(c2_kombi,1),1)*sum(c2_kombi));
      c2=[c2 c2_kombi*(-1)^j];     	       
      end;

newrule=[rule_dat;rule_dat_neu];
