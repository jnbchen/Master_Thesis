  function [f_auswertung,dateiname]=get_datei(uihd,extension,kopfname,parameter)
% function [f_auswertung,dateiname]=get_datei(uihd,extension,kopfname,parameter)
%
% The function get_datei is part of the MATLAB toolbox Gait-CAD. 
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

if parameter.gui.validierung.auswertung_in_datei==0
   f_auswertung=1;
   dateiname=[];
   return;
end;

%Texprotokoll
if parameter.gui.anzeige.tex_protokoll
   textxt='tex';
else 
   textxt='txt';
end;

%File öffnen
dateiname=sprintf('%s_%s.%s',parameter.projekt.datei,extension,textxt);
f_auswertung=fopen(dateiname,'wt');

if f_auswertung<2 
   myerror(sprintf('Can not open file %s!',dateiname));
end;

%Kopf gewünscht?
if ~isempty(kopfname) 
   protkopf(f_auswertung,uihd,parameter.gui.anzeige.tex_protokoll,parameter.projekt.datei,kopfname);
end;
