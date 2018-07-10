% Script callback_klassifikator_laden
%
% Klassifikator laden
%
% The script callback_klassifikator_laden is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(next_function_parameter)
    datei_load_klass_single = next_function_parameter;
end;
if ~exist('datei_load_klass_single','var')
   datei_load_klass_single = [];
end;

klass_single=load_gaitcad_struct(parameter,dorgbez,par,'Load classifier','klass_single',datei_load_klass_single);

clear datei_load_klass_single klass_single_save;

if ~isempty(klass_single)
   %für die Anwendung auf den betroffenen Klassifikator umschalten
   parameter.gui.klassifikation.klassifikator=klass_single(1).entworfener_klassifikator.nummer;
   parameter.gui.klassifikation.mehrklassen  =klass_single(1).entworfener_klassifikator.mehrklassen;
   
   % try to select output variable (for visualization only)
   if ~isempty(getfindstr(bez_code,klass_single(1).klasse.bez,1)) 
       klass_single_save = klass_single;
       set_textauswahl_listbox(gaitfindobj('CE_Auswahl_Ausgangsgroesse'),{klass_single(1).klasse.bez});eval(gaitfindobj_callback('CE_Auswahl_Ausgangsgroesse'));       
   else
       %class does not exist, append!
       newcode     = (length(klass_single(1).klasse.zgf_bez)+1)*ones(par.anz_dat,1);
       newtermname = klass_single(1).klasse.zgf_bez;
       klass_single_save = klass_single;
       newtermname(1,end+1).name = 'unknown';
       [code_alle,zgf_y_bez,bez_code,L] = new_output(code_alle,zgf_y_bez,bez_code,L,newcode,klass_single(1).klasse.bez,newtermname);
       aktparawin;
       set_textauswahl_listbox(gaitfindobj('CE_Auswahl_Ausgangsgroesse'),{klass_single(1).klasse.bez});eval(gaitfindobj_callback('CE_Auswahl_Ausgangsgroesse'));       
   end;
   
   %in GUI eintragen
   inGUI;
end;

aktparawin;

%avoid a deletion by a switching of output variables - the classifier in
%klass_single_save will match the result
if exist('klass_single_save','var') && strcmp(klass_single_save(1).klasse.bez,deblank(bez_code(parameter.gui.merkmale_und_klassen.ausgangsgroesse,:)))
   klass_single = klass_single_save;
   clear klass_single_save;
end;