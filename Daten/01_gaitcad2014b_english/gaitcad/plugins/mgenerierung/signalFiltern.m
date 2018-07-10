  function fil = signalFiltern(sig, fA, stopfreq, filtername, typ, ordnung)
% function fil = signalFiltern(sig, fA, stopfreq, filtername, typ, ordnung)
%
%  Filtert das Signal sig mit dem angegeben Filter.
%  Eingaben:
%  sig: zu filterndes Signal. Muss Spaltenvektor oder Matrix mit
%         einzelnen Signalen in Spalten sein
%  fA: Abtastfrequenz des Signals
%  stopfreq: Vektor mit den Filterfrequenzen. Vektor bei
%         Bandpassfilter, Skalar bei Hoch- oder Tiefpaﬂ
%  filtername: Zu verwendender Filter
%         Bisher nur 'butter' implementiert.
%  typ: (default: 2)
%         1: Hochpass,
%         2: Tiefpass,
%         3: Bandpass
%  ordnung: Ordnung des Filters (default: 5)
%
% The function signalFiltern is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 6)
   ordnung = 5;
end;
if (nargin < 5)
   typ = 2;
end;
if (nargin < 3)
   error('Too few parameters!');
end;
filtername = 'butter';

if (typ == 3)
   wn = 2*stopfreq ./ fA;
else
   wn = 2*stopfreq(1) ./ fA;
end;

switch(filtername)
case 'butter' % Butterworth
   if (typ == 1)
      [B, A] = butter(ordnung, wn, 'high');
   else
      [B, A] = butter(ordnung, wn);
   end;
end;

if max(abs(roots(A)))>1
   fprintf(1,'Filter poles:\n');
   disp(roots(A));
   mywarning('The designed filter is unstable. Details are shown in the MATLAB command window!');
end;


fil = filter(B, A, sig);