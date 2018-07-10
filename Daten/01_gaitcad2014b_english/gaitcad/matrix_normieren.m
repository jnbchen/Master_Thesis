  function [dat,par1,par2]=matrix_normieren(dat,mode,par1,par2)
% function [dat,par1,par2]=matrix_normieren(dat,mode,par1,par2)
%
% mode=0 gibt ursprüngliche Werte unverändert zurück
% mode=1 MW Null, Standardabweichung 1
% mode=-1 stellt ursprüngliche Matrix wieder her
% PARAMETER: MEAN, STD
% 
% mode=2 Intervall 0 1
% mode=-2 stellt ursprüngliche Matrix wieder her
% Parameter: MIN, DIFF
% 
% par1, par2: Parameter für Konstruktion bzw. Rekonstruktion
% bei Konstruktion werden die Parameter nur dann aus den Daten berechnet, wenn sie NICHT mit übergeben werden
% 
%
% The function matrix_normieren is part of the MATLAB toolbox Gait-CAD. 
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

if mode==0 
   par1=[];
   par2=[];
   return; 
end;

if (nargin<3) 
   par1=[]; 
end;
if (nargin<4) 
   par2=[]; 
end;


if (mode==1) 
   if isempty(par1) 
      par1=mean(dat,1);
   end;
   if isempty(par2) 
      par2=std(dat,0,1);
   end; 
   
   %irgendwo std= 0? dann par2 = 1 setzen
   ind=(par2 == 0);
   par2(ind)=1;
   
   %dat=(dat-ones(size(dat,1),1)*mean(dat))./(ones(size(dat,1),1)*std(dat));
   dat=(dat-ones(size(dat,1),1)*par1)./(ones(size(dat,1),1)*par2);
end;
if (mode==-1) 
   dat=(dat.*(ones(size(dat,1),1)*par2))+ones(size(dat,1),1)*par1;
end;

if (mode==2) 
   if isempty(par1) 
      par1=min(dat,[],1);
   end; 
   if isempty(par2) 
      par2=max(dat,[],1)-par1;
   end;
   
   %irgendwo keine Unterschiede? dann par2 = 1setzen
   ind=(par1==par2);
   par2(ind)=1;
   
   dat=(dat-ones(size(dat,1),1)*par1)./(ones(size(dat,1),1)*par2);
end;

if (mode==-2) 
   dat=(dat.*(ones(size(dat,1),1)*par2))+ones(size(dat,1),1)*par1;
end;

if (mode==3) 
   if isempty(par1) 
      par1=max(dat,[],1);
   end;
   dat=dat./(ones(size(dat,1),1)*par1);
end;

if (mode==-3) 
   dat=(dat.*(ones(size(dat,1),1)*par1));
end;

if (mode==4) 
   if isempty(par1) 
      par1=dat(1,:);
   end;
   dat=dat./(ones(size(dat,1),1)*par1);
end;

if (mode==-4) 
   dat=(dat.*(ones(size(dat,1),1)*par1));
end;

if (mode==5) 
   if isempty(par1) 
      par1=mean(dat,1);
   end;
   par2 = [];
   dat=(dat-ones(size(dat,1),1)*par1);
end;
if (mode==-5) 
   dat=dat+ones(size(dat,1),1)*par1;
end;
