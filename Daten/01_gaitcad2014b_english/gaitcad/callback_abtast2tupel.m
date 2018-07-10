% Script callback_abtast2tupel
%
% The script callback_abtast2tupel is part of the MATLAB toolbox Gait-CAD. 
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

if (isempty(d_orgs))
   myerror('No time series selected. Cancel.');
   return;
end;
%if (size(d_orgs,1) > 1)
%   myerror('The function works only for one data point but we have more data points. Canceling...');
%   return;
%end;

%Klassencodes zusammenbauen
code_alle_zr=code_alle;
code_alle=zeros(size(d_orgs,2)*size(d_orgs,1), size(code_alle,2));
d_org = zeros(size(d_orgs,2)*size(d_orgs,1), size(d_orgs,3)+2);

%evtl. vorhandene Bilder löschen
reset_image_struct;

k=0;
for i_dt = 1:size(d_orgs,1)
  fprintf('DT %d\n',i_dt);
  for i_sa = 1:size(d_orgs,2)
      k=k+1;
      d_org(k, :) = [squeeze(d_orgs(i_dt, i_sa, :))' i_sa i_dt];
      code_alle(k,:)=code_alle_zr(i_dt,:);
   end;
end;

% Nur bis end-1, da an var_bez ein y angehängt ist.
dorgbez = strvcatnew(var_bez(1:par.anz_merk,:),'Sample point','Data points');

code = code_alle(:,1);
%bez_code = 'None';

% Datei speichern
%clear zgf_y_bez code_alle d_orgs var_bez
clear code_alle_zr d_orgs var_bez ;
saveprj_g;
clear datei_save;

% Neues Projekt laden
datei_load = [datei '.prjz'];
ldprj_g;
