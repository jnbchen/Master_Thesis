  function [code_em, zgf_em_bez]=kat_aut_losch(code_em, zgf_em_bez)
% function [code_em, zgf_em_bez]=kat_aut_losch(code_em, zgf_em_bez)
%
%  sucht alle Kategorien (durch alle Spalten von em) und sucht die Anzahl der verschiedenen Kategorien
%  wenn nur eine Kategorie vorkommt, dann Löschen
%
% The function kat_aut_losch is part of the MATLAB toolbox Gait-CAD. 
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

ind=[]; 
for i=1:size(code_em,2)
   anz_kat=findd(code_em(:,i)); 
   if length(anz_kat)==1 
      ind=[ind i];
   end;
end;

% die nachfolgende Abfrage muss aus programmtechn. Gründen (Löschen in structs) geschehen (man kann nicht zgf_em_bez(5,:).name=[]; realisieren)
%  d.h. die erste Kategorie kann nicht gelöscht werden (hier stehen die *.katbez drin)
if ~isempty(ind) 
   if ind(1)==1 
      ind(1)=[]; 
   end; 
end; 

if ~isempty(ind)
   fprintf('Deleted categories: \n ');
   disp(zgf_em_bez(1,1).katbez(ind,:));
   code_em(:,ind)=[];
   zgf_em_bez(1,1).katbez(ind,:)=[];
   zgf_em_bez(ind,:)=[];
else
   fprintf('No categories deleted. \n');
end
%Abspecken der string-Matrix
zgf_em_bez(1,1).katbez(:,find(min(abs(zgf_em_bez(1,1).katbez)==32)))=[];
fprintf('Ready \n');
