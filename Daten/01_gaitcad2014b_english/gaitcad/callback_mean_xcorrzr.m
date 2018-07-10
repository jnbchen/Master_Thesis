% Script callback_mean_xcorrzr
%
% Berechnet die paarweisen Kreuzkorrelationsfunktionen aller übergebenen
% Zeitreihen und der übergebenen Datentupel.
% Dabei wird über die gewählte Klasse oder die gewählten Datentupel gemittelt
% 
% ind_zr ist für die ausgewählten Zeitreihen.
%
% The script callback_mean_xcorrzr is part of the MATLAB toolbox Gait-CAD. 
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

zuviele = 10;
if (length(ind_auswahl) > zuviele) && ( (mode==1) || (mode==4) )
    antwort = questdlg(sprintf('Compute CCF for %d data points?', length(ind_auswahl)), 'Question', 'Yes', 'No', 'No');
    if (strcmp(antwort,'No'))
        return;
    end;
end;

ind_zr1=get(figure_handle(2,1),'value');
ind_zr2=get(figure_handle(3,1),'value');
ind_zr = unique([ind_zr1 ind_zr2]);
[muell,ind_zr1i]  = intersect(ind_zr,ind_zr1);
[muell,ind_zr2i]  = intersect(ind_zr,ind_zr2);
ta = 1./parameter.gui.zeitreihen.abtastfrequenz;



%Anzeige über alle Datentupel
switch mode
    case 1
        kkfs = [];
        for zr_i=ind_zr1
            for zr_j=ind_zr2
                fprintf('%d-%d\n',zr_i,zr_j);
                kkfs{zr_i,zr_j} = kreuzkorr(var_bez, parameter, ind_auswahl, [zr_i zr_j],  parameter.gui.anzeige.par_korr, parameter.gui.anzeige.figures_korr);
            end;
        end;
        
    case 2
        [cxcorr, mcxcorr, zeit] = xcorr_zr(d_orgs(ind_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, ind_zr), ...
            ta,ind_zr1i,ind_zr2i,parameter.gui.statistikoptionen.scaleopt_type_text);
        
        mcxcoeff = [];
        mcxcoeff.cxcorr  = cxcorr;
        mcxcoeff.mcxcorr = mcxcorr;
        mcxcoeff.zeit = zeit;
        mcxcoeff.bez  = deblank(var_bez(ind_zr,:));
        mcxcoeff.ind_zr = ind_zr;
        %Anzeige
        callback_anzeige_mean_xcorrzr;
    case 3
        % Sonst suche die verschiedenen Klassen und berechne einzeln für die die Spektogramme:
        klassen = unique(code, 'rows');
        mcxcoeff = [];
        count = 1;
        for k = 1:length(klassen)
            tmp_auswahl = find(code(ind_auswahl) == klassen(k));
            % Leere Klassen sollen abgefangen werden.
            if (~isempty(tmp_auswahl))
                [cxcorr, mcxcorr, zeit] = xcorr_zr(d_orgs(tmp_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, ind_zr), ...
                    ta,ind_zr1i,ind_zr2i,parameter.gui.statistikoptionen.scaleopt_type_text);
                
                mcxcoeff(count).cxcorr  = cxcorr;
                mcxcoeff(count).mcxcorr = mcxcorr;
                mcxcoeff(count).zeit = zeit;
                mcxcoeff(count).bez  = deblank(var_bez(ind_zr,:));
                mcxcoeff(count).bez_code = deblank(bez_code(par.y_choice, :));
                mcxcoeff(count).zgf_bez  = zgf_y_bez(par.y_choice, k).name;
                mcxcoeff(count).ind_zr = ind_zr;
                
                count = count + 1;
            end; % if (~isempty(tmp_auswahl))
        end; % for(k = 1:length(klassen))
        %Anzeige
        callback_anzeige_mean_xcorrzr;
        
        %Kurzzeit-KKF
    case 4
        for zr_i=ind_zr1
            for zr_j=ind_zr2
                callback_kurzzeit_kkf;
            end;
        end;
        
end;

fprintf(1, 'Complete!\n');
clear mode count ta ind_zr ind_zr1 ind_zr2 muell zr_i zr_j;