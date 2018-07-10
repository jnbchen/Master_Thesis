  function [dat_pfad,pfad]=getsubdir(pfad,extension,subdirectories,removepath)
% function [dat_pfad,pfad]=getsubdir(pfad,extension,subdirectories,removepath)
%
% gibt alle Dateien mit Suchmaske extension aus pfad zurück
% subbdirectories==1: zusätzlich alle Unterpfade durchsuchen
% pfad muss (skalarer) String oder cell-Array sein, wenn Pfad eine Date ist, wird die wieder zurückgegeben
%
% The function getsubdir is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<3 
   subdirectories=0;
end;


if nargin<4
   removepath = '';
end;

% Aktuellen Pfad merken und darauf am Ende wieder zurückspringen
akt_pfad = pwd;

if ~iscell(pfad)
   %kein Cell-Array? dann machen wir eins draus!
   if ~isdir(pfad) 
      %Kein Directory? Dann wohl doch eine Datei!
      warning('No path!!!');
      dat_pfad=dir(pfad);
      pfad=fileparts(which(pfad));
      return;
   end;
      pfad={pfad};
end;

%kein End-Bindestrich? Anhängen!
for i=1:length(pfad)
   if ~isempty(pfad{i}) && abs(pfad{i}(end))~=abs('\')
      pfad{i}(end+1)='\';
   end;
end;

%bei Bedarf
if subdirectories 
   pfad=getsubpath(pfad,removepath);
end;   


%Dateien zusammensuchen
dat_pfad=[];

if ~iscell(extension)
   extension_cell{1} = extension;
else
   extension_cell = extension;
end;

for i_path=1:length(pfad)
   if ~isempty(pfad{i_path})
      if isdir(pfad{i_path})
         cd(pfad{i_path});
         temp=[];
         for i_extension = 1:length(extension_cell)
            if strcmp(extension_cell{i_extension},'*.')
               tt = dir(sprintf('%s%s',pfad{i_path},extension_cell{i_extension}));
               for i_tt=1:length(tt)
                  if ~isdir(tt(i_tt).name) 
                     tt(i_tt).name(end+1) = '.';
                  end;                  
               end;               
               temp=[temp;tt];
            else
               temp=[temp;dir(sprintf('%s%s',pfad{i_path},extension_cell{i_extension}))];
            end;            
         end;
         
      else
         temp=dir(pfad{i_path}(1:length(pfad{i_path})-1));
      end;
      for i=1:length(temp) 
         if ~temp(i).isdir 
            try
               if exist([pwd filesep temp(i).name],'file') 
                  dat_pfad(end+1).name=[pwd filesep temp(i).name];
               else
                  dat_pfad(end+1).name=which(temp(i).name);
               end;
            catch
               fprintf('Error in  %s\n',temp(i).name);
            end;            
         end;
      end;   
   end;  
end;

cd(akt_pfad);