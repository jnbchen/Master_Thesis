  function [Stabw] = Standardabweichung (daten, a1, a2, ta, asigma, init)
% function [Stabw] = Standardabweichung (daten, a1, a2, ta, asigma, init)
%
%  Stabw=Standardabweichung(daten, 0.98, 0.99, 0.001, 0.98, 0.1);
%  ta entspricht HIER der Abtastzeit in Sekunden (nicht 1000stel !!!!)
% 
%
% The function Standardabweichung is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

if nargin < 6 
   init=0; 
end;
if nargin < 5 
   asigma=0.98; 
end;
if nargin < 4 
   ta=0.01; 
end;
if nargin < 3 
   a2=0.99; 
end;
if nargin < 2 
   a1=0.98;
end;

fil=[];

fil(:,1)=filter(1-a1, [1 -a1], daten);
fil(:,2)=filter(1-a2, [1 -a2], daten);

trend=(fil(:,1)-fil(:,2))./(ta*(a2-a1)/(1-a1)/(1-a2));

sigma_quadr=zeros(length(daten),1);
sigma_quadr(1)=init;

sigma_quadr=filter(1-asigma, [1 -asigma], .5.*([init; diff(daten)] - trend.*ta).^2, init);

Stabw=sqrt(sigma_quadr);




%sig_quadr=zeros(size(fil(:,1)));
%for i=2:length(sig_quadr)
%   sig_quadr(i)=asigma*sig_quadr(i-1)+(1-asigma)*0.5*(daten(i)-daten(i-1)-trend(i)*ta)^2;
%end;
% sig_quadr=sqrt(sig_quadr);

