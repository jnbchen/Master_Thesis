  function h = zr_navi_callbacks(params, fct)
% function h = zr_navi_callbacks(params, fct)
%
% 
% 
%
% The function zr_navi_callbacks is part of the MATLAB toolbox Gait-CAD. 
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

indx = findobj('type', 'figure', 'tag', 'zr_navi_main_figure_12jh2');
if (isempty(indx))
   return;
end;

h = get(indx, 'UserData');
switch(fct)
   case 'resize' % Die Fenstergröße wurde geändert.
      if (isfield(h, 'axes') && ~isempty(h.axes))
         fig_size = get(h.figure, 'Position');
         ax_size  = get(h.axes, 'Position');
         set(h.elements.slider.h, 'Position', [.1 ax_size(2)-(3*h.elements.slider.hoehe/fig_size(4)) .8 h.elements.slider.hoehe/fig_size(4)]);
      end;
   case 'ax_bdn' % In der Zeichenfläche wurde ein Knopf gedrückt
      h.mouse_pos = round(get(h.axes, 'CurrentPoint'));
      h = addMarker(h);
   case 'slider' % Der Slider wurde bewegt.
      % Glücklicherweise wird der Callback nicht bei einem Ziehen mit gedrückter Maustaste ausgelöst, sondern
      % nur bei Loslassen der Taste (wie ist es bei Maltab >5.3?)
      h.akt_pos = round(get(h.elements.slider.h, 'Value'));
      h = replot(h);
   case 'grid' % Die Checkbox zum Ein- und Ausschalten des Grids wurde geklickt.
      onoff = get(h.axes, 'XGrid');
      if (strcmp(onoff, 'on'))
         set(h.axes, 'XGrid', 'off', 'YGrid', 'off');
      else
         set(h.axes, 'XGrid', 'on', 'YGrid', 'on');
      end;
   case 'zoomedit' % Die Anzahl anzuzeigender Abtastpunkte wurde verändert.
      tmp = liesNum(h.elements.zoom.edit, 1);
      if (~isempty(tmp))
         h.akt_ap = tmp;
         if (h.akt_ap > size(h.zr,1))
            h.akt_ap = size(h.zr,1);
         end;
         h = replot(h);
         % Wird die komplette Zeitreihe angezeigt, kann nicht gescrollt werden.
         % Da max nicht kleiner als min sein darf, muss der Fall abgefangen werden.
         % Irgendwie sehen aber alle Werte einigermaßen komisch aus oder führen
         % zu Fehlern im Slider. Also auf komplette Länge setzen.
         neu_max = size(h.zr,1)-h.akt_ap;
         if (neu_max == 0)
            neu_max = size(h.zr,1);
         end;
         val = get(h.elements.slider.h, 'value');
         if (val > neu_max)
            val = neu_max;
         end;
         set(h.elements.slider.h, 'Max', neu_max, 'value', val);
         % Passe die StepSize des Sliders an. Mit einem Klick auf die Pfeile soll ca. 1/4 weitergeschaltet werden,
         % bei einem Klick in den Slider 2/3.
         steps = [h.akt_ap/4 h.akt_ap*2/3] ./ get(h.elements.slider.h, 'Max');
         steps(steps > 1) = 1;
         if (steps(1) >= steps(2))
            steps(1) = 0.1*steps(2);
         end;
         set(h.elements.slider.h, 'SliderStep', steps);
      end;
   case 'reduktion' % Der Reduktionsfaktor wurde verändert.
      tmp = liesNum(h.elements.reduktion.edit, 1);
      if (~isempty(tmp))
         h.akt_step = tmp;
         if (h.akt_step < 1)
            h.akt_step = 1;
         end;
         if (h.akt_step > size(h.zr,1))
            h.akt_step = 1;
         end;
         h = replot(h);
      end;
   case 'auswahl_trigger' % Gehe zu dem in der Listbox markierten Trigger.
      val = get(h.elements.triggers.listbox, 'value');
      if (~isempty(val) && ~isempty(get(h.elements.triggers.listbox, 'String')))
         h.akt_pos = h.trigger_list(val) - round(h.akt_ap/2);
         min_ = get(h.elements.slider.h, 'Min'); max_ = get(h.elements.slider.h, 'Max');
         if (h.akt_pos < min_)
            h.akt_pos = min_;
         end;
         if (h.akt_pos > max_)
            h.akt_pos = max_;
         end;
         h = replot(h);
      end;
   case 'add_trigger' % Füge die aktuelle Markierung als Trigger hinzu.
      if (~isfield(h, 'trigger_list'))
         h.trigger_list = [];
         h.trigger_klasse = [];
      end;
      % Wenn der Trigger nicht schon in der Liste enthalten ist...
      if (~ismember(h.mouse_pos(1,1), h.trigger_list))
         % füge den Trigger hinzu und sortiere die Liste
         h.trigger_list = [h.trigger_list; h.mouse_pos(1,1)];
         [h.trigger_list, I] = sort(h.trigger_list);
         h.trigger_klasse = [h.trigger_klasse; 1];
         h.trigger_klasse = h.trigger_klasse(I);
      end; % if (~ismember(h.mouse_pos(1,1), h.trigger_list))
      
      set(h.elements.triggers.listbox, 'String', liststr([h.trigger_list h.trigger_klasse]));
      h = replot(h);
      
   case 'del_trigger' % Lösche einen Trigger aus der Liste.
      val = get(h.elements.triggers.listbox, 'value');
      if (~isempty(val) && ~isempty(get(h.elements.triggers.listbox, 'String')))
         % Entferne den Trigger aus der Liste
         h.trigger_list(val) = [];
         h.trigger_klasse(val) = [];
         set(h.elements.triggers.listbox, 'String', liststr([h.trigger_list h.trigger_klasse]));
         % Setze die Auswahl der Liste neu.
         if (~isempty(h.trigger_list))
            if (val-1 >= 1)
               set(h.elements.triggers.listbox, 'value', val-1);
            else
               set(h.elements.triggers.listbox, 'value', 1);
            end;
         end; % if (~isempty(h.trigger_list))
      end; % if (~isempty(val))
      replot(h);
      
   case {'ink_klasse', 'dek_klasse'} % Erhöhe oder verringere die Klassenzugehörigkeit des Triggerereignisses
      val = get(h.elements.triggers.listbox, 'value');
      if (~isempty(val) && ~isempty(get(h.elements.triggers.listbox, 'String')))
         if (strcmp(fct, 'ink_klasse'))
            h.trigger_klasse(val) = h.trigger_klasse(val)+1;
         else
            h.trigger_klasse(val) = max(1,h.trigger_klasse(val)-1);
         end;
         set(h.elements.triggers.listbox, 'String', liststr([h.trigger_list h.trigger_klasse]));
         addTrigger(h, 1);
      end; % if (~isempty(val))
      
   case {'ink_pos', 'dek_pos'} % Genaue Anpassungen der Triggerpositionen.
      val = get(h.elements.triggers.listbox, 'value');
      if (~isempty(val) && ~isempty(get(h.elements.triggers.listbox, 'String')))
         if (strcmp(fct, 'ink_pos'))
            h.trigger_list(val) = h.trigger_list(val)+1;
         else
            h.trigger_list(val) = h.trigger_list(val)-1;
         end;
         set(h.elements.triggers.listbox, 'String', liststr([h.trigger_list h.trigger_klasse]));
      end; % if (~isempty(val))
      replot(h);
   case 'zr_auswahl' % Schaltet zwischen der Anzeige verschiedener Zeitreihen um.
      val = get(h.elements.zeitreihen.listbox, 'value');
      if (isempty(val))
         val = 1;
         set(h.elements.zeitreihen.listbox, 'value', 1);
      end;
      h.zr_auswahl = val;
      replot(h);
   case 'im_trigger' % Importiere eine Zeitreihe mit einem Trigger aus  einer Variablen im Workspace
      Answer = inputdlg('Name of variable', 'Import from variable');
      if (~isempty(Answer))
         try
            imp_trig = evalin('base', sprintf('%s', Answer{1}));
            if (length(imp_trig) ~= size(h.zr,1))
               fprintf(1, 'The length of the trigger time series must fit the number of sample points in the project.\n');
            else
               if (size(imp_trig, 1) > 1)
                  imp_trig = imp_trig';
               end;
               [ind] = find(imp_trig > 0);
               h.trigger_list 	= ind';
               h.trigger_klasse 	= imp_trig(ind);
               if (size(h.trigger_klasse,2) > 1)
                  h.trigger_klasse = h.trigger_klasse';
               end;
               set(h.elements.triggers.listbox, 'String', liststr([h.trigger_list h.trigger_klasse]));
               replot(h);
            end;
         catch
            fprintf(1, 'Error by importing. Possible wrong variable name?\n%s\n', lasterr);
         end;
      end; % if (~isemtpy(Answer))
   case 'ex_trigger' % Schreibe die gewählten Trigger in eine neue Zeitreihe im Projekt
      evalin('base', 'zr_navi_exp_trigger;');
      return;
      
      %case 'close'
      %evalin('base', 'clear h_navi');
      %   fprintf(1, 'Close...\n');
      %   return;
end; % switch(fct)

set(h.figure, 'UserData', h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Einige Unterfunktionen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeichne die Zeitreihe neu.
function h = replot(h)
% Richtige Zeichenfläche aktivieren und zeichnen:
axes(h.axes);
h.akt_marker = [];
% Bestimme Start und Endpunkte des Plots:
start = h.akt_pos;
ende  = h.akt_pos + h.akt_ap - 1;
if (start < 1)
   start = 1;
end;
if (ende > size(h.zr,1))
   start = size(h.zr,1)-h.akt_ap+1;
   ende = size(h.zr,1);
end;
p = plot([start:h.akt_step:ende], h.zr(start:h.akt_step:ende, h.zr_auswahl));
if (start > get(h.elements.slider.h, 'Max'))
   start = get(h.elements.slider.h, 'Max');
end;
set(h.elements.slider.h, 'value', start);
xlim([start ende]);
h = addMarker(h);
addTrigger(h);
legend(p, deblank(h.zr_bez(h.zr_auswahl,:)));

% Lies einen numerischen Wert aus einem Edit-Feld der Oberfläche
function num = liesNum(handle, ganzzahlig)
if (nargin < 2)
   ganzzahlig = 0;
end;
num = [];
tmp = str2num(get(handle, 'String'));
if (~isempty(tmp))
   if (ganzzahlig)
      tmp = round(tmp);
      set(handle, 'String', num2str(tmp));
   end; % if (ganzzahlig)
   num = tmp;
end; % if (~isempty(tmp))

% Füge eine Markierung zum Plot hinzu.
function h = addMarker(h)
if (isfield(h, 'mouse_pos') && ~isempty(h.mouse_pos))
   indx = findobj('tag', 'zrns_ak28sn28');
   if ~isempty(indx)
      delete(indx);
   end;
   axes(h.axes);
   set(h.axes, 'NextPlot', 'add');
   ylims = ylim;
   h.akt_marker = plot([h.mouse_pos(1,1) h.mouse_pos(1,1)], ylims, 'k--', 'tag', 'zrns_ak28sn28');
   set(h.axes, 'NextPlot', 'replacechildren');
end; % if (isfield(h, 'mouse_pos') && ~isempty(h.mouse_pos))

% Fügt die vorhandenen Trigger zum Plot hinzu
function addTrigger(h, upd)
if (nargin < 2)
   upd = 0;
end;
% Wenn ein Update der Ereignisse gemacht wird, dann lösche die alten zunächst.
if (upd)
   indx = findobj('tag', 'zrns_trigger_ev');
   if (~isempty(indx))
      delete(indx);
   end;
end; % if (upd)
if (isfield(h, 'trigger_list') && ~isempty(h.trigger_list))
   % Zeichne die Trigger ein, die im aktuellen Plot enthalten sind:
   xlim_ = get(h.axes, 'XLim');
   indx = find(h.trigger_list >= xlim_(1) & h.trigger_list <= xlim_(2));   % Coderevision: &/| checked!
   axes(h.axes);
   set(h.axes, 'NextPlot', 'add');
   ylims = ylim;
   for i = 1:length(indx)
      plot([h.trigger_list(indx(i)) h.trigger_list(indx(i))], ylims, 'r:', 'tag', 'zrns_trigger_ev');
      text(h.trigger_list(indx(i)), ylims(2)-0.02*ylims(2), [' ' num2str(h.trigger_klasse(indx(i)))], 'tag', 'zrns_trigger_ev');
   end;
   set(h.axes, 'NextPlot', 'replacechildren');
end; % if (isfield(h, 'trigger_list') & ~isempty(h.trigger_list))



