  function figure_handle=new_figure(titel,callback,info,string,auswahl,max_auswahl,auswahl_string,manclose)
% function figure_handle=new_figure(titel,callback,info,string,auswahl,max_auswahl,auswahl_string,manclose)
%
% zum Aufbau eines neuen Fensters für Merkmalsauswahl
%  figure_handle = zur Übermittllung von aller handles (sowohl figure,pushbuttons, als auch der ausgewählten Elementen 'values')
%                       die Values sind in figure_handle(i,1) mit i=2..n, n=Anzahl Elementen
%  titel        = Titelzeile
%  callback     = Aktion bei drücken des ok-Buttons
%  info         = Bezeichner des string
%  string       = Listen vom Typ 'name1 | name2 | name 3' in einer Zeile.
%                      mehrere Zeilen bewirken Erzeugung mehrerer Auswsahlfenster,
%                      wobei Zeilenanzahl von info und string gleich sein müssen
%  auswahl      = speichert in einer Matrix alle letzten Auswählungen. In einer Zeile alle Auswählungen eines Merkmals
%                       Nullen in der Matrix werden nicht berücksichtigt (werden aber zum Auffüllen der Zeilen benötigt)
%  max_auswahl  = Vektor mit entsprechender Zeilenlänge, der angibt wieviel Merkmale ausgewählt werden dürfen
%                      wenn nicht angegeben, dann ist Auswahl maximal
%  manclose       = Wenn 1, wird kein Zugriff auf das Fenster nach dem Klicken mehr ausgeführt.
% 
% RM 29.6.04: versteckter Übernehmen-Button neuer auswahl_string
% 
%
% The function new_figure is part of the MATLAB toolbox Gait-CAD. 
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

figure_screen=get(0,'screensize');


%interne Parameter Bild
%max. Fensterhoehe mit Fusszeile
fensterhoehe_ohne_fusszeile=0.75*figure_screen(4);
hoehe_fusszeile=50;
fensterhoehe_mit_fusszeile=fensterhoehe_ohne_fusszeile+hoehe_fusszeile;

%min. Fesnterbreite
min_fensterbreite=600;

zeilenhoehe=15;
min_anzahl_zeilen=3;
max_anzahl_zeilen=10;

fenster_abstand=20;

%Abfang, wenn schon anderes Bild geöffnet
if ~isempty(findobj('UserData','Configuration'))
    warning('Only one configuration window can be active!');
    return;
end;

if nargin<6
    max_auswahl=[];
end;

if nargin<7
    auswahl_string='';
end;
if (nargin<8)
    manclose = 0;
end;

%damit erste Zeile auch oben im Bild steht:
info=flipud(info);
string=flipud(string);
if exist('max_auswahl', 'var')
    max_auswahl=flipud(max_auswahl);
end;

%Berechne Anzahl der Elemente pro Zeile und  Auswahl-Fenster Höhe
for zeilen=1:size(info,1)
    
    if ~iscell(string)
        anz_inhalt(zeilen)=length(find(abs(string(zeilen,:))==124))+1; %suche nach allen | in einer Zeile, daraus Anzahl der Elemente % Coderevision: &/| checked!
    else
        %new option: all information as cell string to fasten selection, cell string length on first position
        anz_inhalt(zeilen)=string{zeilen,1};
    end;
    
    hoehe(zeilen)=max(min(round(anz_inhalt(zeilen)),max_anzahl_zeilen),min_anzahl_zeilen)*zeilenhoehe; % Berechnet Höhe in Abhängigkeit der Element-Anzahl, Zeilenhöhe ca. 14 Pixel
end;

if iscell(string)
    %new option: all information as cell string to fasten selection, cell string length on first position - now never needed...
    string(:,1) = [];
end;



if isempty(max_auswahl)
    max_auswahl=anz_inhalt;
end; %maximal auswählbare Elemente

if isempty(auswahl)
    auswahl=ones(size(info,1),1);
end; % alle ersten Elemente auswählen

%wenn mehrere listboxen existieren als auswahl, dann ergänze auswahl
if ~iscell(auswahl)
    if  size(auswahl,1)<size(info,1)
        auswahl(size(auswahl,1)+1:size(info,1),1)=1;
    end;
    auswahl=flipud(auswahl); % wie oben, Bild wird hier von unten nach oben aufgebaut
else
    %vielleicht gibt es ja inzwischen zusätzliche Ausgangsgrößen ...
    for i_auswahl = length(auswahl)+1:size(info,1)
        auswahl{i_auswahl} = {'All'};
    end;
    auswahl=fliplr(auswahl); % wie oben, Bild wird hier von unten nach oben aufgebaut
end;


%Baue figure auf:
figure_handle(1,1)=figure;
figure_hoehe=min(2*hoehe_fusszeile+length(hoehe)*fenster_abstand+sum(hoehe),fensterhoehe_mit_fusszeile);

%neu: Breitenschätzung:
if ~iscell(string)
    figure_breite= max(diff([1 find(string(1,:)=='|') max(find(string(1,:)))]))*7;
else
    figure_breite = min_fensterbreite;
end;

figure_breite= min(figure_screen(3)*0.9,max([min_fensterbreite figure_breite]));

%Fenster aufbauen
set(figure_handle(1,1),'position',[round(0.5*(figure_screen(3)-figure_breite)) 100 figure_breite figure_hoehe],'NumberTitle','off','MenuBar','None','Name',titel,'UserData','Configuration');

%hier: erstelle y-Positionen der listboxen, in den verschiedenen Bildern, wenn mehrere listboxen
anz_bild=1; % Variable, die Anzahl der wählbaren Bilder speichert
lower_line=1; %speichert Zeilen-Nummer, die an unterster Stelle im Bild steht
for zeilen=1:length(hoehe)
    %Berechne y-pos der betrachteten 'zeile' und speicchere in tmp Variable
    % Philosophie: zähle alle Höhen der listboxen zusammen mit einem jeweiligen Abstand von 20 zwischen den listboxen
    %              Vorsicht: die Höhe der aktuellen Listbox darf nicht verwendet werden!
    %              +hoehe_fusszeile ist der Abstand von unten (Platz für Okay und Abbruch Buttons)
    y_pos_tmp(zeilen)=sum(hoehe(lower_line:zeilen)+fenster_abstand)-hoehe(zeilen) + hoehe_fusszeile;
    if y_pos_tmp(zeilen)+hoehe(zeilen)<=figure_hoehe-hoehe_fusszeile %schau, ob mit der neuen listbox der Platz im figure ausreicht
        y_pos(zeilen)=y_pos_tmp(zeilen);
    else
        y_pos(zeilen)=hoehe_fusszeile; %fange wieder unten im Bild an
        anz_bild=anz_bild+1; %ergänze ein weiteres Bild
        lower_line=zeilen;
    end;
    %speichert die Zugehörigkeit der listbox zum entsprechenden Bild
    % sie wird später als 'userdata' gespeichert
    bild_zg(zeilen)=anz_bild;
end;

if anz_bild>1
    tmp='Part 1';
    for i=2:anz_bild
        tmp=sprintf('%s|Part %d',tmp,i);
    end;
    [figure_handle(1,2),figure_handle(1,3)]=popini('Show selection',tmp,1,figure_hoehe-2*fenster_abstand);
    set(figure_handle(1,3),'style','text','BackgroundColor',[0.7 0.7 0.7]);
    for i=2:3
        set(figure_handle(1,i),'visible','on');
    end;
    tmp_text=sprintf('     set(figure_handle(2:size(figure_handle,1)-1,1:2),''visible'',''off'');'); %schalte alle Listboxen aus
    tmp_text=sprintf('%s   tmp=get(figure_handle(1,2),''value'');',tmp_text); %speicher anzuzeigendes Bild
    tmp_text=sprintf('%s   tmp=findobj(''userdata'',tmp);',tmp_text); %suche alle vorkommenden listboxen in diesem Bild
    tmp_text=sprintf('%s   set(tmp,''visible'',''on'');',tmp_text); %schalte alle gefundenen listboxen an
    set(figure_handle(1,2),'callback',tmp_text);
    clear tmp_text;
end;





for zeilen=1:size(info,1)
    %y_pos=y_pos+tmp(zeilen);
    % Kontrolle, ob auswahl auf Elemente verweist, die es nicht gibt
    %   if max(auswahl( zeilen , : ))>anz_inhalt(zeilen)
    %      auswahl(zeilen,1:size(auswahl,2))=[1 zeros(1,size(auswahl,2)-1)];
    %   end;
    %   figure_handle(zeilen+1,1) = uicontrol(figure_handle(1,1),'position',[300 y_pos(zeilen) 250+(figure_breite-600) hoehe(zeilen)] ,'style','listbox','string',string(zeilen,:),'max',max_auswahl(zeilen),'value',auswahl( zeilen , auswahl(zeilen,:)~=0),'userdata',bild_zg(zeilen),'visible','off');%max_auswahl(zeilen));
    if ~iscell(string)
        %complete strings!!!
        figure_handle(zeilen+1,1) = uicontrol(figure_handle(1,1),'position',[300 y_pos(zeilen) 250+(figure_breite-600) hoehe(zeilen)] ,'style','listbox','string',string(zeilen,:),'max',max_auswahl(zeilen),'userdata',bild_zg(zeilen),'visible','off');
    else
        %for cells only the used elements!!!!
        figure_handle(zeilen+1,1) = uicontrol(figure_handle(1,1),'position',[300 y_pos(zeilen) 250+(figure_breite-600) hoehe(zeilen)] ,'style','listbox','string',string(zeilen,1:anz_inhalt(zeilen)),'max',max_auswahl(zeilen),'userdata',bild_zg(zeilen),'visible','off');
    end;
    
    if iscell(auswahl)
        if isempty(auswahl{zeilen})
            auswahl{zeilen} = {'All'};
        end;
        set_textauswahl_listbox(figure_handle(zeilen+1,1),auswahl{zeilen});
    else
        if max(auswahl( zeilen , : ))>anz_inhalt(zeilen)
            auswahl(zeilen,1:size(auswahl,2))=[1 zeros(1,size(auswahl,2)-1)];
        end;
        set(figure_handle(zeilen+1,1),'value',auswahl( zeilen , auswahl(zeilen,:)~=0));
    end;
    figure_handle(zeilen+1,2) = uicontrol(figure_handle(1,1),'position',[20  y_pos(zeilen)+hoehe(zeilen)-fenster_abstand 250 fenster_abstand] ,'style','text','BackgroundColor',[0.7 0.7 0.7],'string',info(zeilen,:),'userdata',bild_zg(zeilen),'visible','off');
end;

set(findobj('userdata',1),'visible','on');

%damit das passende handle übergeben wird (wegen obigem flipud Befehl)
figure_handle(2:zeilen+1,:)=flipud(figure_handle(2:zeilen+1,:));

figure_handle(zeilen+2,1) = uicontrol(figure_handle(1,1),'position',[20  fenster_abstand 100 20],'style','pushbutton','string','OK');
figure_handle(zeilen+2,2) = uicontrol(figure_handle(1,1),'position',[220 fenster_abstand 100 20],'style','pushbutton','string','Cancel');

%Der Übernehmen-Button existiert, ist aber standardmäßig unsichtbar geschaltet!!
%gleicher Callback wie o.k., aber ohne Fenster schließen!
figure_handle(zeilen+2,3) = uicontrol(figure_handle(1,1),'position',[420 fenster_abstand 100 20],'style','pushbutton','string','Apply','visible','off');

%schließe Fenster und lösche handles
%der delete-Ablauf verhindert den Error: ??? Error using ==> delete Root object may not be deleted.
%zuerst alle handles löschen, dann das eigentliche Fenster handle figure_handle(1,1)
fenster_zu='delete(flipud(figure_handle(find_nonempty_handle(figure_handle(:)))));clear figure_handle;';

% MS: fuer Callbacks, die in einem M-File gespeichert wurden, den
% Dateinamen als Callback-Funktion angeben

callback_auswahl_retten=sprintf('%s=[]; for i=2:size(figure_handle,1)-1 tmp=get(figure_handle(i,1),''value''); %s(i-1,1:length(tmp))=tmp;end;',auswahl_string,auswahl_string);

if exist(callback, 'file') == 2
    [cbpath, cbmfile] = fileparts(callback);
    
    %Der Übernehmen-Button existiert, ist aber standardmäßig unsichtbar geschaltet!!
    %gleicher Callback wie o.k., aber ohne Fenster schließen!
    set(figure_handle(zeilen+2,3),'callback',cbmfile); % Übernehmen-Button
    
    if (~manclose)
        callback_okay=sprintf('%s; %s %s; aktparawin;',cbmfile,callback_auswahl_retten,fenster_zu);
    else
        callback_okay=sprintf('%s; aktparawin;',cbmfile);
    end;
else
    %Der Übernehmen-Button existiert, ist aber standardmäßig unsichtbar geschaltet!!
    %gleicher Callback wie o.k., aber ohne Fenster schließen!
    set(figure_handle(zeilen+2,3),'callback',callback); % Übernehmen-Button
    
    if (~manclose)
        callback_okay=sprintf('%s; %s %s; aktparawin;',callback,callback_auswahl_retten,fenster_zu);
    else
        callback_okay=sprintf('%s; aktparawin;',callback);
    end;
end

%Buttons
set(figure_handle(zeilen+2,1),'callback',callback_okay); %Okay-Button
callback_abbruch=sprintf('%s; clear functions;',fenster_zu);
set(figure_handle(zeilen+2,2),'callback',fenster_zu); % Abbruch-Button

