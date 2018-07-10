  function ind_katem=kat_auswahl(zgf_em_bez, code_em)
% function ind_katem=kat_auswahl(zgf_em_bez, code_em)
%
%  erstellt Auswahl Vektor analog zum ind_auswahl, allerdings für Kategorie
%  zgf_em_bez ist ein struct, in dem das Feld zgf_em_bez( 1:anz_kat , 1 ).auswahl
%  existieren muss, anz_kat ist Anzahl Kategorien, z.B. 7
%
% The function kat_auswahl is part of the MATLAB toolbox Gait-CAD. 
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

anz_kat=size(zgf_em_bez,1);
ind_katem=ones(size(code_em,1),1);

for i=1:anz_kat
   ausw=zgf_em_bez(i,1).auswahl; % Zeilenvektor, in dem alle auszuwählenden Kategorien sind
   ind_katem = ind_katem.*sum( code_em(:,i)*ones(1,size(ausw,2))==ones( size(code_em,1) , 1 )*(ausw) ,2 );
end
ind_katem=find(ind_katem); %nur noch die Indizes
fprintf('Ready! \n');
