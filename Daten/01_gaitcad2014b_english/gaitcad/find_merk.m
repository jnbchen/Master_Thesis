  function merk=find_merk(name,var_bez,genauigkeit,lr)
% function merk=find_merk(name,var_bez,genauigkeit,lr)
%
%  wenn genauigkeit=1 (default)
%       gibt Nummer des 1. Merkmals mit EXAKTER Übereinstimmung in var_bez mit name zurück,
%       und Null, wenn kein Merkmal gefunden wird
% 
%  wenn genauigkeit=2
%       gibt Nummern aller Merkmale zurück bei denen 'name' in 'var_bez' vorkommt
%  wenn lr=1 , wird genau nach der anderen Körperseite gesucht (default lr=0)
% 
%
% The function find_merk is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<3)
   genauigkeit=1;
end;
if (nargin<4)
   lr=0;
end;

if (lr)
   indl=strfind(name,'L-'); % name kann nur eine Zeile sein (und nicht string-Matrix)
   indr=strfind(name,'R-');
   indl_neu=strfind(name,'[Left');
   indr_neu=strfind(name,'[Right');
   indl_meanneu=strfind(name,'[MeanLeft');
   indr_meanneu=strfind(name,'[MeanRight');
   
   if (~isempty(indl))
      name(indl)='R';
   end;
   
   if (~isempty(indl_neu))
      if indl_neu==1 % wenn [Left ganz links am Anfang steht
         name=sprintf('[Right%s',name(indl_neu+5:length(name)));
      else % wenn [Left wo anders steht
         name=sprintf('%s[Right%s',name(1:indl_neu-1),name(indl_neu+5:length(name)));
      end;
   end;
   
   if (~isempty(indl_meanneu))
      if indl_meanneu==1 % wenn [MeanLeft ganz links am Anfang steht
         name=sprintf('[MeanRight%s',name(indl_meanneu+9:length(name)));
      else % wenn [MeanLeft wo anders steht
         name=sprintf('%s[MeanRight%s',name(1:indl_meanneu-1),name(indl_meanneu+9:length(name)));
      end;
   end;
   
   
   if (~isempty(indr))
      name(indr)='L';
   end;
   
   if (~isempty(indr_neu))
      if indr_neu==1 % wenn [Right ganz links am Anfang steht
         name=sprintf('[Left%s',name(indr_neu+6:length(name)));
      else % wenn [Right wo anders steht
         name=sprintf('%s[Left%s',name(1:indr_neu-1),name(indr_neu+6:length(name)));
      end;
   end;
   
   if (~isempty(indr_meanneu))
      if indr_meanneu==1 % wenn [Right ganz links am Anfang steht
         name=sprintf('[MeanLeft%s',name(indr_meanneu+10:length(name)));
      else % wenn [Right wo anders steht
         name=sprintf('%s[MeanLeft%s',name(1:indr_meanneu-1),name(indr_meanneu+10:length(name)));
      end;
   end;
   
end; %if lr


merk=0;
name=kill_lz(name);

if isstruct(var_bez)
   for i=1:length(var_bez)
      if (genauigkeit==1)
         if strcmp (name,var_bez(i).struct)
            merk=i;
            break;
         end;
      end;
      if (genauigkeit==2)
         if ~isempty(strfind(name,var_bez(i).struct))
            merk=[merk i];
         end;
      end;
   end;
else
   for i=1:size(var_bez,1)
      if (genauigkeit==1)
         if strcmp (name,deblank(var_bez(i,:)))
            merk=i;
            break;
         end;
      end;
      if (genauigkeit==2)
         if ~isempty(strfind(name,deblank(var_bez(i,:))))
            merk=[merk i];
         end;
      end;
   end;
end;

%Bei bedarf Null löschen
if (length(merk)>1)
   merk(1)=[];
end;


