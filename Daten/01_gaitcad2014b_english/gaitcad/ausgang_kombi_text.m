  function [string,info,callback]=ausgang_kombi_text(bez_code)
% function [string,info,callback]=ausgang_kombi_text(bez_code)
%
% The function ausgang_kombi_text is part of the MATLAB toolbox Gait-CAD. 
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

fprintf('Combining output variables and classes...\n');

info(1,:)='Output variable';
string(1,:)=poplist_popini(bez_code);

%Löschen der Ausgangsklasse
tmp=sprintf('   ind_ausg=get(figure_handle(2,1),''value'');  '); % Zeilenvektor mit allen ausgewählten (zu löschenden) Ausgklassen tmp=sprintf('%s  d_org(:,ind_merkmale)=[];',tmp);
tmp=sprintf('%s [bez_code, zgf_y_bez, code_alle]=ausgang_kombi(bez_code, zgf_y_bez, code_alle, ind_ausg);',tmp); 

%Aufräumen und Parameter aktualisieren
tmp=sprintf('%s clear ind_ausg;',tmp); 

tmp=sprintf('%s  fprintf(''Ready!\\n'');',tmp);

%zum Speichern der Auswahl (in Kombination zu new_figure, muss aber hier erfolgen, damit unterschiedliche auswahl-Bezeichner möglich, z.B. auswahl.dat, auswahl.gen,...) 
% speichert letzte Auswahl: Gehe durch alle Auswahlfenster, speicher 'values' in tmp,                  speicher in Matrix (untersch. Längen werden mit 0 aufgefüllt) 
auswahl_speichern='auswahl.ausgkombi=[]; for i=2:size(figure_handle,1)-1    tmp=get(figure_handle(i,1),''value''); auswahl.ausgkombi(i-1,1:length(tmp))=tmp;end;';


callback=sprintf('%s %s',tmp,auswahl_speichern); 
