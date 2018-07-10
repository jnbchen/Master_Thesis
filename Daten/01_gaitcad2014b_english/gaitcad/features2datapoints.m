  function features2datapoints(d_org_old,code_alle_old,bez_code_old,dorgbez_old,zgf_y_bez_old,par_old,parameter_old)
% function features2datapoints(d_org_old,code_alle_old,bez_code_old,dorgbez_old,zgf_y_bez_old,par_old,parameter_old)
%
% 
% features2datapoints(d_org,code_alle,bez_code,dorgbez,zgf_y_bez,par,parameter)
% 
%
% The function features2datapoints is part of the MATLAB toolbox Gait-CAD. 
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

d_org     = [d_org_old code_alle_old]';
code      = [1:size(d_org,1)]';
bez_code  = 'Features';
dorgbez   = char(zgf_y_bez_old(par_old.y_choice,code_alle_old(:,par_old.y_choice)).name);

for i=1:size(d_org_old,2)
    zgf_y_bez(1,i).name = deblank(dorgbez_old(i,:));
end;

for i=1:par_old.anz_y
    zgf_y_bez(1,i+size(d_org_old,2)).name = deblank(bez_code_old(i,:));
end;

save([parameter_old.projekt.datei '_feat.prjz'],'-mat','d_org','bez_code','dorgbez','zgf_y_bez','code');


