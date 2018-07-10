% Script callback_klasse2em
%
% 
% 
%
% The script callback_klasse2em is part of the MATLAB toolbox Gait-CAD. 
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

ind_klasse = parameter.gui.merkmale_und_klassen.ausgangsgroesse;
name_output_variable = sprintf('Estimation %s',deblank(bez_code(ind_klasse,:))');

%Klasse -> Einzelmerkmal
if mode==1
   d_org = [d_org code_alle(:, ind_klasse)];
   dorgbez = strvcatnew(dorgbez(1:par.anz_einzel_merk,:), deblank(bez_code(ind_klasse,:)));
end;

%Geschätzte Klasse -> Einzelmerkmal
if mode==2 && ~isempty(pos)
   d_org = [d_org pos];
   dorgbez = strvcatnew(dorgbez(1:par.anz_einzel_merk,:),name_output_variable );
end;

%Geschätzte Klasse -> Ausgangsgröße
if mode==3 && ~isempty(pos)
   
   newterm = zgf_y_bez(par.y_choice,1:par.anz_ling_y(par.y_choice));
   
   %some estimations are zero - it will be handled as new unkon class
   newterm(end+1).name = 'unknown';
   newcode = pos;
   newcode (find(newcode == 0)) = length(newterm);
   
   %assign new class
   [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,name_output_variable,newterm);
end;

%Klasse -> Einzelmerkmal (Zahl)
if mode==4
   %Initialisieren, unbekannte Werte sind Null
   newnumber = zeros(par.anz_dat,1);
   
   for i_code=generate_rowvector(unique(code))
      %Zahlen aus Termen extrahieren
      mynumber = extract_number_from_text(zgf_y_bez(par.y_choice,i_code).name);
      if length(mynumber) == 1
         newnumber (code == i_code) = mynumber;
      else
         fehlermeldung = ['The output variable cannot be converted to numbers for a single feature. ' sprintf('%d numbers in %s, necessary: exactly one number',length(mynumber),zgf_y_bez(par.y_choice,i_code).name)];
         myerror(fehlermeldung);
      end;
   end;
   
   %neues Einzelmerkmal anhängen
   d_org = [d_org newnumber];
   dorgbez = strvcatnew(dorgbez(1:par.anz_einzel_merk,:), deblank(bez_code(ind_klasse,:)));
   clear newnumber;
end;

%Geschätzte Klasse -> Einzelmerkmal
if mode==5 && ~isempty(prz)
   d_org = [d_org prz];
   newdorgbeznames ='';
   for i_term=1:size(prz,2)
      newdorgbeznames = strvcatnew(newdorgbeznames,sprintf('%s (percental, %s)',name_output_variable,kill_lz(zgf_y_bez(par.y_choice,i_term).name)));
   end;
   dorgbez = strvcatnew(dorgbez(1:par.anz_einzel_merk,:),newdorgbeznames);
end;

clear ind_klasse mode name_output_variable i_term newdorgbeznames;
aktparawin;