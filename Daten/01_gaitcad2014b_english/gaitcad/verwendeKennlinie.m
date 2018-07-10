  function [DatenColor,colorbartick] = verwendeKennlinie(daten, param,colorbartick)
% function [DatenColor,colorbartick] = verwendeKennlinie(daten, param,colorbartick)
%
%  Erzeugt eine neue Farbverteilung durch eine Kennlinie. Dadurch können kleine Werte bevorzugt werden und in einem
%  größeren Farbbereich dargestellt werden
%  Eingaben:
%  daten: Daten, deren Werte umgerechnet werden sollen
%  param: Strukt mit folgenden Feldern:
%  param.kennlinie_art: Nummer der Kennlinie, die verwendet werden soll:
%                      1: lineare Kennlinie
%                      2: Wurzelkennlinie
%                      3: Exponentialkennlinie
%  param.parameter: Parameter für Wurzel- oder Exponentialkennlinie
%  param.name: Zu plottender Name für die Kennlinie
% 
%  Ausgaben:
%  neueDaten: umgerechnete Daten
%  kennlinie: Werte der verwendeten Kennlinie im Bereich [0..1]
%  color_umrechnung: Enthält die Umrechnungsdaten. Mit erzeugeColorbarTickLabels können dadurch die Ticks einer Colorbar auf die
%         richtigen Werte verändert werden kann.
%
% The function verwendeKennlinie is part of the MATLAB toolbox Gait-CAD. 
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

if (~isempty(param.caxis))
   mindatorg = param.caxis(1);
   maxdatorg = param.caxis(2);
else
   mindatorg      = min(min(daten(find(~isnan(daten)))));
   maxdatorg      = max(max(daten(find(~isnan(daten)))));
end;


% allgemeine Formel für inverse Colorbar
% colorbartick(:,2) = f^-1 ( colorbartick(:,1) * ( f(maxdatorg) - f(mindatorg)) + f(mindatorg) )

if mindatorg<0 && param.kennlinie_art>1
   
   daten = (daten - mindatorg)/ (maxdatorg-mindatorg);
   par1 = mindatorg;
   mindatorg = 0;
   par2 = maxdatorg;
   maxdatorg = 1;
   renorm = 1;
else
   renorm = 0;
end;


switch(param.kennlinie_art)
   case 1  % Linear
      
      colorbartick(:,2) = mindatorg + colorbartick(:,1) * (maxdatorg-mindatorg)/colorbartick(end,1);
      mindat = mindatorg;
      maxdat = maxdatorg;
      
   case 2 % Wurzel
      
      daten = daten.^(1/(param.parameter));
      mindat = mindatorg.^(1/(param.parameter));
      maxdat = maxdatorg.^(1/(param.parameter));
      
      fmindatorg = mindatorg^(1/(param.parameter));
      fmaxdatorg = maxdatorg^(1/(param.parameter));
      
      colorbartick(:,2) = ( colorbartick(:,1) * (fmaxdatorg- fmindatorg) + fmindatorg ) .^param.parameter ;
      
   case 3
      
      % Das folgende sieht schlimmer aus als es ist.
      % Problematisch sind die Normierungen. Nach exp sind Werte zwischen [1,e]
      % vorhanden. Das wird zurück auf [0,1] normiert, dann auf [0,255],
      % zum Schluss umgedreht. Denn: die Funktion ist monoton fallend, sie müsste
      % aber monoton steigend sein => vom Maximum abziehen.
      %daten = 1-((exp((1-daten).^param.parameter) - 1) ./ (exp(1)-1));
      
      daten      = 1-((exp((1-daten).^param.parameter) - 1) ./ (exp(1)-1));
      fmindatorg = 1-((exp((1-mindatorg).^param.parameter) - 1) ./ (exp(1)-1));
      fmaxdatorg = 1-((exp((1-maxdatorg).^param.parameter) - 1) ./ (exp(1)-1));
      mindat = 1-((exp((1-mindatorg).^param.parameter) - 1) ./ (exp(1)-1));
      maxdat = 1-((exp((1-maxdatorg).^param.parameter) - 1) ./ (exp(1)-1));
      
      y = colorbartick(:,1) * (fmaxdatorg- fmindatorg) + fmindatorg;
      colorbartick(:,2)  = 1 - log( ( exp(1)-1 ) .* (1-y) + 1 ).^(1/param.parameter);
      
   case 4
      %Log <=0 verhindern!
      mindatorg      = min(min(daten(find(daten>0))));
      
      daten = log(daten);
      mindat = log(mindatorg);
      maxdat = log(maxdatorg);
      
      fmindatorg = log(mindatorg);
      fmaxdatorg = log(maxdatorg);
      
      colorbartick(:,2) = exp( colorbartick(:,1) * (fmaxdatorg- fmindatorg) + fmindatorg) ;
end;

%Daten auf 0-1-Intervall der Farben bringen
%mindat      = min(min(daten(find(~isinf(daten)))));
%maxdat      = max(max(daten(find(~isinf(daten)))));
DatenColor  = (daten-mindat)./(maxdat-mindat);
DatenColor  = min(1,DatenColor);
DatenColor  = max(0,DatenColor);

if renorm == 1
   colorbartick(:,2)= par1 + colorbartick(:,2) * (par2-par1);
end;

%handling of nan-values
if ~isempty(find(isnan(daten)))
   DatenColor(find(isnan(daten))) = NaN;
end;