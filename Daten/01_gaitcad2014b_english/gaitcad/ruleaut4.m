  function [fuzzy_system]=ruleaut4(d_org,code,dorgbez,ybez,zgf_y_bez,par_d_org,ind_auswahl,merkmal_auswahl,interpret_merk,mode,texprotokoll,parameter_regelsuche)
% function [fuzzy_system]=ruleaut4(d_org,code,dorgbez,ybez,zgf_y_bez,par_d_org,ind_auswahl,merkmal_auswahl,interpret_merk,mode,texprotokoll,parameter_regelsuche)
%
% Berechnet Fuzzy-Systeme
% 
%  mode = 1 Einzelregeln ermitteln
%  mode = 2 nicht mehr implementiert
%  mode = 3 Regelbasis ermitteln
%  mode = 4 Entscheidungsbaum ermitteln
%
% The function ruleaut4 is part of the MATLAB toolbox Gait-CAD. 
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

anz_fuzzy=parameter_regelsuche.anz_fuzzy;
stat_absich=parameter_regelsuche.stat_absich;
faktor=parameter_regelsuche.faktor;

baumtyp=parameter_regelsuche.dectree.baumtyp;


%Bäume berücksichtigen Merkmalsauswahl und Interpretationen - wesentliche Ursache für Misserfolge!
if isempty(interpret_merk)
    interpret_merk=ones(size(d_org,2),1);
end;
interpret_merk_rule=zeros(size(interpret_merk));
%berücksichtigt Merkmalauswahl
interpret_merk_rule(merkmal_auswahl)=interpret_merk(merkmal_auswahl);

%Parametervekor...
par_rule=[par_d_org(1:4) anz_fuzzy*ones(1,par_d_org(2))];
zgf=zeros(size(d_org,2)+1,max(anz_fuzzy,max(code)));
%anz_fuzzy=max(anz_fuzzy,max(code));

fprintf('Create ZGF!\n');
%Entwurf ZGF
k=1;

%feste ZGFs? wenn ja, dann überprüfen und laden
if parameter_regelsuche.type_zgf == 6
    
    switch size(parameter_regelsuche.zgf,1)
        
        case 1
            %only one standard set of MBFs for all input variables
            zgf(1:size(d_org,2),1:size(parameter_regelsuche.zgf,2)) = ones(size(d_org,2),1) * parameter_regelsuche.zgf;
            
        case size(d_org,2) || (size(d_org,2)+1)
            %perfect match
            zgf = parameter_regelsuche.zgf;
            
        otherwise
            %separate sets for each input variable
            try 
                zgf(1:size(d_org,2),1:size(parameter_regelsuche.zgf,2))=parameter_regelsuche.zgf(1:size(d_org,2),:);
            catch 
                myerror('Error in mapping of fix membership functions!');
            end;
    end;
else
    
    for i=find(interpret_merk_rule')
        k=k+1;
        if ~rem(k,20)
            fprintf('%d\n',k);
        end;
        %ZGF-Parameter bestimmen und in Parametervekror reinschreiben
        [zgf(i,1:parameter_regelsuche.anz_fuzzy),muell,par_temp]=zgf_en(d_org(:,i),parameter_regelsuche);
        %neue Anzahl linguistischer Terme merken
        par_rule(i+4)=par_temp(5);
        
        %ZGF reparieren, sonst gibt es u.U. Probleme wenn größter Term negativ ist!
        if size(zgf,2)>parameter_regelsuche.anz_fuzzy && zgf(i,parameter_regelsuche.anz_fuzzy)<0
            zgf(i,parameter_regelsuche.anz_fuzzy+1) = -Inf;
        end;
    end; %for
end;



%ZGF-Bezeichnungen - inkl. Rückweisungsklasse!

if ~isempty(zgf_y_bez)
    zgf_bez = zgfname(zgf,par_rule);
    zgf_bez(par_rule(2)+1,1:length(zgf_y_bez))=zgf_y_bez;
else
    zgf_bez=zgfname(zgf,par_rule);
end;
zgf_bez(par_rule(2)+1,par_rule(4)+1).name='REJ';
for i=par_rule(4)+2:anz_fuzzy
    zgf_bez(par_rule(2)+1,i).name='';
end;



%Fuzzifizieren - über alle, nicht nur über ausgewählte Beispiele
[d_fuz,d_quali]=fuzz(d_org,zgf(1:size(d_org,2),1:anz_fuzzy));
yfuz=fuzz(code,1:max(code));

%besetzte ZGF aus Regelbasis?
indr_merkmal=find(max(zgf'~=0,[],1));
%Baum generieren, um wichtigste Merkmale zu suchen
%entweder klassenspezifisch  oder Einzelbaum
if parameter_regelsuche.dectree.klassen_spezifisch
    rulebase=mulbaumsk(d_quali(ind_auswahl,:),code(ind_auswahl),par_rule,baumtyp,0,0,0,interpret_merk_rule,[],[],0,1,parameter_regelsuche);
else
    [rulebase,muell,muell,fuzzy_system.dec_tree.verfahren_baum,fuzzy_system.dec_tree.texprot]=mulbaum(d_quali(ind_auswahl,:),code(ind_auswahl),par_rule,baumtyp,1,0,0,0,interpret_merk_rule,[],[],0,1,parameter_regelsuche);
    %Entscheidungsbaum abspeichern
    if (mode==4)
        %Bezeichner im Baum reparieren
        for ind_baum_merk=1:size(d_quali,2)
            fuzzy_system.dec_tree.texprot.kopf=strrep(fuzzy_system.dec_tree.texprot.kopf,sprintf('$x_{%d}$',ind_baum_merk),sprintf('$%s$',dorgbez(ind_baum_merk,:)));
            fuzzy_system.dec_tree.texprot.tabtext=strrep(fuzzy_system.dec_tree.texprot.tabtext,sprintf('$x_{%d}$',ind_baum_merk),sprintf('$%s$',dorgbez(ind_baum_merk,:)));
        end;
        
    end;
end;

if isempty(rulebase)
    fuzzy_system=[];
    return;
end;

%im Baum nicht aktivierte Merkmale eliminieren - dauert sonst alles ewig
fprintf('Look for specified features!\n');
[indr_aktiv,indr_merkmal]=findaktiv(rulebase(:,5:size(rulebase,2)),anz_fuzzy);

if size(dorgbez,1)==par_rule(2)
    dorgbez = char(dorgbez,'y');
end;
dorgbez_all=dorgbez;
dorgbez_rule=dorgbez([indr_merkmal end],:);

par_rule_all=[par_rule(1) size(d_org,2) par_rule(3:4) par_rule(4+[1:size(d_org,2)])];
par_rule    =[par_rule(1) length(indr_merkmal) par_rule(3:4) par_rule(4+indr_merkmal)];


zgf_all =zgf;
zgf_all_bez = zgf_bez;
%alle aktiven und Ausgangsklasse!

zgf=zgf([indr_merkmal end],:);
zgf_bez=zgf_bez([indr_merkmal size(zgf_bez,1)],:);

d_fuz=d_fuz(:,indr_aktiv);
d_quali=d_quali(:,indr_merkmal);
rulebase=rulebase(:,[1:4 4+indr_aktiv]);

%Regeln prunen (aber nicht bei Entscheidungsbäumen!)
if (mode~=4)
    wichtung=ones(1,par_rule(1));
    fprintf('ATTENTION unnumbered features!');
    [rulebase,masze]=prun12nm(rulebase,par_rule,d_fuz(ind_auswahl,:),yfuz(ind_auswahl,:),parameter_regelsuche,wichtung);
end;

%und moch RB suchen?
if (mode==3) && parameter_regelsuche.rulebase_search == 1
    [rulebase,masze,relevanz]=such_rb9(rulebase,yfuz(ind_auswahl,:),d_fuz(ind_auswahl,:),par_rule,parameter_regelsuche,wichtung,[]);
end;

if isempty(rulebase)
    fuzzy_system=[];
    warning('Found no rules!');
    return;
end;


%Variablennamen der verwendeten Merkmale als Nummern!
%mit Leerzeichen initialisieren
clear tmp;
for i=1:length(indr_merkmal)
    if texprotokoll
        tmp{i}=sprintf('$x_{%d}$',indr_merkmal(i));
    else
        tmp{i}=sprintf('x%d',indr_merkmal(i));
    end;
end;%i

%es gibt auch Regelbasen mit Default-Regel und ohne Merkmale...
if ~isempty(indr_merkmal)
    dorgbez_rule_nr=char(tmp);
else
    dorgbez_rule_nr=[];
end;

savefuzzy_klasssingle;

%bei Entscheidungsbämen brauchen wir später eine scharfe Entscheidungsfindung in der Anwendung
if (mode==4)
    fuzzy_system.qualitativ=1;
    fuzzy_system.inferenz=3;
else
    fuzzy_system.qualitativ=0;
end;

fprintf('Complete!\n');



