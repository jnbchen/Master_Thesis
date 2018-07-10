% Script callback_control_zrauswahl
%
% The script callback_control_zrauswahl is part of the MATLAB toolbox Gait-CAD. 
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

tmp=get(uihd(11,13),'value');

%niemals leersetzen (gibt Chaos!)
if isempty(tmp) && ~isempty(get(uihd(11,13),'string')) 
   tmp=1;
   set(uihd(11,13),'value',1);
end;

try 
  %correct possibly misleading listboxtop values - only for newer versions?
  tmp_listboxtop = get(uihd(11,13),'listboxtop');
  if tmp_listboxtop>par.anz_merk
    set(uihd(11,13),'listboxtop',1);
  end;
  clear tmp_listboxtop;
end;


set(uihd(12,13),'string',sprintf('Select time series (TS), number: %d',length(tmp)));
if length(tmp)==size(d_orgs,3) 
   set(uihd(11,15),'string','all'); 
else 
   set(uihd(11,15),'string',kill_lz(num2str(tmp)) ); 
end;
aktualisiere_projektueber;