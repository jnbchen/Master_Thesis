  function [pos, md, prz] = nn_an (d, net, net_param)
% function [pos, md, prz] = nn_an (d, net, net_param)
%
% The function nn_an is part of the MATLAB toolbox Gait-CAD. 
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

fprintf('Apply Artificial Neural Networks...\n')

p=d';
y=sim(net,p);	% Simulation des Netzes mit den Lerndaten

switch net_param.neurperclass
   
case 1
   
   %Normierung auf Prozent
   %prz=zeros(size(d,1),net_param.num_class);
   prz=max(y',0);
   prz=prz./(sum(prz,2)*ones(1,size(prz,2)));
   
   [tmp,pos]=max(y,[],1);
   pos=round(pos)';
   
case 0
   pos=round(y');
   
   %Begrenzung auf zulässige Nummern Ausgangsklasse
   pos=min(max(pos,1),net_param.num_class);
   prz=full(sparse(1:length(pos),pos,ones(length(pos),1),length(pos),net_param.num_class));
   
case -1
   pos=y';
   prz=[];
end;

md=prz;
fprintf('Ready...\n')

