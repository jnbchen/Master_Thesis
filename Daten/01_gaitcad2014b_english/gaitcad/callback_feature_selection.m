% Script callback_feature_selection
%
% Callback-Funktion zur Merkmalsbewertung und -auswahlmit verschiedenen Methoden...
% mode_bewertung
% anzeige_details = 0 schaltet diverse Zwischenanzeigen aus
%                 = 1 schaltet diverse Zwischenanzeigen ein
% mode_univariat  = 1 univariate Bewwertung
%                 = 2 multivariate Bewwertung
% 
% 
% Parametersatz auslesen
%
% The script callback_feature_selection is part of the MATLAB toolbox Gait-CAD. 
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

parameter_merkred = parameter.gui.klassifikation;
parameter_merkred.par=par;
parameter_merkred.par.par_d_org(1:4)=[length(ind_auswahl) size(d_org,2) 1 length(findd(code(ind_auswahl)))];
if exist('mode_univariat','var') && ~isempty(mode_univariat)
    parameter_merkred.mode_univariat=mode_univariat;
else
    parameter_merkred.mode_univariat=1;
end;
parameter_merkred.mode_bewertung=mode_bewertung;

if exist('anzeige_details','var') && ~isempty(anzeige_details)
    parameter_merkred.anzeige_details=anzeige_details;
else
    parameter_merkred.anzeige_details=1;
end;

if exist('feature_candidates','var') && parameter.gui.anzeige.relevances_for_selected_features == 0
    parameter_merkred.feature_candidates=feature_candidates;
end;

%look only inside the selected features
if parameter.gui.anzeige.relevances_for_selected_features == 1
   parameter_merkred.feature_candidates = parameter.gui.merkmale_und_klassen.ind_em;
end;

parameter_merkred.regression = parameter.gui.regression;

%Müll aufräumen
clear mode_bewertung mode_univariat anzeige_details;

%Vorauswahl auswerten
verfahren_vorauswahl='';

%preselection will be ignored if only selected features are evaluated for
%relevance lists!
if parameter.gui.klassifikation.preselection_merkmale == 1 && parameter.gui.anzeige.relevances_for_selected_features == 0
    parameter_merkred.merkmal_vorauswahl = parameter.gui.merkmale_und_klassen.ind_em;
else
    parameter_merkred.merkmal_vorauswahl=[];
end;

%bei informationstheoretischen Maßen ein evtl. fuzzy_system mit übergeben
if parameter_merkred.mode_bewertung == 5 && ~isempty(fuzzy_system) && ...
        isfield(fuzzy_system,'zgf_all') && size(fuzzy_system.zgf_all,1) == par.anz_einzel_merk+1
    parameter_merkred.fuzzy_system.zgf = fuzzy_system.zgf_all;
end;


% Merkmalsauswahl
switch parameter_merkred.mode_bewertung
   case {11,12,13,14,15,16}
    
    %Number of features for regression
    parameter_merkred.merk_red = parameter.gui.regression.max_number_of_raw_features;
    
    %Regression vorbereiten
    % {'All features'} or {'Selected features'}
    if isfield(parameter_merkred,'feature_candidates') && ~isempty(parameter_merkred.feature_candidates) && ...
            parameter.gui.anzeige.relevances_for_selected_features == 1
       set_textauswahl_listbox(gaitfindobj('CE_Regression_Merkmalsauswahl'),{'Selected features'});
    else
       set_textauswahl_listbox(gaitfindobj('CE_Regression_Merkmalsauswahl'),{'All features'});
        
    end;
    eval(gaitfindobj_callback('CE_Regression_Merkmalsauswahl'));
    % Merkmalsklasse (Input)
    % {'Single features'}
    set_textauswahl_listbox(gaitfindobj('CE_Regression_ZREM'),{'Single features'});
    eval(gaitfindobj_callback('CE_Regression_ZREM'));
    
    
    mode_callback_regression_en=0;
    callback_regression_en;
    parameter_merkred.kp = kp;
    parameter_merkred.ykont = ykont;
    
    %preselection in multivariate case
    if parameter.gui.regression.preselection_merkmale && (parameter_merkred.mode_bewertung == 12  || (parameter_merkred.mode_bewertung == 14) || (parameter_merkred.mode_bewertung == 16))
        
        %correct the shift by the regression output
        ind_preselection = find(ismember(parameter.gui.merkmale_und_klassen.ind_em,regr_single.merkmalsextraktion.feature_generation.input));
        parameter_merkred.merkmal_vorauswahl = parameter.gui.merkmale_und_klassen.ind_em(ind_preselection);
       
    else
        parameter_merkred.merkmal_vorauswahl=[];
    end;
   
    
    parameter_merkred.feature_candidates = regr_single.merkmalsextraktion.feature_generation.input;
end;


if (parameter_merkred.mode_bewertung == 6) || (parameter_merkred.mode_bewertung == 7) ||(parameter_merkred.mode_bewertung == 8)
    erzeuge_parameterstrukt;
    %aktuelle Ausgangsklasse und alle zugehörigen Informationen in den Klassifikator eintragen...
    kp.klass_single=[];
    kp.klass_single.klasse.nr  	 = par.y_choice;
    kp.klass_single.klasse.bez 	 = deblank(bez_code(par.y_choice,:));
    kp.klass_single.klasse.zgf_bez = zgf_y_bez(par.y_choice, 1:size(zgf_y_bez,2));
    
    if (parameter.gui.klassifikation.mehrklassen > 1)
        mywarning('A feature evaluation is only possible for multi-class problems!');
        parameter.gui.klassifikation.mehrklassen = 1;
    end;
    
    parameter_merkred.kp = kp;
end;



%Ausführen...
%aber nur, wenn es nicht um Korrelationsrückstufung geht
if (parameter_merkred.mode_bewertung>0)
          [merkmal_auswahl,merk,merk_archiv] = feature_selection(d_org(ind_auswahl,:),code(ind_auswahl),interpret_merk,parameter_merkred);
    if isempty(merkmal_auswahl)
        return;
    end;
end;

%die Korrelierten Mermale wurden noch nicht gelöscht!!!
if (~parameter.gui.klassifikation.rueckstufung_em)
    rueckstufung=[];
end;

if (parameter.gui.klassifikation.rueckstufung_em)
    c_krit = parameter.gui.statistikoptionen.c_krit;
    [merk,merkmal_auswahl,rueckstufung,merk_archiv]=corrkorrekt(merk,d_org(ind_auswahl, :),c_krit,merkmal_auswahl,merk_archiv);
end;

%Merkmalsrelevanzen durch Zusatzinfos ergänzen
merk_archiv=repair_merk_archiv(merk_archiv);
merk_archiv.rueckstufung=rueckstufung;

%Regression zurücksetzen
merk_archiv_regr =[];

%Merkmalsauswahl in entsprechendes Auswahlfenster schreiben
parameter.gui.merkmale_und_klassen.ind_em = merkmal_auswahl;
inGUIIndx = 'CE_Auswahl_EM';
inGUI;