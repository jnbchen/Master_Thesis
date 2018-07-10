  function pfad=getsubpath(pfad,removepath)
% function pfad=getsubpath(pfad,removepath)
%
% sucht eine List von Unterverzeichnissen für einen Pfad pfad
%
% The function getsubpath is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<2
   removepath = '';
end;

if ~iscell(pfad)
   pfad={pfad};
end;

for j=1:length(pfad)
   if ~isempty(pfad{j}) && abs(pfad{j}(end))~=abs(filesep)
      pfad{j}(end+1)=filesep;
   end;
   temp=dir(pfad{j});
   
   ind=find(ismember({temp.name},'.'));
   if ~isempty(ind)
      temp(ind)=[];
   end;
   
   ind=find(ismember({temp.name},'..'));
   if ~isempty(ind)
      temp(ind)=[];
   end;
   
   for i=1:length(temp)
      if temp(i).isdir
         if isempty(find(ismember(pfad,sprintf('%s%s%s',pfad{j},temp(i).name,filesep))))
            temppfad=sprintf('%s%s%s',pfad{j},temp(i).name,filesep);
            if isempty(getfindstr(removepath,temppfad))
               temppfad=getsubpath(temppfad,removepath);
               for k=1:length(temppfad)
                  pfad{end+1}=temppfad{k};                  
               end;
            end;
         end;
      end;
   end;
end;



