% Script callback_em_loeschen
%
% Löschen der Einzelmerkmale
%
% The script callback_em_loeschen is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(ind_merkmale) 
   
   if (length(ind_merkmale) == par.anz_einzel_merk) && par.anz_merk == 0
      myerror('Not all time series and single features can be deleted!');
   end;
      
   fprintf('%d Single features will be deleted\n',length(ind_merkmale));
   d_org(:,ind_merkmale)=[];
   for i=1:length(ind_merkmale)
      fprintf('%d: %s\n',ind_merkmale(i),dorgbez(ind_merkmale(i),:));
   end;
      dorgbez(ind_merkmale,:)=[];
   if ~isempty(merk) 
      merk(ind_merkmale)=[];
   end;
   %A-Priori-Relevanzen löschen
   if ~isempty(interpret_merk) 
      if interpret_merk>0 
         interpret_merk(ind_merkmale)=[];
      end;
   end;
   merkmal_auswahl=[];
   
   %feature extraction bases on feature numbers, results become invalid!
   regr_single  = [];
   regr_plot    = [];
   klass_single = [];
   
   % Die Anzeigeelemente updaten. Es dürfen auf keinen Fall Elemente ausgewählt bleiben, die es nicht mehr gibt.
   parameter.gui.merkmale_und_klassen.ind_em = setdiff(parameter.gui.merkmale_und_klassen.ind_em,ind_merkmale);
   if (isempty(parameter.gui.merkmale_und_klassen.ind_em))
      parameter.gui.merkmale_und_klassen.ind_em = 1;
   end;
   inGUI;
   fprintf('Complete!\n');
end; 


%Aufräumen und Parameter aktualisieren
clear ind_merkmale; 

%zum Speichern der Auswahl (in Kombination zu new_figure, muss aber hier erfolgen, damit unterschiedliche auswahl-Bezeichner möglich, z.B. auswahl.dat, auswahl.gen,...) 
%speichert letzte Auswahl: Gehe durch alle Auswahlfenster, speicher 'values' in tmp,                  speicher in Matrix (untersch. Längen werden mit 0 aufgefüllt) 
aktparawin; 
