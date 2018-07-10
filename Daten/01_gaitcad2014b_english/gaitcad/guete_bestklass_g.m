  function [q]=guete_bestklass_g(parameter, code, d_org, optionen)
% function [q]=guete_bestklass_g(parameter, code, d_org, optionen)
%
% Gütefunktion
%
% The function guete_bestklass_g is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Markus Reischl, Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


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

if (nargin < 4) 
   optionen.metrik = 3; 
end;

d=d_org*parameter;
[kl,su,s,s_invers,log_s]=klf_en6(d,code,0);
[pos,md,prz]=klf_an6(d, kl, su, s, s_invers, log_s, optionen.metrik, 0);

q=0; 
for i=1:length(code) 
   q=q+(prz(i,code(i))/100<0.5)*(1-2*prz(i,code(i))/100)   +1-(prz(i,code(i))/100); 
	end;

