% Script callback_ds_loeschen
%
% Löschen der Ausgangsklasse
% 
%  Zeilenvektor mit allen ausgewählten (zu löschenden) Ausgklassen tmp=sprintf('s  d_org(:,ind_merkmale)=[];',tmp);
%
% The script callback_ds_loeschen is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(ind_ds) && length(ind_ds)<par.anz_dat
   code_alle(ind_ds,:) = [];
   code(ind_ds,:) = [];
   d_org(ind_ds,:) = [];
   d_orgs(ind_ds,:,:) = [];
   if isempty(d_image.data)
      d_image.data = zeros(size(d_org,1),0);   
   else
      d_image.data(ind_ds,:,:,:) = [];
   end;
   
   ind_auswahl=[1:size(code_alle,1)]'; 
   aktparawin;
   fprintf('ind_auswahl (variable for data point selection) was set to ALL');
else
   if length(ind_ds) >= par.anz_dat
      myerror('Not all data point can be deleted!');
   end;   
end; 

%Aufräumen und Parameter aktualisieren
clear ind_ds; 

fprintf('Complete!\n')