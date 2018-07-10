  function callback_umbenennen_teil2(uihd,var_bez,bez_zeitreihe,bez_code,zgf_bez,zgf_y_bez,figure_handle,L,par)
% function callback_umbenennen_teil2(uihd,var_bez,bez_zeitreihe,bez_code,zgf_bez,zgf_y_bez,figure_handle,L,par)
%
% Umbenennen von Einzelmerkmalen, Zeitreihen, Ausgangsgrößen usw. über Auswahlfenster
%
% The function callback_umbenennen_teil2 is part of the MATLAB toolbox Gait-CAD. 
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

if par.anz_einzel_merk==0 
   new_goal=5;   
else   
   new_goal=1;
end;

if (get(figure_handle(2,1),'value')==1) && par.anz_einzel_merk==0
   mywarning('No single features!'); 
   set(figure_handle(2,1),'value',new_goal);
end; 

if (get(figure_handle(2,1),'value')==2) 
   mywarning('The rename function for linguistic terms of single features is not yet implemented!'); 
   set(figure_handle(2,1),'value',new_goal);
end; 

if (get(figure_handle(2,1),'value')==6) 
   mywarning('Decision cost are not yet implemented!'); 
   set(figure_handle(2,1),'value',new_goal);
end; 

if (get(figure_handle(2,1),'value')==5) && par.anz_merk==0
   mywarning('No time series!'); 
   set(figure_handle(2,1),'value',new_goal);
end; 

if (get(figure_handle(2,1),'value')==7) 
   mywarning('Feature costs are not yet implemented!'); 
   set(figure_handle(2,1),'value',new_goal);
end; 

for i=2:5
   set(figure_handle(i,1),'callback','callback_umbenennen_teil2(uihd,dorgbez,var_bez,bez_code,zgf_bez,zgf_y_bez,figure_handle,[],par);','style','popup','enable','on');
   ind(i)=get(figure_handle(i,1),'value');
end;

%wo steht die Ausgangsgröße ?
ind_handle_ausgang=12;
ind_handle_merkmal=14;
ind_handle_zeitreihe=13;
merkmal_string='Single feature';

id_edit_fenster=6;

auswahl_alt=get(figure_handle(id_edit_fenster,1),'userdata');
set(figure_handle(id_edit_fenster,1),'callback',get(figure_handle(size(figure_handle,1),3),'callback'));
%Übernehmen-Button einschalten
%set(figure_handle(size(figure_handle,1),3),'visible','on');

%hier werden nur die Auswahlfenster verwaltet, um den OK-Button kümmert sich 
%callback_umbenennen_ok

%Art Auswahl? 
switch get(figure_handle(2,1),'value')
   
case 1 %Merkmal
   %wenn vorher NICHT Merkmal o.ä., dann auf aktuelles Merkmal setzen
   if (auswahl_alt~=1)&&(auswahl_alt~=2) 
      tmp=get(uihd(11,ind_handle_merkmal),'value');
      if ~isempty(tmp)
         ind(3)=tmp(1);
      end;
   end; 
   
   ind(3)=repair_popup(figure_handle(3,1:2),poplist_popini(var_bez(1:par.anz_einzel_merk,:)),ind(3),get(uihd(11,ind_handle_merkmal),'value'),merkmal_string);
   
   %Ling.-Terme abschalten
   for i=1:2 
      set(figure_handle(4,i),'visible','off');
   end;
   for i=1:2 
      set(figure_handle(5,i),'visible','off');
   end;
   
   %String in Umbenennen-Fenster
   set(figure_handle(id_edit_fenster,1),'style','edit','string',var_bez(ind(3),:));
   
case 2 %Ling.Term Merkmal
   %wenn vorher NICHT Merkmal o.ä., dann auf aktuelles Merkmal setzen
   if (auswahl_alt~=1) && (auswahl_alt~=2) 
      tmp=get(uihd(11,ind_handle_merkmal),'value');
      if ~isempty(tmp)
         ind(3)=tmp(1);
      end;
   end; 
   
   ind(3)=repair_popup(figure_handle(3,1:2),poplist_popini(var_bez(1:par.anz_einzel_merk,:)),ind(3),get(uihd(11,ind_handle_merkmal),'value'),merkmal_string);
   %alle existierenden (nicht leeren!!!) Terme in Fenster 4 plotten
   ind(4)=repair_popup(figure_handle(4,1:2),poplist_popini(strvcatnew(zgf_bez(ind(3),:).name)),ind(4),1,'Linguistic term');
   
   %Ling.-Terme einschalten
   for i=1:2 
      set(figure_handle(4,i),'visible','on');
   end;
   for i=1:2 
      set(figure_handle(5,i),'visible','off');
   end;
   
   %String in Umbenennen-Fenster
   set(figure_handle(id_edit_fenster,1),'style','edit','string',zgf_bez(ind(3),ind(4)).name);
   
case 3 %Ausgangsklasse
   %wenn vorher Merkmal o.ä., dann auf aktuelle Ausgangsklasse setzen
   if (auswahl_alt<3) 
      ind(3)=get(uihd(11,ind_handle_ausgang),'value');      
   end; 
   ind(3)=repair_popup(figure_handle(3,1:2),poplist_popini(bez_code),ind(3),get(uihd(11,ind_handle_ausgang),'value'),'Output variable');
   %Ling.-Terme usw. abschalten
   for i=1:2 
      set(figure_handle(4,i),'visible','off');
   end;
   for i=1:2 
      set(figure_handle(5,i),'visible','off');
   end;
   
   %String in Umbenennen-Fenster
   set(figure_handle(id_edit_fenster,1),'style','edit','string',bez_code(ind(3),:));
   
case 4 %Linguistischer Term (Ausgang)
   %wenn vorher Merkmal o.ä., dann auf aktuelle Ausgangsklasse setzen
   if (auswahl_alt<3) 
      tmp=get(uihd(11,ind_handle_ausgang),'value');
      if ~isempty(tmp)
         ind(3)=tmp(1);
      end;
   end; 
   %set(figure_handle(3,1),'string',poplist_popini(bez_code),'value',ind(3));
   ind(3)=repair_popup(figure_handle(3,1:2),poplist_popini(bez_code),ind(3),get(uihd(11,ind_handle_ausgang),'value'),'Output variable');
   
   %Ling.-Terme einschalten
   for i=1:2 
      set(figure_handle(4,i),'visible','on');
   end;   
   for i=1:2 
      set(figure_handle(5,i),'visible','off');
   end;
   
   %alle existierenden (nicht leeren!!!) Terme in Fenster 4 plotten
   ind(4)=repair_popup(figure_handle(4,1:2),poplist_popini(strvcatnew(zgf_y_bez(ind(3),:).name)),ind(4),1,'Linguistic term');
   
   %String in Umbenennen-Fenster
   set(figure_handle(id_edit_fenster,1),'style','edit','string',zgf_y_bez(ind(3),ind(4)).name);
   
   
case 5 %Zeitreihe 
   if (auswahl_alt~=5) 
      tmp=get(uihd(11,ind_handle_zeitreihe),'value');
      if ~isempty(tmp)
         ind(3)=tmp(1);
      end;
      
   end; 
   ind(3)=repair_popup(figure_handle(3,1:2),poplist_popini(bez_zeitreihe(1:par.anz_merk,:)),ind(3),get(uihd(11,ind_handle_zeitreihe),'value'),'Time series');
   %Ling.-Terme usw. abschalten
   for i=1:2 
      set(figure_handle(4,i),'visible','off');
   end;
   for i=1:2 
      set(figure_handle(5,i),'visible','off');
   end;
   %String in Umbenennen-Fenster
   set(figure_handle(id_edit_fenster,1),'style','edit','string',bez_zeitreihe(ind(3),:));
   
case 6 %Entscheidungskosten
   if (auswahl_alt<6) 
      ind(3)=get(uihd(11,ind_handle_ausgang),'value');
   end; 
   ind(3)=repair_popup(figure_handle(3,1:2),poplist_popini(bez_code),ind(3),get(uihd(11,ind_handle_ausgang),'value'),'Output variable');
   ind(4)=repair_popup(figure_handle(4,1:2),poplist_popini(strvcatnew(zgf_y_bez(ind(3),:).name)),ind(4),1,'Decision');
   ind(5)=repair_popup(figure_handle(5,1:2),poplist_popini(strvcatnew(zgf_y_bez(ind(3),:).name)),ind(5),1,'(Real) state');
   
   %Ling.-Terme usw. einschalten
   for i=1:2 
      set(figure_handle(4,i),'visible','on');
   end;
   for i=1:2 
      set(figure_handle(5,i),'visible','on');
   end;
   %String in Umbenennen-Fenster
   set(figure_handle(id_edit_fenster,1),'style','edit','string',sprintf('%g',L.ld_alle(ind(3)).ld(ind(4),ind(5))));
   
case 7 %Merkmalskosten
   if (auswahl_alt<7) 
      tmp=get(uihd(11,ind_handle_merkmal),'value');
      ind(3)=tmp(1);
   end; 
   ind(3)=repair_popup(figure_handle(3,1:2),poplist_popini(var_bez),ind(3),get(uihd(11,ind_handle_merkmal),'value'),'Feature');
   %Ling.-Terme einschalten
   for i=1:2 
      set(figure_handle(4,i),'visible','off');
   end;
   for i=1:2 
      set(figure_handle(5,i),'visible','off');
   end;
   
   %String in Umbenennen-Fenster
   set(figure_handle(id_edit_fenster,1),'style','edit','string',sprintf('%g',L.lcl(ind(3))));
   
end;

%alten Menüwert merken - im userdata vom OK-Button!!   
set(figure_handle(id_edit_fenster,1),'userdata',get(figure_handle(2,1),'value'));




