  function plot_trenn_neu(d, code, klass_single, kp, aufloesung)
% function plot_trenn_neu(d, code, klass_single, kp, aufloesung)
%
%  Zeichnet Trennflächen für einen gegebenen Klassifikator.
%  Eingaben:
%  d: Daten mit denen Klassifiziert wurde (also ausgewählte aus d!)
%  d darf maximal 2D sein (also size(d,2) == 2)
%  code: Klassencodes. Gleiche Zahl Zeilen wie d.
%  klass_single: Klassifikationsstrukt aus Gait-CAD und Kafka.
%  kp: Klassifikationsparameter aus Gait-CAD.
%  uihd: Menüelemente der Oberfläche
%  phi_text: Für den Titel der Figure (default: [])
%
% The function plot_trenn_neu is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 6)
   phi_text = [];
end;

if(nargin < 5)
   myerror('Error! Too few parameters.');
   return;
end;

if (size(d,2) > 2)
   mywarning('Too many features!');
   return;
end;

if isempty(klass_single)
   myerror('No classifier designed');
   return;
end;


% Datenzahl erhöhen und in regelmäßigen Abständen eine Punkt einbauen.
% x_Auflösung und y_Auflösung festlegen
a=min(d(:,1)):(max(d(:,1))-min(d(:,1)))/aufloesung:max(d(:,1));	
b=min(d(:,2)):(max(d(:,2))-min(d(:,2)))/aufloesung:max(d(:,2));

ag= a'*ones(1,length(b)); 
ag=ag'; 
bg=b'*ones(1,length(a));
d=[ag(:) bg(:)]; 

bg=b'*ones(1,length(b)); 
bg=bg'; 
ag= a'*ones(1,length(a)); 
d=[d; [ag(:) bg(:)]];

% Nun einfach den Klassifikator aufrufen. Die ganzen Abfragen, welcher Klassifikator
% verwendet wird und die korrekten Parameter stehen entweder in klass_single oder in kp.
% HIER FEHLT NOCH DIE ABFRAGE AUF TURNIERKLASSIFIKATOREN.
if (~isfield(klass_single, 'one_against_one') && ~isfield(klass_single, 'one_against_all'))
   kp.klassifikator = klass_single.entworfener_klassifikator.typ;
   [pos,prz] = klassifizieren_an(klass_single, d, kp);
else
   warning('It is impossible to plot discriminant functions for one-against-one or one-against-all classifiers.');
   return;
end;

% Nun das Ergbenis besorgen und Änderungen in der Klassenzuweisung suchen.
d(:,3)=pos;
d(:,3)=[0; diff(d(:,3))]; 							% Änderungen detektieren
d(aufloesung+2:aufloesung+1:size(d,1),3)=0;	% Zeilensprünge löschen

% Die Änderungen als graue Punkte plotten.
tmp=find(d(:,3));
ha=plot(d(tmp,1),d(tmp,2),'.');
set(ha,'color',[0.5 0.5 0.5]);

% Beim Bayes-Klassifikator noch die Klassenmittelpunkte plotten:
if(strcmp(kp.klassifikator,'bayes'))
   if(size(klass_single,2) > 1)	%bei One-against-all-Klassifikation müssen zuerst unnützen Infos über zu einer Klasse zusammengefassten Klassen entfernt werden
      for i = unique(code(ind_auswahl_org))' 
         kl_plot(i,:) = klass_single(i).bayes.kl(1,:); 
      end
   else 
      kl_plot = klass_single.bayes.kl;
   end
   plot(kl_plot(:,1),kl_plot(:,2),'p', 'linewidth', 1); 
end