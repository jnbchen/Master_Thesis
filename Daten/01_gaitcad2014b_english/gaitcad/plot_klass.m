% Script plot_klass
%
%  Zeichnet Daten
%  Aufruf von außen durch:
%  figure; hold on; Datensatznummern=0; nummerierung=1; plot_klass;
%
% The script plot_klass is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

xlabel('Feature 1'); ylabel('Feature 2');

if exist('Displacement', 'var') % wenn Zahlen zur besseren Darstellung leicht verschoben sein sollen
   tmp=abs(min(d(:,1))-max(d(:,1)));  %
   proz=verschiebung; 			%Um Nummerierung um 1% der Achsenlänge zu verschieben muss verschiebung=0.01 sein
else    tmp=0;   proz=0;
end;


if ~exist('d', 'var')
   msg = msgbox('No classification accomplished');
elseif size(d,2)>2
   msg = msgbox('Plot only possible for 2D-data');
else
   Farben =[0 0 1;...
      0 0.5 0;...
      1 0 0;...
      0 0.75 0.75; ...
      0.75 0 0.75; ...
      0.75 0.75 0; ...
      0.25 0.25 0.25; ...
      0.75 0.5 0.25];
   if nummerierung==1 						% Datennummern plotten (für plot in eigener figure)
      if size(d,2)==2
         %Änderungen Sebastian (23.09.'05) um bei unbesetzte Klassen korrekt zu plotten (die anderen Fälle für nummerierung werden in Gait-CAD nicht verwendet)
         %plot(max(d(:,1)),max(d(:,2)),'w'); plot(min(d(:,1)),min(d(:,2)),'w');
         plot(max(d(ind_auswahl,1)),max(d(ind_auswahl,2)),'w'); plot(min(d(ind_auswahl,1)),min(d(ind_auswahl,2)),'w');
         %for ii=1:size(d,1)
         for ii= ind_auswahl'
            if Datensatznummern
               text(d(ii,1)+proz*tmp, d(ii,2), num2str(ii),'FontSize', 8, 'Color', Farben(code(ii),:));
            else
               text(d(ii,1)+proz*tmp, d(ii,2), num2str(code(ii)),'FontSize', 8);
            end;
         end;
      else
         %plot(max(d(:,1)),0,'w'); plot(min(d(:,1)),0,'w');
         plot(max(d(ind_auswahl,1)),0,'w'); plot(min(d(ind_auswahl,1)),0,'w');
         %for ii=1:size(d,1)
         for i = ind_auswahl'
            text(d(ii,1), 0, num2str(ii),'FontSize', 8, 'Color', Farben(code(ii),:));
         end;
      end;
   elseif nummerierung==-1
      for ii=findd(code)
         if size(d,2)==2 
            DatSet=plot(d(find(code==ii),1)+proz*tmp,d(find(code==ii),2),'.', 'LineWidth', 1);
         else
            DatSet=plot(d(find(code==ii),1),0,'*');
         end;
         Farbe=mod(ii-1,size(Farben,1))+1;
         set(DatSet,'color',Farben(Farbe,:));
      end;
   else										% Plot innerhalb GUI-Umgebung
      for ii=findd(code)
         if size(d,2)==2 
            DatSet=plot(d(find(code==ii),1)+proz*tmp,d(find(code==ii),2),'*', 'LineWidth', 1);
         else
            DatSet=plot(d(find(code==ii),1),0,'*');
         end;
         Farbe=mod(ii-1,size(Farben,1))+1;
         set(DatSet,'color',Farben(Farbe,:));
      end;
   end;
end;
clear Farbe Farben nummerierung Datensatznummern verschiebung;
