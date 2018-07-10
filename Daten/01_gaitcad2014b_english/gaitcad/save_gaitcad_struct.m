  function save_gaitcad_struct(gaitcad_struct,parameter,merkmale_projekt,erklaerungsstring,mode, datei) 
% function save_gaitcad_struct(gaitcad_struct,parameter,merkmale_projekt,erklaerungsstring,mode, datei) 
%
% 
% speichert mehr oder weniger
% 
% Speichern
%
% The function save_gaitcad_struct is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<6)
   datei = '';
end;


if isempty(gaitcad_struct)
   mywarning(sprintf('An empty struct %s can not be saved!',mode));
   return;
end;

%automatic definition of file names for saved files
if ~isempty(datei) && strcmp(datei,'auto_name')
   datei = '';
   auto_name_mode = 1;
else
   auto_name_mode = 0;
end;


if isempty(datei)
   [muell,datei]=fileparts(parameter.projekt.datei);
   
   switch mode
   case 'fuzzy_system'
      datei=strcat(datei,sprintf('_%s_%d_rules',deblank(gaitcad_struct.dorgbez_rule(end,:)),size(gaitcad_struct.rulebase,1)));
      extension='.fuzzy';
   case 'klass_single'
      extension='.class';   
      datei=strcat(datei,sprintf('_%s_%s',deblank(gaitcad_struct(1).klasse.bez),gaitcad_struct(1).entworfener_klassifikator.typ));
   case 'regr_single'
      extension='.regression';
      datei=strcat(datei,sprintf('_%s_%s',deblank(gaitcad_struct.designed_regression.output_name),gaitcad_struct.designed_regression.type));
   case 'plugin_sequence'
     extension='.plugseq';
     datei=strcat(datei,sprintf('_%d_operations',length(gaitcad_struct.plugins)));
   end;
   
   if auto_name_mode == 0
      %Dateinamen festlegen
   [datei,pfad]=uiputfile([datei extension],erklaerungsstring);
   else
      pfad = pwd;
   end;
   
else                
   tmp=which(datei);
   
   if isempty(tmp) 
      [pfad,datei,extension] = fileparts(datei);
      if isempty(pfad) 
         pfad=pwd;
      end; %if isempty(pfad)
   else  
      [pfad,datei,extension] = fileparts(tmp);
   end;   %   if isempty(tmp)
end;

if datei 
   cd(pfad);
   %Speichern
   [muell,datei]=fileparts(datei);
   
   %Merkmale besser als Cellstring abspeichern
   merkmale_projekt=cellstr(merkmale_projekt);
   
   %Datei speichern
   save([repair_dosname(datei) extension],'gaitcad_struct','merkmale_projekt','mode',...
      '-mat',char(parameter.gui.allgemein.liste_save_mode_matlab_version(parameter.gui.allgemein.save_mode_matlab_version)));
end;


   
   


