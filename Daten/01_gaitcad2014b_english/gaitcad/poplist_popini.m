  function popstring=poplist_popini(var_bez,startstring,relevanzen)
% function popstring=poplist_popini(var_bez,startstring,relevanzen)
%
%  Erstellt string für ein Auswahl-Fenster mit Muster
%    "startstring|var_bez(1,:) ( relevanz(1,:) )|var_bez(2,:) ( relevanz(2,:) ) | ..."
%  Relevanz ist z.B. die Merkmalsrelevanz, falls angegeben
%
% The function poplist_popini is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(var_bez) 
   popstring=[]; 
   return; 
end; 

%nachfolgender Trick ersetzt num2str und ist erheblich schneller
tmp=sprintf('''%d-'',',1:size(var_bez,1));
tmp=eval(sprintf('char(%s)',tmp(1:length(tmp)-1)));
var_bez=[tmp var_bez];

if nargin<3 
   relevanzen=[];
end;
if (nargin==3) && (size(var_bez,1)==length(relevanzen)) %checke, ob auch Anzahl relevanzen identisch mit Anzahl EM 
   %die Relevanzen werden als string-matrix konvertiert: 
   relevanzen=sprintf('''(%1.3f)'',',relevanzen);
   relevanzen=eval(sprintf('char(%s)',relevanzen(1:length(relevanzen)-1))); 
else
   relevanzen=[];
end

if (nargin>1)  
   if ~isempty(startstring)  
      var_bez=char(startstring, var_bez); 
      % Wenn's hier noch 'relevanzen' gibt und einen startstring, dann muss 'relevanzen' um eine Leerzeile ergänzt werden
      if ~isempty(relevanzen) 
         relevanzen=char(' ',relevanzen);
      end 
   end; 
end; 

%  (es gibt eine var_bez-Matrix (mit/ohne startstring) und eine (leere, oder nicht leere) relevanzen-Matrix)
zeilen_ende=char(ones(size(var_bez,1),1)*abs('|')); 
zeilen_ende(length(zeilen_ende))=' ';
var_bez=[var_bez   ones(size(var_bez,1),1)*abs('  ')   relevanzen  zeilen_ende];
clear relevanzen; 
var_bez=var_bez';
popstring=var_bez(:)';

