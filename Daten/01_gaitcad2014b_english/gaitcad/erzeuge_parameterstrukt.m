% Script erzeuge_parameterstrukt
%
% The script erzeuge_parameterstrukt is part of the MATLAB toolbox Gait-CAD. 
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

kp.mehrklassen = parameter.gui.klassifikation.mehrklassen;


%ACHTUNG!! Verfahren werden sowohl für Klassifikation als auch für Regression gebraucht!!
%Deswegen die relevanten Teile besser gleich rausziehen
%Neuronale Netze
kp.ann = parameter.gui.klassifikation.ann;
kp.ann.type = parameter.gui.klassifikation.ann.typ;
kp.ann.neurperclass = parameter.gui.klassifikation.ann.mlp.ausgangsneuronen -1 ;	%Wertanpassung für Funktion nn_en
kp.ann.norm = 1;	%kann nicht vom Benutzer festgelegt werden

if kp.ann.type == 3 && ~exist('feedforwardnet','file')
    fprintf('In this MATLAB version, Feedforwardnet (MLP) is not available. The option is changed to MLP!');
    fprintf('\n');
    parameter.gui.klassifikation.ann.typ = 1;
    kp.ann.type = parameter.gui.klassifikation.ann.typ;
    inGUIIndx = 'CE_NN_Typ';
    inGUI;
end;
kp.ann.mlp.lernalg = parameter.gui.klassifikation.ann.mlp.lernalgorithmus;
kp.ann.mlp.neur_layer1 = parameter.gui.klassifikation.ann.mlp.neuronentyp;
zeichnen_status = parameter.gui.klassifikation.ann.mlp.zeichnen;

%Nearest Neighbour
kp.knn.normieren = 1;
kp.knn.k = parameter.gui.klassifikation.knn.k;	%Benutzerparameter
val = parameter.gui.klassifikation.knn.metrik; % Metrik
switch(val)
    case 1
        kp.knn.metrik = 'euclid';
    case 2
        kp.knn.metrik = 'seuclid';
    case 3
        kp.knn.metrik = 'cityblock';
    case 4
        kp.knn.metrik = 'mahal';
end;
kp.knn.region_schalter = parameter.gui.klassifikation.knn.region;
if (~kp.knn.region_schalter)
    kp.knn.region = [];
else
    kp.knn.region = parameter.gui.klassifikation.knn.groesse_region;
end;
% Soll nach Abstand gewichtet werden?
kp.knn.wichtung = parameter.gui.klassifikation.knn.abstandswichtung - 1;
if (~parameter.gui.klassifikation.knn.max_abstand_schalter)
    kp.knn.max_abstand = [];
else
    kp.knn.max_abstand = parameter.gui.klassifikation.knn.max_abstand;
end;
kp.knn.max_abstand_anz = parameter.gui.klassifikation.knn.max_abstand_anz;


if zeichnen_status
    %nach 1 Iteration (Lernepochen) wird jeweils der Forschritt dargestellt
    kp.ann.mlp.zeichnen = 1;
else
    %es erfolgt (angeblich) keine grafische Darstellung
    kp.ann.mlp.zeichnen = NaN;
end
kp.ann.rbf.spreizung = parameter.gui.klassifikation.ann.rbf.spreizung;


if (parameter.gui.klassifikation.mehrklassen == 4) && isempty(L)
    mywarning(['A system with unknown decision costs (matrix L)',' can not evaluation decision costs. The selection was changed to multi-class problem.']);
    
    parameter.gui.klassifikation.mehrklassen = 1;
    inGUIIndx = 'CE_Klassifikation_Mehrklassen'; inGUI;
end;


switch parameter.gui.klassifikation.klassifikator
    case 1	%Bayes-Klassifikator
        kp.klassifikator = 'bayes';
        kp.bayes.metrik = parameter.gui.klassifikation.bayes.metrik;
        kp.bayes.apriori = parameter.gui.klassifikation.bayes.apriori;
        
    case 2	%kuenstliches Nueronales Netz
        kp.klassifikator = 'ann';
        %Funktioniert nicht beim Klassifikator!
        kp.ann.mlp.mlp_zeichnen_details =0;
        
        if (parameter.gui.klassifikation.mehrklassen == 4)
            mywarning(['An Artificial Neural Net',' can not evaluation decision costs. The selection was changed to multi-class problem.']);
            parameter.gui.klassifikation.mehrklassen = 1;
            inGUIIndx = 'CE_Klassifikation_Mehrklassen'; inGUI;
        end;
        
        
    case 3	%SVM
        if(parameter.gui.klassifikation.mehrklassen == 1 || parameter.gui.klassifikation.mehrklassen == 4)
            mywarning('A Support Vector Classifier can only solve two class problems. Consequently, the selection was switched to one-against-one.');
            parameter.gui.klassifikation.mehrklassen = 3;
            inGUIIndx = 'CE_Klassifikation_Mehrklassen'; inGUI;
        end;
        
        kp.klassifikator = 'svm';
        kp.svm.svm_options = parameter.gui.klassifikation.svm;
        kp.svm.svm_options.lambda = 1e-7;	%interner Parameter
        kp.svm.svm_options.anz_klass_total = parameter.par.anz_ling_y(parameter.par.y_choice);
        kp.svm.svm_options.normierung = 1;	%kann nicht vom Benutzer festgelegt werden
        %Parameter aus GUI
        kp.svm.svm_options.verbose = parameter.gui.validierung.detail_anzeige;
        kp.svm.svm_options.mehrklassentype = parameter.gui.klassifikation.mehrklassen - 1;	%Anpassung fuer Funktionen svm_en und svm_an
        %different name!
        kp.svm.svm_options.c = parameter.gui.klassifikation.svm.c_parameter_svm;
        
    case 4 % k-Nearest-Neighbour
        kp.klassifikator = 'knn';
        if (parameter.gui.klassifikation.mehrklassen == 4)
            mywarning(['A k-Nearest-Neighbor classifier',' can not evaluation decision costs. The selection was changed to multi-class problem.']);
            parameter.gui.klassifikation.mehrklassen = 1;
            inGUIIndx = 'CE_Klassifikation_Mehrklassen'; inGUI;
        end;
        
        
    case 5	%k-Nearest-Neighbour (Toolbox)
        %if(get(uihd(11,102),'value') == 2)
        %   warning('For the k-nearest-neighbor classifier, only multi-class and one-against-all problems are implemented!')
        %   set(uihd(11,102),'value',1);
        %end;
        
        kp.klassifikator = 'knn_tool';
        kp.knn_tool.normierung = 1;
        kp.knn_tool.k = parameter.gui.klassifikation.knn.k;	%Benutzerparameter
        
        if (parameter.gui.klassifikation.mehrklassen == 4)
            mywarning(['A k-Nearest-Neighbor classifier',' can not evaluation decision costs. The selection was changed to multi-class problem.']);
            parameter.gui.klassifikation.mehrklassen = 1;
            inGUIIndx = 'CE_Klassifikation_Mehrklassen'; inGUI;
        end;
        
        
        
    case 6 % Fuzzy-Klassifikator
        kp.klassifikator = 'fuzzy_system';
        kp.fuzzy_system=parameter.gui.klassifikation.fuzzy_system;
        
        if (parameter.gui.klassifikation.mehrklassen == 4)
            mywarning(['A fuzzy classifier',' can not evaluation decision costs. The selection was changed to multi-class problem.']);
            parameter.gui.klassifikation.mehrklassen = 1;
            inGUIIndx = 'CE_Klassifikation_Mehrklassen'; inGUI;
        end;
        
        if ~isempty(fuzzy_system) && isfield(fuzzy_system,'zgf_all') && size(fuzzy_system.zgf_all,1) == par.anz_einzel_merk+1
            kp.fuzzy_system.zgf           = fuzzy_system.zgf_all;
        end;
        
        
    case 7 % Entscheidungsbaum
        kp.klassifikator = 'dec_tree';
        %auch der Entscheidungsbaum nutzt das Fuzzy-Parameter-Strukt!!!
        kp.fuzzy_system=parameter.gui.klassifikation.fuzzy_system;
        
        if (parameter.gui.klassifikation.mehrklassen == 4)
            mywarning(['A decision tree',' can not evaluation decision costs. The selection was changed to multi-class problem.']);
            parameter.gui.klassifikation.mehrklassen = 1;
            inGUIIndx = 'CE_Klassifikation_Mehrklassen'; inGUI;
        end;
        
        if ~isempty(fuzzy_system) && isfield(fuzzy_system,'zgf_all') && size(fuzzy_system.zgf_all,1) == par.anz_einzel_merk+1
            kp.fuzzy_system.zgf           = fuzzy_system.zgf_all;
        end;
        
    case 8 % Ensemble
        kp.klassifikator = 'fitensemble';
        kp.fitensemble.method = 'Subspace';
        kp.fitensemble.NLearn = 10;
        kp.fitensemble.Learners = 'Discriminant';
end;

% Achtung! Funktioniert nur, weil der Klassifikator sich gleichzeitig merkt, für welche Klassen er angelernt wurde.
kp.anz_class = parameter.par.anz_ling_y(parameter.par.y_choice);

% Für Zeitreihen-Klassifikation:
kp.klassi_typ.typ = parameter.gui.zr_klassifikation.typ;
kp.klassi_typ.anz_cluster_kand = parameter.gui.zr_klassifikation.anz_cluster;
kp.klassi_typ.x_abtast = parameter.gui.zr_klassifikation.x_abtast;

% Triggerzeitreihe?
kp.triggerzr = parameter.gui.zr_klassifikation.triggerzr-1;
if (mode_berechne_triggerzr == 1)
    if (kp.triggerzr > 0 && ~isempty(d_orgs))
        kp.triggerevent.zr = squeeze(d_orgs(1, :, kp.triggerzr));
        kp.triggerevent.start = find(kp.triggerevent.zr);
        kp.triggerevent.start = kp.triggerevent.start(1);
        kp.triggerevent.kmax = length(find(kp.triggerevent.zr));
    else
        kp.triggerevent.zr = cumsum(ones(1,size(d_orgs,2)));
        kp.triggerevent.start = find(kp.triggerevent.zr);
        kp.triggerevent.start = kp.triggerevent.start(1);
        kp.triggerevent.kmax = size(d_orgs,2);
    end;
else % Irgendwo habe ich zuviel geschummelt... Jetzt wollen auch die EM-Klassifikatoren einmal auf diese Variable zugreifen. Also lieber setzen...
    kp.triggerevent.zr = [];
    kp.triggerevent.start = [];
    kp.triggerevent.kmax = [];
end;
mode_berechne_triggerzr = 0;

% Lese auch die Parameter für die Ausreißerdetektion:
% Welcher Kernel soll verwendet werden?
kp.ausreisser.verfahren = parameter.gui.ausreisser.verfahren;
kp.ausreisser.schwelle  = parameter.gui.ausreisser.schwelle;
kp.ausreisser.one_class.kernel = 'rbf';
if (parameter.gui.ausreisser.cityblock)
    kp.ausreisser.one_class.kernel = 'rbf_cityblock';
end;
kp.ausreisser.one_class.kernel_parameter = parameter.gui.klassifikation.svm.kerneloption;
if (parameter.gui.ausreisser.grenzen == 1) % Harte Grenzen
    kp.ausreisser.one_class.lambda = [];
else
    kp.ausreisser.one_class.lambda = parameter.gui.ausreisser.lambda;
end;
% Die verschiedenen Algorithmen wurden aus der Oberfläche verbannt. lp_solve arbeitet vernünftig.
kp.ausreisser.one_class.algorithmus = 'lp_solve';
kp.ausreisser.dichte.max_abstand = parameter.gui.klassifikation.knn.max_abstand;

%Entscheidungkosten für Klassifikationsentscheiungen
if exist('L','var')
    kp.L = L;
    if (parameter.gui.klassifikation.mehrklassen == 4)
        kp.decision = 2;
    else
        kp.decision = 1;
    end;
else
    %Entscheidungskosten werden ignoriert
    kp.L = [];
    kp.decision = 1;
end;

temp_string = get(gaitfindobj('CE_Regression_Typ'),'string');
temp_string = deblank(temp_string(parameter.gui.regression.typ,:));

%add specific information for regression
kp.regression = parameter.gui.regression;

% Parameter für die Regression:
switch temp_string
    case 'Polynom'
        parameter.gui.regression.type = 'polynom';
    case 'Artificial Neural Networks'
        parameter.gui.regression.type = 'ann';
    case 'k-nearest-neighbor'
        parameter.gui.regression.type = 'knn';
    case 'Curve fit (MATLAB)'
        parameter.gui.regression.type = 'fit';
    case 'Fuzzy system'
        parameter.gui.regression.type = 'fuzzy_system';
        kp.fuzzy_system = parameter.gui.klassifikation.fuzzy_system;
    case 'Lolimot'
        parameter.gui.regression.type = 'lolimot';
    case 'Virtual Storage A (energy package)'
        if isfield(parameter.gui,'energy')
            parameter.gui.regression.type = 'vsa';
            kp.regression.vsa.a     = parameter.gui.energy.par_a_min:parameter.gui.energy.par_delta_a:parameter.gui.energy.par_a_max;
            kp.regression.vsa.K_h   = parameter.gui.energy.par_K_h_min:parameter.gui.energy.par_delta_K_h:parameter.gui.energy.par_K_h_max;
            kp.regression.vsa.Emax  = parameter.gui.energy.par_Emax_min:parameter.gui.energy.par_delta_Emax:parameter.gui.energy.par_Emax_max;
            kp.regression.vsa.Esoll = parameter.gui.energy.par_Esoll/100;
            kp.regression.vsa.io_delay = parameter.gui.energy.vsa_io_delay;
            kp.regression.vsa.sampling_time  = parameter.gui.energy.sampling_time;
            kp.regression.vsa.price_criteria = parameter.gui.energy.popup_price_criteria;
            kp.regression.vsa.price_calc     = parameter.gui.energy.vsa_price_calc;
            kp.regression.vsa.train_dataset  = parameter.projekt.datei;
        end;
        if strcmp(kp.regression.merkmalsklassen,'Single features')
            mywarning('This option is only valid for time series!');
            parameter.gui.regression.type = 'polynom';
            parameter.gui.regression.typ = 1;
            inGUIIndx = 'CE_Regression_Typ'; inGUI;
        end;
    case 'Virtual Storage B (energy package)'
        if isfield(parameter.gui,'energy')
            parameter.gui.regression.type = 'vsb';
            kp.regression.vsb.a     = parameter.gui.energy.par_a_min:parameter.gui.energy.par_delta_a:parameter.gui.energy.par_a_max;
            kp.regression.vsb.K_h   = parameter.gui.energy.par_K_h_min:parameter.gui.energy.par_delta_K_h:parameter.gui.energy.par_K_h_max;
            kp.regression.vsb.Emax  = parameter.gui.energy.par_Emax_min:parameter.gui.energy.par_delta_Emax:parameter.gui.energy.par_Emax_max;
            kp.regression.vsb.Esoll = parameter.gui.energy.par_Esoll/100;
            kp.regression.vsb.io_delay = parameter.gui.energy.vsb_io_delay;
            kp.regression.vsb.sampling_time    = parameter.gui.energy.sampling_time;
            kp.regression.vsb.price_calc       = parameter.gui.energy.vsb_price_calc;
            kp.regression.vsb.storage_setpoint = parameter.gui.energy.popup_setpoint_method;
            kp.regression.vsb.train_dataset    = parameter.projekt.datei;
        end;
        if strcmp(kp.regression.merkmalsklassen,'Single features')
            mywarning('This option is only valid for time series!');
            parameter.gui.regression.type = 'polynom';
            parameter.gui.regression.typ = 1;
            inGUIIndx = 'CE_Regression_Typ'; inGUI;
        end;
    case 'Virtual Storage C (energy package)'
        if isfield(parameter.gui,'energy')
            parameter.gui.regression.type = 'vsc';
            kp.regression.vsc.a     = parameter.gui.energy.par_a_min:parameter.gui.energy.par_delta_a:parameter.gui.energy.par_a_max;
            kp.regression.vsc.K_h   = parameter.gui.energy.par_K_h_min:parameter.gui.energy.par_delta_K_h:parameter.gui.energy.par_K_h_max;
            kp.regression.vsc.Emax  = parameter.gui.energy.par_Emax_min:parameter.gui.energy.par_delta_Emax:parameter.gui.energy.par_Emax_max;
            kp.regression.vsc.Esoll = parameter.gui.energy.par_Esoll/100;
            kp.regression.vsc.io_delay = parameter.gui.energy.vsc_io_delay;
            kp.regression.vsc.sampling_time    = parameter.gui.energy.sampling_time;
            kp.regression.vsc.price_calc       = parameter.gui.energy.vsc_price_calc;
            kp.regression.vsc.storage_setpoint = parameter.gui.energy.popup_setpoint_method;
            kp.regression.vsc.train_dataset    = parameter.projekt.datei;
        end;
        if strcmp(kp.regression.merkmalsklassen,'Single features')
            mywarning('This option is only valid for time series!');
            parameter.gui.regression.type = 'polynom';
            parameter.gui.regression.typ = 1;
            inGUIIndx = 'CE_Regression_Typ'; inGUI;
        end;
    case 'ARX (energy package)'
        if isfield(parameter.gui,'energy')
            parameter.gui.regression.type = 'arx';
            kp.regression.arx.na = parameter.gui.energy.arx_na;
            kp.regression.arx.nb = parameter.gui.energy.arx_nb;
            kp.regression.arx.nk = parameter.gui.energy.arx_nk;
            kp.regression.arx.train_dataset = parameter.projekt.datei;
        end;
        if strcmp(kp.regression.merkmalsklassen,'Single features')
            mywarning('This option is only valid for time series!');
            parameter.gui.regression.type = 'polynom';
            parameter.gui.regression.typ = 1;
            inGUIIndx = 'CE_Regression_Typ'; inGUI;
        end;
end;
kp.regression.type = parameter.gui.regression.type;

clear temp;
string_fitpar1 =  int2str(parameter.gui.regression.fitpar1);
string_fitpar2 =  int2str(parameter.gui.regression.fitpar2);
%  weibull
%  exp 1-2
%  fourier 1-8
%  gauss1-8
%  cubicinterp
%  pchipinterp
%  poly curve 1-9
%  power 1-2
%  rat 1-5, 1-5
%  sin 1-8
%  cubicspline
%  smoothingspline
%  biharmonicinterp
%  poly surface 1-5, 1-5
%  lowess
%  loess

%curvefit
temp_test = {'weibull',['exp' string_fitpar1], ['fourier' string_fitpar1], ['gauss' string_fitpar1],'cubicinterp','pchipinterp',...
    ['poly' string_fitpar1],['power' string_fitpar1],['rat' string_fitpar1 string_fitpar2],['sin' string_fitpar1],'cubicspline',...
    'smoothingspline','biharmonicinterp',['poly' string_fitpar1 string_fitpar2],'lowess','loess'};
kp.fit =  sprintf('%s',temp_test{parameter.gui.regression.fit});


%aggregregation and normalization
kp.klassifikation = parameter.gui.klassifikation;
