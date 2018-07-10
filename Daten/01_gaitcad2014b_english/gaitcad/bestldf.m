  function [phi_dis,d]=bestldf(phi_dis,d_org,code,einstellungen,uihd)
% function [phi_dis,d]=bestldf(phi_dis,d_org,code,einstellungen,uihd)
%
% einstellungen=[] bedeutet Ruf durch KAFKA...
%
% The function bestldf is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(einstellungen)  %KAFKA-Ruf
   konvergenz_mit_drehung = 0;								% Sollen durch Drehungen der Transmatrix neue Startwerte berechnet werden?
   Schrittweite=1; 
   Qend=0.001;
   
   %ACHTUNG!!!!!! Gütefunktionen bekommen
   global Globaluihd
   Globaluihd=uihd;
   
   %wir holen den Funktionsnamen für die Evaluierungsfunktion aus dem Menü
   tmpstring=get(uihd(11,85),'string');
   verfahren=tmpstring(get(uihd(11,85),'value'),:);        
   
else %Vorbereitung für Davedesign
   konvergenz_mit_drehung = (get(uihd(45),'value')==1);								% Sollen durch Drehungen der Transmatrix neue Startwerte berechnet werden?
   Schrittweite= einstellungen.disk.opt.schrittweite;
   Qend 			= einstellungen.disk.opt.minaend;
end;

if ~exist('phi_dis', 'var')
   myerror('No Discriminant Analysis has been applied!');
else
   
   % bestldf-Optimierung durchführen
   if konvergenz_mit_drehung
      while konvergenz_mit_drehung
         Qold=guete_bestldf(phi_dis,code,d_org);
         change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));				% Parameter, die optimiert werden dürfen
         phi_dis=optimiere(phi_dis,change_param, code, d_org, Schrittweite, verfahren, 1, Qend);					% neuen Transformationsvektor aus altem TV berechnen
         phi_dis=varimax(phi_dis); 
         fprintf('\n\nTurn\n\n');
         Qneu=guete_bestldf(phi_dis,code,d_org);
         if ~((Qold-Qneu)/Qold>0.01) 
            konvergenz_mit_drehung=0;
         end;
      end; 
   else
      change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));				% Parameter, die optimiert werden dürfen
      phi_dis=optimiere(phi_dis,change_param, code, d_org, Schrittweite, verfahren, 1, Qend);					% neuen Transformationsvektor aus altem TV berechnen
   end;
   d=d_org*phi_dis;   
   
end;

%KAFKA-Ruf, sicherheitshalber globale Variablen wieder entsorgen !!!
if isempty(einstellungen) 
   clear Globaluihd; 
end;