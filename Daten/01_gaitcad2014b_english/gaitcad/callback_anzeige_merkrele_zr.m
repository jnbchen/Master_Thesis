% Script callback_anzeige_merkrele_zr
%
% The script callback_anzeige_merkrele_zr is part of the MATLAB toolbox Gait-CAD. 
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

datei_temp=sprintf('%s_merk',parameter.projekt.datei);
if ~exist('verfahren','var')
   verfahren=[];
end;

%bei der Regression macht das die Einzelmerkmaksfunktion mit !!!!
if mode<2 && ~isempty(merk_archiv_regr)
   callback_anzeige_merkrele;
   return;
end;


%Merkmalsrelevanzen
%mode==0: Tabelle unsortiert
%mode==1: Tabelle sortiert
if (mode<2)
   spString = sprintf('(SP %d) ', parameter.gui.zeitreihen.samplepunkt);
   spString = myResizeMat(spString, size(var_bez,1), 1);
   tmp=[spString var_bez];
   clear spString;
   
   if ~isempty(strfind(verfahren,'Univariate'))
      datei_temp=sprintf('%s_anova',parameter.projekt.datei);
   end;
   if ~isempty(strfind(verfahren,'Multivariate'))
      datei_temp=sprintf('%s_manova',parameter.projekt.datei);
   end;
   if ~isempty(strfind(verfahren,'Information measure'))
      datei_temp=sprintf('%s_inftheo',parameter.projekt.datei);
   end;
   merk_report(merk,tmp,length(merk),-1,verfahren,parameter.gui.anzeige.tex_protokoll,mode,datei_temp,uihd);
end;

clear mode tmp datei_temp