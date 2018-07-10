% Script saveprj_g
%
% The script saveprj_g is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(next_function_parameter)
    datei_save = next_function_parameter;
    next_function_parameter = '';
end;

if (exist('parameter', 'var') && isfield(parameter,'projekt') && ~isempty(parameter.projekt) && isfield(parameter.projekt,'datei'))
   datei_old=parameter.projekt.datei;
else
   if (exist('datei', 'var'))
      datei_old = datei;
   else
      datei_old = [];
   end;
end;

%possibility for an extern definition of the name of the project file,
%otherwise, the name is determined by a GUI figure
if ~exist('datei_save','var') 
   [datei,pfad]=uiputfile(sprintf('%s.prjz',datei_old),'Save project');
else                
   %wichtig um Makros laden zu können: datei_load kann durch ein anderes Skript übergeben werden!!!
   tmp=which(datei_save);
   
   if isempty(tmp) 
      [pfad,datei,extension] = fileparts(datei_save);
      if isempty(pfad) 
         pfad=pwd;
      end; %if isempty(pfad)
   else  
      [pfad,datei,extension] = fileparts(tmp);     
   end;   %   if isempty(tmp) 
   datei = [datei extension];
   fprintf('File %s saving...\n',datei);
   clear tmp datei_save;
end;%if ~exist('datei_save','var') 


if ischar(datei) && ischar(pfad)
   if exist(pfad,'dir') 
      cd(pfad);
   else
      mkdir_gaitcad(pfad);
      cd(pfad);      
   end;
   fprintf('Save project ...\n')
   %Name ohne Extension
   [muell,datei]=fileparts(datei);
   
   %Datei speichern
   % Parameter-Strukt aktualisieren...
   parameter.projekt.datei = datei;
   % Hier kommt das eigentliche Sichern der Optionen.
   optionen = save_options(parameter.gui.control_elements, -1,plugins);
   % Die projektspezifischen Dinge sichern:
   projekt  = parameter.projekt;
   
   % Noch auf die Existenz der einzelnen Variablen prüfen. Die, die nicht vorhanden sind, werden auf leer gesetzt:
   if(~exist('d_org', 'var'))
      d_org = [];
   end;
   if(~exist('d_orgs', 'var'))
      d_orgs = [];
   end;
   if(~exist('d_image', 'var'))
      d_image = [];
   end;
   if (size(code,1) == 1)
      code = code';
   end;
   if (~exist('code_alle', 'var') || isempty(code_alle))
      if (exist('code', 'var'))
         code_alle = code;
      else
         myerror('No class membership defined! Saving impossible!');
      end;
   end;
   if (~exist('dorgbez', 'var'))
      dorgbez = [];
   end;
   if (~exist('var_bez', 'var'))
      var_bez = [];
   end;
   if (~exist('zgf_y_bez', 'var'))
      zgf_y_bez = [];
   end;
   if (~exist('bez_code', 'var'))
      bez_code = [];
   end;
   [pfad_,datei_,extension_] = fileparts(datei);
   parameter.projekt.pfad = pwd;
   parameter.projekt.datei = datei_;
   
   %zur Sicherheit noch Modus überprüfen, sonst u.U. Probleme in Matlab 5
   callback_savemode;
   
   %eigentliches Speichern
   save([datei '.prjz'], 'd_org', 'd_orgs', 'd_image', 'code_alle', 'dorgbez', 'var_bez', 'zgf_y_bez', 'bez_code', 'projekt',...
      'interpret_merk', 'interpret_merk_rett', 'L','-mat',char(parameter.gui.allgemein.liste_save_mode_matlab_version(parameter.gui.allgemein.save_mode_matlab_version)));
   
   %Speichern der Optionen?
   if (parameter.gui.allgemein.optionen_speichern)
      save([datei '.prjz'],'optionen', '-append','-mat','ind_auswahl',char(parameter.gui.allgemein.liste_save_mode_matlab_version(parameter.gui.allgemein.save_mode_matlab_version)));
   end;
     
   
   set(1,'name',sprintf('%s, Project %s',program_name,datei));
   
   fprintf('...ready\n');
   
   clear pfad_ datei_ extension_;
else 
   %wenn es nicht geklappt hat, alten dateinamen wieder zuweisen
   fprintf('Project not saved!\n');   
   datei=datei_old;
end;


