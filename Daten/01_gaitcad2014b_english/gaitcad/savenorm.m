  function  savenorm(ref,parameter,var_bez,dorgbez,datei)
% function  savenorm(ref,parameter,var_bez,dorgbez,datei)
%
% speichert Normkurven (Mittelw. + Streuung) und Bezeichnungen in *.norm-Datei ab
%
% The function savenorm is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

my=ref.my;
mstd=ref.mstd;

%Mittelwerte und Standardabweichungen Einzelmerkmale (wenn vorhanden)
if isfield(ref,'my_em') 
   my_em=ref.my_em;
else 
   my_em=[];
end;
if isfield(ref,'mstd_em') 
   mstd_em=ref.mstd_em;
else 
   mstd_em=[];
end;

%Erklärung Norm merken
titelzeile=ref.titelzeile;
if (nargin < 5) || isempty(datei)
   [muell,datei]=fileparts(parameter.projekt.datei);
   
   %Dateinamen festlegen
   [datei,pfad]=uiputfile([datei '.norm'],'Save normative data');
else                
   tmp=which(datei);
   
   if isempty(tmp) 
      [pfad,datei] = fileparts(datei);
      if isempty(pfad) 
         pfad=pwd;
      end; %if isempty(pfad)
   else  
      [pfad,datei] = fileparts(tmp);
   end;   %   if isempty(tmp)
end;
%Dateinamen festlegen
if datei
   cd(pfad);
   %Speichern
   [muell,datei]=fileparts(datei);
   save([datei '.norm'],'my','mstd','my_em','mstd_em','var_bez','dorgbez','titelzeile');
   fprintf(1, 'File saved.\n');
end;


