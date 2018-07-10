  function [string,info,callback]=datenauswahl_text(bez_code,zgf_y_bez,code_alle,par)
% function [string,info,callback]=datenauswahl_text(bez_code,zgf_y_bez,code_alle,par)
%
% The function datenauswahl_text is part of the MATLAB toolbox Gait-CAD. 
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

string = {};
for i=1:size(code_alle,2)
   
   %complete reimplementation: 
   %1. all information as cell string to fasten selection
   %2. cell string length on first position
   string{i,1} = max(code_alle(:,i))+1;
   string{i,2} = 'All';
   [string{i,3:max(code_alle(:,i))+2}] = deal(zgf_y_bez(i,1:max(code_alle(:,i))).name);
   
   tmp=sprintf('Selection %s',bez_code(i,:));
   info(i,1:length(tmp))=tmp;
end; 


% Callback Erzeugung entfällt: Text steht in callback_datenauswahl

%zum Speichern der Auswahl (in Kombination zu new_figure, muss aber hier
%erfolgen, damit unterschiedliche auswahl-Bezeichner möglich, z.B.
%auswahl.dat, auswahl.gen,...) 
%speichert letzte Auswahl: Gehe durch alle Auswahlfenster, speicher
%'values' in tmp, speicher in Matrix (untersch. Längen werden mit 0 aufgefüllt)
auswahl_speichern='merk=[];';

% Callback zuordnen
callback = sprintf('%s\n%s',auswahl_speichern, 'callback_datenauswahl;');
