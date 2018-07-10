  function [kkfs] = kreuzkorr(var_bez, parameter, ind_auswahl, merk_auswahl, kkf_rueckgabe, plot)
% function [kkfs] = kreuzkorr(var_bez, parameter, ind_auswahl, merk_auswahl, kkf_rueckgabe, plot)
%
%  Berechnet die Kreuzkorrelationsfunktion
%  Eingaben:
%  var_bez: Namensmatrix aus Gait-CAD
%  parameter: Parameter-Strukt aus Gait-CAD
%  ind_auswahl: Aktuelle Datentupelauswahl
%  merk_auswahl: Auswahl der Merkmale Skalar oder 1x2 Vektor
%  kkf_rueckgabe: kkfs soll zurückgegeben werden (sonst nur plot)
%  plot: plot==1: Plotten, sonst nicht.
%  Rückgaben;
%  kkfs sind die Kreuzkorrelationskoeffizienten. Wird nur zurückgegeben, wenn kkf_rueckgabe == 1
%  (default = 0). Achtung: könnte ein klein bisschen Speicher benötigen...
%  kkfs ist ein Strukt, das die Kreuzkorrelationskoeffizienten, die Zeit, sowie die Nummer des Datentupels,
%  und die beiden Zeitreihen enthält.
%
% The function kreuzkorr is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<5)
    kkf_rueckgabe = 0;
end;
if (nargin<6)
    plot = 1;
end;

% Hier wird nun die eigentliche Funktionalität ausgeführt:
if (length(merk_auswahl) == 1)
    ind1 = merk_auswahl;
    ind2 = ind1;
else
    ind1 = merk_auswahl(1);
    ind2 = merk_auswahl(2);
end;

global d_orgs;

if (size(ind_auswahl,2) == 1)
    ind_auswahl = ind_auswahl';
end;

count = 1;
kkfs = [];
ta = 1/parameter.gui.zeitreihen.abtastfrequenz;
for i = ind_auswahl
    if plot == 1
        if parameter.gui.anzeige.aktuelle_figure == 0
            figure;
        end;
        if isfield(parameter.projekt,'recent_figure')
            figure(parameter.projekt.recent_figure);
        end;
    end;
        
    tmp1 = squeeze(d_orgs(i, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, ind1));
    tmp2 = squeeze(d_orgs(i, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, ind2));
    [erg, zeit] = myxcorr([tmp2' tmp1'], plot, [], [], [], ta,parameter.gui.statistikoptionen.scaleopt_type_text);
    if (kkf_rueckgabe)
        kkfs(count).kkf = erg;
        kkfs(count).zeit = zeit';
        kkfs(count).ds = i;
        kkfs(count).merk = [ind2 ind1];
        count = count + 1;
    end;
    if (ind1 == ind2)
        name = sprintf('%d: Auto correlation function data point %d, %s', get_figure_number(gcf), i, deblank(var_bez(ind1,:)));
        ylabel('Auto correlation function (ACF)');
    else
        name = sprintf('%d: Cross correlation function data point %d, %s - %s', get_figure_number(gcf), i, deblank(var_bez(ind1,:)), deblank(var_bez(ind2,:)));
    end;
    set(gcf, 'Name', name, 'NumberTitle', 'off');
    
    if ~isempty(parameter)
        xlabel(['Time shift' ' [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'] );
    end;
    
    
end;
