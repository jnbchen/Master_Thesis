% Script aut_zr_loesch
%
% Hier werden Zeitreihen gelöscht, die komplett Null sind
% Änderung RALF: Variable eingeführt datenanteil_loeschen
%
% The script aut_zr_loesch is part of the MATLAB toolbox Gait-CAD. 
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

plotmodus=0;
callback_anzeige_fehldaten;

datenanteil_loeschen=1-sscanf(get(uihd(11,50),'string'),'%d')/100;
floesch=fopen(sprintf('%s_data_deleted.txt',parameter.projekt.datei),'wt');

%zu löschende Datensätze
ds_loeschen_ind=[];

%Projekt aktualisieren
aktparawin;

%Zeitreihen, Variable suspect stammt aus callback_anzeige_fehldaten
if exist('suspect','var') && ~isempty(suspect)
   ind_null_merk = find ((1-sum(suspect,1)/par.anz_dat) < datenanteil_loeschen);
   if ~isempty(ind_null_merk) 
      
      fboth(floesch,'The following time series will be deleted due to too many missing data (%s %%): \n',get(uihd(11,50),'string'));
      for i=ind_null_merk 
         fboth(floesch,'%d %s \n',i,var_bez(i,:));
      end;
      d_orgs(:,:,ind_null_merk)=[]; 
      var_bez(ind_null_merk,:)=[];
      suspect(:,ind_null_merk)=[];
      fboth(floesch,'Number of remaining time series: %d\n',size(d_orgs,3));
   end;
   
   %die verbleibenden suspekten Datentupel auf die Löschliste setzen
   ds_loeschen_ind=[ds_loeschen_ind find(max(suspect,[],2))];
   
end;


%Einzelmerkmale: 
if exist('suspect_dorg','var') && ~isempty(suspect_dorg)
   ind_null_merk = find ((1-sum(suspect_dorg,1)/par.anz_dat) < datenanteil_loeschen);
   if ~isempty(ind_null_merk) 
      fboth(floesch,'The following single features will be deleted due to too many missing data (%s %%): \n',get(uihd(11,50),'string'));
      for i=ind_null_merk 
         fboth(floesch,'%d %s \n',i,dorgbez(i,:));
      end;
      d_org(:,ind_null_merk)=[]; 
      dorgbez(ind_null_merk,:)=[];
      suspect_dorg(:,ind_null_merk)=[];
      fboth(floesch,'Number of remaining single features: %d\n',size(d_org,2));      
   end;   
   
   %die verbleibenden suspekten Datentupel auf die Löschliste setzen
   ds_loeschen_ind=unique([ds_loeschen_ind;find(max(suspect_dorg,[],2))]);
end;

%Datensätze löschen
if ~isempty(ds_loeschen_ind)
   if length(ds_loeschen_ind) == par.anz_dat
      myerror('Not all data point can be deleted!');
   end;
   fprintf('The following data points will be deleted due to too many missing data (with all features): \n');
   fprintf(' %d',ds_loeschen_ind);
   fprintf(' \n');
   d_orgs(ds_loeschen_ind,:,:)=[];
   d_org(ds_loeschen_ind,:)=[];
   if isempty(d_image.data) 
      reset_image_struct;
   end;
   code_alle(ds_loeschen_ind,:)=[];
   code(ds_loeschen_ind)=[];
   ind_auswahl=[1:size(d_org,1)]';
   warning('Data selection deleted!!');
   ds_loeschen_ind=[];       
end;

clear ind_null_merk;
aktparawin;     

fclose(floesch);
fprintf('\nReady! \n');

clear ds_loeschen_ind suspect suspect_d_orgs