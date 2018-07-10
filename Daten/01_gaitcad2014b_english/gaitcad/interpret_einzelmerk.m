  function interpret_merk=interpret_einzelmerk(zgf_em_bez,code_em,parameter_kategorien)
% function interpret_merk=interpret_einzelmerk(zgf_em_bez,code_em,parameter_kategorien)
%
% weist allen Merkmalen explizierte Interpretierbarkeiten interpret_merk zu und verwendet dabei
% die Kategorien in code_em (Merkmalscodes) und deren Bezeichner zgf_em_bez
% 
% spezieller KAFKA-Aufruf
% par1.anz_y=1;par1.anz_ling_y=par(4);[code_em, zgf_em_bez]=kat_ber(var_bez(1:par(2),:),zgf_y_bez,par1,bez_code,0) ;
% interpret_merk=interpret_einzelmerk(zgf_em_bez,code_em)
%
% The function interpret_einzelmerk is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

relevance_kat=ones(size(zgf_em_bez,1),size(zgf_em_bez,2),zgf_em_bez(1,1).maxrel);

for i=1:size(zgf_em_bez,1)
    for j=1:size(zgf_em_bez,2)
        if ~isempty(zgf_em_bez(i,j).relevance)
            relevance_kat(i,j,1:length(zgf_em_bez(i,j).relevance))=zgf_em_bez(i,j).relevance;
        end;
    end;
end;

%Gesamt-Interpretierbarkeiten berechnen:
%zunächst Interpretierbarkeits-Einzelwerte fuer Merkmale in code_em raussuchen
for i=1:size(code_em,2) 
   interpret_merk_all(:,i,:)=relevance_kat(i,code_em(:,i),:);
end;
%Produkt bilden als Zusammenfassung
interpret_merk=squeeze(prod(interpret_merk_all,2));

