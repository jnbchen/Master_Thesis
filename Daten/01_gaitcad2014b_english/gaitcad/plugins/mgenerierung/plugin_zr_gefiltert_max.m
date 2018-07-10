  function [datenOut, ret, info] = plugin_zr_gefiltert_max(paras, datenIn)
% function [datenOut, ret, info] = plugin_zr_gefiltert_max(paras, datenIn)
%
%   Berechne das Maximum einer Zeitreihe.
%   Plugin-Fkt für Gait-CAD.
%
% The function plugin_zr_gefiltert_max is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:07
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

info = struct('beschreibung', 'Filtered maximum', 'bezeichner', 'Fil-MAX', 'anz_zr', 1, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation = strcat('sliding maximum value with exponential forgetting.',' Here, a causal filter is used.');


if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

fakt = 0.01;
datenOut.dat_zr = zeros(size(datenIn.dat));
% Für jeden einzeln
for n = 1:size(datenIn.dat,1)
   % Irgendwann noch mal versuchen eine Schleife zu sparen...
   max_ = datenIn.dat(n, 1);
   for sp = 2:size(datenIn.dat,2)
      % Wenn es ein neues Maximum gibt, das verwenden...
      if (datenIn.dat(n, sp) > max_)
         max_ = datenIn.dat(n, sp);
      else % ... ansonsten das alte Maximum etwas abschwächen.
         %max_ = max_ + sign(max_)*fakt;
         max_ = max_ - abs(max_) * fakt;
      end; % if (datenIn.dat(n, sp) > max_)
      datenOut.dat_zr(n, sp) = max_;
   end; % for(sp = 1:size(datenIn.dat,2))
end; % for(n = 1:size(datenIn.dat,2))

ret.ungueltig = 0;
