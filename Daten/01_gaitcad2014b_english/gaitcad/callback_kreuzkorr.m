  function [string, info, callback] = callback_kreuzkorr(var_bez, par,mode)
% function [string, info, callback] = callback_kreuzkorr(var_bez, par,mode)
%
% Vorbereitung f�r die Anzeige der Kreuzkorrelationsfunktion
%
% The function callback_kreuzkorr is part of the MATLAB toolbox Gait-CAD. 
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

if (~isempty(par))
   %Zeitreihen 1
	tmp=poplist_popini(var_bez(1:par.anz_merk,:));
	string(1,1:length(tmp))=tmp;
	tmp=['Time series 1' ' (potential input)'];
   info(1,1:length(tmp))=tmp;
   
   %Zeitreihen 1
	tmp=poplist_popini(var_bez(1:par.anz_merk,:));
	string(2,1:length(tmp))=tmp;
	tmp=['Time series 2 (for ACF same as time series 1)' ' (potential output)'];
	info(2,1:length(tmp))=tmp;
   
   callback = sprintf('mode=%d; callback_mean_xcorrzr;',mode);
end;