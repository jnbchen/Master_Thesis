  function [Fil]=IIRFilter(daten, am, init)
% function [Fil]=IIRFilter(daten, am, init)
%
%  Fil=IIRfilter(daten(:,1),0.99, 0);
%  Filtert daten mit einer Filterkonstanten am. Das
%  Filter wird mit init initialisiert
% 
% filter=zeros(length(daten),1);
% filter(1)=init;
% 
% for i=2:length(daten)
%    filter(i)=(1-am)*daten(i)+am*filter(i-1);
% end;
%  Die init-Werte sind noch nicht ganz korrekt. Erste �nderung muss
%  ber�cksichtigt werden. Bei kleinen Werten kann das aber zu Fehlern f�hren!!!
%
% The function IIRFilter is part of the MATLAB toolbox Gait-CAD. 
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

if (isempty(init) || all(abs(init)) < 1e-5) 
   init = daten(1);
else
   init = init * am;
end;
Fil = filter(1-am, [1 -am], daten, init);