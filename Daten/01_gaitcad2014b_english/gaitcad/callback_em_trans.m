% Script callback_em_trans
%
% fügt neue Ausgangsklasse hinzu anhand ausgewählter EM
%
% The script callback_em_trans is part of the MATLAB toolbox Gait-CAD. 
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

parameter_regelsuche            = parameter.gui.klassifikation.fuzzy_system;
%number of terms for the output variable
parameter_regelsuche.anz_fuzzy  = parameter.gui.merkmale_und_klassen.anz_em_klasse;

%gehe durch alle ausgewählten EM's einzeln
for ind=parameter.gui.merkmale_und_klassen.ind_em 
   
   ind_isnan  = isnan(d_org(:,ind));
   temp = d_org(ind_auswahl,ind);
   temp = temp(~isnan(temp));
         
   if parameter.gui.merkmale_und_klassen.alle_werte == 0
      zgf_tmp=zgf_en(temp,parameter_regelsuche);
      ca_name = 'ca. ';
      %qualitative Werte raussuchen (Klassen-Nummern!)
      [tmp,newcode]=fuzz(d_org(:,ind),zgf_tmp); 
   
   else
      %problems by NaNs
      [zgf_tmp,a,newcode]=unique(temp);
      ca_name = '';
      zgf_tmp = zgf_tmp';
      [tmp,newcode]=fuzz(d_org(:,ind),zgf_tmp); 
   end;
   
   newtermname=[];
   for i=1:length(zgf_tmp) 
      newtermname(i).name=kill_lz(sprintf('%s: %s%g',dorgbez(ind,:),ca_name,zgf_tmp(i))); 
   end;
   
   if ~isempty(ind_isnan)
      newcode(ind_isnan) = length(zgf_tmp) +1;
      newtermname(length(zgf_tmp) +1).name = 'NaN';
   end;
   
   [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,dorgbez(ind,:),newtermname);
end;
clear newtermname ind newcode zgf_temp parameter_regelsuche temp par_kafka ca_name
aktparawin;
