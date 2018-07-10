% Script callback_apriori_edit
%
% 
%  Gewählte Einzelmerkmale
%
% The script callback_apriori_edit is part of the MATLAB toolbox Gait-CAD. 
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

if (mode==1) 
   % auf_eins wird vom Menüpunkt gesetzt
   if (isempty(interpret_merk_rett))
      mywarning(sprintf('Undefined a priori relevances are all set to %d\n', wert_apriori));
      interpret_merk_rett(1:size(d_org,2),1) =wert_apriori ;      
   else
      interpret_merk_rett(parameter.gui.merkmale_und_klassen.ind_em,:)=wert_apriori;
      fprintf(1, '%d a priori relevances are set to %d \n', length(parameter.gui.merkmale_und_klassen.ind_em), wert_apriori);
   end;    
end;

%Apriori-Merkmalsrelevanzen gibt es gar nicht      
if ~exist('interpret_merk_rett', 'var') || isempty(interpret_merk_rett)
   parameter.gui.merkmale_und_klassen.a_priori_relevanzen = 0;
   interpret_merk=[];
   %inGUIIndx = 'CE_A_Priori'; 
   return;
end;

%berechnete Merkmalsrelevanzen sicherheitshalber rücksetzen
merk=[];

if (parameter.gui.merkmale_und_klassen.a_priori_relevanzen == 0)
   %keine A-Priori-Relevanzen verwenden, wenn diese ausgeschaltet sind ...
   interpret_merk=[];
else 
   
   switch size(interpret_merk_rett,2)
   case 1
      %nur Interpretierbarkeit
      interpret_merk = interpret_merk_rett.^parameter.gui.merkmale_und_klassen.a_priori_relevanzen_alpha;   
   case 2
      %Interpretierbarkeit und Implementierbarkeit
      interpret_merk = (interpret_merk_rett(:,1).^parameter.gui.merkmale_und_klassen.a_priori_relevanzen_alpha) .* (interpret_merk_rett(:,2).^parameter.gui.merkmale_und_klassen.a_priori_relevanzen_beta);
   end;   
end;

clear mode wert_apriori;