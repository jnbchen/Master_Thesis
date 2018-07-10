  function tickLabels = erzeugeColorbarTickLabels2(col_umrechnung, ticks)
% function tickLabels = erzeugeColorbarTickLabels2(col_umrechnung, ticks)
%
% Diese Funktion erzeugt die Texte an einer Colorbar.
% Leider macht die Matlab-Colorbar-Funktion eine lineare Interpolation
% für die Farbwerte und sucht nicht in der Matrix nach den tatsächlichen
% Werten.
% Also wird hinterher der Text der Colorbar verändert.
% 
% In col_umrechnung steht in der ersten Spalte der äquidistante Dezimalwert,
% in der zweiten Spalte der berechnete Farbwert
%
% The function erzeugeColorbarTickLabels2 is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

tickLabels = [];
col_umrechnung(:,3) = [0:1:255]';
for i = 1:length(ticks)
   % Erster Wert kann ausgenommen werden, zumindest wenn er 0 ist.
   if (i == 1 && ticks(1) == 0)
      tickLabels = num2str(0);
   else
      col_tmp = col_umrechnung(:,1)-ticks(i);
      % Suche den Wert, der am nächsten an dem aktuellen Tick ist.
      [val, indx] = min(abs(col_tmp));
      % "Umkreise" den Wert... Die Color-Umrechnung muss monoton steigend sein.
      if (col_umrechnung(indx,1) > ticks(i))
         start = indx - 1;
         stop = indx;
      else
         start = indx;
         stop = indx + 1;
      end;
      % Gibt es den Stopwert nicht mehr?
      if (stop > size(col_umrechnung,1))
         tickLabels = strvcatnew(tickLabels, num2str(col_umrechnung(start,1)));
      else
	      %d = col_umrechnung(stop,3) - col_umrechnung(start,3);
         %proz = col_umrechnung(start,3)/ticks(i);
         %proz = d/ticks(i);
         % Farbwert bei linearer Verteilung
         d = col_umrechnung(start, 3);
         % Nun suche in der zweiten Spalte nach diesem Farbwert
         col_tmp = col_umrechnung(:,2) - d;
         [val, indx] = min(abs(col_tmp));
         % Der Wert in der ersten Spalte ist der gesuchte:
         lbl = col_umrechnung(indx, 1);
         
	      %lbl = proz * col_umrechnung(start,1) + (1-proz)*col_umrechnung(stop,1);
         tickLabels = strvcatnew(tickLabels, num2str(lbl,'%0.3f'));
      end;
   end;
end;
