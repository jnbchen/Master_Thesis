  function [sigma,sigma_p]=corr_aut(d_org,var_bez,parameter,uihd,merkmal_auswahl,vorberechnete_corrcoef,name_korrelation)
% function [sigma,sigma_p]=corr_aut(d_org,var_bez,parameter,uihd,merkmal_auswahl,vorberechnete_corrcoef,name_korrelation)
%
% The function corr_aut is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

fprintf('Compute correlation coefficients ...\n');

corr_type = parameter.gui.statistikoptionen.type_liste{parameter.gui.statistikoptionen.corr_type};


if nargin<5
    merkmal_auswahl=[];
end;
if isempty(merkmal_auswahl)
    merkmal_auswahl=1:size(d_org,2);
end;


if nargin<6
    vorberechnete_corrcoef=[];
end;
if nargin<7
    name_korrelation.merkmal = sprintf('%s (%s)','Correlation coefficients',corr_type);
    name_korrelation.kopf    = sprintf('%s (%s)','Correlation analysis',corr_type);
    name_korrelation.objekt  = 'Feature';
    name_korrelation.objekte = 'Features';
end;
if (length(merkmal_auswahl)==1)
    mywarning('Only one selected feature!');
end;
tabelle=0;

if parameter.gui.anzeige.show_corr_selected == 1 && strcmp(parameter.gui.regression.merkmalsklassen,'Single features')
    ind_selection = parameter.gui.regression.output;
    [merkmal_auswahl,temp,indb] = unique([ind_selection merkmal_auswahl]);
    ind_selection = indb(1);
    myfilename = strcat(parameter.projekt.datei,var_bez(parameter.gui.regression.output,:));
else
    ind_selection = 1:length(merkmal_auswahl);
    myfilename = parameter.projekt.datei;
end;

if parameter.gui.anzeige.tex_protokoll
    dateicorr=repair_dosname(sprintf('%s_CORR_%s.tex',myfilename,corr_type));
else
    dateicorr=repair_dosname(sprintf('%s_CORR_%s.txt',myfilename,corr_type));
end;


%p values for correlation coefficients
sigma_p = [];

if isempty(vorberechnete_corrcoef)
    d_org=d_org(:,merkmal_auswahl);
    [sigma,sigma_p]=mycorrcoef(d_org,corr_type);
    
    
else
    sigma=vorberechnete_corrcoef(merkmal_auswahl,merkmal_auswahl);
end; %if isempty

%natürlich nicht zu sich selber bei Einzelmerkmalen ...
if strcmp(name_korrelation.objekt,'Feature')
    sigma=sigma-diag(diag(sigma));
end;

if length(sigma)==1
    mywarning('Cancel: The covariance matrix is a scalar value. Possible reason: only one feature or data point selected.');
    return;
end;


if any(any(isnan(sigma)))
    mywarning('The covariance matrix contains NaN elements.');
end;

f=fopen(dateicorr,'wt');
%Merkmalsauswahl?
if ~isempty(uihd)
    prottail=protkopf(f,uihd,parameter.gui.anzeige.tex_protokoll,parameter.projekt.datei,name_korrelation.kopf);
end;


%Optional Bonferroni correction
if ~isempty(sigma_p)
    %dependant if all feature pairs are tested or only the investigated
    %feature is analyzed
    if parameter.gui.anzeige.show_corr_selected == 1
        number_of_tests = length(merkmal_auswahl)-1;
        sigma_p_row = sigma_p(ind_selection,:);
        [sigma_p_krit_row_bonf,prottext_bonf] = bonferroni_correction(sigma_p_row,parameter,...
            number_of_tests,1);
        sigma_p_krit_bonf = sigma_p;
        sigma_p_krit_bonf(ind_selection,:) = sigma_p_krit_row_bonf;
        sigma_p_krit_bonf(:,ind_selection) = sigma_p_krit_row_bonf';
        
    else
        number_of_tests = length(merkmal_auswahl)*(length(ind_selection)-1)/2;
        [sigma_p_krit_bonf,prottext_bonf] = bonferroni_correction(sigma_p,parameter,...
            number_of_tests,1);
        
    end;
end;


%zur Anzeige vorbereiten
for i=ind_selection
    if ~rem(i,20)
        fprintf('%d\n ',i);
    end;
    prottext=sprintf('%s of %s %d (%s) to different %s',name_korrelation.merkmal,name_korrelation.objekt,merkmal_auswahl(i),kill_lz(var_bez(merkmal_auswahl(i),:))',name_korrelation.objekte);
    if ~isempty(sigma_p)
        %add Bonferroni method
        prottext= strcat(prottext,prottext_bonf);
    end;
    merk  =squeeze(sigma(i,:));
    if ~isempty(sigma_p) && parameter.gui.anzeige.p_values_corr == 1
        merk_p                 = squeeze(sigma_p(i,:));
        merk_sigma_p_krit_bonf = squeeze(sigma_p_krit_bonf(i,:));
    else
        merk_p = [];
    end;
    
    merk_anz=sum(abs(merk)>parameter.gui.statistikoptionen.c_krit);
    if (merk_anz)
        tabelle=tabelle+1;
        if (tabelle>10) && parameter.gui.anzeige.tex_protokoll == 1
            tabelle=0;
            fprintf(f,'\\clearpage\n');
        end;
        
        merk_alle=zeros(max(merkmal_auswahl),1);
        merk_alle(merkmal_auswahl)  = merk;
        if ~isempty(merk_p)
            p_values.features=zeros(max(merkmal_auswahl),1);
            p_values.features(merkmal_auswahl)= merk_p;
            
            p_values.sigma_p_krit_bonf=zeros(max(merkmal_auswahl),1);
            p_values.sigma_p_krit_bonf(merkmal_auswahl)= merk_sigma_p_krit_bonf;
            
            
        else
            p_values = [];
        end;
        
        
        
        merk_report(merk_alle,var_bez(1:max(merkmal_auswahl),:),merk_anz,f,prottext,parameter.gui.anzeige.tex_protokoll,3,'test',[],[],[],[],p_values);
    end;
end;

if ~isempty(uihd)
    fprintf(f,'%s',prottail);
end;

fclose(f);
viewprot(dateicorr);
fprintf('Ready! ...\n');

