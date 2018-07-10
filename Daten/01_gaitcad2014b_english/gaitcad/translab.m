  function plausall=translab(baum,par,absich,type,anzeige)
% function plausall=translab(baum,par,absich,type,anzeige)
%
% übersetzt Baum- in Regelstruktur
% type=1 mit Nullregeln, type=0 ohne Nullregeln (default)
%
% The function translab is part of the MATLAB toolbox Gait-CAD. 
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

j=1;

fprintf('Create rulebase out of decision tree ... \n');

%Behandlung von Nullregeln: 
% ==1   werden als Regeln ohne Beispiel eingetragen
%       sonst Elternregel wird mit niedrigerer Relevanz eingetragen
%       -> weniger Regeln, aber teilweise widersprüchlich  
if (nargin<4) 
   type=0;
end;
if (nargin<5) 
   anzeige=1;
end;

%Anzahl Fuzzy-Mengen für Regelbasis
anz_fuzzy=max(par(5:end));


%Baum beschneiden um Nullzeilen
baum(find(baum(:,1)==0),:)=[];

%Endzweige, die keine weitere U-Unterteilung haben -> gültige Regeln
ind=find(baum(:,3)==0);

for i=ind' 
   elter=baum(i,1);
   kind=i;
   mas=zeros(par(2),1+anz_fuzzy);
   
   %nach oben Suchen bis Wurzel und so Regel zusammenstellen
   while (elter~=-1)
      klasse=find(baum(elter,4:size(baum,2))==kind);
      variable=baum(elter,3);
      mas(variable,1)=klasse; 
      kind=elter;
      elter=baum(elter,1);
   end;
   
   %um Beispielanzahl und Fehler ergänzen
   plausall(j,:)=[-1 absich(i,:) baum(i,2) mas2pla(mas)];
   j=j+1;
   if (rem(j,20)==0) && anzeige 
      fprintf('%4d \n',j);
   end;
end;


%Endzweige, bei denen nur ein Unterteilung nach bestimmten U-Klassen stattfindet
%also z.B. Entscheidungsvariable u1 mit Klassen 1,2 aber ohne Beispiele für Klasse 3
%d.h. Regeln ohne Beispiele !!!

%Regeln werden als Regeln ohne Beispiel eingetragen

%aber nicht die gültigen Regeln von oben
baum(ind,3:size(baum,2))=-1*ones(size(baum(ind,3:size(baum,2))));
if (anzeige) 
   fprintf('Zero-rules ... \n');
end;
if (type==1)
   %alle Zweige, in denen mindestens eine 0 vorkommt und die 
   %zugehörigen Verzweigungen
   [indx,indy]=find(baum(:,4:size(baum,2))==0);
   
   for i=1:length(indx)
      elter=baum(indx(i),1);
      kind=indx(i);
      mas=zeros(par(2),1+anz_fuzzy);
      %ACHTUNG ! Die Verzweigung, die nicht durch Daten abgedeckt ist,
      %wird mit in Regel aufgenommen 
      variable=baum(indx(i),3);
      klasse=indy(i);
      
      %nur für gültige Terme !!
      if klasse<=par(4+variable)
         mas(variable,1)=klasse; 
         while (elter~=-1)
            klasse=find(baum(elter,4:size(baum,2))==kind);
            variable=baum(elter,3);
            mas(variable,1)=klasse; 
            kind=elter;
            elter=baum(elter,1);
         end; %while
         plausall(j,:)=[-1-(absich(i,2)==0) absich(i,:) baum(kind,2) mas2pla(mas)];
         j=j+1; 
      end; %if (klasse<=
   end; %for i
end; %if type==1

if (type==0)
   %alle Zweige, in denen mindestens eine 0 vorkommt
   indx=find(full(min(baum(:,4:size(baum,2))')==0));
   
   for i=indx
      elter=baum(i,1);
      kind=i;
      mas=zeros(par(2),1+anz_fuzzy);
      %ACHTUNG ! Die Verzweigung, die nicht durch Daten abgedeckt ist,
      %wird NICHT mit in Regel aufgenommen - nur die Elternregel mit
      %der dort optimalen Entscheidung 
      
      %Regelprämissen zusammenbauen
      while (elter~=-1)
         klasse=find(baum(elter,4:size(baum,2))==kind);
         variable=baum(elter,3);
         mas(variable,1)=klasse; 
         kind=elter;
         elter=baum(elter,1);
      end;
      plausall(j,:)=[-2 absich(i,:) baum(i,2) mas2pla(mas)];
      j=j+1;
      if (rem(j,20)==0) 
         fprintf('%4d \n',j);
      end;
   end;
end; %type==0

if (anzeige) 
   fprintf('Ready \n');
end;