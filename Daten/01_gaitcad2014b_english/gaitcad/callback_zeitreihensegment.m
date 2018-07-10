% Script callback_zeitreihensegment
%
%  Callback für Auswahl von Zeitreihensegmenten und Triggerereignissen
%  mode==0    Zeitreihensegment linker - rechter Rand
%  mode==1..C Triggerereignis linker Rand, wird zunächst in Datei geschrieben
% 
%  basiert auf dem aktuellen Zeitreihenbild und dem entsprechenden Callback
%
% The script callback_zeitreihensegment is part of the MATLAB toolbox Gait-CAD. 
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

ax=axis;
ax=ax(1:2);

%normalerweise Sample, können aber auch prozentuale Angaben oder die Zeit sein 
%dann gibt es Korrekturen!!!
if strcmp(parameter.gui.zeitreihen.anzeige,'Percental')
   ax=1+ax*par.laenge_zeitreihe/100;
end;
if strcmp(parameter.gui.zeitreihen.anzeige,'Time')
   ax=1+ax*parameter.gui.zeitreihen.abtastfrequenz;
end;
if strcmp(parameter.gui.zeitreihen.anzeige,'Project')
   return;
end;




%Begrenzung auf 1-Länge Zeitreihe
ax=max(1,round(ax));
ax=min(par.laenge_zeitreihe,ax);

if (mode==0)
   %Segment: ausgewählter Bildbereich
   parameter.gui.zeitreihen.segment_start=ax(1);
   parameter.gui.zeitreihen.segment_ende=ax(2);
   inGUI;
end;


if (mode>0)
   %Segment: ausgewählter Bildbereich
   f_trig=fopen([parameter.projekt.datei '.trigger'],'at');
   fprintf(f_trig,'%g \t %g\n',ax(1),mode);
   fclose(f_trig);
   
   %hold on;   
   %plot()
   
   %Aufräumen!!!
   clear f_trig;
end;

%Aufräumen!!!
clear ax ;