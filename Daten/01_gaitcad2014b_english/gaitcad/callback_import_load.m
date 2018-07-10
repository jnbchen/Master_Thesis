% Script callback_import_load
%
% The script callback_import_load is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

set(gcf,'Pointer','watch');
drawnow;

if (~exist('button', 'var'))
   button = 0;
end;
if (~button)
   fprintf(1, 'Canceled by the user\n');
else
   % Bereite die Optionen vor.
   quelle = get(import_gui.ce(1).h, 'String');
   trennzeichen = strvcatnew(' ', '_', '-', sprintf('\t'), ';', ',');
   trennzeichen_d = strvcatnew(' ', '_', '-', ';', ',');
   
   indx = get(import_gui.ce(3).h, 'value');
   if (indx > 1)
      optionen.klassentrennzeichen.ordner = trennzeichen(indx-1);
   end;
   indx = get(import_gui.ce(4).h, 'value');
   if (indx > 1)
      optionen.klassentrennzeichen.datei = trennzeichen(indx-1);
   end;
   if (get(import_gui.ce(5).h, 'value') == 1)
      optionen.dezimaltrennzeichen = '.';
   else
      optionen.dezimaltrennzeichen = ',';
   end;
   indx = get(import_gui.ce(6).h, 'value');
   optionen.spaltentrennzeichen = trennzeichen(indx);
   
   if (optionen.spaltentrennzeichen == optionen.dezimaltrennzeichen)
      myerror('Error! Separators for columns and decimal points are identical.');
      return;
   end;
   
   optionen.inhalt = get(import_gui.ce(10).h, 'value');
   optionen.firstline_bez = get(import_gui.ce(7).h, 'value');
   optionen.ordner_rekursiv = get(import_gui.ce(2).h, 'value');
   if (modus == 2)
      optionen.separate_projects = get(import_gui.ce(16).h, 'value');
   else
      optionen.separate_projects = 0;
   end;
   if (modus == 2)
      optionen.dateiendung = get(import_gui.ce(13).h, 'String');
      % Bei der Dateiendung muss ein Punkt vorne sein.
      if isempty(strfind(optionen.dateiendung,'.'))
         optionen.dateiendung = ['.' optionen.dateiendung];
      end;
   end;
   indx = get(import_gui.ce(14).h, 'value');
   switch(indx)
      case 1
         optionen.gleiche_laenge = 'resampling';
      case 2
         optionen.gleiche_laenge = 'zeros';
      case 3
         optionen.gleiche_laenge = 'last_value';
      case 4
         optionen.gleiche_laenge = 'nan';
   end;
   indx = get(import_gui.ce(15).h, 'value');
   switch indx
      case 1
         optionen.importfct = 'fgetl';
      case 2
         optionen.importfct = 'rewrite';
      case 3
         optionen.importfct = 'turbo';
      case 4
         optionen.importfct = 'ascii';
      case 5
         optionen.importfct = 'getdata';
      case 6
         optionen.importfct = 'importdata';
         
         %ERRORHANDLING
   end;
   str = get(import_gui.ce(9).h, 'String');
   val = str2num(str);
   if (~isempty(val))
      optionen.ignore_firstlines = val-1;
   end;
   str = get(import_gui.ce(8).h, 'String');
   if (~isempty(str))
      optionen.ignoriere_zeilen_mit = str(1);
   end;
   
   %Ignore GUI warnings if 1 (useful for loading files from macros)
   optionen.ignore_warnings = parameter.gui.import.ignore_warnings;
   
   % Und lese die Daten ein.
   [d_orgs, bez, ausgangsgroessen] = importiere_daten(quelle, optionen);
   
   if ~isempty(d_orgs)
      inh_zr = (optionen.inhalt == 1);
      % Bereite die Daten für das Speichern vor.
      % Lösche die alten Daten:
      clear d_org code bez_code zgf_y_bez code_alle dorgbez var_bez optionen;
      % Es werden Zeitreihen importiert
      if (inh_zr)
         % Beim Importieren einer einzelnen Datei ist die dritte Dimension 1. Das versteht d_orgs aber nicht:
         if (modus == 1)
            tmp = zeros(1, size(d_orgs,1), size(d_orgs,2));
            tmp(1, :, :) = d_orgs;
            d_orgs = tmp;
            clear tmp;
         end;
         var_bez = bez;
         d_org = [];
         dorgbez = [];
      else
         % Es werden Einzelmerkmale importiert
         if (size(d_orgs,3) ~= 1)
            if isempty(ausgangsgroessen)
               myerror('Import error. The data seems to contain time series instead of single features.');
            else
               %Einzelmerkmale aus mehreren Dateien importieren
               temp_code=size(d_orgs,3);
               %Ausgangsgrößen retten durch dranhängen
               for i1=1:size(ausgangsgroessen.code,1)
                  for i2 = 1:size(ausgangsgroessen.code,2)
                     d_orgs(i1,:,temp_code + i2) = ausgangsgroessen.code(i1,i2);
                  end;
               end;
               %Datentupel umsortieren
               d_orgs = reshape(d_orgs,size(d_orgs,1) * size(d_orgs,2),size(d_orgs,3));
               %Ausgangsgrößen rekonstruieren
               ausgangsgroessen.code = d_orgs(:,end+[-size(ausgangsgroessen.code,2)+1:0]);
               %wieder von den Daten abhängen
               d_orgs(:,end+[-size(ausgangsgroessen.code,2)+1:0]) =[];
            end;
         end;
         d_org = d_orgs;
         d_orgs = [];
         dorgbez = bez;
         var_bez = [];
      end;
      bez_code ='';
      if ~isempty(ausgangsgroessen)
         code_alle = ausgangsgroessen.code;
         zgf_y_bez = ausgangsgroessen.zgf_y_bez;
         if isfield(ausgangsgroessen,'bez_code')
            bez_code  = ausgangsgroessen.bez_code;
         else
            bez_code ='';
         end;
         
         code = code_alle(:,1);
      else
         code = ones(max(size(d_orgs,1), size(d_org,1)), 1);
         code_alle = code;
         zgf_y_bez(1,1).name = '1';
      end;
      % Bezeichner der Klassen einführen
      if isempty(bez_code)
         bez_code = [abs('y')*ones(size(code_alle,2),1) num2str([1:size(code_alle,2)]')];
      end;
      
      
      %no images ...
      d_image.data = zeros(size(code_alle,1),0);
      d_image.names = '';
      d_image.filelist= {};
      
      % Projekt speichern. Dabei sicherstellen, dass datei_save nicht existiert. Die Variable würde den Dateinamen vorgeben
      clear datei_save;
      if (exist('datei', 'var') && ~isempty(datei) && ~all(datei == 0) && ~strcmp(parameter.projekt.datei,datei))
         [path, name, ext] = fileparts(datei);
      else
         [path, name, ext] = fileparts(quelle);
      end;
      if ~isempty(path)
         datei = [path filesep name];
      else
         datei = name;         
      end;
      clear path name ext;
      
      parameter.projekt.datei=datei;
      
      if parameter.gui.import.auto_save_file == 1
         datei_save =  [parameter.projekt.datei '.prjz'];
      end;
      
      saveprj_g;
      
      % Etwas aufräumen...
      try
         delete(import_gui.h);
      end;
      
      
      % Und das neue Projekt laden
      datei_load = [datei '.prjz'];
      
      clear x_size y_size screensize x_pos y_pos import_gui pfad button str val indx modus datei;
      ldprj_g;
   end;
end;

try
   delete(import_gui.h);
end;

clear x_size y_size screensize x_pos y_pos import_gui pfad button str val indx modus;