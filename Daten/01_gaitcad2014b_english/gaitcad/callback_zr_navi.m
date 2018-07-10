% Script callback_zr_navi
%
% Callbackfunktion zum Erstellen (mode_trigger==1) oder Bearbeiten (mode_trigger==2) von Triggerzeitreihen
% 
% Triggerzeitreihe soll bearbeitet werden!
%
% The script callback_zr_navi is part of the MATLAB toolbox Gait-CAD. 
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

if mode_trigger==2  
   
   %kann das alles passen? 
   if length(parameter.gui.merkmale_und_klassen.ind_zr)~=1
      myerror('Error! Only one time series can be selected as trigger time series!');
   end; 
  
   trigger_list   = find(d_orgs(1,:,parameter.gui.merkmale_und_klassen.ind_zr))';
   trigger_klasse = d_orgs(1,trigger_list,parameter.gui.merkmale_und_klassen.ind_zr)';
   
   classes = unique(trigger_klasse);
   if any(classes ~= round(classes)) || isempty(classes) || min(classes)<=0 
      myerror('Error! Trigger events have to be positive integers!');
   end; 
end;  
   
%Navi aufbauen   
if par.anz_merk>1
    h_navi = zr_navi(squeeze(d_orgs(1,:,:)), var_bez(1:size(var_bez,1)-1,:));
else
    %u.U. Probleme, wenn nur eine Zeitreihe
    temp=squeeze(d_orgs(1,:,[1 1]));
    h_navi = zr_navi(temp(:,1), var_bez(1:size(var_bez,1)-1,:)); 
    clear temp;
end;

%Triggerzeitreihe soll bearbeitet werden!
if mode_trigger==2
   h_navi.trigger_list = trigger_list;
   h_navi.trigger_klasse = trigger_klasse;
   h_navi.trigger_nr=parameter.gui.merkmale_und_klassen.ind_zr;
   set(h_navi.elements.triggers.listbox, 'String', liststr([h_navi.trigger_list h_navi.trigger_klasse]));
   set(h_navi.figure, 'UserData', h_navi);
   %Einzeichnen...
   zr_navi_callbacks([], 'slider');
   %Aufräumen
   clear trigger_list trigger_klasse classes 
end;

   
