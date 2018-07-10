  function pl_2da(dat,code,kl,s,su,dist,za_mode,sw_mode,var_bez,zgf_bez,newfigure,ind_auswahl)
% function pl_2da(dat,code,kl,s,su,dist,za_mode,sw_mode,var_bez,zgf_bez,newfigure,ind_auswahl)
%
%  zeigt Daten im Farbcode der Klassifikation
%  und zeichnet Kovarianzmatrizen ein
%  Eingangsvariablen:
%  dat      -> Datenmatrix
%  code         -> Klassencode
%              (!!!code von 1 bis kl_anz!!!)
%  kl       - Klassenmittelpunkte
%  s        - Klassenspezifische Kovarianzmatrizen
%  su       - Mahalanobis-Kovarianzmatrix
%  dist     ==1   Euklidische Distanz
%           ==2   Mahalanobis Distanz
%           ==3   Tatsuoka Abstände
%  za_mode  ==1   Datentupel werden mit Klassenzeichen und Nummer angezeigt
%           ==0   Datentupel werden mit Klassenzeichen angezeigt (default)
%           ==-1  Datentupel werden nicht mit angezeigt
%  sw_mode  ==2   Klassen-Nr.
%           ==1   Schwarz-Weiß-Modus -> Klassenzeichen = Zahl
%           ==0   Farb-Modus -> Klassenzeichen = farbiger Stern
%  var_bez  Variablenbezeichnungen
%  zgf_bez  Bezeichnungen ZGF
%
% The function pl_2da is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<9
   var_bez='';
end;
if nargin<10
   zgf_bez=[];
end;
if nargin<11
   newfigure=1;
end;
if nargin<12
   ind_auswahl=0;end;


if (gcf == 1)
   newfigure = 1;
end;
if (newfigure)
   figure;
end;
hold on;
if (za_mode~=-1)
   pl_2d(dat,code,1,za_mode,sw_mode,var_bez,zgf_bez,0,0,1,ind_auswahl);
end;

kl_anz=max(code);
if (size(dat,2)==2)
   
   %Kovarianzmatrix Datenmaterial
   my=mean(dat);
   my_ellip(cov(dat),my,1,'c');
end;

%Kovarianzmatrix der Klassen
cc=hsv;
for i=1:kl_anz
   if (~isempty(find(code==i)))
      if dist==3
         mycov=s(size(s,2)*(i-1)+(1:size(s,2)),:);
      end;
      if dist==2
         mycov=su;
      end;
      if dist==1
         mycov=eye(size(s,2))*.1*mean(std(dat));
      end;
      my_ellip(mycov,kl(i,:),1,'k');
      text(kl(i,1),kl(i,2),sprintf('%d',i));
   end;
end;

zoom on;

