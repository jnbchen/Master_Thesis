% Script callback_klass_hierch
%
% Default-Werte fuer uebrige Parameter (vgl. klf_en_hierch)
%
% The script callback_klass_hierch is part of the MATLAB toolbox Gait-CAD. 
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

fehlermax = 0.01;


merk_red = parameter.gui.klassifikation.merk_red;
if mode~=2 
   if parameter.gui.klassifikation.anz_hk >= merk_red
      set(uihd(11,75),'string',sprintf('%d',max(1,merk_red-1)));
      eval(get(uihd(11,75),'callback'));
   end;
   
   %Klassifikator entwerfen
   klass_hierch_bayes=klf_en_hierch(d_org(ind_auswahl,:), code(ind_auswahl,:), merk_red, fehlermax,parameter.gui.klassifikation.anz_hk, get(uihd(11,100),'value'));
end;

if mode~=1
   %Klassifikator anwenden (gem‰ﬂ Auswahl in kp.klassifikator)
   pos = zeros(par.anz_dat,1);
   prz = zeros(par.anz_dat,kp.anz_class);
   md  = zeros(par.anz_dat,kp.anz_class);
   pos(ind_auswahl)=klf_an_hierch(d_org(ind_auswahl,:), klass_hierch_bayes);
   
   if (get(uihd(11,119),'value'))
      %Ausgabe in Datei...
      fid = fopen(strcat('ClassResult_',parameter.projekt.datei,'_BayesHierch','.','txt'),'wt');
      [konf,fehl_proz,fehl_kost,feat_kost,relevanz_klass] = klass9([],code(ind_auswahl),pos(ind_auswahl),prz(ind_auswahl,:),-2,fid);
      fclose(fid);
   else 
      %nur Bildschirm...
      [konf,fehl_proz,fehl_kost,feat_kost,relevanz_klass] = klass9([],code(ind_auswahl),pos(ind_auswahl),prz(ind_auswahl,:),0,1);
   end
end;

enmat = enable_menus(parameter, 'enable', 'MI_EMHierchKlassi_An');

clear fehlermax format mode merk_red;
