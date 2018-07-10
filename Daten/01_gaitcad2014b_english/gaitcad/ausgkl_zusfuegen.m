  function   [code_alle, zgf_y_bez, bez_code]=ausgkl_zusfuegen(par, ind_auswahl, code_alle, zgf_y_bez, bez_code)
% function   [code_alle, zgf_y_bez, bez_code]=ausgkl_zusfuegen(par, ind_auswahl, code_alle, zgf_y_bez, bez_code)
%
% generiert neue Ausgangsklasse (mit nur 2 Klassen), die aktuell gewählte Ausgangsklasse dient nur
% der Namensgebung der neuen Ausgangsklasse.
% Bei der neuen Ausgangsklasse sind alle ausgewählten Daten in der 1. Klasse, alle anderen in der 2. Klasse
% 
% z.B. Datenauswahl PRE+unbekannt, mittel+langsam+schnell, Ausgangsklasse= Geschw.
%
% The function ausgkl_zusfuegen is part of the MATLAB toolbox Gait-CAD. 
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

[ind_rest,ind]=ausgkl_zusfuegen_indrest(code_alle,ind_auswahl,par);

if isempty(ind_rest) 
   myerror('All data points selected -> invalid class distribution!');
end;

code_alle=[code_alle 2*ones(size(code_alle,1),1)];
code_alle(ind_auswahl,size(code_alle,2))=1;
bez_code=char(bez_code,sprintf('%s (OR)',deblank(bez_code(par.y_choice,:))));

tmp=sprintf('%s, ',zgf_y_bez(par.y_choice,ind).name);tmp(length(tmp)-1:length(tmp))=[];
zgf_y_bez(size(code_alle,2),1).name=tmp;

tmp=sprintf('%s, ',zgf_y_bez(par.y_choice,ind_rest).name);tmp(length(tmp)-1:length(tmp))=[];
zgf_y_bez(size(code_alle,2),2).name=sprintf('Rest: %s',tmp);
