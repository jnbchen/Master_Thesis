  function show_spectrogram(spect,param,fig_handle,ind_bez,var_bez)
% function show_spectrogram(spect,param,fig_handle,ind_bez,var_bez)
%
% 
%  zeigt das Spektogramme der übergebenen Daten an
%  Eingaben:
%  param: Parameterstrukt mit folgenden Feldern:
%     param.fA (zwingend)
%     param.fensterLaenge (default: 64)
%     param.farbwerte_verteilen (default: 0) nutzt den kompletten Farbraum
%     param.colormap  (default: 1=Jet) (für Indizes siehe erzeugeColormap)
%     param.kennlinie_art (default: 1) 1=Linear, 2=Wurzel, 3=umg. Exponentiell
%     param.kennlinie_parameter (default: 1) Parameter für die Kennlinie
%     param.kennlinie_anzeigen (default: 0) zeigt verwendete Kennlinie an
%     param.kennlinie_name Wird fürs Plotten verwendet. Sonst siehe kennlinie_art
%     param.colorbar_anzeigen (default: 0)
%   param.caxis (default []) begrenzt die Farbskala auf caxis(1) caxis(2)
%  anzeige: Spektogramme plotten: 1, Spektogramme nicht plotten: 0, nur plotten: -1 (spect darf dann nicht leer sein!)
%     default: 0
%  var_bez: Bezeichner der Zeitreihen, default: []
%  ind_bez: Bezeichner der Datentupel (nur für Anzeige), default: []
%  fig_handle: Soll in eine spezielle figure geplottet werden, kann das Handle hier übergeben werden
% 
%
% The function show_spectrogram is part of the MATLAB toolbox Gait-CAD. 
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

if (~isfield(param, 'colormap'))
   cmap = erzeugeColormap(1);
else
   cmap = erzeugeColormap(param.colormap);
end;
if (~isfield(param, 'figurename'))
   param.figurename  = 'SPECT';
end;
if (~isfield(param, 'x_beschrift'))
   param.x_beschrift  = '';
end;
if (~isfield(param, 'y_beschrift'))
   param.y_beschrift  = '';
end;
if (~isfield(param, 'kennlinie_art'))
   kennlinie_param.kennlinie_art = 1;
else
   kennlinie_param.kennlinie_art = param.kennlinie_art;
end;
if (~isfield(param, 'kennlinie_parameter'))
   kennlinie_param.parameter = 1;
else
   kennlinie_param.parameter = param.kennlinie_parameter;
end;
if (isfield(param, 'kennlinie_name'))
   kennlinie_param.name = param.kennlinie_name;
else
   switch(kennlinie_param.kennlinie_art)
      case 1
         kennlinie_param.name = 'Linear ';
      case 2
         kennlinie_param.name = 'Root-';
      case 3
         kennlinie_param.name = 'Exponential-';
      case 4
         kennlinie_param.name = 'Logarithmic ';
   end;
end;

if (~isfield(param, 'colorbar_anzeigen'))
   colorbar_anzeigen = 0;
else
   colorbar_anzeigen = param.colorbar_anzeigen;
end;
if (~isfield(param, 'caxis'))
   col_axis = [];
else
   col_axis = param.caxis;
end;
if (~isfield(param, 'pcolormode'))
   param.pcolormode  = 0;
end;

kennlinie_param.caxis = col_axis;

%Abtesten, ob Bild gewünscht ist
if get_figure_number(fig_handle)
   specFig = fig_handle;
else
   specFig = figure;
end;

tickLabels = [];
% Bei der Anzeige mit surf wird die letzte Zeile der Matrix unterschlagen.
% Das kann korrigiert werden, in dem die letzte Zeile noch einmal angehängt wird.
% Dann müssen aber auch die Frequenzbezeichner korrigiert werden:
specFreq = [spect{2}; spect{2}(end)+spect{2}(end)-spect{2}(length(spect{2})-1)];
specTime = [spect{3}(2)-2*spect{3}(1); spect{3}]+0.5*(spect{3}(2)-spect{3}(1));
specData = [spect{1} spect{1}(:,end)];
specData = [specData; specData(end,:)];

if param.pcolormode == 1
   pcolor([0 0],[0 0],[0 1;0 1]);
else
   surf([0 0],[0 0],[0 1;0 1]);
end;
handle_colorbar = colorbar;
length_colorbar = length(get(handle_colorbar, 'YTick'));


%Farben und Colorbar berechnen
[specColor,colorbartick] = verwendeKennlinie(spect{1}, kennlinie_param,[0:1/(length_colorbar-1):1]');

specColor = [specColor specColor(:,end)];
specColor = [specColor;specColor(end,:)];
if param.pcolormode == 1
   pcolor(specTime, specFreq, specColor);
else
   surf(specTime, specFreq, specData, specColor);
end;



colormap(cmap);
shading flat;

str = sprintf('%d: %s ',get_figure_number(specFig),param.figurename);
if (~isempty(ind_bez))
   str = [str ' Data point ' deblank(ind_bez)];
end;
if (~isempty(var_bez))
   str = [str ' ''' deblank(var_bez) ''''];
end;
set(gcf,'Name',str,'NumberTitle','Off');
title(sprintf('%s, %s function', str, kennlinie_param.name));
xlabel(param.x_beschrift);
ylabel(param.y_beschrift);
maxF = max(specFreq);
minF = min(spect{2});
maxT = max(specTime);
minT = min(specTime);
set(gca,'XLim', [minT maxT], 'YLim', [minF maxF]);
view(2);

%avoid surf problems in MATLAB 7
set(gcf,'renderer','zbuffer');

% Colorbar anzeigen?
handle_colorbar = colorbar;
% Wenn die Werte nicht verteilt sind, stimmt die "normale" Colorbar.
% Es muss aber die Kennlinie rausgerechnet werden:
set(handle_colorbar, 'YTick', colorbartick(:,1));
set(handle_colorbar, 'YTickLabel', colorbartick(:,2));
%end;
if (colorbar_anzeigen == 0)
   delete(handle_colorbar);
end;

if param.phasengang && length(spect) >3
   f=figure;
   
   %falsche Bildnummer entsorgen
   ind = strfind(str,':');
   str = str(ind(1)+1:end);
   
   myphase = spect{4};
   
   set(f,'Name',[num2str(f) ': ' str ' (Phase response)'],'NumberTitle','Off');
   phase_tmp = [myphase; myphase(end,:)];
   
   kennlinie_param_phase.kennlinie_art = 1;
   
   if (colorbar_anzeigen)
      handle_colorbar = colorbar;
      length_colorbar = length(get(handle_colorbar, 'YTick'));
   end;
   
   [specColor, colorbartick] = verwendeKennlinie(myphase, kennlinie_param_phase,0:1/(length_colorbar-1):1);
   
   if param.pcolormode == 1
      pcolor(spect{3}, specFreq, [specColor; specColor(end,:)]);
   else
      surf(spect{3}, specFreq, [myphase; myphase(end,:)],[specColor; specColor(end,:)]);
   end;
   
   
   colormap(cmap);
   shading flat;
   title(sprintf('%s, %s function', str, kennlinie_param.name));
   xlabel(param.x_beschrift);
   ylabel(param.y_beschrift);
   set(gca,'XLim', [minT maxT], 'YLim', [minF maxF]);
   view(2);
   
   %avoid surf problems in MATLAB 7
   set(gcf,'renderer','zbuffer');
   
   
   
   
   % Colorbar anzeigen?
   if (colorbar_anzeigen)
      handle_colorbar = colorbar;
      % Wenn die Werte nicht verteilt sind, stimmt die "normale" Colorbar.
      % Es muss aber die Kennlinie rausgerechnet werden:
      set(handle_colorbar, 'YTick', colorbartick(:,1));
      set(handle_colorbar, 'YTickLabel', colorbartick(:,2));
      %end;
   end;
   
   
end;


