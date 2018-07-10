% Script anz_klasserg_neu
%
% The script anz_klasserg_neu is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(klass_single)
   return;
end;

anzeigetyp=get(uihd(11,121),'value');

%Makro mit neuen Bildern?
newfigureintern=get(uihd(11,72),'value');
anzeige_nr_ds = get(uihd(11,18),'value');


if anzeigetyp >2
    anzeige_nr_ds = 0;
end;


anzeige_grafiken = get(uihd(11,26),'value');
anzeige_trennflaechen = get(uihd(11,133), 'value');

% Diese Daten sind bei Gaitcad nur in klass_single enthalten
if isfield(klass_single(1), 'bayes')
    kl = klass_single(1).bayes.kl;
    s_return = klass_single(1).bayes.s;
    su = klass_single(1).bayes.su;
end;

if isfield(klass_single(1), 'klasse')
    zgf_bez_tmp = klass_single(1).klasse.zgf_bez;
else
    zgf_bez_tmp = [];
end;

%Bezeichner bei ausgewählten Merkmalen...
var_bez_tmp = klass_single(1).merkmalsextraktion.var_bez;
par_kafka=[par.anz_dat par.anz_merk 1 par.anz_ling_y(par.y_choice)];

switch anzeigetyp
    case {1,3,4}
        ausgabedaten=code(ind_auswahl);
        ausgabedaten_full=code;
    case 2
        ausgabedaten=pos(ind_auswahl);
        ausgabedaten_full=pos;
    case 5
        ausgabedaten  = code_alle(ind_auswahl,parameter.gui.anzeige.different_class);
        zgf_bez_tmp  = zgf_y_bez(parameter.gui.anzeige.different_class,:);
end;

%bei welchen Datentupeln gibt es Fehlklassifikationen?
if ~exist('pos', 'var')
    pos=[];
end;
if isempty(pos)
    ind_fehlklassi=[];
else
    ind_fehlklassi=ind_auswahl(pos(ind_auswahl)~=code(ind_auswahl));
end;

%Rücksetzen, wenn keine Fehlklassifikationen
if (isempty(ind_fehlklassi) && (anzeigetyp>2))
    anzeigetyp = 1;
end;

%mit Kovarianzmatrizen, hier kann auch Metrik integriert werden!
if (uicall==15)
    
    if anzeigetyp == 5
        myerror('The visualization of an other output variable with covariance matrices is impossible!');
    end;
    
    if (size(d,2)~=2) || (size(kl,2)~=2)
        fprintf('Too many features!\n');
        return;
    end;
    pl_2da(d(ind_auswahl,:),ausgabedaten,kl,s_return,su,3,anzeige_nr_ds,anzeige_grafiken,var_bez_tmp,zgf_bez_tmp,~newfigureintern,ind_auswahl);
    title(phi_text);
    dtemp=d(ind_fehlklassi,:);
end;

%ohne Kovarianzmatrizen
if (uicall==8)
    pl_2d(d(ind_auswahl,:),ausgabedaten,newfigureintern,anzeige_nr_ds,anzeige_grafiken,var_bez_tmp,zgf_bez_tmp,0,0,1,ind_auswahl);
    dtemp=d(ind_fehlklassi,:);
end;

%Regeln
if (uicall==17)
    translap(rulebase(ind,:),par_kafka,d_org(ind_auswahl,:),ausgabedaten,zgf,anzeige_nr_ds,anzeige_grafiken,var_bez,zgf_bez_tmp);
    [tmp,ind_temp]=findaktiv(rulebase([ind ind],5:size(rulebase,2)),(size(rulebase,2)-4)/par_kafka(2));
    dtemp=d_org(ind_fehlklassi,ind_temp);
    %damit der Titel nicht versaut wird...
    anzeigetyp=0;
end;

%Merkmale
if (uicall==27)
    ind = get(uihd(11,14),'value');
    ind = ind(find(ind <= par_kafka(2)));
    if (length(ind)>1)
        pl_2d(d_org(ind_auswahl,ind),ausgabedaten,newfigureintern,anzeige_nr_ds,anzeige_grafiken,var_bez(ind,:),zgf_bez_tmp,0,0,1,ind_auswahl);
        dtemp=d_org(ind_fehlklassi,ind);
    else return;
    end;
    phi_text='Features';
end;

%Wertediskrete Merkmale
if (uicall==43)
    ind = get(uihd(11,14),'value');
    ind = ind(find(ind <= par_kafka(2)));
    
    %komplexere Anzeigen können wir nicht zeichnen
    if (anzeigetyp>3)
        anzeigetyp=1;
    end;
    
    if (length(ind)>2)
        mywarning('Plot of qualitative features works only for two selected features!');
        ind=ind(1:2);
    end;
    if (length(ind)==2)
        %colorvect=color_style(4);
        % Änderung Ole: color_style verwendet jetzt die Menüauswahl, wenn keine Übergabe erfolgt.
        colorvect = color_style;
        recthist_kafka(d_org(ind_auswahl,ind(1)),d_org(ind_auswahl,ind(2)),ausgabedaten,colorvect,var_bez(ind,:),newfigureintern);
    else
        myerror('Plot of qualitative features works only for two selected features!');
    end;
    phi_text='Features';
end;

%SVMs
if (uicall==41)
    pl_2d(d(ind_auswahl,:),ausgabedaten,newfigureintern,anzeige_nr_ds,anzeige_grafiken,var_bez_tmp,zgf_bez_tmp,0,0,1,ind_auswahl);
    if (size(d,2) == 2)
        aufloesung = str2num(get(uihd(11,132), 'String'));
        plot_trenn_neu(d(ind_auswahl,:), ausgabedaten, klass_single, kp, aufloesung);
    end;
    dtemp=d(ind_fehlklassi,:);
    
    %Supportvektoren einzeichnen
    ha = [];
    if (isfield(klass_single(1), 'svm_system') && size(d,2) == 2)
        hold on;
        ha=plot(klass_single(1).svm_system.xsupanzeige(:,1),klass_single(1).svm_system.xsupanzeige(:,2),'>');
    end;
    set(ha,'markersize',12);
end;

if (anzeige_trennflaechen && size(d,2) == 2)
    % Auflösung des Gitternetzes aus der Oberfläche besorgen
    aufloesung = str2num(get(uihd(11,132), 'String'));
    plot_trenn_neu(d(ind_auswahl,:), ausgabedaten, klass_single, kp, aufloesung);
end;

switch anzeigetyp
    %nur ursprüngliche Ausgangsklassen aus Lerndatensatz
    case 1
        title(phi_text);
        
        %nur Klassifikationsergebnisse
    case 2
        title(sprintf('%s (classes from classifier)',phi_text));
        
        %ursprüngliche Ausgangsklassen aus Lerndatensatz + DS-Nr. Fehlklassifikationen
    case 3
        hold on;
        ax=axis;
        pl_2d(dtemp,ones(length(ind_fehlklassi),1),1,2,3,'missing axis names and labels',zgf_bez,0,0,1,ind_fehlklassi); %Nummern!
        title(sprintf('%s (with data point numbers for misclassifications)',phi_text));
        axis(ax);
        
        %ursprüngliche Ausgangsklassen aus Lerndatensatz + Klassen-Nr. Fehlklassifikationen
    case 4
        hold on;
        ax=axis;
        pl_2d(dtemp,pos(ind_fehlklassi),1,0,2,'missing axis names and labels',zgf_bez);
        title(sprintf('%s (with class numbers for misclassifications)',phi_text));
        axis(ax);
end;

%nicht bei Regeln...
if (anzeigetyp)
    set(gcf,'numbertitle','off','name',sprintf('%d: %s',get_figure_number(gcf),kill_lz(phi_text)));
end;



