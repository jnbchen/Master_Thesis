  function [knneighbour]= knneighbour_en(d, code, ind_auswahl, normierung, anzahl_nachbarn)
% function [knneighbour]= knneighbour_en(d, code, ind_auswahl, normierung, anzahl_nachbarn)
%
% The function knneighbour_en is part of the MATLAB toolbox Gait-CAD. 
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

knneighbour.k=anzahl_nachbarn;
knneighbour.normierung=normierung;
if knneighbour.normierung==1
   knneighbour.minimum=min(d,[],1); 
   knneighbour.differenz=(max(d,[],1) - min(d,[],1)); 
   knneighbour.differenz(find(knneighbour.differenz==0))=1;
	d=(d-ones(size(d,1),1)*knneighbour.minimum)./(ones(size(d,1),1)*knneighbour.differenz);
end;   

%Daten für Klassifikator speichern
fprintf('Create k-NN-classifier: Save data...\n');
knneighbour.dat =d(ind_auswahl,:);
knneighbour.code=code(ind_auswahl);
knneighbour.su=cov(knneighbour.dat,1);


fprintf('Complete!\n');


