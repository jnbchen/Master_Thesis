% Script makro_ausfuehren_mfile
%
% The script makro_ausfuehren_mfile is part of the MATLAB toolbox Gait-CAD. 
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
extension='*.makrog';

%set debuig modus
dbstop if error;

%delete macroo files performed as m file
if exist('makro_m_file.m','file') && exist('makro_datei','var') && ~isempty(makro_datei)
   button_name = questdlg(sprintf('Should the existing file makro_m_file.m be saved as %s to confirm changes?',makro_datei),'Question','Yes','No','Yes');
   
   if strcmp(button_name,'Yes')
      copyfile('makro_m_file.m',makro_datei);
      pfad = pwd;
   else
      [makro_datei,pfad]=uigetfile(extension,'Load macro');
      if (makro_datei==0)
         makro_datei=[];
      end;      
   end;
else
   [makro_datei,pfad]=uigetfile(extension,'Load macro');
   if (makro_datei==0)
      makro_datei=[];
   end;
end;



if (pfad ~= 0)
   cd(pfad);
   
   
   %Datei erzeugen und ausführen
   if ~isempty(makro_datei)
      
      %um abzufangen, dass die Datei irgendwo rumhängt...
      clear functions;
      if exist(makro_datei,'file')
         full_path_makro=which(makro_datei);
      else
         full_path_makro='';
      end;
      
      if isempty(full_path_makro)
         myerror('Macro not found!The macro must be located anywhere in the current MATLAB path!');
      end;
      
      %Original-Pfad wiederherstellen
      cd(org_path);
      clear org_path;
      %max Filenamenlänge 30 - also abschneiden!
      makro_m_datei='makro_m_file';
      %makro als *.m Datei kopieren
      % Verwende statt dem !copy-Befehl den Matlab-Internen Befehl copyfile.
      % Der hat weniger Probleme mit Leerzeichen im Dateinamen.
      copy_s = copyfile(full_path_makro, [makro_m_datei '.m']);
      if (~copy_s)
         makro_datei = [];
         
         %be careful and reset the selection fields - a very typical error for
         %macros - it avoids problems for further selections
         auswahl.dat = [];
         auswahl.gen = [];
         
         myerror(['Error during macro execution! The generation of the m-files was not successful.']);
         return;
      end;
      
      makro_m_file;
   end;
end;

%delete macroo files performed as m file
if exist('makro_m_file.m','file')
   delete('makro_m_file.m');
end;
