  function [datenOut, ret, info] = plugin_mean_norm_ts(paras, datenIn)
% function [datenOut, ret, info] = plugin_mean_norm_ts(paras, datenIn)
%
% 
%  
% 
%  Normiert die Zeitreihen auf ihren Mittelwert
%  Plugin-Fkt f�r Gait-CAD.
% 
%  Die Funktion plugin_mean_norm_ts ist Teil der MATLAB-Toolbox Gait-CAD.
%  Copyright (C) 2007  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Markus Reischl]
% 
% 
%  Letztes �nderungsdatum: 10-May-2007 17:43:42
% 
%  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der GNU General Public License,
%  wie von der Free Software Foundation ver�ffentlicht, weitergeben und/oder modifizieren,
%  entweder gem�� Version 2 der Lizenz oder jeder sp�teren Version.
% 
%  Die Ver�ffentlichung dieses Programms erfolgt in der Hoffnung, dass es Ihnen von Nutzen sein wird,
%  aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder
%  der VERWENDBARKEIT F�R EINEN BESTIMMTEN ZWECK.
%  Details finden Sie in der GNU General Public License.
% 
%  Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm erhalten haben.
%  Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
%  Weitere Erl�uterungen zu Gait-CAD finden Sie in der beiliegenden Dokumentation oder im folgenden Konferenzbeitrag:
% 
%  MIKUT, R.; BURMEISTER, O.; REISCHL, M.; LOOSE, T.:  Die MATLAB-Toolbox Gait-CAD.
%  In:  Proc., 16. Workshop Computational Intelligence, S. 114-124, Universit�tsverlag Karlsruhe, 2006
%  Online verf�gbar unter: http://www.iai.fzk.de/projekte/biosignal/public_html/gaitcad.pdf
% 
%  Bitte zitieren Sie diesen Beitrag, wenn Sie Gait-CAD f�r Ihre wissenschaftliche T�tigkeit verwenden.
% 
%
% The function plugin_mean_norm_ts is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

anz_zr = 1;
info = struct('beschreibung', 'Normalized to mean value', 'bezeichner', 'NORMMEAN', 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation      = 'normalizes the time series to the mean value';
info.explanation_long = info.explanation;


if (nargin < 2 || isempty(datenIn))
    datenOut = [];
    ret = [];
    return;
end;

% preallocation - Lege Speicher f�r die neuen Zeitreihen an
datenOut.dat_zr = datenIn.dat;

% calculation
% if there is a timeseries with mean = 0
tmpPos = find(eq(mean(datenIn.dat,2), 0) == 1);
tmpNeg = find(eq(mean(datenIn.dat,2), 0) == 0);

if ~isempty(tmpPos) == 1
    datenOut.dat_zr(tmpPos,:) = datenIn.dat(tmpPos,:);
    datenOut.dat_zr(tmpNeg,:) = datenIn.dat(tmpNeg,:)./(mean(datenIn.dat(tmpNeg,:),2)*ones(1,size(datenIn.dat,2)));
elseif ~isempty(tmpPos) == 0
    datenOut.dat_zr = datenIn.dat./(mean(datenIn.dat,2)*ones(1,size(datenIn.dat,2)));
end

ret.ungueltig = 0;
ret.bezeichner = info.bezeichner;