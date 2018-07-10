  function [sig, t_eff] = morlet_filterung(x, fA, f, w0, kausal)
% function [sig, t_eff] = morlet_filterung(x, fA, f, w0, kausal)
%
%  Filtert mittels Morlet-Wavelet. Gibt den Absolutwert zurück
%  (Morlet-Wavelets sind komplex).
%  x: zu filterndes Signal (Vektor)
%  fA: Abtastfrequenz des Signals
%  f: gewünschte Filterfrequenz
%  w0: Eigenfrequenz des Wavelets
%  kausal: gibt an, ob ein kausales Wavelet verwendet werden soll (default: 1)
%  (wird dann auf der Zeitachse um 2*t_eff verschoben, um den akausalen
%  Teil kausal zu bekommen). Reagiert dadurch natürlich später auf die Frequenzen...
%  sig: gefiltertes Signal
%  t_eff: eFolding-Time des Wavelet
%
% The function morlet_filterung is part of the MATLAB toolbox Gait-CAD. 
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

if (all(size(x)~=1))
   myerror('Error! The function requires a vector!');
   return;
end;

if (nargin < 4)
   myerror('Too few parameters!');
   return;
end;
if (nargin < 5)
   kausal = 1;
end;

omega0 = w0;
s = (omega0+ sqrt(2+omega0.^2)) ./ (4*pi*f);

ta = 1/fA;
% Breite im Zeit- und Frequenzbereich
t_eff = sqrt(2)*s;
f_eff = sqrt(2)/(2*pi*s);
% Hier bin ich mir über das Vorzeichen nicht sicher. Aber wenn man es umdreht (-), sieht
% das Ergebnis ein bisschen wie mit Blick in die Zukunft aus.
if (kausal)
   tau = 2*t_eff;
else
   tau = 0;
end;
t = [-4*t_eff:ta:4*t_eff];
% Morlet-Wavelet aus Lemm '04
wavelet = 1/sqrt(s) * pi.^(-1/4) .* exp(1i*omega0.* (t-tau)/s) .* exp(-1/2 * ((t-tau)/s).^2);

if (size(x,1) ~= 1)
   x = x';
end;

% Warum hier 1/sqrt(s)????
sig = 1/sqrt(s) * abs(conv2(x, wavelet, 'same'));
