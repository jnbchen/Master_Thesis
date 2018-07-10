  function [phi_dis, d]= mod_diskri (d_org, code, phi_dis, art, optionen, schrittweite, qend, drehung)
% function [phi_dis, d]= mod_diskri (d_org, code, phi_dis, art, optionen, schrittweite, qend, drehung)
%
%  Modifizierte Diskriminanz: Optimierung der Matrix zur Merkmalsaggregation
% 
%  d_org:             Datenmatrix
%  code:              Kodierung
%  phi_dis:           Startwert für Aggregationsmatrix
%  schrittweite:  des numerischen Optimierers
%  art:               1: bestklass-Verfahren, 2: bestklass-select-Verfahren, 3: best-LDF Verfahren
%  optionen:          bei bestLDF: Kostenmatrix
% ÄNDERUNG Sebastian (30.09.05)
%  optionen:          Strukt, enthält (bis jetzt) Distanzmaß, wird in klf_an6 benötigt
%  qend:              maximale Änderung bei der der Optimierungsprozess abgebrochen werden darf
%  drehung:           Wiederholung der Optimierung mit gedrehten Transformationsmatrizen
%  phi_mod:           neue modifizierte Aggregationsmatrix
%  d:                 transformierter Merkmalsraum
% 
%  [phi_mod]= mod_diskri (d_org, code, phi_dis, schrittweite, qend, drehung)
%  [phi_dis,d]= mod_diskri (d_org, code, phi_dis, 1, [], 1, 0.001, 0);
% 
%
% The function mod_diskri is part of the MATLAB toolbox Gait-CAD. 
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

warning_state=warning;
warning off;

if nargin < 8 
   drehung = 0; 
end;
if nargin < 7 
   qend = 0.001; 
end;
if nargin < 6 
   schrittweite= 1; 
end;
if nargin < 5 
   select=ones(length(findd(code)))-eye(length(findd(code))); 
end;
if nargin < 4 
   art=1; 
end;


% bestklass-Optimierung
if art==1							
   if drehung
      while drehung
         qold=guete_bestklass_g(phi_dis,code,d_org);
         change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));				% Parameter, die optimiert werden dürfen
         phi_dis=optimiere(phi_dis,change_param, code, d_org, schrittweite, 'guete_bestklass_g', 1, qend, optionen);
         phi_dis=varimax(phi_dis); 
         fprintf('\n\nTurn\n\n');			
         qneu=guete_bestklass_g(phi_dis,code,d_org);
         if ~((qold-qneu)/qold>qend) 
            drehung=0;
         end;
      end; 
   else
      change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));				% Parameter, die optimiert werden dürfen
      % neuen Transformationsvektor aus altem TV berechnen
      phi_dis=optimiere(phi_dis,change_param, code, d_org, schrittweite, 'guete_bestklass_g', 1, qend, optionen);					
      
   end;
   
   % bestklassselect-Optimierung   
elseif art==2					
   select=optionen;																				% Kostenmatrix
   if drehung
      while drehung
         qold=guete_bestklass_select(phi_dis,code,d_org);						% neuen Transformationsvektor aus altem TV berechnen
         change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));				% Parameter, die optimiert werden dürfen
         phi_dis=optimiere(phi_dis,change_param, code, d_org, schrittweite, 'guete_bestklass_select',1, qend, select);				
         phi_dis=varimax(phi_dis); fprintf('\n\nTurn\n\n');
         qneu=guete_bestklass_select(phi_dis,code,d_org);						% neuen Transformationsvektor aus altem TV berechnen
         if ~((qold-qneu)/qold>qend) 
            drehung=0;
         end;
      end;
   else
      change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));						% Parameter, die optimiert werden dürfen
      phi_dis=optimiere(phi_dis,change_param, code, d_org, schrittweite, 'guete_bestklass_select', 1, qend, select);					
   end;   
   
   % bestLDF-Optimierung   
elseif art==3					
   if drehung
      while drehung
         qold=guete_bestldf(phi_dis,code,d_org);
         change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));				% Parameter, die optimiert werden dürfen
         phi_dis=optimiere(phi_dis,change_param, code, d_org, schrittweite, 'guete_bestldf', 1, qend);					
         phi_dis=varimax(phi_dis);
         fprintf('\n\nTurn\n\n');
         qneu=guete_bestldf(phi_dis,code,d_org);
         if ~((qold-qneu)/qold>qend) 
            drehung=0;
         end;
      end; 
   else
      change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));				% Parameter, die optimiert werden dürfen
      % neuen Transformationsvektor aus altem TV berechnen
      phi_dis=optimiere(phi_dis,change_param, code, d_org, schrittweite, 'guete_bestldf', 1, qend);					      
   end;
end;

% Normierung, so dass der Betrag des größten Elements = 1 ist.
tmp=find(abs(phi_dis(:))==max(abs(phi_dis(:)))); 
tmp=tmp(1);		% Falls es mehr als ein Maximum gibt.
phi_dis=phi_dis./phi_dis(tmp)*((phi_dis(tmp)>0)-0.5).*2;

d=d_org*phi_dis;    

% Warnstatus wiederherstellen
warning warning_state;