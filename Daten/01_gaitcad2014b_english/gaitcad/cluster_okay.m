% Script cluster_okay
%
% Ausführen bei Drücken des OK Buttons
% die Bezeichner dorgbez_wahl und var_bez_wahl sind Sicherungen, falls keine EM oder ZR existieren
%
% The script cluster_okay is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

if length(ind_auswahl)<2
   myerror('At least two data points should be selected for a cluster analysis.');
end;


d_org_wahl=[];
d_orgs_wahl=[];
d_org_wahl_alle=[];
d_orgs_wahl_alle=[];
dorgbez_wahl=[];
var_bez_wahl=[];
dorgbez_zr=''; % zum späteren Anhangen von Cluster ZGH als EM
dorgbez_em=''; % zum späteren Anhangen von Cluster ZGH als EM
param=[];

%hier die Einstellung des Zeitbereichs über den geclustert werden soll:
%vorläufig über alles!!
param.zr_bereich=[parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende];
if exist('zr_bereich_vorgabe', 'var')
   if ~isempty(zr_bereich_vorgabe)
      param.zr_bereich=zr_bereich_vorgabe;
   end
end

%tmp='Time series (TS)|Single features|Both simultaneously|Both subsequently'; string(1,1:length(tmp))=tmp;
%tmp='Feature class'; info(1,1:length(tmp))=tmp;
%Merkmale raussuchen: Clustern über Zeitreihen...
% die if Abfrage ...*size(d_org,2) ist eine Sicherung, falls es keine Einzelmerkmale (Zeitreihen) gibt
if (parameter.gui.clustern.merkmalsklassen~=2) && (size(d_orgs,3)>0)
   if (isempty(get(uihd(11,13), 'value')))
      mywarning('Warning! No time series selected!');
      return;
   end;
   d_orgs_wahl_alle = d_orgs(:,param.zr_bereich,get(uihd(11,13),'value'));
   d_orgs_wahl = d_orgs(ind_auswahl,param.zr_bereich,get(uihd(11,13),'value'));
   param.label_zr=var_bez(get(uihd(11,13),'value'),:);
   dorgbez_zr=sprintf('TS-No.r %s ',sprintf('%d ',get(uihd(11,13),'value')));
end;
%Merkmale raussuchen: Clustern über Einzelmerkmalen...
if (parameter.gui.clustern.merkmalsklassen~=1) && size(d_org,2)>0
   if (isempty(get(uihd(11,14), 'value')))
      mywarning('Warning! No single feature selected!');
      return;
   end;
   d_org_wahl_alle  = d_org (:,get(uihd(11,14),'value'));
   d_org_wahl  = d_org (ind_auswahl,get(uihd(11,14),'value'));
   param.label_em=dorgbez(get(uihd(11,14),'value'),:);
   dorgbez_em=sprintf('SF-No. %s ',sprintf('%d ',get(uihd(11,14),'value')));
end;

%tmp='off|On (without breaks)|On (with breaks)|On (key pressed)'; string(2,1:length(tmp))=tmp;
%tmp='Video (Main window: selection of output variable, graphics)'   ; info(2,1:length(tmp))=tmp;
param.video=parameter.gui.clustern.video;

%tmp='Number of clusters (multiple choice possible)'; info(3,1:length(tmp))=tmp;
param.anz_c_zentr_vek=parameter.gui.clustern.anzahl_cluster;

%tmp='Equally distributed|random start cluster|random data points|Data points from GUI';
%string(4,1:length(tmp))=tmp;
%tmp='Compute start prototypes for clusters'; info(4,1:length(tmp))=tmp;
param.c_zentr_opt=parameter.gui.clustern.clusterstartzentren;
%data points from GUI as start clusters if chosen - be careful with
%selected data points
param.data_points_from_gui = find(ismember(ind_auswahl,parameter.gui.allgemein.datentupel));

%tmp='Euklidische Distanz|Varianznormierung (HD)|Mahalanobis-Distanz|Gustafson-Kessel|Gath
%Geva|vereinfachter Gustafson-Kessel(HD)'; string(6,1:length(tmp))=tmp; tmp='Distance measure (metric)';
%info(6,1:length(tmp))=tmp;
param.abstandsmass=parameter.gui.clustern.abstandsmass;

%tmp='yes|none'; string(7,1:length(tmp))=tmp; tmp='Plot start clusters';
%info(7,1:length(tmp))=tmp;
param.start_c_zeichnen=0;

%tmp='Original data|Mean values|None'; string(8,1:length(tmp))=tmp; tmp='Plot original TS';
%info(8,1:length(tmp))=tmp;
param.o_dat=parameter.gui.clustern.zeichnenorgzr;

%tmp='unlimited|0 (e.g. to compute centroids from cluster memberships)|50|100|150'; string(9,1:length(tmp))=tmp;
%tmp='Maximal number of iterations'; info(9,1:length(tmp))=tmp;
if parameter.gui.clustern.iterationunbegrenzt 
   param.max_iteration=0;
else 
   param.max_iteration=parameter.gui.clustern.iterationsschritte;
end;

%Parameter aus Oberfläche und Workspace%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Legenden
param.legend_on=get(uihd(11,30),'value');
param.legend_bez=zgf_y_bez(par.y_choice,:);

%Anzeige Nr. Datentupel
param.nr_daten=get(uihd(11,18),'value');
%die passenden Nummern 
param.ind_auswahl=ind_auswahl;

%Farbig oder schwarz-weiß ? 
param.sw_symbol=get(uihd(11,26),'value');

%ÄNDERUNG RALF: Fuzzifier kommt aus Oberfläche
%[uihd(11,63),uihd(12,63)]=datini('Fuzzifier for clustering','fuzzifier_fcm','uihd(11,63)',220,fuzzifier_fcm,1,'if fuzzifier_fcm<=1 fuzzifier_fcm=1.1;end;set(uihd(11,63),''string'',sprintf(''%g'',fuzzifier_fcm));');
param.q=sscanf(get(uihd(11,63),'string'),'%g');

%Validierungsfunktionen hier immer mit berechnen, aber nur bei echtem FCM
if param.q>1 
   param.validierung_berechnen=1;
else
   %... und nicht beim k-means
   param.validierung_berechnen=0;
end;

%Kovarianzmatrizen vor Entwurf auf jeden Fall zurücksetzen
param.S_inv = [];

%Rausch-Cluster
param.noise_cluster_factor=parameter.gui.clustern.noise_cluster_factor;
param.noise_cluster_method=parameter.gui.clustern.noise_cluster_method;

if param.noise_cluster_method>1 && min(param.anz_c_zentr_vek)<3
   mywarning('For the use of noise clusters, at least three clusters should be used! Please check the number of clusters!');
end;


%Cluster-Funktion!!!!!!!!!!!!!!
switch mode_cluster 
case 1
   %Gait-CAD eigene Funktion
   cluster_ergebnis = clusterkafka(d_orgs_wahl,d_org_wahl,code(ind_auswahl),param);
case {2,3}
   %Hierarchisches Clustern mit Statistik-Toolbox
   cluster_ergebnis = clustermatlab(d_orgs_wahl,d_org_wahl,code(ind_auswahl),parameter);   
end;



if ~isempty(cluster_ergebnis)
   cluster_ergebnis.ind_auswahl = ind_auswahl;
   
   % Cluster-ZGH als EM anfügen?(-1 für nicht gewählte):
   %tmp='yes|none'; string(5,1:length(tmp))=tmp; tmp='Add all cluster memberships as single features?';
   %info(5,1:length(tmp))=tmp;
   
   
   %Cluster-Funktion!!!!!!!!!!!!!!
   switch mode_cluster 
   case 1
      %Gait-CAD eigene Funktion
      %Cluster-Zentren sind dann schon bekannt
      param.c_zentr_opt=5;
      param.v_start_vorgabe=cluster_ergebnis.cluster_zentren;
      %Video aus!
      param.video=1; 
      %nur eine Iteration!
      param.max_iteration=-1;
      %Cluster-Zentren dürfen nicht springen!
      param.c_setz_neu=2;
      param.validierung_berechnen=0;
      
      param.S_inv = cluster_ergebnis.S_inv;
      
      cluster_ergebnis_tmp = clusterkafka(d_orgs_wahl_alle,d_org_wahl_alle,code,param);
      
      param.S_inv = [];
   case {2,3}
      %Hierarchisches Clustern mit Statistik-Toolbox
      %unbekanntes Cluster wird für Restdaten eingeführt 
      cluster_ergebnis_tmp  =cluster_ergebnis;  
      cluster_ergebnis_tmp.cluster_zgh = [zeros(par.anz_dat,cluster_ergebnis.anz_cluster) 1E-10*ones(par.anz_dat,1)];
      cluster_ergebnis_tmp.cluster_zgh(ind_auswahl,1:size(cluster_ergebnis.cluster_zgh,2)) = cluster_ergebnis.cluster_zgh;           
      
   end;
   
   
   if parameter.gui.clustern.clusterausgangsgroesseanhaengen<3
      %scharfe Klassenzuweisung...
      [tmp_wert pos]=max(cluster_ergebnis_tmp.cluster_zgh,[],2);
      
      [code_alle,zgf_y_bez,bez_code,y_choice,L]=addnewoutput_cluster(code_alle,zgf_y_bez,bez_code,L,pos,parameter.gui.clustern,cluster_ergebnis_tmp);
      %vorsichtshalber noch Mittelwerte löschen
      mw=[];
      aktparawin;
      set(uihd(11,12),'value',y_choice);
      eval(get(uihd(11,12),'callback'));
      clear cluster_ergebnis_tmp;
   end;
   
end;

clear d_orgs_wahl_alle d_org_wahl_alle param dorgbez_zr dorgbez_em dorgbez_wahl var_bez_wahl d_orgs_std_wahl y_choice;


