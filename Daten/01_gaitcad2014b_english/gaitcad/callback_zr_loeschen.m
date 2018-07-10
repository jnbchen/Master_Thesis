% Script callback_zr_loeschen
%
% Löschen von Zeitreihen
%
% The script callback_zr_loeschen is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(ind_zr)
   
   if (length(ind_zr) == par.anz_merk) && par.anz_einzel_merk == 0
      myerror('Not all time series and single features can be deleted!');
   end;
      
   fprintf('%d Time series will be deleted\n',length(ind_zr));
   d_orgs(:,:,ind_zr)=[];
   for i=1:length(ind_zr)
      fprintf('%d: %s\n',ind_zr(i),var_bez(ind_zr(i),:));
   end;
   var_bez(ind_zr,:)=[];
   my=[];
   mstd=[]; %Ohne lange rum zu machen, ob's existiert: Es wird gelöscht. 
   if ~isempty(ref) 
      ref.my(:,:,ind_zr)=[];
      ref.mstd(:,:,ind_zr)=[];
   end;
   parameter.gui.merkmale_und_klassen.ind_zr = setdiff(parameter.gui.merkmale_und_klassen.ind_zr,ind_zr);
   if (isempty(parameter.gui.merkmale_und_klassen.ind_zr))
      parameter.gui.merkmale_und_klassen.ind_zr = 1;
   end;
   inGUI;
   fprintf('Complete!\n');
end; 

%Aufräumen und Parameter aktualisieren
clear ind_zr 
aktparawin; 
