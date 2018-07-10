% Script callback_beenden
%
% The script callback_beenden is part of the MATLAB toolbox Gait-CAD. 
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

if exist('datei','var') && ~isempty(datei)
   %anderenfalls wahrscheinlich zusätzlicher Aufruf beim 2. Gait-CAD-Start
   %da sollen sich andere um das close all kümmern...
   antwort=questdlg('Save project?', 'Save?', 'Yes', 'No', 'Cancel', 'Yes');
   if (strcmp(antwort, 'Cancel'))
      return;
   end;
   if strcmp(antwort, 'Yes')
      datei_save=datei;
      saveprj_g;
   end;
   % Dieses setzen ist wichtig! callback_beenden wurde als DeleteFcn definiert.
   % Dadurch wird dieses Skript erneut aufgerufen, wenn das Fenster geschlossen wird.
   % Eine zweite Frage soll aber vermieden werden.
   datei = [];
   delete(1);
   close all;
else
   % NICHT ENTFERNEN!!!
   % Wenn dieser Fall nicht enthalten ist, kann Gait-CAD nicht geschlossen
   % werden, wenn keine Datei geladen wurde!
   % Der Fall ist vielleicht selten, aber er kommt vor!!
   try
      delete(1);
      close all;
   catch
      lasterr;
   end;
end;

% Bekannt geben, dass kein Projekt mehr geladen ist.
parameter.projekt = [];


