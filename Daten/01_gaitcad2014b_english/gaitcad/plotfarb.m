  function plotfarb(d,code,parameter_gui_anzeige_or_za_mode,sw_mode,var_bez,zgf_bez,legende_an,ind_auswahl,x_y_tausch,grautoene,farb_variante,parameter_gui_anzeige)
% function plotfarb(d,code,parameter_gui_anzeige_or_za_mode,sw_mode,var_bez,zgf_bez,legende_an,ind_auswahl,x_y_tausch,grautoene,farb_variante,parameter_gui_anzeige)
%
% zeichnet Daten d mit farbigen Sternen (sw_mode==1), Zahlen (sw_mode==2) oder SW-Symbolen (sw_mode==3)
% in ein- bis dreidimensionales Bild, je nach Spaltenzahl von d
% code muss ganzzahlig sein !
%  d enthält Datenmatrix, wenn nur eine Spalte wird gegen code als Ausgangsklasse geplottet
%         für d zweispaltig (bzw. dreispaltig), wird gegen 1. Spalte über 2. geplottet (analog: 3-spaltig)
%         die Farbe kann dabei mit code eingestellt werden.
%  var_bez ist für die x,y,z-labels  (optional)
%  zgf_bez für die Legende (optional)
% wenn za_mode==1, werden noch Nummern des Datentupels hinzugezeichnet, aber nicht bei sw_mode==1
% 
% wir plotten niemals mit plotfarb in Bild 1 ;-)
%
% The function plotfarb is part of the MATLAB toolbox Gait-CAD. 
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

if gcf==1
    figure;
end;

hold on;
grid on;
zoom on;

if (nargin<3)
    parameter_gui_anzeige_or_za_mode=0;
end;
if isstruct(parameter_gui_anzeige_or_za_mode)
    parameter_gui_anzeige = parameter_gui_anzeige_or_za_mode;
   
    %switch for old or new parameter style, all other parameters
    za_mode       = parameter_gui_anzeige.anzeige_nr_datentupel;
    sw_mode       = parameter_gui_anzeige.anzeige_grafiken;
    legende_an    = parameter_gui_anzeige.legende;
    x_y_tausch    = parameter_gui_anzeige.em_anzeige_xy_tausch;
    farb_variante = parameter_gui_anzeige.farbvariante;
    inverse_order = parameter_gui_anzeige.inverse_class_order;
    grautoene     = 0;
    marker_size   = parameter_gui_anzeige.marker_size;
else
    parameter_gui_anzeige = [];
    za_mode = parameter_gui_anzeige_or_za_mode;
    inverse_order = 0;
    marker_size   = 6;
end;

if (nargin<4) && isempty(parameter_gui_anzeige)
    sw_mode=1;
end;
if (nargin<5)
    var_bez='';
end;
if (nargin<6)
    zgf_bez='';
end;
if (nargin<7) && isempty(parameter_gui_anzeige)
    legende_an=1;
end;
if (nargin<8)
    ind_auswahl=0;
end;
if (ind_auswahl==0)
    if za_mode
        warning('No data point numbers knows -> new numbers defined.');
    end;
end;
if (nargin<9) && isempty(parameter_gui_anzeige)
    x_y_tausch=0;
end;
if (nargin<10) && isempty(parameter_gui_anzeige)
    grautoene=0;
end; % zum darstellen unterschiedlicher Helligkeiten ( Vektor: Laenge=size(d,1) ), Empfehlung: Grautöne im SW-Modus (z.B. max Cluster-ZGH)
if (nargin<11) && isempty(parameter_gui_anzeige)
    farb_variante=4;
end; % zum Einstellen von Farb/Style Varianten

if isempty(var_bez)
    var_bez=['1st feature';'2nd feature';'3rd feature'];
end;
if x_y_tausch %hier einfach var_bez und d vertauscht, um x-y-z Achse zu vertauschen
    % obacht: bei plot gegen code wird unten nochmals Abfrage durchgeführt, allerdings nur beim plot-Befehl
    %  nicht
    var_bez = flipud(var_bez) ;
    d = fliplr(d);
end

%wenn Klassen-Nummern, dann ohne Nr. Datentupel!
if (sw_mode==2)
    za_mode=0;
end;

%Farb-Matrix
[cc,sty,color_and_style]=color_style(farb_variante);

uni_code = unique(code)';

%Option: veränderte Druckreihenfolge, irgendwann mal rausziehen
if inverse_order
    uni_code = fliplr(uni_code);
end;

%special solution for bicolor images (only 2D)
if ~isempty(farb_variante) && farb_variante == 10
    try
        secondary_output.code      = evalin('base','code_alle(ind_auswahl,parameter.gui.anzeige.different_class);');
        secondary_output.zgf_y_bez = evalin('base','zgf_y_bez(parameter.gui.anzeige.different_class,1:par.anz_ling_y(parameter.gui.anzeige.different_class));');
    end;
    
    for i1=generate_rowvector(uni_code)
        c1 = find(code==i1);
        uni_code_c2 = unique(secondary_output.code(c1));
        for i2=generate_rowvector(uni_code_c2)
            c2 = find(secondary_output.code(c1) == i2);
            far(i1,i2)=plot(d(c1(c2),1),d(c1(c2),2),'*');
            set(far(i1,i2),'color',cc(1+rem(i1-1,size(cc,1)),:));
            set(far(i1,i2),'Marker',sty(1+rem(i2-1,length(sty))),'MarkerSize',marker_size);
        end;
    end;
    
else
    for i=generate_rowvector(uni_code)
        c=find(code==i);
        
        %Sterne bei farbig
        if (sw_mode==1)&&(~isempty(c))
            if (size(d,2)==1)  % gegen Ausgangsklasse zeichnen
                far(i)=plot(d(c,1),ones(size(c)),'*');
            end;
            if (size(d,2)==2)  % 2D plots
                far(i)=plot(d(c,1),d(c,2),'*');
                if grautoene % hier als Farb-Sättigungen:
                    tmp=sprintf('%c',sty(1+rem(i-1,length(sty))));
                    % nochmals alle Daten über die bestehenden zeichnen, damit Legende bleibt:
                    set(far(i),'LineWidth', 3, 'MarkerSize', marker_size,'color',cc(1+rem(i-1,size(cc,1)),:), 'marker',tmp);
                    for gt=1:length(c)
                        tmp_pl=plot(d( c(gt),1 ),d( c(gt),2 ),'*');
                        set( tmp_pl,'color' , (1-grautoene( c(gt) ))*get(far(i),'color') , 'LineWidth', 3, 'MarkerSize', marker_size, 'marker', tmp);
                    end
                end % if grautoene
            end; % if 2D-plots
            
            if (size(d,2)>2)   % 3D plots
                far(i)=plot3(d(c,1),d(c,2),d(c,3),'*');
            end;
            set(far(i),'color',cc(1+rem(i-1,size(cc,1)),:),'MarkerSize',marker_size);
            if color_and_style == 1
                set(far(i),'Marker',sty(1+rem(i-1,length(sty))));
            end;
        end;
        
        %schwarze, unterschiedliche Zeichen
        if (sw_mode==3)&&(~isempty(c))
            tmp=sprintf('%ck',sty(1+rem(i-1,length(sty))));
            if (size(d,2)==1)
                if ~x_y_tausch %OHNE Vertauschung zeichnen, sollte alt sein, da in "ausgkl_einz_text" abgefangen wird
                    far(i)=plot(d(c,1),ones(size(c)),tmp);
                else % MIT Vertauschung zeichnen
                    far(i)=plot(ones(size(c)),d(c,1),tmp);
                end;
            end;
            if (size(d,2)==2)
                far(i)=plot(d(c,1),d(c,2),tmp);
                if grautoene
                    % nochmals alle Daten über die bestehenden zeichnen, damit Legende bleibt:
                    set(far(i),'LineWidth', 6, 'MarkerSize', marker_size);
                    for gt=1:length(c)
                        tmp_pl=plot(d( c(gt),1 ),d( c(gt),2 ),tmp);
                        set( tmp_pl,'color' , (1-grautoene( c(gt) ))*ones(1,3) , 'LineWidth', 6, 'MarkerSize', marker_size);
                    end
                end % if grautoene
            end;
            if (size(d,2)>2)
                far(i)=plot3(d(c,1),d(c,2),d(c,3),tmp);
            end;
            set(far(i),'MarkerSize', marker_size);
        end;
        
        %Nummernanzeige (Datentupel oder Klassen)
        %Nummern fuer Datentupel-Anzeige in dat_satz, wenn ind_auswahl für Datentupel-Nr. übergeben, dann verwende sie, ansonsten, nimm 'c':
        if ind_auswahl==0
            dat_satz=1:size(d,1);
        else
            dat_satz=ind_auswahl;
        end
        if ((sw_mode==2)||(za_mode))&&(~isempty(dat_satz))
            for kk=c'
                if (sw_mode==2)
                    tmp = sprintf(' %d',i);% i ist Ausgangskl. (code)
                else
                    tmp=sprintf(' %d',dat_satz(kk)); % kk ist Datentupel-Nr. von d (übergebenen Daten)
                end;
                
                if isstruct(parameter_gui_anzeige_or_za_mode) &&  parameter_gui_anzeige_or_za_mode.show_termnames
                    tmp = sprintf(' %s',deblank(zgf_bez(code(kk)).name));
                end;
                
                if (size(d,2)==1)
                    ha=text(d(kk,1),1,tmp);
                end;
                
                if (size(d,2)==2)
                    ha=text(d(kk,1),d(kk,2),tmp);
                end;
                
                if (size(d,2)>2)
                    ha=text(d(kk,1),d(kk,2),d(kk,3),tmp);
                end;
                
                if (za_mode)
                    set(ha,'HorizontalAlignment','left');
                else
                    set(ha,'HorizontalAlignment','center');
                end; %if za_mode
                
            end;
        end;
    end;
end;

%Achsenbezeichnungen
if ~strcmp(var_bez,'missing axis names and labels')
    xlabel(strrep(deblank(var_bez(1,:)),'_',' '));
    
    if (size(d,2)>1)
        ylabel(strrep(deblank(var_bez(2,:)),'_',' '));
    end;
    
    if (size(d,2)>2)
        zlabel(strrep(deblank(var_bez(3,:)),'_',' '));
        view(30,30);
    end;
    
else
    legende_an=0;
end;

if legende_an
    if ~isempty(farb_variante) && farb_variante == 10
        
        colorlist = find(sum(far>0,2));
        for i1=1:length(colorlist)
            legendhandle(i1) = plot(0,0,'*');
            set(legendhandle(i1),'color',cc(1+rem(colorlist(i1)-1,size(cc,1)),:),'MarkerSize', marker_size);
        end;
        symbollist = find(sum(far>0,1));
        for i2=1:length(symbollist)
            legendhandle(i2+length(colorlist)) = plot(0,0,'h');
            set(legendhandle(i2+length(colorlist)),'color',[0.5 0.5 0.5]);
            set(legendhandle(i2+length(colorlist)),'Marker',sty(1+rem(symbollist(i2)-1,length(sty))),'MarkerSize', marker_size);
        end;
        
        if (length(legendhandle)<50)
            tmp=strrep(sprintf('''%s'',',zgf_bez(size(zgf_bez,1),colorlist).name,secondary_output.zgf_y_bez(end,symbollist).name),'_',' ');
            eval(sprintf('legend(legendhandle,%s,0)',strrep(tmp(1:length(tmp)-1),'\','\\')));
        end;
        delete(legendhandle);
        
    else
        %Aufbau Legende mit zgf_bez (wenn vorhanden und belegt)
        %nur die aktiven Klassen far(find(far)) werden in die Legende eingetragen
        if (length(uni_code)<50) && (size(zgf_bez,2)>=max(code))
            if  (sw_mode~=2)
                %MATLAB 2014B compatibility                
                tmp=strrep(sprintf('''%s'',',zgf_bez(size(zgf_bez,1),find_nonempty_handle(far)).name),'_',' ');
                eval(sprintf('legend(far(find_nonempty_handle(far)),%s,0)',strrep(tmp(1:length(tmp)-1),'\','\\')));
            end;
        else
            fprintf(1,'No legend drawn (too many classes).');
        end;
    end;
end; % if ~legende_an

