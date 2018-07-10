% Script mfile_ausfuehren
%
% The script mfile_ausfuehren is part of the MATLAB toolbox Gait-CAD. 
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

org_path=pwd;
if exist('next_function_parameter','var')
   mfile_datei=next_function_parameter;
else
   mfile_datei=[];
end;

next_function_parameter = [];

%Datei laden, wenn es noch keine gibt
if isempty(mfile_datei)
   [mfile_datei,pfad]=uigetfile('*.m','Load M-file');
   if (mfile_datei==0)
      mfile_datei=[];
   end;
   if (pfad ~= 0)
      mfile_datei = [pfad filesep mfile_datei];
   end;
end;

[pfad,mfile_datei,temp] = fileparts(mfile_datei);
if ~isempty(pfad)
   cd(pfad);
end;

%Datei in makro_tmp_ausfuehren.m umbenennen und ausführen
if ~isempty(mfile_datei)
   
   %um abzufangen, dass die Datei irgendwo rumhängt...
   if ~exist(mfile_datei,'file')
      myerror('M-file not found! M-File must be located in the recent search path!');
   end;
   
   %Execute m file
   eval(mfile_datei);
   
   
   % Trage das Makro in die Liste der Favoriten ein.
   if exist('mfile_datei','var') && ~isempty(mfile_datei)
      param = parameter.gui.menu.favoriten.param;
      param.name_eintrag = sprintf('M-file: %s', [mfile_datei '.m']);
      parameter.gui.menu.favoriten = aktualisiere_favoriten(parameter.gui.menu.favoriten, ...
         sprintf('next_function_parameter=''%s''; mfile_ausfuehren;', [pwd filesep mfile_datei '.m']), ...
         parameter, 'ADD USERCALLBACK', param);
      callback_update_favoriten;
      
      %Original-Pfad wiederherstellen
      cd(org_path);
      clear org_path;
   end;
   
   mfile_datei = [];
   
   
end;

