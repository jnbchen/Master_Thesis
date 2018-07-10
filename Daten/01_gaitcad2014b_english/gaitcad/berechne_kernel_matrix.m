  function K = berechne_kernel_matrix(daten1, daten2, kernel, kernel_param)
% function K = berechne_kernel_matrix(daten1, daten2, kernel, kernel_param)
%
% The function berechne_kernel_matrix is part of the MATLAB toolbox Gait-CAD. 
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

K = zeros(size(daten1,1), size(daten2,1));
for i = 1:size(daten1,1)
   tupel_i = daten1(i, :);
   for j = 1:size(daten2,1)
      tupel_j = daten2(j, :);
      K(i,j) = berechne_kernel(tupel_i, tupel_j, kernel, kernel_param);
   end;
end;

function erg = berechne_kernel(x,y,kernel,kernel_param)
switch(kernel)
case 'rbf'
   erg = exp( -((x-y)*(x-y)') / (2*kernel_param^2));
case 'rbf_cityblock'
   erg = exp( -sum(abs(x-y)) / (2*kernel_param^2));
case 'poly'
   erg = (x * y')^kernel_param;
case 'polyhomog'
   erg = (x * y' + 1)^kernel_param;
otherwise % Wenn nicht bekannt, verwende einfach RBF
   erg = exp( -((x-y)*(x-y)') / (2*kernel_param^2));
end;


