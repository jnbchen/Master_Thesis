% Script callback_klassifikator_an
%
% The script callback_klassifikator_an is part of the MATLAB toolbox Gait-CAD. 
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

if ~isfield(klass_single, 'merkmalsextraktion')
    mywarning('No information about feature selection and aggregation found. Please design a classifier');
    pos = [];
    prz = [];
    md  = [];
    
    return;
end;
erzeuge_parameterstrukt;

%GANZ, GANZ wichtig: bei der Anwendung beziehen wir uns auf denm entworfenen Klassifkiator!!!!!!!
kp.mehrklassen  =klass_single(1).entworfener_klassifikator.mehrklassen;
kp.klassifikator=klass_single(1).entworfener_klassifikator.typ;

%Entscheidungkosten für Klassifikationsentscheiungen - bei Bayes ist eine Abweichung zwischen 1 und 4 o.k. - aber nur dort
if exist('L','var') && strcmp(kp.klassifikator,'bayes') && kp.mehrklassen == 1  && parameter.gui.klassifikation.mehrklassen == 4
    kp.mehrklassen = 4;
end;


%Klassifikator anwenden (gemäß Auswahl in kp.klassifikator)
clear pos md prz svm_md;
pos =zeros(par.anz_dat,1);
prz = zeros(par.anz_dat,kp.anz_class);
md  = zeros(par.anz_dat,kp.anz_class);

% prz und md haben hier die soviele Spalten wie es Klassen im Datensatz gibt.
% Die Rückgabe geht von 1 bis zur maximalen Klasse der übergebenen Datentupel.
% Da die Dimensionen also nicht übereinstimmen müssen, erst einmal in temporäre Variable
% schreiben
if kp.mehrklassen == 1 || kp.mehrklassen == 4 || ((strcmp(kp.klassifikator, 'svm') && isfield(klass_single(1).svm_system.options,'internes_oax')) && klass_single(1).svm_system.options.internes_oax == 1)
    d=erzeuge_datensatz_an(d_org,klass_single(1).merkmalsextraktion);
    [pos_return_value, md_temp, prz_temp, svm_md] = klassifizieren_an(klass_single(1), d(ind_auswahl,:), kp);
    if ~isempty(pos_return_value)
        pos(ind_auswahl) = pos_return_value;
        clear pos_return_value;
    else
        clear pos_return_value;
        mywarning('Error by applying the classifier!');
        return;
    end;
    
else
    one_against_x_an;
    
    if isempty(md_oax)
        mywarning('Error by applying the classifier!');
        return;
    end;
    
    % Es wird ein md_temp und ein prz_temp erwartet.
    md_temp  = md_oax;
    prz_temp = prz_oax;
end;
% und anschließend so viele Spalten wie vorhanden kopieren:
md (ind_auswahl, 1:size(md_temp,2))  = md_temp;
prz(ind_auswahl, 1:size(prz_temp,2)) = prz_temp;
if (isempty(svm_md))
    clear svm_md;
end;

%Vorbereitung Dateiausgabe wie in KAFKA
if parameter.gui.klassifikation.konf_in_datei == 1
    f_klass9 = fopen(['results_' parameter.projekt.datei '.txt'],'at');
else
    f_klass9 = 1;
end;

global global_plot_off;
if (isempty(global_plot_off))
    anzeige_interna = 0;
else
    anzeige_interna = ~global_plot_off - 1;
end;
[konf,fehlproz,fehl_kost,feat_kost,relevanz_klass]=klass9(d(ind_auswahl,:),code(ind_auswahl),pos(ind_auswahl),prz(ind_auswahl,:),anzeige_interna,f_klass9,0,0,[],[],L);
% Soll direkt das Ergebnis angezeigt werden?
if (parameter.gui.klassifikation.konf_plot_details)
    uicall = 8;
    anz_klasserg_neu;
end;

if (~exist('phi_text', 'var') || isempty(phi_text))
    phi_text = sprintf('%s', upper(kp.klassifikator));
else
    klammer_auf = strfind(phi_text, '(');
    klammer_zu = strfind(phi_text, ')');
    if ~isempty(klammer_auf) && ~isempty(klammer_zu)
        % Falls es mehrere Klammern geben sollte, verwende alles zwischen der ersten öffnenden und letzten schließenden Klammer
        klammer_auf = klammer_auf(1);
        klammer_zu = klammer_zu(end);
        phi_text = sprintf('%s (%s)', upper(kp.klassifikator), phi_text(klammer_auf+1:klammer_zu-1));
    else
        phi_text = sprintf('%s (%s)', upper(kp.klassifikator), phi_text);
    end;
end;

%Datei wieder schließen
if parameter.gui.klassifikation.konf_in_datei == 1
    fclose(f_klass9);
end;

aktparawin;
