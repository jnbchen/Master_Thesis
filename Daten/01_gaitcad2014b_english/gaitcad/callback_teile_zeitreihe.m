% Script callback_teile_zeitreihe
%
% The script callback_teile_zeitreihe is part of the MATLAB toolbox Gait-CAD. 
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

if (~exist('d_orgs', 'var') || isempty(d_orgs))
   myerror('No time series for separation found');
end;
if (size(d_orgs,1) > 1)
   %myerror('Cancel: Data is already split.');
   mywarning('The project contain more than one data point! Synchron trigger events are assumed for all data points.');
end;

% Dann die Daten vorbereiten und das Auswahlfenster aufrufen
vars = whos;
vars = char(vars.name);
if ~exist('zr_trig','var') || isempty(zr_trig)
   zr_trig = teile_zeitreihe_af(vars, deblank(var_bez(1:size(var_bez,1)-1,:)));
   
   % Auf das Schließen des Fensters warten:
   uiwait(zr_trig.fig_handles.h);
end;


% Nun prüfen, ob zr_trig.out (noch) vorhanden ist
if (exist('zr_trig', 'var') && isfield(zr_trig, 'out') && ~isempty(zr_trig.out))
   copy_zrs = [1:size(d_orgs,3)];
   % Nun kopiere die Triggerereignisse und prüfe die Dimensionen
   if (zr_trig.out.quelle == 1)
      % Die Triggerereignisse stehen in einer Zeitreihe:
      if (zr_trig.out.trig_var <= size(d_orgs,3))
         fprintf(1, 'Use time series %s for segmentation...\n', deblank(zr_trig.var_bez(zr_trig.out.trig_var,:)));
         trigger_er = squeeze(d_orgs(1, :, zr_trig.out.trig_var));
         copy_zrs(copy_zrs == zr_trig.out.trig_var) = [];
      else
         zr_trig = [];
         myerror('Too large time series index. Cancel.');
      end;
   else
      fprintf(1, 'Using workspace variable %s for separation...\n', deblank(zr_trig.vars(zr_trig.out.trig_var,:)));
      eval(sprintf('trigger_er = %s;', deblank(zr_trig.vars(zr_trig.out.trig_var,:))));
   end;
   % Nun die Dimensionen prüfen
   [z, s] = size(trigger_er);
   if (z > 1 && s > 1)
      zr_trig = [];
      myerror('A time series with trigger events must be a vector!');
   end;
   if ( (z == 1 && s ~= size(d_orgs,2)) || (s == 1 && z ~= size(d_orgs,2)) )
      zr_trig = [];
      myerror('The number of sample points of the time series in trigger events does not fit the number of sample points in the project!');
   end;
   
   % So, nun kann es losgehen
   triggers = find(trigger_er > 0);
   offsets = zr_trig.out.offset;
   if (length(offsets) < 2)
      mywarning('Only one offset defined. Set start to trigger event.');
      offsets = [0 offsets(1)];
   else
      offsets = offsets(1:2);
   end;
   
   %Ereignisse vor dem Beginn und nach dem Ende werden weggeschnitten
   triggers=triggers( find( (triggers - abs(offsets(1))) >= 1              ));
   triggers=triggers( find( (triggers + offsets(2))      <= size(d_orgs,2) ));
   
   N = size(d_orgs,1);
   
   % Soll eine Trigger-ZR erzeugt werden?
   if (zr_trig.out.trigger)
      neu = zeros(N*length(triggers), abs(diff(offsets))+1, length(copy_zrs)+1);
      % Dadurch, dass das Ende des Triggers mit dem Ende der Zeitreihe zusammenfällt, funktioniert
      % folgende einfache Geschichte:
      start = abs(offsets(1))+1;
      trig_zr = zeros(1, size(neu,2));
      trig_zr(start:length(trig_zr)) = 1;
      trig_zr = cumsum(trig_zr);
   else
      neu = zeros(N*length(triggers), abs(diff(offsets))+1, length(copy_zrs));
      trig_zr = [];
   end; % if (zr_trig.out.trigger)
   
   
   % neue Ausgangsklassen
   % Wenn N > 1, wird code_neu dreispaltig angelegt. In der ersten Spalte steht
   % die eigentliche Klasse, in der zweiten Spalte die Nummer des originalen Datentupels
   % und in der dritten Spalte die laufende Nummer des Triggerereignisses
   if (N > 1)
      code_neu = zeros(N*length(triggers), size(code_alle, 2) + 3);
   else
      code_neu = zeros(length(triggers), size(code_alle, 2) + 1);
   end;
   
   for t_c = 1:length(triggers)
      t = triggers(t_c);
      
      start = t - abs(offsets(1));
      ende  = t + offsets(2);
      
      % Berechne die Indizes für die Datentupel:
      start_tc = N * (t_c - 1) + 1;
      ende_tc  = start_tc + N - 1;
      if (~isempty(trig_zr))
         neu(start_tc:ende_tc, :, 1:size(neu,3)-1) = d_orgs(:, start:ende, copy_zrs);
         % Die Triggerzeitreihe muss nun vervielfältigt werden.
         neu(start_tc:ende_tc, :, size(neu,3)) 	 = myResizeMat(trig_zr, N, 1);
      else
         neu(start_tc:ende_tc, :, :) = d_orgs(:, start:ende, copy_zrs);
      end;
      if (N > 1)
         code_neu(start_tc:ende_tc, :) = [myResizeMat(trigger_er(t), N, 1) [1:N]' t_c*ones(N,1) code_alle];
      else
         code_neu(t_c, :) = [trigger_er(t) code_alle];
      end;
   end; % for(t_c = 1:length(triggers))
   
   var_bez = deblank(var_bez(copy_zrs, :));
   if (~isempty(trig_zr))
      var_bez = strvcatnew(var_bez, 'Trigger-TS');
   end;
   
   % Datei speichern
   clear d_org dorgbez code_alle d_orgs
   d_orgs = neu;
   clear neu;
   if (N > 1)
      bez_code = strvcatnew('Class', 'No. of original data point', 'Number of trigger event', bez_code);
      if (~isempty(zgf_y_bez))
         % Kopiere die alten Klassenbezeichner
         tmp_y_bez(4:size(bez_code,1), :) = zgf_y_bez;
         clear zgf_y_bez;
         zgf_y_bez = tmp_y_bez; clear tmp_y_bez;
         % Und füge für die vorderen Bezeichner Standardwerte ein
         for c = 1:3
            for cc = 1:max(code_neu(:, c))
               zgf_y_bez(c, cc).name = num2str(cc);
            end;
         end;
      end;
   else
      bez_code = strvcatnew('Class', bez_code);
      if (~isempty(zgf_y_bez))
         zgf_y_bez(2:size(bez_code,1), :) = zgf_y_bez;
         for cc = 1:max(code_neu(:, 1))
            zgf_y_bez(1, cc).name = num2str(cc);
         end;
      end;
   end;
   code_alle = code_neu;
   clear code_neu;
   saveprj_g;
   
   % Neues Projekt laden
   datei_load = [datei '.prjz'];
   ldprj_g;
else
   zr_trig = [];
   myerror('Options unknown. Stop segmentation.\n');
end;


clear triggers offsets trig_zr neu start t t_c vars zr_trig trigger_er s z