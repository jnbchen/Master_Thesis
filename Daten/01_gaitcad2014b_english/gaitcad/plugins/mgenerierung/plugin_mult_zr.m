  function [datenOut, ret, info] = plugin_mean_zr(paras, datenIn)
% function [datenOut, ret, info] = plugin_mean_zr(paras, datenIn)
%
% 
%  function [datenOut, ret, info] = plugin_mean_zr(paras, datenIn)
% 
%  Berechnet den Mittelwert zweiter Zeitreihen
%  Plugin-Fkt für Gait-CAD.
% 
%  Die Funktion plugin_mean_zr ist Teil der MATLAB-Toolbox Gait-CAD. 
%  Copyright (C) 2007  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Markus Reischl]
% 
% 
%  Letztes Änderungsdatum: 10-May-2007 17:43:43
%  
%  Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU General Public License,
%  wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, 
%  entweder gemäß Version 2 der Lizenz oder jeder späteren Version.
%  
%  Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, dass es Ihnen von Nutzen sein wird,
%  aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder 
%  der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK.
%  Details finden Sie in der GNU General Public License.
%  
%  Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm erhalten haben.
%  Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
%  
%  Weitere Erläuterungen zu Gait-CAD finden Sie in der beiliegenden Dokumentation oder im folgenden Konferenzbeitrag:
%  
%  MIKUT, R.; BURMEISTER, O.; REISCHL, M.; LOOSE, T.:  Die MATLAB-Toolbox Gait-CAD. 
%  In:  Proc., 16. Workshop Computational Intelligence, S. 114-124, Universitätsverlag Karlsruhe, 2006
%  Online verfügbar unter: http://www.iai.fzk.de/projekte/biosignal/public_html/gaitcad.pdf
%  
%  Bitte zitieren Sie diesen Beitrag, wenn Sie Gait-CAD für Ihre wissenschaftliche Tätigkeit verwenden.
% 
%
% The function plugin_mult_zr is part of the MATLAB toolbox Gait-CAD. 
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

info = struct('beschreibung', 'Multiplikation beliebiger Zeitreihen', 'bezeichner', 'MULTTS', 'anz_zr', 1, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = Inf;

info.explanation = 'multiplies all time series that are selected in the configuration window.';

if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;



datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, 1);
% Der Mittelwert muss über die Zeitreihen genommen werden, also die dritte Dimension!
datenOut.dat_zr = prod(datenIn.dat, 3);

ret.ungueltig = 0;
ret.bezeichner = ['MULTTS with ' sprintf('%s ', deblank(paras.var_bez(paras.ind_zr_merkmal(2:end),:))')];