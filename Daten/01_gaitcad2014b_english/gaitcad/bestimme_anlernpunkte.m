% Script bestimme_anlernpunkte
%
% interner Fuzzy-TSK-Parameter
%
% The script bestimme_anlernpunkte is part of the MATLAB toolbox Gait-CAD. 
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

schwell_max_fuzzy_cluster=parameter.gui.zr_klassifikation.schwell_max_fuzzy_cluster;


% bestimme_anlernpunkte
te = kp.triggerevent.start;

switch(kp.klassi_typ.typ)
case {1, 2, 3} % K1 (bester Abastpunkt), K2 oder K3
   % mode == 1: ANOVA, mode == 2: MANOVA
   switch (get(uihd(11,96), 'value'))
   case 3
      zr_rel_mode = 1;
   case 4
      zr_rel_mode = 2;
   otherwise
      zr_rel_mode = 1;
   end;
   berechne_zr_rel;
   
   zeitl_gew = get(uihd(11,142), 'value'); 
   if (zeitl_gew)
      XM.I = gueteMerk(:,end);
      XM.T = ([1:size(gueteMerk,1)]')./parameter.gui.zeitreihen.abtastfrequenz;
      zt = te / parameter.gui.zeitreihen.abtastfrequenz;
      %gueteZeit=XM.I./(XM.T-zt).*(XM.T>(zt+0.15*zt));
      gueteZeit=XM.I./(XM.T-zt).*(XM.T>(zt+0.16666*zt));
      
      % Es können Peaks vorkommen. Die deuten aber auf unzuverlässige Merkmale hin. Also filtern (mit Triangel).
      laengeTriangel = 20;
      triangel = [0:1/laengeTriangel:0.5-1/laengeTriangel 0.5 0.5-1/laengeTriangel:-1/laengeTriangel:0];
      % Sollte in der Summe 1 ergeben...
      triangel = triangel ./ sum(triangel);
      % nun mit den Güten falten
      gueteZeitNeu = conv2(gueteZeit', triangel, 'same');
      [temp, maxind] = max(gueteZeitNeu);
   else
      [temp, maxind] = max(gueteMerk(:,end));
   end;
   
   % Nur ein Anlernpunkt. Der Beste...
   klass_zr.samples = kp.triggerevent.zr(maxind);
   % Kreiere die Aktivitäts- und Wichtungszeitreihe. Hier nur 1 ab Triggerzeitpunkt.
   klass_zr.aktiv = ones(kp.triggerevent.kmax, 1, 1);
   klass_zr.wichtung = klass_zr.aktiv;
   
   % K2 wird behandelt wie K1 - siehe temp_klassi_typ von oben
   
	% K3 (ein Abtastpunkt anlernen und aggregation, jeder Abtastpunkt Parameter)
   % Zunächst Behandlung wie K1 und dann Änderung in klassifizieren_zr_en.
   % siehe temp_klassi_typ von oben
case 4 % K4 (jeder Abtastpunkt hat eigenen Klassifikator)
   klass_zr.samples  = [1:kp.triggerevent.kmax];
   klass_zr.aktiv    = [1:kp.triggerevent.kmax]';
   klass_zr.wichtung = ones(kp.triggerevent.kmax,1);
case 5
   % Wird völlig anders gemacht, die Ergebnisse der nächsten Zeilen werden mehr oder weniger ignoriert...
   klass_zr.samples  = [1:kp.triggerevent.kmax];
   klass_zr.aktiv    = [1:kp.triggerevent.kmax]';
   klass_zr.wichtung = ones(kp.triggerevent.kmax,1);
case 6 % Fuzzy-geclustert
   %Clustern über ANOVA-Werte
   mode=1; 
   
   %Cluster berechnen
   if (mode==1) 
      zr_rel_mode = 1; berechne_zr_rel;
      %aus ANOVA-Werten über Zeitreihen
      d=alleMerk;
   end;
   
   cluster_param.anz_c_zentr_vek = kp.klassi_typ.anz_cluster_kand;
   cluster_param.video = 0;
   %[cluster_zentren_tmp, cluster_zgh_alle,valid,S_clust]=clusterkafka([],d,ones(size(d,1),1), cluster_param);
   
   %number of clusters? 
   if max(cluster_param.anz_c_zentr_vek)*1.5>length(d)
      cluster_param.anz_c_zentr_vek = max(2,floor(1.5*length(d)));      
   end;
   
   
   cluster_ergebnis_tmp=clusterkafka([],d,ones(size(d,1),1), cluster_param);

   % Anzeige,Fenster schließen 
   %eval(get(uihd(5,10),'callback'));
   
   %Bestimmung der Sample für den Klassifikatorentwurf
   %Schnittpunkte für neues Cluster ? 
   [max_zgh,ind_max]=max(cluster_ergebnis_tmp.cluster_zgh');
   ind_diff=[1 find(diff(ind_max)) length(ind_max)];
   temp_cluster_max_zgh=[];
   sample_fuzzy = [];
   for i=1:length(ind_diff)-1 
      [temp_cluster_max_zgh(i),posmax]=max(max_zgh(ind_diff(i):ind_diff(i+1)));
      sample_fuzzy(i)=ind_diff(i)+posmax-1;
   end;
   [sample_fuzzy,ind_sample_fuzzy]=unique(sample_fuzzy);
   temp_cluster_max_zgh = temp_cluster_max_zgh(ind_sample_fuzzy);
   
   %neu: Schwellwert, um kurzzeitige dominante schlechte Cluster zu unterdrücken, Parameter siehe oben
   sample_fuzzy(temp_cluster_max_zgh<schwell_max_fuzzy_cluster)=[];
   
   %Notreparatur, wenn es keine Cluster gibt
   if isempty(sample_fuzzy)
      sample_fuzzy = [1 length(kp.triggerevent.zr)];
   end;
   
   
   klass_zr.samples = kp.triggerevent.zr(sample_fuzzy);
   
   %Suche nach Trigger-Bereichen mit x_TT>0
   indx = find(kp.triggerevent.zr);
   klass_zr.aktiv = [];
   klass_zr.wichtung = [];
   
   %über alle Sample, die zu Trigger-Bereichen mit x_TT>0 gehören
   for i = indx
      %Fuzzifizieren über sample
      akt_klass = fuzz(kp.triggerevent.zr(i), klass_zr.samples);
      %aktive Klassifikatoren und deren Gewichte bestimmen 
      a = find(akt_klass);
      klass_zr.aktiv   (kp.triggerevent.zr(i), 1:length(a)) = a;
      klass_zr.wichtung(kp.triggerevent.zr(i), 1:length(a)) = akt_klass(a);
   end;
   
   % Falls das Plotten der Fuzzy-Cluster eingeschaltet ist.
   if (get(uihd(11,148), 'value'))
      %ZGF für Fuzzy-Klassifikatoren plotten
      % Plottet die Zugehörigkeiten zu den einzelnen Klassifikatoren (Dreiecksfunktionen)
      zgf_tsk_bez=[];
      for i=1:length(klass_zr.samples)
         tmp=sprintf('C_%d',i);
         zgf_tsk_bez(i,1:length(tmp))=tmp;
      end;
      zgf_tsk_bez(~zgf_tsk_bez)=32;
      f=figure;
      plotzgf(klass_zr.samples,f,0,max(kp.triggerevent.kmax),1.2,char(zgf_tsk_bez),'x_{TT}[k]','Membership value');
      
      figurename=sprintf('%d: Membership functions for  TSK-Fuzzy',get_figure_number(gcf));
      set(gcf,'numbertitle','off','name',kill_lz(figurename));

      
      % Plottet die tatsächlichen Clusterzugehörigkeiten.
      figure; 
      plot(cluster_ergebnis_tmp.cluster_zgh); 
      title('Cluster memberships');
      figurename=sprintf('%d: %s',get_figure_number(gcf),'Cluster memberships');
      set(gcf,'numbertitle','off','name',kill_lz(figurename));

   end;
end;

%sonst dreht MATLAB durch ...
if (size(klass_zr.samples, 1) ~= 1)
   klass_zr.samples = klass_zr.samples';
end;

clear cluster_ergebnis_tmp