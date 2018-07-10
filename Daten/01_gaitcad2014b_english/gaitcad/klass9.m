  function [konf,fehl_proz,fehl_kost,feat_kost,relevanz_klass]=klass9(dat,code,pos,prz,anzeige,f,sw_mode,za_mode,var_bez,zgf_bez,L,feature_aktiv,evidenz_aktiv,relevanz)
% function [konf,fehl_proz,fehl_kost,feat_kost,relevanz_klass]=klass9(dat,code,pos,prz,anzeige,f,sw_mode,za_mode,var_bez,zgf_bez,L,feature_aktiv,evidenz_aktiv,relevanz)
%
%   Typ Entscheidung einlesen und fehl_kost entsprechend ausgeben
%   Durchführung der Klassifizierung
% 
%   Eingangsvariablen:
%   dat     -> Datenmatrix
%   code        -> Klassencode
%              (!!!code von 1 bis kl_anz!!!)
%   pos     -> geschätzte Klassenzugehörigkeiten
%   md      -> Distanzen zu Klassenmittelpunkten
%   anzeige        -> 1 wenn Bilder
%   file     - Ausgabe in Datei (optional, sonst Monitor)
%   sw_mode  - ==1 Anzeige mit Klassen-Nr., sonst Farbe (optional)
%   za_mode  - ==1 Anzeige mit Datentupel-Nr.
% 
%   Default: Monitor
%
% The function klass9 is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<6) 
   f=1;
end;

%wenn in Datei, dann bitte alles plotten!, auf Bildschirm wie in Anzeige Detailinfos vereinbart
f=[f anzeige+1];
%reine Bidschrimausgabe, aber mit Anzeigeumschaltung
fmon=[1 anzeige+1];


if (nargin<7) 
   sw_mode=0;
end;
if (nargin<8) 
   za_mode=0;
end;
if (nargin<9) 
   var_bez='';
end;
if (nargin<10) 
   zgf_bez=[];
end;
if (nargin<11) 
   L=[];
end;
if isempty(L) 
   fehl_kost=0;
end;
if nargin<12 
   feature_aktiv=[]; 
end;
if isempty(feature_aktiv)
   feat_kost=0; 
end;
if nargin<13 
   evidenz_aktiv=0; 
end;
if nargin<14 
   relevanz=[]; 
end;
if nargout>4 
   relevanz_klass=[]; 
end;

kl_anz=max(code);
ent_anz=max(kl_anz,max(pos));

cl_err=pos-code;
anz_err=length(find([pos-code]~=0));
fehl_proz=anz_err/length(pos)*100;

fboth(f,'\nAnalyze classification result ... \n');
fboth(f,'Number of misclassifications: %d of %d examples (%5.2f %%)\n',anz_err,length(pos),fehl_proz);
fboth(f,'Confusion matrix (Rows: True class assignments, columns: Result of classification):\n');
if evidenz_aktiv
   fboth(f,'The first %d columns belong to a class, all following columns to a conjunction of classes:\n',kl_anz);
end;

for i=1:kl_anz 
   for j=1:ent_anz 
      konf(i,j)=sum((code==i) & (pos==j));  % Coderevision: &/| checked!
   end;
end;
for i=1:size(konf,1) 
   fboth(f,'%3d  ',konf(i,:));
   fboth(f,'\n'); 
end; 

if ~isempty(L) 
   if ent_anz>kl_anz
      if isfield(L,'ld_evidenz') && evidenz_aktiv
         L.ld(kl_anz+1:ent_anz,:)=L.ld_evidenz; % 
      else
         L.ld(kl_anz+1:ent_anz,:)=min(sum(L.ld(:,code),2)/length(code)); % 
      end;
   end;
   
   
   fehl_kost=sum(sum(L.ld(1:ent_anz,1:kl_anz)'.*konf))/length(pos); %Kosten für Fehlentscheidungen
   fboth(f,'Costs for misclassifications: %g\n',fehl_kost);
   
   if (~isempty(feature_aktiv)) || (isfield(relevanz,'feat_kost_apriori')) % Merkmalskosten, wenn aktive Merkmale vorhanden. Bei Evidenz immer vorhanden
      if isfield(relevanz,'feat_kost_apriori')
         feat_kost=relevanz.feat_kost_apriori;
      else
         feat_kost=sum(L.lcl(feature_aktiv));
      end;         
      fehl_kost_total=fehl_kost+feat_kost;
      fboth(f,'Costs for features: %g\n',feat_kost);
      %immer plotten:
      fboth(f,'Total costs per decision: %g\n',fehl_kost_total);
   else
      fehl_kost_total=fehl_kost; % Keine zusätzlichen Merkmalskosten
      feat_kost=0;					% Dann sind natürlich die Merkmalskosten null...sonst Augang nicht belegt und Warnung   
   end; %if if ~isempty(feature_aktiv)
   if (nargout>4) % Ausgabe von weiteren Informationen zur Kostenstruktur: 
      
      %ÄNDERUNG RALF: identische Kostenbezeichner wie bei relevanz_cv_alle ergänzt
      relevanz_klass.fehl_kost=fehl_kost;
      relevanz_klass.fehl_proz=fehl_proz;
      relevanz_klass.gesamt_kost=fehl_kost_total;
      %%%%%%%%%%%%%
      
      relevanz_klass.keine_ent_kost=sum(sum(L.ld(kl_anz+1:ent_anz,1:kl_anz)'.*konf(1:kl_anz,kl_anz+1:ent_anz)))/length(pos);
      relevanz_klass.nur_fehl_kost=fehl_kost-relevanz_klass.keine_ent_kost;
      %Aktive Merkmale protokollieren
      relevanz_klass.feature_aktiv=feature_aktiv;
      % Bei hierarchischer Klassifikation werden die Anteile der Merkmale und die Anzahl der Ebenen weitergegeben:
      if isfield(relevanz,'feature_anteil') 
         relevanz_klass.feature_anteil=relevanz.feature_anteil;
         relevanz_klass.anz_ebene=relevanz.anz_ebene;
      end;
      relevanz_klass.feat_kost=feat_kost;
   end; %nargout
end;%if ~isempty(L) 

if evidenz_aktiv && (nargout>4)
   L.cost_norm=sum(L.ld(size(L.ld,1),code))/size(code,1); % Zur berechnung der Default Kosten
   relevanz_klass.evidenz_cost=1-(L.parameter_regelsuche.beta*relevanz_klass.keine_ent_kost+relevanz_klass.nur_fehl_kost)/L.cost_norm;
   relevanz_klass.evidenz_cost_feat=1-fehl_kost_total/L.cost_norm;
end; %if evidenz aktiv

if (nargout>4) % Relevanzinformationen für hierarchische Klass... ohne L
   relevanz_klass.keine_ent_fehlproz=sum(sum(konf(1:kl_anz,kl_anz+1:ent_anz)))/length(pos);
   relevanz_klass.nur_fehlproz=fehl_proz-relevanz_klass.keine_ent_fehlproz;
end; %if nargout


if (anzeige>0)
   
   %Fehlklassifikationen über Klassen
   figure;
   subplot(2,1,1);plot(1:length(pos),[pos code]);title('Classification');
   subplot(2,1,2);plot(1:length(pos),[pos-code],'*');title('Misclassification: <>0');
   zoom on;
      
   %Fehlklassifikationen über Klassifizierungswahrscheinlichkeiten
   figure;
   for i=1:kl_anz     
      subplot(kl_anz,1,i);       
      plot(prz(:,i));hold on;
      eval(sprintf('ylabel(''Class %d'');',i));         
      plot(100*(code==i),'g');
      if (i==1) 
         title('Probability of classification target-actual');
      end; 
      ylabel(sprintf('Class %d',i));
      xlabel('Nr. data point');
      ax=axis;axis([ax(1:2) 0 110]); 
   end;
   for i=find(cl_err)' 
      subplot(kl_anz,1,pos(i) );
      plot(i,100,'r*');
      subplot(kl_anz,1,code(i));
      plot(i,100,'b*');
   end;
   
   %Darstellung im Merkmalsraum mit farbigen Klassen
   figure;plotfarb(dat,code,za_mode,sw_mode,var_bez,zgf_bez);
end;

fboth(fmon,'Complete ... \n');