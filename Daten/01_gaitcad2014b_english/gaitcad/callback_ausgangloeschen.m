% Script callback_ausgangloeschen
%
% The script callback_ausgangloeschen is part of the MATLAB toolbox Gait-CAD. 
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

if exist('figure_handle','var') && ~isempty(figure_handle)
   ind_ausg=get(figure_handle(2,1),'value');   % Zeilenvektor mit allen ausgewählten (zu löschenden) Ausgklassen  d_org(:,ind_merkmale)=[];',tmp);
else
   if ~exist('ind_ausg','var') || (~isempty(ind_ausg) && max(ind_ausg)>par.anz_y)
      ind_ausg=[];
   end;
end;

if length(ind_ausg)==par.anz_y
   mywarning('Not all output variables can be deleted!');
   ind_ausg=[];
end;

if ~isempty(ind_ausg)
   fprintf('%d Output variables will be deleted\n',length(ind_ausg));
   for i=1:length(ind_ausg)
      fprintf('%d: %s\n',ind_ausg(i),bez_code(ind_ausg(i),:));
   end;
   code_alle(:,ind_ausg)=[];
   bez_code(ind_ausg,:)=[];
   zgf_y_bez(ind_ausg,:)=[];

   %handling of decision costs
   if exist('L','var') && ~isempty(L) && isfield(L,'ld_alle')
      L.ld_alle(ind_ausg) = [];
   end;
   
   parameter.gui.merkmale_und_klassen.ausgangsgroesse = 1;
   par.y_choice = 0;
   
   %selected outputs might be invalid
   auswahl.dat  = [];
  
   inGUIIndx = 'CE_Auswahl_Ausgangsgroesse'; inGUI;
   fprintf('Complete!\n');
end;

%Aufräumen und Parameter aktualisieren
clear ind_ausg;



