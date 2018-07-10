  function [fc,f,T,phasec]=myfft(x,plopt,ta,fc,f,T,phasec,einheit)
% function [fc,f,T,phasec]=myfft(x,plopt,ta,fc,f,T,phasec,einheit)
%
% 
% berechnet FFT des Signals x
% und gibt Amplitude fc(f), Phasenverschiebung phasec(f)
% Die Phasenverschiebung wird nur ab 4 Ausgabeelementen berechnet!
% wenn plopt==1 wird FFT-Signal zusätzlich über Frequenz in [Hz] geplottet
% wenn plopt==2 wird FFT-Signal zusätzlich über Periodendauer  in [s] geplottet
% optionale Argumente fc,f,T enthalten bereits berechnete Ergebnisse
% in beiden Fällen muss Abtastzeit ta mit gegeben sein !!
% Beispiel: ta=0.01;t=0:ta:100;figure;myfft(sin(2*pi/5*t),2,ta);
% 
%
% The function myfft is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

if nargin<2 
   return;
end;  

%Ergebnisse noch nicht berechnet!!!
if nargin<4 
   fc=[];
   f=[];
   T=[];
   phasec=[];
end;

%vorkonfektionierte Standard-Einheiten
if nargin<8
   einheit.frequenz='[Hz]';
   einheit.zeit='[sec]';
end;
 

if isempty(fc) || isempty(f) || isempty(T) || isempty(phasec)
   %Ergebnisse noch nicht berechnet!!!
   
   %Amplitude
   fc=abs(fft(x));
   fc=fc(floor(1:length(fc)/2));
   fc=2*fc/length(x);
   
   %Phasenverschiebung
   if (nargout>3) 
      phasec=phase(fft(x));
      phasec=180/pi*phasec(floor(1:length(phasec)/2));
   end;
      
   %Frequenz
   f=[0:length(fc)-1]'/(length(x)-1)/ta;
   T=[Inf;1./f(2:length(f))];
end;


%nicht ins Gait-CAD Fenster plotten (anderen Programmen schadet das nichts...)
if ~isempty(strfind(upper(get(gcf,'name')),upper('Gait-CAD')))
   figure;
end;

if (plopt==1) 
   
   bar(f,fc);
   xlabel(['Frequency f ' einheit.frequenz]);
   ylabel('Amplitude');
   zoom on;
   if (nargout>3) 
      figure;
      plot(f,phasec);
      xlabel(['Frequency f ' einheit.frequenz]);
      ylabel('Phase shift[°]');
   end;
   zoom on;
end;      

if (plopt==2) 
   bar(T(2:length(T)),fc(2:length(fc)));
   zoom on;
   xlabel(['Period length T ' einheit.zeit]);
   ylabel('Amplitude');
   
end;      

