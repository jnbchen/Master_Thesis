% Script callback_kat_auswahl_text
%
% hier Unterscheidung, ob Zeitreihen, oder Einzelmerkmale
%
% The script callback_kat_auswahl_text is part of the MATLAB toolbox Gait-CAD. 
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

switch mode
   %Zeitreihen   
case 1
   for i=1:size(code_zr,2) 
      ind=get(figure_handle(i+1,1),'value')-1; % die '-1' wegen 'ALL'
      if ind(1)==0 
         ind=findd(code_zr(:,i));
      end; %Wenn 'ALL' gewählt
      zgf_zr_bez(i,1).auswahl=ind;  
   end; 
   
   ind_katzr=kat_auswahl(zgf_zr_bez, code_zr); 
   % Zeitreihen-Auswahl im Hauptfenster neu einstellen: 
   parameter.gui.merkmale_und_klassen.ind_zr=ind_katzr;
   
   % speichert letzte Auswahl: Gehe durch alle Auswahlfenster, 
   %speicher 'values' in tmp, 				
   %speicher in Matrix (untersch. Längen werden mit 0 aufgefüllt) 
   auswahl.katzr=[]; 
   for i=2:size(figure_handle,1)-1  
      tmp=get(figure_handle(i,1),'value'); 
      auswahl.katzr(i-1,1:length(tmp))=tmp;
   end;
   
   %Einzelmerkmale       
case 2
   
   for i=1:size(code_em,2)  
      ind=get(figure_handle(i+1,1),'value')-1; % die '-1' wegen 'ALL'
      if ind(1)==0 
         ind=findd(code_em(:,i));
      end;%Wenn 'ALL' gewählt
      zgf_em_bez(i,1).auswahl=ind;
   end;
   
   ind_katem=kat_auswahl(zgf_em_bez, code_em);
   parameter.gui.merkmale_und_klassen.ind_em=ind_katem;  
   auswahl.katem=[]; 
   for i=2:size(figure_handle,1)-1   
      tmp=get(figure_handle(i,1),'value');
      auswahl.katem(i-1,1:length(tmp))=tmp;
   end;
end;

%Kategorienergebnisse eintragen
inGUI;
