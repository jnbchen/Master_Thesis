% Script zr_navi_exp_trigger
%
% 
% 
%  Schreibe die Triggerzeitreihe in d_orgs:
%  Die Variable zrns_handle muss vorher gesetzt worden sein.
%  Besorge zunächst die Daten. Die sind in der UserData der figure gespeichert:
%
% The script zr_navi_exp_trigger is part of the MATLAB toolbox Gait-CAD. 
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

trigger_zr = zeros(size(d_orgs, 2), 1);
h_navi=get(h_navi.figure,'userdata');

%gibt es schon einen Trigger?
if isfield(h_navi,'trigger_klasse') 
   trigger_zr(h_navi.trigger_list) = h_navi.trigger_klasse;
else
   mywarning('No trigger time series defined');
   return;
end;


if mode_trigger==1 
   %Trigger hinten anhängen
   
   h_navi.trigger_nr = size(d_orgs,3)+1;
   % Den Bezeichner noch hinten anhängen:
   % Geht hier nur von 1 bis L, da ganz hinten ein y hängt 
   
   var_bez = strvcatnew(var_bez(1:h_navi.trigger_nr-1,:), 'Trigger');
end;

for i = 1:size(d_orgs,1)
   d_orgs(i, :, h_navi.trigger_nr) = trigger_zr;
end;
close(h_navi.figure);
clear h_navi trigger_zr h zrns_handle;

aktparawin;
