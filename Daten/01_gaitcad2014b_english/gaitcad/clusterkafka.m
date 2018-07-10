  function  [cluster_ergebnis]=clusterkafka(d_orgs, d_org, code, param)
% function  [cluster_ergebnis]=clusterkafka(d_orgs, d_org, code, param)
%
%   berechnet Cluster Zentren nach Fuzzy-c-means Algorithmus:
%   J(X,V)= sum sum u^q * d^2(X,V)  -> min
%   dabei können Zeitreihen und Einzelmerkmale geclustert werden, wichtig dabei ist, dass
%    die Anzahl der (Beispiels-) Datentupel gleich ist!
%   ERKLÄRUNG DER VARIABLEN:
% 
%  d_orgs              -  Zeitreihen
% 
%  d_org               -  Einzelmerkmale
% 
%  code            -  Klassenzuweisung NUR FÜR VISUALISIERUNG NICHT FÜR BERECHNUNG verwendet
% 
%  Inhalt Parameter-Vektor param:
% 
%  zr_bereich     -  Angabe des Zeitreihenbereichs als Vektor über den geclustert werden soll, z.B.  maximal: zr_bereich=1:par.laenge_zeitreihe
% 
%  anz_c_zentr_vek-  Vorgabe der Cluster-Zentren Anzahl, kann Zeilenvektor sein, für mehrmaliges Durchlaufen bei versch. Clusteranzahlen
% 
%  c_zentr_opt    -  Optionen zur Berechnung von Start-Cluster-Zentren,
%                           =1  gleichmäßige Verteilung zwischen den vorhandenen min und max Werten (der entsprechenden Dimension)
%                           =2  zufallig verteilt
%                           =3  zufällige Datentupel DS
%                           =4  aus v_start_vorgabe (nicht im Menü enthalten!!!!)
% 
%  epsilon         -  Schwellwert, der die zu erreichende Verbesserung der Optimierungsfunktion J
%                    in einem Rechenschritt angibt
% 
%  q               -  Fuzzifizierungsgrad
% 
%  abstandsmass    -  =1 rein Euklidischer Abstand
%                     =2 Euklidischer Abstand unter Normierung der Streuung entlang jeder Dimension, natürlich
%                     =3 Mahalanobis-Distanz (mit Kovarianz-Matrix über alle Datentupel)
%                     =4 Gustafson-Kessel
%                     =5 Gath-Geva
%                     =6 vereinfachter GK
% 
%  c_setz_neu      -  =1 eng benachbarte Clusterzentren neu setzen zulassen
%                     =2   "    "  NICHT zulassen
% 
%  v_start_ind     -  Vorgabe der Cluster-zentren-Index, d.h. Zeilenvektor in dem verwendete Datentupel benutzt werden
%                            z.B. ein abgewandeltes ind_auswahl, in dem nur erster Schritt einer Pers. eines U-Dat verwendet wird
% 
%  video           -  =1 video aus
%                      -  =2 Video an: Berechnung auf 2-dim plot verfolgen ohne Pausen
%                      -  =3 Video an: mit Pausen
%                      -  =4 Video an: mit Tastendruck
% 
%  label_em        - string Matrix für Einzelmerkmals-Achsenbeschriftung, Anzahl Zeilen MUSS passend zu 2. Dimension in d_org sein!
% 
%  label_zr        - string Matrix für Zeitreihen-Beschriftung, Anzahl Zeilen MUSS passend zu 3. Dimension in d_orgs sein!
% 
%  legend_on       - nur für Video:
%                          =0 ohne Legende
%                          =1 mit Legende
% 
%  legend_bez      - struct für Legenden-Bezeichner, z.B. zgf_y_bez,
%                                ACHTUNG: Muss natürlich zu code passen!!! : Wenn es einen Eintrag im code mit 25 gibt, dann muss es mindestens auch ein legend_bez(1,25).name geben!!!
%                                    Am besten zgf_y_bez in Aktueller Spalte komplett übergeben: zgf_y_bez(par.y_choice,:)
%                            mit z.B. legend_bez(1).name='mittel'
%                            mit z.B. legend_bez(2).name='schnell'
%                            mit z.B. legend_bez(3).name='langsam'
% 
%  titelzeile      - gibt bei video die titelzeile an
% 
%  o_dat           - Auswahl für das zeichnen der Originaldaten bei Zeitreihen:
%                            =1 zeichnet Original-ZR mit ein
%                            =2 nur die Mittelwerte
%                            =3 keine O-Daten, nur Clusterzentren
% 
%  start_c_zeichnen - =1 Startcluster mit einzeichnen
%                            =2 Startcluster nicht einzeichnen
% 
%  ellipse_on      -  nur für Video:
%                          =1 Zeichnet Streu-Ellipse ein
%                          =2 zeichnet sie nicht ein
% 
%  nr_daten        - Anzeige Nr.-Datentupel
%                            =0 aus
%                            =1 an
% 
%  ind_auswahl     - zur Anzeige Nr.-Datentupel notwendige Daten-Nummern
%  max_iteration  - gibt die maximale Anzahl von Iterationsschritten vor, 0 für unbegrenzt,
%                            -1 keine Iteration, aber es werden die Cluster-ZGH initialisiert! und zurückgegeben
% 
%  sw_symbol         -  =1 für normal bunte und farbige Bilder
%                            =2 für Farbeinteilung entsprechend max. Cluster-ZGH
%                            =3 für SW Bilder, die Cluster-Zentren sind zwar farbig, aber dafür gestrichelt
% 
%  rausch_cluster    -  1= ja
%                        -  2= nein
%   v                  -  Cluster-Zentren Ausgabe
%   u                  -  Zugehörigkeiten Ausgabe
%   valid              -  Ein Strukt, das verschiedene Validierungen zurück gibt
% 
%
% The function clusterkafka is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(d_orgs) && isempty(d_org)
  mywarning('Neither single features nor time series exist');
  cluster_ergebnis=[];
  return;
end;





if (nargin < 3)
  error('Too few parameters!');
end;
if (nargin < 4)
  param = [];
end;
if (~isfield(param, 'zr_bereich'))
  zr_bereich = [];
end;
if (~isfield(param, 'anz_c_zentr_vek'))
  anz_c_zentr_vek = 2;
end;
if (~isfield(param, 'c_zentr_opt'))
  c_zentr_opt=3;
end;
if (~isfield(param, 'epsilon'))
  epsilon=10^-3;
end;
if (~isfield(param, 'q'))
  q=2;
end;
if (~isfield(param, 'abstandsmass'))
  abstandsmass=1;
end;
if (~isfield(param, 'c_setz_neu'))
  c_setz_neu=2;
end;
if (~isfield(param, 'v_start_ind'))
  v_start_ind=[];
end;
if (~isfield(param, 'video'))
  video = 2;
end;
if (~isfield(param, 'label_em'))
  label_em=[];
end;
if (~isfield(param, 'label_zr'))
  label_zr = [];
end;
if (~isfield(param, 'legend_on'))
  legend_on=1;
end;
if (~isfield(param, 'legend_bez'))
  legend_bez = [];
end;
if (~isfield(param, 'titelzeile'))
  titelzeile='';
end;
if (~isfield(param, 'o_dat'))
  o_dat = 1;
end;
if (~isfield(param, 'start_c_zeichnen'))
  start_c_zeichnen = 2;
end;
if (~isfield(param, 'ellipse_on'))
  ellipse_on = 2;
end;
if (~isfield(param, 'nr_daten'))
  nr_daten = 0;
end;
if (~isfield(param, 'ind_auswahl'))
  ind_auswahl = [];
end;
if (~isfield(param, 'max_iteration'))
  max_iteration = 0;
end;
if (~isfield(param, 'v_start_vorgabe'))
  v_start_vorgabe = [];
end;
if (~isfield(param, 'sw_symbol'))
  sw_symbol = 1;
end;
if (~isfield(param, 'validierung_berechnen'))
  validierung_berechnen = 0;
end;
if (~isfield(param, 'noise_cluster_method'))
  param.noise_cluster_method = 1;
end;
if (~isfield(param, 'noise_cluster_factor'))
  param.noise_cluster_factor = 1;
end;
if (~isfield(param, 'S_inv'))
  param.S_inv = [];
end;




% Wandle die Strukt-Elemente in Workspace-Variablen um:
fields = fieldnames(param);
for i = 1:size(fields,1)
  eval(sprintf('%s = getfield(param, ''%s'');', fields{i}, fields{i}));
end;

if ~isempty(d_orgs) && (size(d_orgs,1) < max(anz_c_zentr_vek))
  mywarning(sprintf('Too few data points (%d) for the selected number of clusters (%d)', size(d_orgs,1), max(anz_c_zentr_vek)));
  anz_c_zentr_vek = anz_c_zentr_vek(find(anz_c_zentr_vek <= size(d_orgs,1)));
  if isempty(anz_c_zentr_vek)
    anz_c_zentr_vek = 2;
  end;
  
end;
if ~isempty(d_org) && (size(d_org,1) < max(anz_c_zentr_vek))
  mywarning(sprintf('Too few data points (%d) for the selected number of clusters (%d)', size(d_org,1), max(anz_c_zentr_vek)));
  anz_c_zentr_vek = anz_c_zentr_vek(find(anz_c_zentr_vek <= size(d_org,1)));
  if isempty(anz_c_zentr_vek)
    anz_c_zentr_vek = 2;
  end;
  
end;

if isempty(label_em)
  if ~isempty(d_org)
    label_em=zahl2text(1:size(d_org,2),0);
  else label_em=[];
  end;
end; % nummeriert einfach die Achsenbeschriftung

if isempty(label_zr)
  if ~isempty(d_orgs)
    label_zr=zahl2text(1:size(d_orgs,3),0);
  else
    label_zr=[];
  end;
end;
if isempty(legend_bez)
  tmp=zahl2text(1:max(code),0);
  for i=1:size(tmp,1)
    legend_bez(i).name=tmp(i,:);
  end;
end


%Vorverarbeitung von d_orgs und d_org in eine (dim,anz_dat) Matrix x,
% wobei dim die Dimension der Cluster ist, z.B. 2 für zwei EM, oder 100 für eine ZR, oder 202 für zwei ZR und zwei EM
% und anz_dat die Anzahl der Beispiels-Datentupel ist
x=[];
anz_zr=0;
anz_em=0;
valid=[];
zrpos = [];

nr_merk=1:size(d_orgs,3);

if ~isempty(d_orgs) % hier wird Cluster-Matrix x zusammengebaut, siehe Kommfinder1
  anz_zr=size(d_orgs,3);
  for i=nr_merk
    x=[x;squeeze(d_orgs(:,:,i))'];
    zrpos = [zrpos;i*ones(size(d_orgs,2),1)];
  end;
end;
if ~isempty(d_org)
  anz_em=size(d_org,2);
  x=[x;d_org'];
  if rem(anz_em,2)&&(anz_em>1) % wenn ungerade Anzahl EM und mindestens 2 EM ausgewählt (d.h. mind. drei!!!)
    tmp=size(label_em,1);
    % das vorletzte EM wird doppelt eingezeichnet
    label_em=char( label_em(1:tmp-1,:) , kill_lz( sprintf('%s (double)',label_em(tmp-1,:))) , label_em(tmp,:) );
  end
  if anz_em==1
    label_em=char(kill_lz(sprintf('%s (double)',label_em(1,:))),label_em);
  end
end;

for durchlaeufe=1:length(anz_c_zentr_vek)
  
  anz_c_zentr=anz_c_zentr_vek(durchlaeufe);
  fprintf('%d Clusters\n',anz_c_zentr);
  
  start=1; % q=1.5;
  %Initialisierung Abbruchbedingung und -zeitpunkt
  j_opt=1E250;
  z_opt=1;
  
  %Erstelle Start-Cluster:
  switch c_zentr_opt
    case 1
      % Berechnet anz_c_zentr Clusterzentren gleichmäßig zwischen min und max der jeweiligen dim:
      v_start=[min(x,[],2)*ones(1,anz_c_zentr)+((max(x,[],2)-min(x,[],2))*[0:anz_c_zentr-1])/(anz_c_zentr-1)];
      start_c_text='Equally distributed'; %für Video: Bezeichnung des Startclusters
    case 2
      %zufällige Startcluster
      %die im Bereich zwischen min und max der Datentupel der jeweiligen Dimension sind:
      v_start=min(x,[],2)*ones(1,anz_c_zentr) + rand(size(x,1),anz_c_zentr).* ( ( max(x,[],2)-min(x,[],2) ) * ones(1,anz_c_zentr));
      start_c_text='random'; %für Video: Bezeichnung des Startclusters
    case 3
      %zufällige Startcluster
      %die im Bereich zwischen min und max der Datentupel der jeweiligen Dimension sind:
      indvs=randperm(size(x,2));indvs=indvs(1:anz_c_zentr);
      v_start=x(:,indvs);
      start_c_text='random data points'; %für Video: Bezeichnung des Startclusters
    case 4
      %random data points
      v_start=[min(x,[],2)*ones(1,anz_c_zentr)+((max(x,[],2)-min(x,[],2))*[0:anz_c_zentr-1])/(anz_c_zentr-1)];
      
      %but overwrite the first ones with data points from GUI
      ind_my_first_data_points = 1:min(length(param.data_points_from_gui),anz_c_zentr);
      v_start(:,ind_my_first_data_points) = x(:,param.data_points_from_gui(ind_my_first_data_points));
      
      start_c_text='predefined data points (from GUI)'; %für Video: Bezeichnung des Startclusters
    case 5
      v_start=v_start_vorgabe;
      start_c_text='Apply';
      
  end; % switch c_zentr_opt
  
  %Gewichtungsmatrix:
  std_abw=ones(size(x,1),1);
  
  %neu: Parameter S_inv kann von außen fest vorkonfiguriert werden!!
  S_inv   = param.S_inv;
  S_inv_b = [];
  
  S_clust=[];
  switch abstandsmass
    case {1,4,5,6}
      %rein Euklidischer Abstand (ohne Streuungs-Normierung)
      % für GK und GG Algorithmen dient der erste Schritt als Vorinitialisierung
      S_inv=eye(size(x,1));
      % S_inv_b (aufgeblähte Inverse) muss an Abstandsberechnung angepasst werden, weil Geschw.Vorteile genutzt werden können! siehe unten
      S_inv_b=diag(S_inv)*ones(1,size(x,2)); % diese Zeile ist recht pfiffig, wegen Geschwindigkeit!
      switch abstandsmass % zur Namensgebung
        case 1
          dist_text='Euclidean distance';
        case 4
          % S_inv wird ständig aktualisiert
          dist_text='Gustafson-Kessel';
        case 5
          % S_inv existiert nicht
          dist_text='Gath-Geva';
        case 6
          dist_text='Simplified GK';
      end
    case {2,7}
      %Euklidischer Abstand mit Streuung-Normierung:
      if isempty(S_inv)
        std_abw=std(x,0,2); %zum späteren Zeichnen der Clusterzentren, sonst werden sie verzerrt (relativ zu den O-Daten) dargestellt
        
        %special solution for time series - standard deviations for one
        %time series are set to equal values
        if abstandsmass == 7 && ~isempty(zrpos)
          for i_zr = generate_rowvector(unique(zrpos))
            std_abw(find(zrpos == i_zr)) = mean (std_abw(find(zrpos == i_zr)));
          end;
        end;
        
        S_inv=diag(1./ std_abw ).^2; % berücksichtigt HIER Streuung, Vorteil beim Plotten: Daten werden nicht verzerrt
        
        %avoid problems with infinite values
        if ~isempty(find(isinf(S_inv)))
           S_inv (find(isinf(S_inv))) = 0;
        end;
      end;
      % aufgeblähte Inverse, nutzt Geschwindigkeitsvorteile:
      S_inv_b=diag(S_inv)*ones(1,size(x,2));
      switch abstandsmass % zur Namensgebung
        case 2
          dist_text='Euclidean Distance with normalized standard deviation'; % für Titel;
        case 7
          dist_text=sprintf('%s for time series','Euclidean Distance with normalized standard deviation');
      end;
      % separate S_inv Berechnung ist hier ausgelagert, um Geschw. zu trimmen !!!!!!!!!!!!!!
    case 3
      %Mahalanobis:
      if isempty(S_inv)
        S=cov(x');
        S_inv=pinv(S);
        %avoid problems with infinite values
        if ~isempty(find(isinf(S_inv)))
           S_inv (find(isinf(S_inv))) = 0;
        end;
      end;
      
      dist_text='Mahalanobis distance'; %für Titel
      
  end;
  
  d=zeros(size(x,2),size(v_start,2))+1E-10;
  v=v_start; % v sind die aktuellen Clusterzentren, v_start wurde oben berechnet / festgelegt
  % Vorinitialisieren von u:
  u=zeros(size(x,2), size(v,2))+1/anz_c_zentr; % u enthält Zugehörigkeitsgrad der einzelnen Messwerte zu den einzelnen Clustern
  % Berechnung der Abstände:
  [u]=berechne_abstand(abstandsmass, x, v, S_inv, S_inv_b, u, q,[],param);
  
  % Schalte Video an/aus (funktioniert nur im 2-dimensionalen)
  % die 2 Abfragen sind notwendig, da später (ganz unten) nochmals nach video gefragt wird
  kein_abbruch=1; %zum vorzeitigen Abbruch der Cluster-Berechnung
  %% alt: jetzt soll auch 1dim geclustert werden:
  if (video>1)
    figure;
    grid on;
    hold on;
    %Erzwingt Abbruch
    abbruch=uimenu;
    set(abbruch,'label','Abort','callback','0');
    farlegend=[];
    start_c_far_leg=[]; % Initialisierung für Legende
    anz_subplots=anz_zr+ceil(anz_em/2);
    spalten=1;
    zeilen=ceil(anz_subplots/spalten);
    
    clust_farb=color_style;
    clust_style_zr=char(ones(11,1)*'.');
    clust_style_em=char(ones(11,1)*'.');
    if (sw_symbol>1)
      [tmp,clust_style_zr]=color_style;
      [tmp,clust_style_em]=color_style;
    end;
    cc=color_style;
    set(gcf,'numbertitle','off','name',sprintf('%d: Cluster results',get_figure_number(gcf)));
    
    %zeichnet EINMAL die Datenpunkte, später werden die Clusterzentren (mit delete) verschoben = schnell!!!
    supl=[1:anz_subplots];
    j=0; % zählvariable in der Schleife, die durch die Daten zählt
    for supl_var=supl %gehe durch alle Zeitreihen und EM-PAARE und zeichne Daten in versch subplots ein
      j=j+1;
      subplot(zeilen,spalten,supl_var);hold on;
      start=1;
      for a_klasse=findd(code) %gehe durch alle versch. Ausgangsklassen
        dat_tmp=find(code==a_klasse);
        if j<=anz_zr %plotte alle ZEITREIHEN
          % sucht die Datenpositionen in x:
          dat_pos=(j-1)*length(zr_bereich)+[1:length(zr_bereich)];
          
          switch o_dat
            case 1
              if sw_symbol~=2
                far(a_klasse).farbe=plot( zr_bereich, x( dat_pos, dat_tmp'));
              else % zeigt Farben entsprechend max. Cluster-ZGH an
                for i=dat_tmp' % muss leider jeder DS einzeln gezeichnet werden, da Klassen (max.Cluster-ZGH) sich ändert
                  far(1).farbe(i)=plot( zr_bereich, x( dat_pos, i));
                end;
              end; % if
            case 2
              if sw_symbol==2
                mywarning('Plot of mean in combination with max. affiliation to cluster (vide plot diagram) is nonsensical because of affinity of cluster centres');
                sw_symbol=1;
              end
              far(a_klasse).farbe=plot( zr_bereich, mean (x( dat_pos, dat_tmp'),2) );
          end; % switch o_dat
          
          if nr_daten>0
            for dat_zahler=dat_tmp' %gehe durch alle Schritte einzeln durch (einer Person, die in dat_tmp rausgesucht wurde)
              nr_text=sprintf('%d',ind_auswahl(dat_zahler));
              %Schreibt Daten-Nr. am Anfang, Mitte une Ende einer Zeitreihe:
              text(zr_bereich(1), x( dat_pos(1), dat_zahler),nr_text,'HorizontalAlignment','center');
              text(round( (length(zr_bereich)-1)/2), x( dat_pos(round( (dat_pos(length(dat_pos))-dat_pos(1))/2 )), dat_zahler),nr_text,'HorizontalAlignment','center');
              text(zr_bereich(length(zr_bereich)), x( dat_pos(length(dat_pos)), dat_zahler),nr_text,'HorizontalAlignment','center');
            end
          end
          
          if start_c_zeichnen==1 % Erst-Cluster in abgesetzter Darstellung:
            % Cluster-Zentren mit Std-Abw multiplizieren, sonst Verzerrung
            start_c_handle.farbe_c=plot( zr_bereich , v_start(dat_pos,:),'<k');
            start_c_far_leg=start_c_handle.farbe_c(1); % in der Legende sollen alle Startcluster nur einmal erwählnt werden
          end
          % erstelle erste Cluster-Zentren:
          if a_klasse==max(findd(code))  % Cluster im Vordergrund
            for i=1:size(v_start,2)
              cluster_handle(i,j).farbe=plot( zr_bereich ,v_start(dat_pos,i),'Marker',clust_style_zr(1+rem(i-1,size(clust_style_zr,1)),:),'color',clust_farb(1+rem(i-1,size(clust_farb,1)),:));
              set(cluster_handle(i,j).farbe,'LineWidth',[3]);
              if (sw_symbol==2)
                set(cluster_handle(i,j).farbe,'Marker','.','MarkerFaceColor','k','MarkerEdgeColor','k');
              end
            end
            start=0;
            axis auto;
            achs=axis;
            axis([achs(1) zr_bereich(length(zr_bereich)) achs(3)-0.2*(achs(4)-achs(3)) achs(4)+0.2*(achs(4)-achs(3))]);
          end; % if (start)
          
        else  %plotte alle EINZELMERKMALE
          %hier kracht's noch, wenn ungerade anzahl von em vorhanden sind
          % suche Position der EM-Paare heraus, die gerade gezeichnet werden sollen:
          dat_pos=min ( (anz_zr*length(zr_bereich) + (j-anz_zr)*2 -1) , ( size(x,1)-1 ) ); % "*2" weil 2 EM in ein plot passen
          if dat_pos==0 % dann ist nur ein EM ausgewählt
            dat_pos=[1 1]; % plotte dieses EM gegeneinander
          else
            dat_pos=[dat_pos dat_pos+1]; %plotte EM-Paare
          end
          %% nochmals checken:  j=j+1;
          if sw_symbol~=2
            far(a_klasse).farbe=plot( x( dat_pos(1), dat_tmp'), x( dat_pos(2), dat_tmp'), '.');
          else
            for i=dat_tmp' % muss leider jeder DS einzeln gezeichnet werden, da Klassen (max.Cluster-ZGH) sich ändert
              far(1).farbe(i)=plot( x( dat_pos(1), i), x( dat_pos(2), i), '.');
            end
          end
          if nr_daten >0
            for dat_zahler=dat_tmp' %gehe durch alle Schritte einzeln durch (einer Person, die in dat_tmp rausgesucht wurde)
              nr_text=sprintf('%d',ind_auswahl(dat_zahler));
              text(x( dat_pos(1), dat_zahler), x( dat_pos(2), dat_zahler),nr_text,'HorizontalAlignment','center');
            end
          end
          
          if start_c_zeichnen==1
            start_c_handle.farbe_c=plot(v_start(dat_pos(1),:),v_start(dat_pos(2),:),'<k','LineWidth',[3]);
            start_c_far_leg=start_c_handle.farbe_c(1); % in der Legende sollen alle Startcluster nur einmal erwählnt werden
          end;
        end; % if j<=anz_zr
        if (o_dat~=3)
          if sw_symbol~=2 % für max.Cluster-ZGH Darstellung wird später permanent aktualisiert
            set(far(a_klasse).farbe,'color',cc(1+rem(a_klasse-1,size(cc,1)),:));
            %Abfrage, falls für Ausgangsklasse i keine Daten vorhanden sind:
            if ~isempty(far(a_klasse).farbe(1))&&(j==1) % Legende nur in erstem subplot (j) erstellen
              farlegend=[farlegend far(a_klasse).farbe(1)];
            end;
          end; %if sw_symbol
        end; % if (o_dat~=3)
      end; % a_klasse
    end; % j
    
    if (sw_symbol==2)&&(o_dat~=3) % aktualisieren max-Cluster-ZGH Darstellung
      [tmp1,tmp2]=max(u');
      for i=1:size(u,1) % gehe durch jeden DS
        set(far(1).farbe(i),'color',clust_farb(1+rem(tmp2(i)-1,size(clust_farb,1)),:),'LineStyle',clust_style_em(1+rem(tmp2(i)-1,size(clust_style_em,1)),:), 'LineWidth',2,'MarkerSize',8);
      end;
    end; % if (sw_...)
    
  end; % if video
  
  z=0; %Zählvariable für Anzahl der Iterationsdurchgänge
  if (max_iteration>=0)&&(video>1) % stört, wenn man nur Cluster ZGH berechnen will
    fprintf('Number of calculated iterations: %d    function for optimization: \n',z);
  end
  
  krit=1; %Anfangs-Abbruch-Schranke
  v_opt=v;u_opt=u;
  
  %%%%%%%%%%% EIGENTLICHE CLUSTER BERECHNUNG - START -   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  while (krit>epsilon)&&((z-z_opt)<50)&& ((z<max_iteration) || (max_iteration==0))
    z=z+1; %Zählvariable für Anzeige der Iterationsschritte
    u_dach=u;% speichern der alten Zugehörigkeiten für Abbruchkriterium
    
    
    %Berechne neue Clusterzentren:
    for i=1:size(v,2)
      v(:,i) = x* (u(:,i).^q) / sum(u(:,i).^q);
      
      if any(isnan(v(:,i)))
         v(:,i) = 0;
         mywarning(sprintf('Reset cluster center with NaN values to zero (Iteration %d)!\n',z));
      end;
    end; %i
    
    try
      [u, d, S_clust]=berechne_abstand(abstandsmass, x, v, S_inv, S_inv_b, u, q,[],param);
    catch
      mywarning('Problems by computing distances. Please select a different distance measure');
      cluster_ergebnis =[];
      return;
    end;
    
    krit=sum(sum( (u-u_dach).^2) ); % Abbruchkriterium
    
    %Clusterkriterium
    jkrit=sum(sum(u.^q.*d));
    %bestes merken
    if (jkrit<j_opt)
      v_opt=v;
      u_opt=u;
      j_opt=jkrit;
      z_opt=z;
    end;
    
    if (~rem(z,1)) && (max_iteration>=0) && (video>1)
      %Schreibe Staatus alle 10 Iterationsschritte
      fprintf('Iteration: %d     J_opt= %f   J_krit=%d      Abort criterion= %d \n',z,j_opt,jkrit,krit);
    end;
    
    
    %Strukturänderung alle istrukt Schritte
    %c_setz_neu  =1: Sprinegn springen
    %                =2: NICHT zulassen
    istrukt=5;
    if (~rem(z,istrukt)||(krit<epsilon))&&abs(c_setz_neu-2)
      %welche Cluster vereinigen?
      tmp=mycorrcoef(u);
      tmp=tmp-diag(diag(tmp));
      [a,b]=find(tmp==max(max(tmp)));
      v(:,a(1))=0.5*(v(:,a(1))+v(:,b(1)));
      %neues Zentrum: zufälliges Datentupel, der aber relative weit von Clusterzentren wegliegt
      %(==kleine Streuung!!)
      [tmp,ind]=min(std(u').*(1+rand(1,length(u))));
      v(:,b(1))=x(:,ind);
      krit=2*epsilon;
    end;
    
    if video>1 % für Zeichnung wird keine neue Funktion verwendet, da sonst zu viele Daten umhertransportiert werden
      if video==3
        pause(0.3);
      end;
      if video==4
        pause;
      end;
      
      j=0;
      for supl_var=supl % gehe durch alle subplots
        j=j+1;
        if (start)
          subplot(zeilen,spalten,supl_var);
        end;
        
        for i=1:size(v,2) % gehe nochmals durch alle Clusterzentren, um sie in versch. Farben zu zeichnen
          if j<=anz_zr
            % suche Datenpositionen in x:
            dat_pos=(j-1)*length(zr_bereich)+[1:length(zr_bereich)]';
            
            % Cluster-Zentren müssen mit Std-Abweichung multipliziert werden, sonst Verzerrung gegenüber O-Daten
            set(cluster_handle(i,j).farbe,'Ydata',v(dat_pos,i));
            
          else % j<=anz_zr, d.h. EM
            %hier kracht's noch, wenn ungerade anzahl von em vorhanden sind
            dat_pos=min ( (anz_zr*length(zr_bereich) + (j-anz_zr)*2 -1) , ( size(x,1)-1 ) ); % "*2" weil 2 EM in ein plot passen
            % Kommentare siehe oben:
            if dat_pos==0
              dat_pos=[1 1];
            else
              dat_pos=[dat_pos dat_pos+1];
            end;
            
            if (start)
              cluster_handle(i,j).farbe=plot(v(dat_pos(1),i),v(dat_pos(2),i),'s','color',clust_farb(1+rem(i-1,size(clust_farb,1)),:),'LineWidth',[3],'MarkerSize',15);
              if (sw_symbol==2)
                set(cluster_handle(i,j).farbe,'color','k');
              end
            else
              set(cluster_handle(i,j).farbe,'Xdata',v(dat_pos(1),i),'YData',v(dat_pos(2),i));
            end
          end; % if <=anz_zr
          if (start)
            axis tight;
            achs=axis;
            if j<=anz_zr
              axis([achs(1) zr_bereich(length(zr_bereich)) achs(3)-0.2*(achs(4)-achs(3)) achs(4)+0.2*(achs(4)-achs(3))]);
            end;
          end;
        end; %for i
        
      end; %for j
      if (sw_symbol==2) && (o_dat~=3) % aktualisieren max-Cluster-ZGH Darstellung, für EM und ZR identisch
        [tmp1,tmp2]=max(u');
        for i=1:size(u,1) % gehe durch jeden DS
          set(far(1).farbe(i),'color',clust_farb(1+rem(tmp2(i)-1,size(clust_farb,1)),:),'LineStyle',clust_style_em(1+rem(tmp2(i)-1,size(clust_style_em,1)),:),'MarkerSize',8 );
        end
        
      end;
      
      start=0;
      drawnow;
      
      if get(abbruch,'callback')==0
        sprintf('Premature termination \n');
        break;
      end;
    end; %if video
    
  end; %while
  %%%%%%%%%%% EIGENTLICHE CLUSTER BERECHNUNG - ENDE -   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  if (max_iteration>=0) && (video>1)
    fprintf('%d iteration steps have been applied, J= %f      Abort criterion=%d . \n',z,sum(sum(u.^q.*d)),krit);
  end;
  
  v_opt=v;
  u_opt=u;
  
  if (video>1) %Nachbereitung des plots
    
    j=0;
    for supl_var=supl % gehe durch alle subplots
      j=j+1;
      if (start) 
         subplot(zeilen,spalten,supl_var);
      end;
      
      for i=1:size(v,2) % gehe nochmals durch alle Clusterzentren, um sie in versch. Farben zu zeichnen
        if j<=anz_zr
          dat_pos=(j-1)*length(zr_bereich)+[1:length(zr_bereich)]';
          
          % Cluster-Zentren müssen mit Std-Abweichung multipliziert werden, sonst Verzerrung gegenüber O-Daten
          %    .*std_abw(dat_pos)
          % Abfrage, ob Video an oder aus war (start)
          if (start)
            cluster_handle(i,j).farbe=plot( zr_bereich ,v(dat_pos,i),'Marker',clust_style_zr(1+rem(i-1,size(clust_style_zr,1)),:),'color',clust_farb(1+rem(i-1,size(clust_farb,1)),:));
          else
            set(cluster_handle(i,j).farbe,'Ydata',v(dat_pos,i));
          end;
          
        else % plotte EM
          dat_pos=min ( (anz_zr*length(zr_bereich) + (j-anz_zr)*2 -1) , ( size(x,1)-1 ) ); % "*2" weil 2 EM in ein plot passen
          if dat_pos==0
            dat_pos=[1 1];
          else
            dat_pos=[dat_pos dat_pos+1];
          end;
          if (start)
            cluster_handle(i,j).farbe=plot(v(dat_pos(1),i),v(dat_pos(2),i),'s','color',clust_farb(1+rem(i-1,size(clust_farb,1)),:) );
          else
            set(cluster_handle(i,j).farbe,'Xdata',v(dat_pos(1),i),'YData',v(dat_pos(2),i));
          end
        end; % if <=anz_zr
      end; %for i, gehe durch alle Clusterzentren
      
    end; %for j, gehe durch alle subplots
    start=0;
    drawnow;
    
    titelzeile=[titelzeile,' clustered with ',dist_text];
    % titelzeile in 2 Zeilen unterteilen, falls zu lang
    if length(titelzeile)>150
      titelzeile=sprintf('%s\n%s',titelzeile(1:100),titelzeile(101:length(titelzeile)));
    end
    subplot(zeilen,spalten,1);title(titelzeile);
    
    j=0;
    %Zähler für das i-te Einzelmerkmal in der Visualisierung
    i_em=1;
    
    for supl_var=supl %=[1:anz_zr anz_zr+1:2:anz_zr+anz_em] % gehe durch alle subplots
      j=j+1;
      subplot(zeilen,spalten,supl_var);
      
      if j<=anz_zr
        xlabel('Time');
        ylabel(label_zr(j,:));
        
      else % j<=anz_zr
        dat_pos=min ( (anz_zr*length(zr_bereich) + (j-anz_zr)*2 -1) , ( size(x,1)-1 ) ); % "*2" weil 2 EM in ein plot passen
        % Kommentare siehe oben:
        if dat_pos==0
          dat_pos=[1 1];
        else dat_pos=[dat_pos dat_pos+1];
        end;
        xlabel(label_em(i_em,:));
        i_em=i_em+1;
        ylabel(label_em(i_em,:));
        i_em=i_em+1;
        if (ellipse_on==1)&&(abstandsmass~=6)
          %hier die Metrik raussuchen (S_tmp) zum Einzeichen in plot, falls erwünscht
          switch abstandsmass
            case 3 % hier wurde ein S bereits oben berechnet, also nur noch passende Stelle suchen
              S_tmp=S(dat_pos(1):dat_pos(2),dat_pos(1):dat_pos(2));
              my_ellip(S_tmp,mean(x(dat_pos(1):dat_pos(2),:),2)',1,'k');
            case 4
              for i=1:size(v,2)
                S_tmp=S_clust{i};
                
                %ÄNDERUNG: RALF 5.1.05, ergänzte Zeile als Bugfix, sonst steigt my_ellip bei mehr als 2 Dimensionen aus%%%%
                S_tmp=S_tmp(dat_pos(1):dat_pos(2),dat_pos(1):dat_pos(2));
                %ÄNDERUNG: RALF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                my_ellip(S_tmp,v(dat_pos(1):dat_pos(2),i)',1,'k');
              end;
            otherwise
              S_tmp=pinv(S_inv(dat_pos(1):dat_pos(2),dat_pos(1):dat_pos(2)));
              %sonst wird Ellipse zu klein:
              if (abstandsmass==1)
                S_tmp=S_tmp*max(std(x'));
              end;
              % kann hier im Verhältnis der max. Streuung vergrößert werden:
              my_ellip(S_tmp,mean(x(dat_pos(1):dat_pos(2),:),2)',1,'k');
          end; %switch
        end; % if (ellipse_on==1)
      end; %if j
    end; % for j
    
    if (legend_on)
      start_c_text=sprintf('%d starting cluster (%s)',size(v,2),start_c_text);
      %kleiner Trick, um neue Clusterzentren alle pauschal schwarz zu zeichnen und nicht in den versch. Farben:
      for i=1:size(v,2)
        clust_bez(i).name=sprintf('Cluster %d',i);
      end;%Baue Cluster-Legende auf
      for i=1:size(cluster_handle,1)
        clust_leg(i)=cluster_handle(i,1).farbe;
      end; %Baut Legenden-handles auf
      % Baue Legenden Text auf (je nachdem, ob O-Daten, Startcluster zeichnen aktiviert ist):
      leg_text='';
      if (o_dat~=3) && (sw_symbol~=2)
        leg_text=char(leg_text,legend_bez( findd(code) ).name);
      end;
      if start_c_zeichnen==1
        leg_text=char(leg_text,start_c_text);
      end;
      leg_text=char(leg_text,clust_bez.name);
      leg_text(1,:)=[];
      try
        legend([farlegend,start_c_far_leg,clust_leg],leg_text,1);
      end;
    end; % if legend
    
  end; %if video>1
  
  %%%%%%%%%%%%%%%%%%%%%% GLOBALE CLUSTER VALIDIERUNGEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if (max_iteration>=0) && (validierung_berechnen==1) % wenn nur ZGH berechnet, dann keine Validierungen berechnen, z.B. über alle Datentupel gibt es in der Regel Ärger
    
    if durchlaeufe==1
      f=fopen('cluster_valid.txt','wt');
    else
      f=fopen('cluster_valid.txt','at');
    end;
    
    fprintf(f,'Features: %s %s \n \n',label_zr',label_em');
    fprintf(f,'Number of cluster centres: %d \n \n',anz_c_zentr);
    
    % Berechnung Kompaktheit der Partition
    % (ist nicht zu empfehlen, weil j_opt mit speziellen Distanzen und Einbezug von q besser ist)
    % diese Kompaktheit ist stark von der Clusteranzahl abhängig!
    for i=1:size(v_opt,2) % gehe durch alle Cluster_zentren
      kompaktheit(i)=sum(     (u_opt(:,i).^2)' .* (ones(1,size(x,1))*((x-v_opt(:,i)*ones(1,size(x,2))).^2))    )     /sum(u_opt(:,i));
    end;
    valid.kompaktheit(anz_c_zentr)=(1/size(v_opt,2))*sum(kompaktheit);
    fprintf(f,'compactness: %f \n',valid.kompaktheit(anz_c_zentr));
    
    %Berechnung von ZGH Validierungen:
    valid.mean_ZGH_Schranke(anz_c_zentr)=mean(u_opt(u_opt>1/size(u_opt,2)));
    fprintf(f,'Medium affiliation of clusters over minimum barrier 1/number of features = 1/%d = %f : %f \n',anz_c_zentr,1/anz_c_zentr,valid.mean_ZGH_Schranke(anz_c_zentr));
    
    [tmp1,tmp2]=max(u_opt');
    valid.mean_max_ZGH(anz_c_zentr)=mean(tmp1);
    fprintf(f,'Medium max. affiliation of clusters: %f (completely worse=%f=1/number of cluster centres) \n',valid.mean_max_ZGH(anz_c_zentr),1/size(u_opt,2));
    
    % Bezdek's PC:
    valid.pc(anz_c_zentr)=sum(sum(u_opt.^2))/size(x,2);
    fprintf(f,'Coefficient of partition with  1/number of cluster centres = %f <= Pc <= 1 thus  PC = %f\n',1/anz_c_zentr,valid.pc(anz_c_zentr));
    
    % Partitionsentropie
    valid.pe(anz_c_zentr) = -sum(sum(u_opt.*log(u_opt)))/size(x,2);
    fprintf(f, 'Partition entropy = %f (worst case= %f)\n', valid.pe(anz_c_zentr), log(anz_c_zentr));
    
    % Windham PX, sicherheitshalber mal schönlangsam durchgehen, optimiert kann später:
    max_zgh=max(u_opt');
    
    px_mul=1;
    %for j=1:size(x,2) % gehe durch alle Datentupel
    for j=1:length(max_zgh)
      mu=floor(1/max_zgh(j));
      if max_zgh(j)>1
        warning('A MBF can not have values > 1! ');
      end; % diese Warnung sollte nicht vorkommen (anz_c_zentr>1 und q>1)
      px_sum=0;
      %         px_vek=[];
      for l=1:mu
        px_sum = px_sum +  (-1)^(l+1)  * nchoosek(anz_c_zentr,l) *  (1-l*max_zgh(j))^(anz_c_zentr-1)  ;
        %px_vek=[px_vek     (-1)^(l+1)  * nchoosek(anz_c_zentr,l) *  (1-l*max_zgh(j))^(anz_c_zentr-1) ];
      end
      px_mul = px_mul * px_sum;
    end;
    if px_mul
      valid.px(anz_c_zentr)=-log2(px_mul);
    else
      valid.px(anz_c_zentr)=Inf;
    end;
    fprintf(f,'Windham Proportion exponent is PX=%f \n',valid.px(anz_c_zentr));
    
    % die eigentliche Optimierungsfunktion J_q:
    valid.j_q(anz_c_zentr)=j_opt;
    fprintf(f,'Objective Function J_q=%f \n',valid.j_q(anz_c_zentr));
    
    % Trennungsgrad, separation:
    if (length(S_inv_b)>1)
      S_inv_b=S_inv_b(:,1:size(v,2));
    end;
    [tmp, d_cluster]=berechne_abstand(abstandsmass, v, v, S_inv, S_inv_b, diag(ones(size(v,2),1)) , q, S_clust,param);
    d_cluster=d_cluster+eye(length(d_cluster))*1E+10;
    d_cluster=min(min(d_cluster));
    valid.s(anz_c_zentr)=j_opt/(anz_c_zentr*d_cluster);
    valid.d_min_cluster(anz_c_zentr)=d_cluster;
    fprintf(f,'Degree of separation S=%f \n \n',valid.s(anz_c_zentr));
    fclose(f);
    
  end; % if (max_iteration>=0)
  
  %Ergebnisse Durchläufe speichern...
  erg_durchlauf(durchlaeufe).v_opt=v_opt;
  erg_durchlauf(durchlaeufe).u_opt=u_opt;
  
  
end; % for durchlaeufe=1:length(anz_c_zentr_vek), schau mal ganz weite oben

% nun zeichne mal die verschiedenen Cluster-Validierungen:
if (length(anz_c_zentr_vek)>1) && ( exist('valid', 'var') ) && ~isempty(valid)
  %empfehle Clusteranzahl:
  % aufgrund von separation s:
  tmp=find(diff([Inf valid.s(anz_c_zentr_vek) Inf])>=0)-1;
  valid.anz_clust_empfehlung_s=anz_c_zentr_vek( tmp(1) ); % erstes lokales Minumum in separation s
  
  %bestes Ergebnis Durchlauf übernehmen...
  v_opt=erg_durchlauf(tmp(1)).v_opt;
  u_opt=erg_durchlauf(tmp(1)).u_opt;
  
  %zeige Validierungen:
  tmp=figure;
  subplot(5,1,1);
  hold on;
  plot(anz_c_zentr_vek,valid.kompaktheit(anz_c_zentr_vek),'*-b');
  legend('compactness');
  set(gcf,'numbertitle','off','name',sprintf('%d: Cluster validation',get_figure_number(gcf)));
  
  
  subplot(5,1,2);
  hold on;
  plot(anz_c_zentr_vek,valid.px(anz_c_zentr_vek),'*-c');
  legend('Proportion Coefficient PX');
  
  subplot(5,1,3);
  hold on;
  plot(anz_c_zentr_vek,valid.mean_ZGH_Schranke(anz_c_zentr_vek),'*-r');
  plot(anz_c_zentr_vek,valid.mean_max_ZGH(anz_c_zentr_vek),'p-k');
  plot(anz_c_zentr_vek,valid.pc(anz_c_zentr_vek),'*-y');
  legend('Medium affiliation above minimum barrier','Medium maximum affiliation','Partition Coefficient');
  
  subplot(5,1,4);
  hold on;
  plot(anz_c_zentr_vek,valid.s(anz_c_zentr_vek),'s-y');
  legend('Separation');
  
  figure;
  hold on;
  set(gcf,'numbertitle','off','name',sprintf('%d: Cluster: Separation',get_figure_number(gcf)));
  
  plot(anz_c_zentr_vek,valid.s(anz_c_zentr_vek),'s-y');
  legend('Separation');
  
  figure(tmp);
  subplot(5,1,5);
  hold on;
end;

%Ergebnisse in Struct speichern
cluster_ergebnis.cluster_zentren=v_opt;
cluster_ergebnis.cluster_zgh=u_opt;
cluster_ergebnis.anz_cluster=size(cluster_ergebnis.cluster_zgh,2);
cluster_ergebnis.param=param;
cluster_ergebnis.valid=valid;
cluster_ergebnis.S_clust=S_clust;
cluster_ergebnis.ind_auswahl=ind_auswahl;


cluster_ergebnis.S_inv = S_inv;

for i_cluster=1:cluster_ergebnis.anz_cluster
  cluster_ergebnis.newtermname(i_cluster).name = sprintf('Cluster %d/%d',i_cluster,cluster_ergebnis.anz_cluster);
end;
if param.noise_cluster_method>1
  cluster_ergebnis.newtermname(cluster_ergebnis.anz_cluster).name= 'Noise cluster';
end;

