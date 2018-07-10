  function visu_zeitreihe(d_orgs,code,var_bez,zgf_y_bez,parameter,par,labeltext,titelzeile,ref,anzeige_norm,ind_auswahl,erster_andere,no_figure,x_beschrift,sw_symbol,linienstaerke,time,nosubplots)
% function visu_zeitreihe(d_orgs,code,var_bez,zgf_y_bez,parameter,par,labeltext,titelzeile,ref,anzeige_norm,ind_auswahl,erster_andere,no_figure,x_beschrift,sw_symbol,linienstaerke,time,nosubplots)
%
% time - Aufteilung Punkte auf x-Achse (optional, sonst 0: Länge Zeitreihe -1)
% nosubplots - Ist eine etwas trickreiche Anpassung: um mehrere Zeitreihen in ein Bild zeichnen zu können (ohne subplots). Verwendung siehe callback_visuzeitreihe.
%
% The function visu_zeitreihe is part of the MATLAB toolbox Gait-CAD. 
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

norm_farbe=0.85;

if nargin<11
   ind_auswahl=0;
end; %für Darstellung der Datentupel-Nr.
if nargin<12
   erster_andere=0;
end;
if nargin<13
   no_figure=0;
end;
if nargin<14
   x_beschrift='';
end;% Initialisierung %
if isempty(x_beschrift)
   x_beschrift='% ambulation cycles';
end % dafault, de.

if nargin<15
   sw_symbol=[];
end;
if isempty(sw_symbol)
   sw_symbol=1;
end % dafault
if nargin<16
   linienstaerke=[];
end;
if isempty(linienstaerke)
   linienstaerke=1;
end % dafault

%ÄNDERUNG RALF
if (nargin<17)
   time=[];
end;

% ÄNDERUNG OLE
if (nargin < 18)
   nosubplots = [];
end;

if isempty(time)
   %Abstastfrequenz nachschauen
   tf=parameter.gui.zeitreihen.abtastfrequenz;
   tmp = parameter.gui.zeitreihen.anzeige;
   switch(tmp)
      case 'Percental' % Prozentuale Anzeige?
         time=[parameter.gui.zeitreihen.segment_start-1:parameter.gui.zeitreihen.segment_ende-1]*100./(size(d_orgs,2)-1);
         x_beschrift = 'Percent';
      case 'Time' % Zeit anzeigen
         %Zeitachse setzen
         x_beschrift=['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
         time=[parameter.gui.zeitreihen.segment_start-1:parameter.gui.zeitreihen.segment_ende-1]/tf;
      case 'Project' % Projektspezifische Einheit anzeigen
         %Zeitachse setzen
         x_beschrift=parameter.projekt.timescale.name;
         if parameter.gui.zeitreihen.segment_ende>length(parameter.projekt.timescale.time)
            parameter.gui.zeitreihen.segment_ende = length(parameter.projekt.timescale.time);
         end;
         
         time=parameter.projekt.timescale.time(parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende);
      otherwise %'Abtastpunkte' - Samplepunkte anzeigen
         time=[parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende];
         x_beschrift = 'Sample points';
   end;
end;


%imageplot ist sinnlos, wenn es nur eine Zeitreihe gibt
if length(code)== 1
   parameter.gui.zeitreihen.image_plot = 0;
end;

%Imageplot: nur ein Teil der Optionen ist möglich

if parameter.gui.zeitreihen.image_plot ==1
   parameter.gui.anzeige.legende = 0;
   parameter.gui.anzeige.anzeige_nr_datentupel = 0;
   ref = [];
   %Reaktion auf evtl. gedrehte Zeiten
   [temp,timeind] = sort(time);
   param.fA 						= parameter.gui.zeitreihen.abtastfrequenz;
   param.fensterLaenge 			= parameter.gui.zeitreihen.fenstergroesse;
   param.colormap					= parameter.gui.zeitreihen.colormap;
   param.kennlinie_art 			= parameter.gui.zeitreihen.kennlinie;
   param.phasengang  			= parameter.gui.zeitreihen.phasengang;
   param.x_beschrift          = ['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
   param.y_beschrift          = ['Frequency [' char(parameter.gui.zeitreihen.einheit_abtastfrequenz_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
   
   if (param.kennlinie_art == 2)
      param.kennlinie_parameter	= parameter.gui.zeitreihen.exponent_wurzel;
   elseif (param.kennlinie_art == 3)
      param.kennlinie_parameter	= parameter.gui.zeitreihen.exponent_exp;
   end;
   param.kennlinie_name 		= deblank(parameter.gui.zeitreihen.kennlinie_name(param.kennlinie_art,:));
   param.colorbar_anzeigen		= parameter.gui.zeitreihen.plot_colorbar;
   param.zeitverschiebung     = (parameter.gui.zeitreihen.segment_start-1)/parameter.gui.zeitreihen.abtastfrequenz;
   % Automatische Farbachsenskalierung?
   if (parameter.gui.zeitreihen.caxis)
      param.caxis = [];
   else
      param.caxis = parameter.gui.zeitreihen.caxis_vec;
   end;
   if parameter.gui.zeitreihen.log>2
      parameter.gui.zeitreihen.log = parameter.gui.zeitreihen.log-2;
   end;
end;

%Neu: nur der interessierende ZR-Bereich wird überhaupt ausgewertet...
d_orgs=d_orgs(:,parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende,:);
if ~isempty(ref)
   ref.my=ref.my(:,parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende,:);
   ref.mstd=ref.mstd(:,parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende,:);
end;


if isempty(code)
   mywarning('No data points selected!');
   return;
end;

%RALF: TRICK, um mit Tobis komischen vorbereiteten Optionen und Bilder-Ausschalten bei Makros umgehen zu können:
%no_figure==0: Normalmodus: draußen nichts vorbereitet, neues Bild
%no_figure==1: alle Merkmale draußen vorbereitet, keine Bilder
%no_figure==2: draußen nichtts vorbereitet, keine Bilder
if no_figure==1
   %alles draussen schon vorbereitet
   merk=1; %nur ein Merkmal!
   if (isfield(parameter.gui, 'ganganalyse') && isfield(parameter.gui.ganganalyse, 'links_rechts'))
      l_r_darst = parameter.gui.ganganalyse.links_rechts;
   else
      l_r_darst = 0;
   end;
   leg=parameter.gui.anzeige.legende; %Legenden
else
   merk=parameter.gui.merkmale_und_klassen.ind_zr; %sucht ausgewählte Zeitreihen_Merkmal aus
   if (isfield(parameter.gui, 'ganganalyse') && isfield(parameter.gui.ganganalyse, 'links_rechts'))
      l_r_darst = parameter.gui.ganganalyse.links_rechts;
   else
      l_r_darst = 0;
   end;
   leg=parameter.gui.anzeige.legende; % schaut, ob Button 'Show legend' aktiviert ist
end;

%if ( ~(no_figure || isempty(nosubplots)) )
if ~isempty(nosubplots)
   merk = nosubplots';
   l_r_darst = 0;
   leg=parameter.gui.anzeige.legende;
end;

%Abtesten, ob Makro Bilder ausschalten will
temp=no_figure_test;
if (~isempty(temp) && temp==1)
   no_figure=1;
end;
k=0;

if ~no_figure
   %Standard-Visuzeitreihe, malt neues Bild
   f1=figure;
   hold on;
   set(f1,'Position',[50 150 750 530]);
else
   if get_figure_number(gcf) == 1
      figure;
   end;
end;

%Merkmal auswählen
if l_r_darst
   merk(2,:)=zeros(size(merk));
   for j=1:size(merk,2)
      merk(2,j)=find_merk(var_bez(merk(1,j),:),var_bez,1,1);
   end; %j
   if ~sum(merk(2,:)) % falls mindestens zu einem Merkmal keine passende li bzw. re Kurve gefunden wurden
      mywarning('No corresponding time series for other body side. ');
      merk(2,:)=[];
   end
end

nr_ausgangsgroesse=parameter.gui.merkmale_und_klassen.ausgangsgroesse;

% Titelzeile löschen, falls zu lang
if length(titelzeile)>100
   titelzeile='';
   fprintf(1,'The title was too long and was deleted.\n');
end;

%enthaltene Ausgangsklassen
code_ind=findd(code);


%Farb-Matrix bzw. sw_style
[cc, c_style]=color_style(parameter.gui.anzeige.farbvariante);

%Farben ausrechnen
farbreihe        = 1+rem(code_ind-1,size(cc,1));
farbreihe_cstyle = 1+rem(code_ind-1,size(c_style,1));

%Abfang: Wenn nur Normdaten in Datenauswahl zur Ansicht gewählt sind (sonst später warning Meldung)
if isempty(code_ind)
   code_ind=findd(code);
end;

%Matlab Leckerbissen: Sortiere code_ind nach Anzahl Unterschiedlicher code's
% damit später zuerst die geplottet werden, die am meisten Kurven haben (sie sind dann auch im Hintergrund)
for i=1:length(code_ind)
   anz(i)=sum(code==code_ind(i));
end;
[a, b]=sort(-anz);
code_ind=code_ind(b);
%Farben sortieren
farbreihe        = farbreihe(b);
farbreihe_cstyle = farbreihe_cstyle(b);


for l=1:size(merk,2) % gehe durch alle ausgewählten Merkmale
   
   % Trick: ceil(..) sucht passende Anzahl von Zeilen im subplot, Division mit tmp(=1 oder2) ist nochmals Spezialtrick, Tip: spiel mal mit rum!
   %aber kracht, wenn Merkmal bereits übergeben wird
   %Änderung Ralf: Umorganisation Subplots
   if (~no_figure && isempty(nosubplots))
      %subplot(ceil(size(merk,2)/tmp),tmp,l);
      if size(merk,2)<7
         subx=size(merk,2);
         suby=1;
      else
         subx=ceil(sqrt(size(merk,2)));
         suby=ceil(size(merk,2)/subx);
      end;
      %Ende Änderung Ralf: Umorganisation Subplots
      subplot(subx,suby,l);
   end;
   
   if l==1 % schreibe Titel nur ins erste subplot
      if (~isempty(ref) && anzeige_norm && ~no_figure)
         title(sprintf('%s (Norm)\n%s',ref.titelzeile,titelzeile));
      else
         title(titelzeile);
      end
   end % if l==1
   
   hold on;
   for j=size(merk,1):-1:1 %zuerst mit der 2. (li bzw. re) Kurve anfangen, da Parameter dann überschrieben und für erste Kurve später verwendet
      k=0; % Gruppenbezeichner für versch. Farb-Anzeige
      
      % ÄNDERUNG OLE:
      % Bei mehreren Datentupeln sind die Normdaten z.T. etwas schwer zu finden, wenn sie im Hintergrund
      % sind. Daher per Option umschalten zwischen zeichnen im Vordergrund und Hintergrund.
      % Normdaten zuerst zeichnen (=im Hintergrund)
      if (~parameter.gui.ganganalyse.normdaten_vordergrund) && isempty(get(gca,'userdata'))
         legende_norm=[''];
         if (~isempty(ref) && anzeige_norm)
            %neu: Normdaten als grauer Bereich...
            hndl_fill=fill([time fliplr(time)],[ref.my(1,:,merk(j,l))+ref.mstd(1,:,merk(j,l)) ref.my(1,end:-1:1,merk(j,l))-ref.mstd(1,end:-1:1,merk(j,l))],norm_farbe*[1 1 1]);
            set(hndl_fill,'EdgeColor',norm_farbe*[1 1 1]);
            set(gca,'userdata',1);
         end; % if ref...
      end; % if (~parameter.gui.ganganalyse.normdaten_vordergrund)
      
      
      % Daten einzeichnen (sind dann im Vordergrund)
      if parameter.gui.zeitreihen.image_plot == 0
         for i=code_ind
            k=k+1;
            ind=find(code==i)';  % i wird nur hier zum suchen von ind verwendet
            
            if erster_andere
               far(k).farbe(1)=plot(time,squeeze(d_orgs(ind(1),:,merk(j,l)))');
               if (length(ind)>1)
                  far(k).farbe(2:length(ind))=plot(time,squeeze(d_orgs(ind(2:length(ind)),:,merk(j,l)))','--');
               end;
            else
               far(k).farbe=plot(time,squeeze(d_orgs(ind,:,merk(j,l)))');
               if ~isempty(ind_auswahl) && ~isempty(find(ind_auswahl)) && (parameter.gui.anzeige.anzeige_nr_datentupel)
                  for dat_zahler=ind
                     dat_text=sprintf('%d',ind_auswahl(dat_zahler));
                     text(time(1),d_orgs(dat_zahler,1,merk(j,l)),dat_text,'HorizontalAlignment','center');
                     %Vorsicht: "...reihe-1)/2)-1" die "-1" mußte sein, da hier mit time
                     % gearbeitet wird, nicht mit par.laenge_zeitreihe (historisch begründet)
                     %text(round( (par.laenge_zeitreihe-1)/2)-1,d_orgs(dat_zahler, round( (par.laenge_zeitreihe-1)/2 ), merk(j,l)),dat_text,'HorizontalAlignment','center');
                     %ÄNDERUNG RALF: jetzt mit time!
                     text(time(round(length(time)/2)),d_orgs(dat_zahler, round( (size(d_orgs,2)-1)/2 ), merk(j,l)),dat_text,'HorizontalAlignment','center');
                     text(time(length(time)),d_orgs(dat_zahler,end,merk(j,l)),dat_text,'HorizontalAlignment','center');
                  end
               end
            end;
            set(far(k).farbe,'color',cc(farbreihe(k),:),'LineWidth',linienstaerke);  % Einstellungen "normale" Kurven
            % nachfolgende Zeile ist z.B. für gestrichelte zweite Ausgangsklasse:
            if sw_symbol==3
               set(far(k).farbe,'LineStyle','-','Marker',char(c_style(farbreihe_cstyle(k))),'color','k');
            end;
            
            if sw_symbol == 1 && parameter.gui.anzeige.farbvariante == 9
               set(far(k).farbe,'LineStyle','-','Marker',char(c_style(farbreihe_cstyle(k))));
            end;
            
            if j==1
               farlegend(k)=far(k).farbe(1);
               
            end; %Legende nur für eine Seite eines Merkmals, nicht für dazugehörende li/re Kurven
            
            if (isfield(parameter.gui, 'ganganalyse') && isfield(parameter.gui.ganganalyse, 'timeseries_left_right'))
               if parameter.gui.ganganalyse.timeseries_left_right(merk(j,l))==1
                  %rechts durchgezogen
                  set(far(k).farbe,'LineStyle','-');
               end;
               if parameter.gui.ganganalyse.timeseries_left_right(merk(j,l))==2
                  %links gestrichelt
                  set(far(k).farbe,'LineStyle','--');
               end;
            end; % Unterscheidung linke und rechte Zeitreihe
         end; %i
      else
         if parameter.gui.zeitreihen.image_plot_classsort == 1
            %klassenweise nach Ausgangsgröße sortieren
            mycode = code;
         else
            %keine Sortierung
            mycode = [1:length(code)]';
         end;
         
         [temp,ind] = sort(mycode);
         
         spect{1} = squeeze(d_orgs(ind,timeind,merk(j,l)));
         spect{3} = time';
         spect{2} = [1:length(ind)]';
         if isempty(nosubplots) || nosubplots == 0
            param.figurename = deblank(var_bez(merk(1,l),:));
         end;
         show_spectrogram(spect,param,gcf,'','');
         
         %NEW: plot the class names to the y axis
         temp_code=[generate_columnvector(find(diff(mycode(ind))));length(ind)];
         
         ax = axis;
         ax(1) = ax(1)-0.01*(ax(2)-ax(1));
         ax(3) = ax(3)-0.01*(ax(4)-ax(3));
         axis(ax);
         grid off;
         switch parameter.gui.zeitreihen.image_plot_classsort
            case 0
               set(gca,'ytick',[1:length(ind_auswahl)]+0.5);
               if ind_auswahl(1)~=0
                  set(gca,'yticklabel',ind_auswahl);
               else
                  set(gca,'yticklabel',1:length(ind_auswahl));
               end;
            case 1
               set(gca,'ytick',temp_code+1);
               set(gca,'yticklabel',char(zgf_y_bez(par.y_choice,mycode(ind(temp_code))).name));               
         end;         
         
      end; % parameter.gui.zeitreihen.image_plot
      
      
      % Normdaten zuletzt zeichnen (=im Vordergrund)
      if (parameter.gui.ganganalyse.normdaten_vordergrund)
         legende_norm=[''];
         if (~isempty(ref) && anzeige_norm)
            legende_norm=[''];
            if (~isempty(ref) && anzeige_norm)
               hndl_fill=fill([time fliplr(time)],[ref.my(1,:,merk(j,l))+ref.mstd(1,:,merk(j,l)) ref.my(1,end:-1:1,merk(j,l))-ref.mstd(1,end:-1:1,merk(j,l))],norm_farbe*[1 1 1]);
               set(hndl_fill,'EdgeColor',norm_farbe*[1 1 1]);
            end; % if ref...
         end;
      end; % if (parameter.gui.ganganalyse.normdaten_vordergrund)
   end; %j
   
   if (isempty(nosubplots))
      var_bez_text = var_bez(merk(1,l),:);
      %Achse jetzt ohne Labeltext, der kommt dafür in den Titel
      ylabel(kill_lz(sprintf('%s ',var_bez_text)),'FontSize',12);
      if parameter.gui.zeitreihen.image_plot_classsort ~= 1
         grid on;
      end;
      xlabel(x_beschrift,'FontSize',12);
      if parameter.gui.zeitreihen.image_plot == 0
         xlim([min(time) max(time)]);
      end;
   else
      var_bez_text = zgf_y_bez(nr_ausgangsgroesse, 1).name;
      %kann bei Verzicht auf Subplots sonst ewig dauern, deswegen nur ein Aufruf ...
      if l==1
         grid on;
         ylabel('Measurement values');
         xlabel(x_beschrift,'FontSize',12);
         if parameter.gui.zeitreihen.image_plot == 0
            xlim([min(time) max(time)]);
         end;
      end;
   end;
   
   %Aufbau Legende mit zgf_y_bez (wenn vorhanden und belegt)
   %nur die aktiven Klassen far(find(far)) werden in die Legende eingetragen
   %Anzeigereihenfolge für Legende wiederherstellen
   [tmp,indsort]=sort(b);
   
   %Änderung RALF: Legende kommt nur noch ins letzte Bild
   if leg && l==size(merk,2)
      if (size(zgf_y_bez,2)>=length(far))
         tmp=sprintf('''%s'',',zgf_y_bez(nr_ausgangsgroesse,code_ind(indsort)).name);
         eval(sprintf('legend(farlegend(indsort),%s)',tmp(1:length(tmp)-1)));
      end;
   end; %leg
end; %l

%Figure-Titel modifizieren
if ~isempty(nosubplots) && any(nosubplots ~= 0)
   % Wenn die Zeitreihen alle in eine Abbildung geschrieben werden, stimmt die Auswahl nicht.
   % Somit wird immer der Name der ersten Zeitreihe im Projekt angezeigt. Verwende stattdessen
   % den Bezeichner aus zgf_y_bez.
   figurename = sprintf('%d: %s %s u.a.', get_figure_number(gcf), labeltext, zgf_y_bez(1,1).name);
else
   if size(merk,2) ==1
      figurename=sprintf('%d: %s %s',get_figure_number(gcf),labeltext,var_bez(merk(1,1),:));
   else
      figurename=sprintf('%d: %s %s ff.',get_figure_number(gcf),labeltext,var_bez(merk(1,1),:));
   end;
end;

set(gcf,'numbertitle','off','name',kill_lz(figurename));

%Callback für Auswahl von Zeitreihensegmenten
if isempty(findobj('type','uimenu','label','Select time series segment','parent',gcf))
   uimenu('parent',gcf,'label','Select time series segment','callback','mode=0;callback_zeitreihensegment;');
end;


%Callback für Auswahl von Triggerereignissen
if par.anz_dat==1 && isempty(findobj('type','uimenu','label','Set trigger event','parent',gcf))
   temp=uimenu('parent',gcf,'label','Set trigger event');
   uimenu('parent',temp,'label','Class 1','callback','mode=1;callback_zeitreihensegment;');
   uimenu('parent',temp,'label','Class 2','callback','mode=2;callback_zeitreihensegment;');
   uimenu('parent',temp,'label','Class 3','callback','mode=3;callback_zeitreihensegment;');
   uimenu('parent',temp,'label','Class 4','callback','mode=4;callback_zeitreihensegment;');
   uimenu('parent',temp,'label','Class 5','callback','mode=5;callback_zeitreihensegment;');
end;

switch parameter.gui.zeitreihen.log
   case 2
      set(gca,'xscale','log');
   case 3
      set(gca,'yscale','log');
   case 4
      set(gca,'xscale','log');
      set(gca,'yscale','log');
end;



