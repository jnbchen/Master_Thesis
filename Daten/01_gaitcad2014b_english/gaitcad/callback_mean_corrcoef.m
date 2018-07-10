% Script callback_mean_corrcoef
%
%  Berechnet die paarweisen Korrelationskoeffizienten aller übergebenen
%  Zeitreihen und der übergebenen Datentupel.
%  Dabei wird über die gewählte Klasse oder die gewählten Datentupel gemittelt
%  ind_zr ist für die ausgewählten Zeitreihen.
%
% The script callback_mean_corrcoef is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

ind_zr =  parameter.gui.merkmale_und_klassen.ind_zr;
corr_type = parameter.gui.statistikoptionen.type_liste{parameter.gui.statistikoptionen.corr_type};

names.axis ='Time series (TS)';

% Soll über alle Datentupel gemittelt werden?
if (ds_mitteln)
   [czr, mczr] = corr_zr(d_orgs(ind_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, ind_zr), parameter.gui.zeitreihen.tau,parameter.gui.statistikoptionen);
   
   mccoeff = [];
   mccoeff.czr      = czr;
   mccoeff.mczr(ind_zr,ind_zr) = mczr;
   mccoeff.bez = deblank(var_bez);
   mccoeff.ind_zr = ind_zr;
   mccoeff.tau = parameter.gui.zeitreihen.tau;
   %corr_aut([],var_bez,parameter.gui.statistikoptionen.c_krit,parameter.gui.anzeige.tex_protokoll,parameter.projekt.datei,uihd,zgf_y_bez,ind_zr,0,mczr);
   corr_aut([],var_bez,parameter,uihd,ind_zr,mccoeff.mczr);
   names.title=sprintf('Correlation visualization time series (time shift = %g, %s)',parameter.gui.zeitreihen.tau,corr_type);
   korrmatrix([],[], ind_zr, [],mccoeff.mczr,names,mccoeff.bez); 
   
else % if (ds_mitteln)
   % Sonst suche die verschiedenen Klassen und berechne einzeln für die die Spektogramme:
   klassen = unique(code, 'rows');
   mccoeff = [];
   count = 1;
   for k = 1:length(klassen)
      tmp_auswahl = find(code(ind_auswahl) == klassen(k));
      % Leere Klassen sollen abgefangen werden.
      if (~isempty(tmp_auswahl))
         [czr, mczr] = corr_zr(d_orgs(tmp_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, ind_zr), parameter.gui.zeitreihen.tau,parameter.gui.statistikoptionen);
         
         mccoeff(count).czr  = czr;
         mccoeff(count).mczr(ind_zr,ind_zr) = mczr;
         mccoeff(count).bez  = deblank(var_bez);
         mccoeff(count).bez_code = deblank(bez_code(par.y_choice, :));
         mccoeff(count).zgf_bez  = zgf_y_bez(par.y_choice, k).name;
         mccoeff(count).ind_zr = ind_zr;
         mccoeff(count).parameter.gui.zeitreihen.tau = parameter.gui.zeitreihen.tau;
         %corr_aut([],var_bez,parameter.gui.statistikoptionen.c_krit,parameter.gui.anzeige.tex_protokoll,parameter.projekt.datei,uihd,zgf_y_bez,ind_zr,0,mczr);   
         corr_aut([],var_bez,parameter,uihd,ind_zr,mczr);
         names.title=sprintf('Correlation visualization time series class %s-%s (time shift = %g, %s)',...
             deblank(bez_code(par.y_choice, :)),zgf_y_bez(par.y_choice,klassen(k)).name,parameter.gui.zeitreihen.tau,corr_type);
         korrmatrix([],[], ind_zr, [],mccoeff(count).mczr,names,mccoeff(count).bez);      
         count = count + 1;         
      end; % if (~isempty(tmp_auswahl))
   end; % for(k = 1:length(klassen))
end; % if (ds_mitteln)

fprintf(1, 'Complete!\n');
clear names ind_zr tmp_auswahl corr_type