  function [zgf,zgf_bez,par_kafka]=zgf_en(d,parameter_regelsuche,par)
% function [zgf,zgf_bez,par_kafka]=zgf_en(d,parameter_regelsuche,par)
%
%  entwirft Zugehörigkeitsfunktionen für Einzelmerkmale in d entsprechend der Parameter in
%  parameter_regelsuche
%  besonders wichtig:
%  parameter_regelsuche.anz_zgf  - Anzahl der Linguistischen Terme
%  parameter_regelsuche.type_zgf - Typ ZGF
%     =1 Median (mit Interpretierbarkeit)
%     =2 Median (ohne Interpretierbarkeit)
%     =3 Gleichverteilt
%     =4 Clustern
%     =5 Clustern (mit Interpretierbarkeit)
%
% The function zgf_en is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

if nargin<3
   par=[];
   par_kafka=[];
end;

fmon=1;

if ~isempty(find(isnan(d)))
   myerror('Problems with missing values (NaN)!');
end;

if ~isempty(find(isinf(d)))
   myerror('Problems with infinite values!');
end;


%Automatische oder freie ZGF
fprintf('Design of membership functions\n');

%Leersetzen und Ausgangs-ZGF vorbereiten
zgf=zeros(size(d,2),parameter_regelsuche.anz_fuzzy);
if ~isempty(par)
   zgf(end+1,1:par.anz_ling_y(par.y_choice))=1:par.anz_ling_y(par.y_choice);
else
   zgf(end+1,1)=1;
end;
% Hier einen definierten Zufallsgenerator-Status herstellen. Garantiert gleiche Ergebnisse bei Mehrfach-Aufruf
% der Funktion.
rand('state',1);
switch parameter_regelsuche.type_zgf
   case 1
      %Median mit Interpretierbarkeit - in jeder Eingangsklasse ungefaehr gleich viele Repräsentanten, Grenzen bei indkrit
      %absolut gleiche Werte zählen wie ein Wert !
      for i=1:size(d,2)
         if ~rem(i,10)
            fboth(fmon,'%d\n',i);
         end;
         
         %mit Median festlegen
         %Variante 4: Minimum, Maximum, dazwischen in allen Bereichen gleich
         zgf(i,1:parameter_regelsuche.anz_fuzzy)=fuzmedian(d(:,i),parameter_regelsuche.anz_fuzzy,4);
      end;
      
   case 2
      %Median ohne Interpretierbarkeit - in jeder Eingangsklasse ungefaehr gleich viele Repräsentanten, Grenzen bei indkrit
      %absolut gleiche Werte zählen wie ein Wert !
      for i=1:size(d,2)
         if ~rem(i,10)
            fboth(fmon,'%d\n',i);
         end;
         
         %mit Median festlegen
         %Variante 2: Minimum, Maximum, dazwischen in allen Bereichen gleich
         zgf(i,1:parameter_regelsuche.anz_fuzzy)=fuzmedian(d(:,i),parameter_regelsuche.anz_fuzzy,2);
      end;
      
   case 3
      %Gleichverteilt
      min_i=min(d);
      max_i=max(d);
      for i=1:size(d,2)
         if ~rem(i,10)
            fboth(fmon,'%d\n',i);
         end;
         if (max_i(i)-min_i(i))
            zgf(i,1:parameter_regelsuche.anz_fuzzy)=[min_i(i):(max_i(i)-min_i(i))/(parameter_regelsuche.anz_fuzzy-1):max_i(i)];
         end;
      end;
      
   case 4
      %Clustern
      for i=1:size(d,2)
         if ~rem(i,10)
            fboth(fmon,'%d\n',i);
         end;
         temp = fuzcluster(d(:,i),parameter_regelsuche.anz_fuzzy);
         zgf(i,1:length(temp))=temp;
      end;
      
   case 5
      %Clustern mit Runden
      for i=1:size(d,2)
         if ~rem(i,10)
            fboth(fmon,'%d\n',i);
         end;
         temp=fuzcluster(d(:,i),parameter_regelsuche.anz_fuzzy);
         temp=fuzround(temp);
         zgf(i,1:length(temp)) = temp;
      end;
      
   case 6
      if isfield(parameter_regelsuche,'zgf') &&  ~isempty(parameter_regelsuche.zgf)
         switch size(parameter_regelsuche.zgf,1)
            case size(d,2)+1
               %complete with MBF for output variable
               zgf = parameter_regelsuche.zgf;
            case size(d,2)
               %complete without MBF for output variable
               zgf(1:end-1,1:size(parameter_regelsuche.zgf,2)) = parameter_regelsuche.zgf;
            otherwise
               myerror('Dimension of membership function incompatible! Option fix not possible.');
         end;
      else
         myerror('No membership functions found! The parameter fix cannot be used.');
      end;      
end;


%ZGF muss monoton ansteigen bis zum Maximum, also die Stellen rauslöschen, wo das nicht so ist
[tmp,ind]=max(zgf',[],1);
%[ind_term,ind_var]=find(diff(zgf',1,2)<=0);
[ind_term,ind_var]=find(diff(zgf')<=0);
if ~isempty(ind_term)
   tmp=ind_term;
   ind_term=ind_term(find(ind(ind_var)>tmp'));
   ind_var=ind_var(find(ind(ind_var)>tmp'));
end;
for i=findd(ind_var)
   %alle betroffenen Terme der Variablen
   ind_var_tmp=ind_term(find(ind_var==i));
   zgfvar_tmp=zgf(i,:);
   zgfvar_tmp(ind_var_tmp)=[];
   zgf(i,:)=[zgfvar_tmp min(0,max(zgfvar_tmp))*ones(1,length(ind_var_tmp))];
   [tmp,ind(i)]=max(zgf(i,:));
end;

%KAFKA-Ausgangsvektor herstellen
if ~isempty(par)
   par_kafka=[par.anz_dat size(d,2) 1 par.anz_ling_y(par.y_choice) min(ind,parameter_regelsuche.anz_fuzzy)];
else
   %bei fehlendem Ausgangsvektor par_kafka nur aus Termen bilden und Dummy-Ausgangs-ZGF wieder wegschneiden
   par_kafka=[0 size(d,2) 1 0 min(ind(1:length(ind)-1),parameter_regelsuche.anz_fuzzy)];
   zgf(end,:)=[];
end;


%Automatische Bezeichnung ZGF
zgf_bez=zgfname(zgf,par_kafka);
fboth(fmon,'Complete ... \n');
