  function zgf_bez=zgfname(zgf,par,zgf_bez_old) 
% function zgf_bez=zgfname(zgf,par,zgf_bez_old) 
%
% vergibt Zugehörigkeitsfunktionen automatisch Namen
% Zugriff über zgf_bez(i,j).name für den Namen der j-ten ZGF
% der i-ten Variablen
% 
%
% The function zgfname is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<3 
   zgf_bez_old=[];
end;

[tmp,ind]=max(zgf');

for i=1:size(zgf,1) 
   
   %Ausgangsgröße: wenn alle Null oder von 1-Klasse, dann Klassenbezeichnung
   if (i==par(2)+1) 
      %Rückweisung
      zgf_bez(par(2)+1,par(4)+1).name='REJ';
      %Standard-Term-Namen, wenn alle zgf=0 oder von 1 bis par(4)
      %sonst gleiche Namenskonventionen wie bei Eingangsgrößen
      if min(zgf(i,:)==0) || ((zgf(i,1)==1) && min(diff(zgf(i,1:par(4)))==1)) 
         for j=1:par(4) 
            zgf_bez(i,j).name=sprintf('%d',j);
         end;
         break;
      end;   
   end;
   
   %nicht belegte ZGFs - müssen alle Null sein!:  
   if min(zgf(i,:)==0)
      for j=1:par(4+i) 
         zgf_bez(i,j).name=sprintf('A%d%d',i,j);
      end;
      
   else %Nicht Null!!
      
      %Position der Null suchen
      ind_null=find(~zgf(i,1:ind(i)));
      if ~isempty(ind_null) 
         zgf_bez(i,ind_null(1)).name='ZE';
      end;
      
      %Position der positiven Werte suchen
      ind_pos=find(zgf(i,1:ind(i))>0);
      if length(ind_pos)==1 
         zgf_bez(i,ind_pos).name='POS';
      end;
      if length(ind_pos)==2 
         zgf_bez(i,ind_pos(1)).name='PS';
         zgf_bez(i,ind_pos(2)).name='PB';
      end;
      if length(ind_pos)==3 
         zgf_bez(i,ind_pos(1)).name='PS';
         zgf_bez(i,ind_pos(2)).name='PM';
         zgf_bez(i,ind_pos(3)).name='PB';
      end;
      if length(ind_pos)==4 
         zgf_bez(i,ind_pos(1)).name='PS';
         zgf_bez(i,ind_pos(2)).name='PM';
         zgf_bez(i,ind_pos(3)).name='PB';
         zgf_bez(i,ind_pos(4)).name='PVB';
      end;
      if length(ind_pos)==5 
         zgf_bez(i,ind_pos(1)).name='PVS';
         zgf_bez(i,ind_pos(2)).name='PS';
         zgf_bez(i,ind_pos(3)).name='PM';
         zgf_bez(i,ind_pos(4)).name='PB';
         zgf_bez(i,ind_pos(5)).name='PVB';
      end;
      if length(ind_pos)==6 
         zgf_bez(i,ind_pos(1)).name='PVS';
         zgf_bez(i,ind_pos(2)).name='PS';
         zgf_bez(i,ind_pos(3)).name='PMS';
         zgf_bez(i,ind_pos(4)).name='PMB';
         zgf_bez(i,ind_pos(5)).name='PB';
         zgf_bez(i,ind_pos(6)).name='PVB';
      end;
      if length(ind_pos)==7 
         zgf_bez(i,ind_pos(1)).name='PES';
         zgf_bez(i,ind_pos(2)).name='PVS';
         zgf_bez(i,ind_pos(3)).name='PS';
         zgf_bez(i,ind_pos(4)).name='PM';
         zgf_bez(i,ind_pos(5)).name='PB';
         zgf_bez(i,ind_pos(6)).name='PVB';
         zgf_bez(i,ind_pos(7)).name='PEB';
      end;
      
      %bei mehr Termen Terme einfach durchnummerieren
      if length(ind_pos)>7  
         for j=1:length(ind_pos) 
            zgf_bez(i,j).name=sprintf('P%d',j);
         end;
      end;
      
      %Position der positiven Werte suchen
      ind_neg=find(zgf(i,1:ind(i))<0);
      if length(ind_neg)==1 
         zgf_bez(i,ind_neg).name='NEG';
      end;
      if length(ind_neg)==2 
         zgf_bez(i,ind_neg(1)).name='NG';
         zgf_bez(i,ind_neg(2)).name='NK';
      end;
      if length(ind_neg)==3 
         zgf_bez(i,ind_neg(1)).name='NG';
         zgf_bez(i,ind_neg(2)).name='NM';
         zgf_bez(i,ind_neg(3)).name='NK';
      end;
      if length(ind_neg)==4 
         zgf_bez(i,ind_neg(1)).name='NVB';
         zgf_bez(i,ind_neg(2)).name='NG';
         zgf_bez(i,ind_neg(3)).name='NM';
         zgf_bez(i,ind_neg(4)).name='NK';
      end;  
      if length(ind_neg)==5 
         zgf_bez(i,ind_neg(1)).name='NVB';
         zgf_bez(i,ind_neg(2)).name='NG';
         zgf_bez(i,ind_neg(3)).name='NM';
         zgf_bez(i,ind_neg(4)).name='NK';
         zgf_bez(i,ind_neg(5)).name='NVS';
      end;
      if length(ind_neg)==6 
         zgf_bez(i,ind_neg(1)).name='NVB';
         zgf_bez(i,ind_neg(2)).name='NG';
         zgf_bez(i,ind_neg(3)).name='NMB';
         zgf_bez(i,ind_neg(4)).name='NMS';
         zgf_bez(i,ind_neg(5)).name='NK';
         zgf_bez(i,ind_neg(6)).name='NVS';
      end;
      if length(ind_neg)==7 
         zgf_bez(i,ind_neg(1)).name='NEG';
         zgf_bez(i,ind_neg(2)).name='NVB';
         zgf_bez(i,ind_neg(3)).name='NG';
         zgf_bez(i,ind_neg(4)).name='NM';
         zgf_bez(i,ind_neg(5)).name='NK';
         zgf_bez(i,ind_neg(6)).name='NVS';
         zgf_bez(i,ind_neg(7)).name='NEK';
      end;
      
      if length(ind_neg)>7  
         for j=1:length(ind_neg) 
            zgf_bez(i,j).name=sprintf('N%d',j);
         end;
      end;
   end; %Nicht Null
end; 

%wenn ZGF-Bezeichnungen übergeben werden, werden die Originalbezeichnungen der Ausgangs-
%Klasse wieder in den automatischen Vektor reingeschrieben
if ~isempty(zgf_bez_old) 
   for i=1:par(4) 
      zgf_bez(par(2)+1,i).name=zgf_bez_old(par(2)+1,i).name;
   end;
end;
