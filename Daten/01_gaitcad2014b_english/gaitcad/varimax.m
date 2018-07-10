  function [Ladungsmatrix_neu] = varimax (Ladungsmatrix)
% function [Ladungsmatrix_neu] = varimax (Ladungsmatrix)
%
%  Achtung: Beim Nachrechnen, ob maximale Parameterstreuung vorhanden ist,
%  müssen Nullelemente in phi_dis berücksichtigt werden. Die Parameterstreuung
%  berechnet sich wie folgt: std(abs(phi_dis(find(phi_dis))));
% 
%  Ladungsmatrix von Nullen befreien (vgl. phi_dis aus KAFKA)
%
% The function varimax is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

tmp=find(Ladungsmatrix); A=zeros(length(tmp)/size(Ladungsmatrix,2), size(Ladungsmatrix,2));	
i=1:length(tmp); A(i)=Ladungsmatrix(tmp(i));

% sofern A von Nullen befreit ist
B=A;
Q=zeros(size(A));

% Varimax-Algorithmus gemäß Magnus & Neudecker
for k=1:100
   
   % Q berechnen
	for i=1:size(A,1)
   	for j=1:size(A,2)
			Q(i,j)=B(i,j)*(B(i,j)^2-sum(B(:,j).^2)/size(B,j));		      
   	end;
	end;

	% B berechnen
	B=A*A'*Q*(Q'*A*A'*Q)^(-.5);

end;

% Nullen wieder einfügen
Ladungsmatrix_neu=zeros(size(Ladungsmatrix));
Ladungsmatrix_neu(tmp)=B;

if sum(isnan(Ladungsmatrix_neu(:)))					% wenn nicht alle Elemente gültig sind
   Ladungsmatrix_neu=Ladungsmatrix;					% alte Transformationsmatrix zurückgeben
end;
