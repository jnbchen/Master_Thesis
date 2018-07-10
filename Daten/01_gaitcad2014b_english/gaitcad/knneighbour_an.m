  function [pos,md,prz]=knneighbour_an(dat,knneighbour)
% function [pos,md,prz]=knneighbour_an(dat,knneighbour)
%
% wendet k-Nearest-Neighbour-Klassifikator in kneighbour auf Datensatz in dat an
%
% The function knneighbour_an is part of the MATLAB toolbox Gait-CAD. 
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

if knneighbour.normierung==1
   dat=(dat-ones(size(dat,1),1)*knneighbour.minimum)./(ones(size(dat,1),1)*knneighbour.differenz);
end;
   
fprintf('Apply k-NN-classifier with k=%d...\n',knneighbour.k);
temp=som_eucdist2(knneighbour.dat, dat);
[pos, P]=knn(temp',knneighbour.code,knneighbour.k);
pos=pos(:,knneighbour.k);

%erstmal nur Einsen ausgeben
%prz=vecinmat(ones(length(pos),1),1:length(pos),pos');
prz = P(:, :, knneighbour.k);

%falls doch irgendjemand md haben will..
md=prz;

fprintf('Complete!\n');
