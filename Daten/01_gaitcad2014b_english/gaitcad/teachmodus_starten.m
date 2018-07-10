  function [teach_modus]=teachmodus_starten(uihd,mode,extension,parameter)
% function [teach_modus]=teachmodus_starten(uihd,mode,extension,parameter)
%
% mode=1 : Funktion wird zusätzlich noch ausgeführt...
%
% The function teachmodus_starten is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<2) 
   mode=1;
end;

if (nargin<3) 
   extension='makro';
end;

if (nargin < 4)
   parameter = [];
end;

[datei,pfad]=uiputfile(sprintf('*.%s',extension),'Save macro');

if (datei==0) 
   teach_modus=[];
   return;
end;
cd(pfad);
indprj=strfind(datei,sprintf('.%s',extension));
if ~isempty(indprj) 
   datei=datei(1:indprj(1)-1);
end;
teach_modus.makro_name=[pwd filesep sprintf('%s.%s',datei,extension)];
teach_modus.f=fopen(teach_modus.makro_name,'wt');
teach_modus.forg=teach_modus.f;

%alle Menüpunkte
%[indx,indy]=find(uihd);

indx=[];
indy=[];
for i=1:size(uihd,1) 
    for j=1:size(uihd,2) 
        if (isnumeric(uihd(i,j)) && uihd(i,j)~=0) || (~isnumeric(uihd(i,j)) && isgraphics(uihd(i,j)) && ~isa(uihd(i,j),'GraphicsPlaceholder') )
            indx = [indx;i]; 
            indy = [indy;j];
        end;
    end;
end;
teach_modus.indx=indx;
teach_modus.indy=indy;
teach_modus.ind_callback=1:length(indx);
for i= teach_modus.ind_callback 
   
   %alten Callbacktext rausholen, wird u.U. später modifiziert
   callbacktext= get(uihd(indx(i),indy(i)),'callback');
   handle_text = get(uihd(indx(i),indy(i)),'tag');
   myparent    = get(uihd(indx(i),indy(i)),'parent');
   if isempty(myparent)
      myparent=0;
   end;
   
   teach_modus.teach_callback(indx(i),indy(i)).text=callbacktext;
   
   %nur dann Plotbefehl reinschreiben, wenn überhaupt ein Callback-String existiert - sonst ist das sinnlos!
   %keinesfalls Makro beenden überschreiben...
   if (strcmp(get(uihd(indx(i),indy(i)),'Type'),'uimenu')) && ( ~isempty(teach_modus.teach_callback(indx(i),indy(i)).text)) && ~strcmp(handle_text,'MI_Makro_Beenden') && (myparent~=1) %& ~strcmp(handle_text,'MI_Extras')
      
      if isempty(get(uihd(indx(i),indy(i)),'Userdata'))
         %KEIN AUSWAHLFENSTER!!!!!!!!!
         %Kommentar drüberschreiben
         kommentartext = '%%%%';
         tmp_hndl = get(uihd(indx(i), indy(i)), 'Parent');
         while(tmp_hndl ~= 1)
            kommentartext = sprintf('%s %s, ', kommentartext, get(tmp_hndl, 'label'));
            tmp_hndl = get(tmp_hndl, 'Parent');
         end;
         % Achtung! Hier wird der Zeilenumbruch als Zeichenkette angehängt. Dieser String wird in fprintf aufgerufen und darf daher
         % an dieser Stelle noch keinen physikalischen Zeilenumbruch beinhalten.
         kommentartext = sprintf('%s %s %s', kommentartext, get(uihd(indx(i), indy(i)), 'label'), '\n');
         %eigentlicher Eval-Befehl
         callbacktext=sprintf('fprintf(teach_modus.f,''%seval(gaitfindobj_callback(''''%s''''));%s'');',kommentartext,handle_text,'\n\n');
         %ursprünglichen Callback anhängen 
         callbacktext=modify_callbacktext(callbacktext,teach_modus.teach_callback(indx(i),indy(i)).text);
      else 
         %einmal ausführen und dann OK Button umbiegen
         fprintf('CONFIGURATION WINDOW %s \n',get(uihd(indx(i),indy(i)),'label'));
         callbacktext=sprintf('tmptag=''%s'';%s;callback_makro_auswahlfenster;',handle_text,callbacktext);
      end;   
   end; %uimenu
   
   %Listboxen usw.
   if (strcmp(get(uihd(indx(i),indy(i)),'Type'),'uicontrol'))
      
      %Checkbox ausser neues Bild
      if (strcmp(get(uihd(indx(i),indy(i)),'Style'),'checkbox')) || (strcmp(get(uihd(indx(i),indy(i)),'Style'),'radiobutton'))
         %Kommentar drüberschreiben
         kommentartext=sprintf('%%%% %s%s',get(uihd(indx(i),indy(i)),'string'),'\n');
         %eigentlicher Eval-Befehl
         callbacktext=sprintf('fprintf(teach_modus.f,''%sset(gaitfindobj(''''%s''''),''''value'''',%%d);eval(gaitfindobj_callback(''''%s''''));%s'',get(gaitfindobj(''%s''),''value''));',kommentartext,handle_text,handle_text,'\n\n',handle_text);
         %ursprünglichen Callback anhängen 
         callbacktext=modify_callbacktext(callbacktext,teach_modus.teach_callback(indx(i),indy(i)).text);
      end; %checkbox
      
      %alle Popupmenüs, aber nicht das Umschaltefenster, das wird noch gebraucht
      if ((strcmp(get(uihd(indx(i),indy(i)),'Style'),'popupmenu')) || (strcmp(get(uihd(indx(i),indy(i)),'Style'),'listbox')) || strcmp(handle_text,'CE_Auswahl_PluginsCommandLine') ) && ~strcmp(handle_text,'CE_Auswahl_Optionen')
         %Kommentar drüberschreiben - hier in userdata
         kommentartext=sprintf('%%%% %s%s',get(uihd(indx(i),indy(i)),'userdata'),'\n');
         %eigentlicher Eval-Befehl
         callbacktext=sprintf('tmp=get_textauswahl_listbox(gaitfindobj(''%s''));kommentarstring2=sprintf(''%%%% %%s'',tmp);fprintf(teach_modus.f,''%s%%s\\nset_textauswahl_listbox(gaitfindobj(''''%s''''),%%s);eval(gaitfindobj_callback(''''%s''''));%s'',kommentarstring2,tmp);',handle_text,kommentartext,handle_text,handle_text,'\n\n');
         %ursprünglichen Callback anhängen 
         callbacktext=modify_callbacktext(callbacktext,teach_modus.teach_callback(indx(i),indy(i)).text);
         
         %special handling for parameters of plugins - here popups or edit windows might occur
         if strcmp(handle_text,'CE_Auswahl_PluginsCommandLine')
            teach_modus.callback_parameter_popup = callbacktext;
         end;         
      end; %popupmenu
      
      %alle Edit-Fenster
      if (strcmp(get(uihd(indx(i),indy(i)),'Style'),'edit')) || strcmp(handle_text,'CE_Auswahl_PluginsCommandLine')
         %Kommentar drüberschreiben - hier in userdata
         kommentartext=sprintf('%%%% %s%s',get(uihd(indx(i),indy(i)),'userdata'),'\n');
         %eigentlicher Eval-Befehl
         callbacktext=sprintf('tmpstring=get(gaitfindobj(''%s''),''string'');fprintf(teach_modus.f,''%sset(gaitfindobj(''''%s''''),''''string'''',''''%%s'''');eval(gaitfindobj_callback(''''%s''''));%s'',tmpstring);',handle_text,kommentartext,handle_text,handle_text,'\n\n');
         %ursprünglichen Callback anhängen 
         callbacktext=modify_callbacktext(callbacktext,teach_modus.teach_callback(indx(i),indy(i)).text);
         
         %special handling for parameters of plugins - here popups or edit windows might occur
         if strcmp(handle_text,'CE_Auswahl_PluginsCommandLine')
            teach_modus.callback_parameter_edit = callbacktext;
            
            if ~(strcmp(get(uihd(indx(i),indy(i)),'Style'),'edit'))
               %actually a popup window - restore the old callback
               callbacktext = teach_modus.callback_parameter_popup;
            end;
            
         end;
      end; %edit
      
      %alle 11er - Pushbuttons, aber nur bei existierendem Callback
      if (strcmp(get(uihd(indx(i),indy(i)),'Style'),'pushbutton')) && ( ~isempty(teach_modus.teach_callback(indx(i),indy(i)).text))
         %Kommentar drüberschreiben - hier in userdata
         kommentartext=sprintf('%%%% %s%s',get(uihd(indx(i),indy(i)),'string'),'\n');
         %eigentlicher Eval-Befehl
         callbacktext=sprintf('fprintf(teach_modus.f,''%seval(gaitfindobj_callback(''''%s''''));\\n\\n'')',kommentartext,handle_text);
         %ursprünglichen Callback anhängen 
         callbacktext=modify_callbacktext(callbacktext,teach_modus.teach_callback(indx(i),indy(i)).text);
      end; %edit

   end; %uicontrol
   
   %Callback-Text reinschreiben
   set(uihd(indx(i),indy(i)),'callback',callbacktext); 
end;

teach_modus.ha=text(0,0,'Record and play macro simultaneously');

set(teach_modus.ha,'Fontsize',30);   
set(1,'color',[1 1 0]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function callbacktext=modify_callbacktext(callbacktext,original_callbacktext)

callbacktext=sprintf('if isempty(teach_modus) teach_modus.f=1;teach_modus.forg=1;end;%s;teach_modus.forg=[teach_modus.f teach_modus.forg];teach_modus.f=1;%s;teach_modus.f=teach_modus.forg(1);teach_modus.forg(1)=[];',callbacktext,original_callbacktext);
