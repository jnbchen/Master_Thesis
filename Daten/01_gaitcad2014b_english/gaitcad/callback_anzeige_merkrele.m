% Script callback_anzeige_merkrele
%
% The script callback_anzeige_merkrele is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(merk_archiv) || ~isfield(merk_archiv,'output_name')
    datei_temp=sprintf('%s_%s',parameter.projekt.datei,deblank(bez_code(par.y_choice,:)));
else
    datei_temp=sprintf('%s_%s',parameter.projekt.datei,merk_archiv.output_name);
end;

%Anzeige Regressionskoeffizienten
if mode<2 && ~isempty(merk_archiv_regr)
    mode = mode + 3;
end;


%Merkmalsrelevanzen
%mode==0: Tabelle unsortiert
%mode==1: Tabelle sortiert
if (mode<2)
    
    if isempty(merk_archiv)
        return;
    end;
    
    
    if ~isempty(interpret_merk)
        tmp=char([dorgbez ones(length(interpret_merk),1)*'A priori: ' zahl2text(interpret_merk) ones(length(interpret_merk),4)*32]);
    else
        tmp=dorgbez;
    end; %if ~isempty
    
    if ~isempty(strfind(merk_archiv.verfahren,'Univariate'))
        datei_temp=sprintf('%s_anova',datei_temp);
    end;
    if ~isempty(strfind(merk_archiv.verfahren,'Multivariate'))
        datei_temp=sprintf('%s_manova_%d',datei_temp,length(merk_archiv.merkmal_auswahl));
        
        
    end;
    if ~isempty(strfind(merk_archiv.verfahren,'Information measure'))
        datei_temp=sprintf('%s_inftheo',datei_temp);
    end;
    if (~exist('rueckstufung', 'var'))
        rueckstufung = [];
    end;
    merk_report(merk,tmp,length(merk),-1,merk_archiv.verfahren,parameter.gui.anzeige.tex_protokoll,mode,datei_temp,uihd,rueckstufung,[],parameter);
end;

%A-Priori-Merkmalsrelevanzen
if (mode==2)
    datei_temp=sprintf('%s_apriori',parameter.projekt.datei);
    merk_report(interpret_merk_rett,dorgbez,length(interpret_merk_rett),-1,'A priori feature relevances',parameter.gui.anzeige.tex_protokoll,0,datei_temp,uihd,[],[],parameter);
end;

%Regressionskoeffizienten
if (mode>2)
    uni_multi_temp='';
    if ~isempty(strfind(merk_archiv_regr.verfahren,'univariat'))
        uni_multi_temp ='univariat';
    end;
    
    if ~isempty(strfind(merk_archiv_regr.verfahren,'multivariat'))
        uni_multi_temp ='multivariat';
    end;
    
    datei_temp=sprintf('%s_regr_%s_%s',parameter.projekt.datei,uni_multi_temp,deblank(merk_archiv_regr.output));
    merk_report(merk,merk_archiv_regr.feature_bez,length(merk),-1,...
        merk_archiv_regr.verfahren,parameter.gui.anzeige.tex_protokoll,mode-3,datei_temp,uihd,[],merk_archiv_regr.input,parameter);
    
end;



clear mode tmp datei_temp