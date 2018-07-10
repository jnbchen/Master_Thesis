  function merk_archiv=repair_merk_archiv(merk_archiv)
% function merk_archiv=repair_merk_archiv(merk_archiv)
%
% 
% 
% Null-Werte auf NaN setzen (gibt sonst später Ärger bei Anzeigen)
%
% The function repair_merk_archiv is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

if ~isempty(merk_archiv)
   
   merk_archiv.guete(merk_archiv.guete<=0)=NaN;
   
   %beste Werte pro Auswahl
   merk_archiv.best_guete=max(merk_archiv.guete,[],2);
   
   %jeweilige Verbesserungen registrieren
   if size(merk_archiv.guete,1)>1
      merk_archiv.guete_fortschritt(1,:)=merk_archiv.guete(1,:);
      for j=2:size(merk_archiv.guete,1)
         merk_archiv.guete_fortschritt(j,:)=merk_archiv.guete(j,:)-merk_archiv.best_guete(j-1);
      end;   
   end;
end;
