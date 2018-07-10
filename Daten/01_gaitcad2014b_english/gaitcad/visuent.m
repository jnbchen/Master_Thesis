  function visuent(d_org,code,dorgbez,bez_code,fuzzy_system,par,parameter)
% function visuent(d_org,code,dorgbez,bez_code,fuzzy_system,par,parameter)
%
% The function visuent is part of the MATLAB toolbox Gait-CAD. 
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

classname=deblank(bez_code(par.y_choice,:));

if (length(parameter.gui.merkmale_und_klassen.ind_em)>20)
   parameter.gui.merkmale_und_klassen.ind_em=parameter.gui.merkmale_und_klassen.ind_em(1:20);
   mywarning('The plot was limited to the first 20 selected features');
end;

for ind_merkmal=parameter.gui.merkmale_und_klassen.ind_em 
     
   %Originale Merkmale
   d_intern=d_org(:,ind_merkmal);
   
   %gibt es passende entworfene ZGFs? 
   if isfield(fuzzy_system,'zgf_all')
      zgf_temp=fuzzy_system.zgf_all(ind_merkmal,:);
      zgf_temp_name=fuzzy_system.zgf_bez_all([ind_merkmal end],:);
   else         
      [zgf_temp,zgf_temp_name]=zgf_en(d_intern,parameter.gui.klassifikation.fuzzy_system,par);
   end;
   
   %Fuzzifizieren
   [muell,d_quali_intern]=fuzz(d_intern,zgf_temp);
   
   %Entropie berechnen
   [masze_baum,py,pu,puy,entr]=entropall([d_quali_intern code],[max(d_quali_intern) max(code)],1);
   if min(entr([1 2 3],1))==0 
      fprintf('The entropy is zero!\n');
   else
      %neues Bild 
      if parameter.gui.anzeige.aktuelle_figure 
         f=gcf;
      else
         f=figure;
         set(gcf,'numbertitle','off','name',sprintf('%d: Entropy for feature %s and output variable %s',get_figure_number(gcf),deblank(dorgbez(ind_merkmal,:)),classname));
      end;
      
      string_transinformation='TI';
      string_rueck='RE';
      string_irr='IR';
            
      subplot(2,2,1);
      pie(entr([6 4 5],1)'/entr(3,1),{string_rueck,string_transinformation,string_irr});
      title(sprintf('Total entropy'));
      hndl=legend('EQ: Equivocation','TI: Mutual information', 'IR: Irrelevance');
      set(hndl,'position',get(hndl, 'position')+[0.4 0 0 0]);
          
      subplot(2,2,3);
      pie([entr([6 4],1);1E-10]'/entr(1,1),{string_rueck,string_transinformation,''});
      title(sprintf('Input entropy (%s)',deblank(dorgbez(ind_merkmal,:))));
      
      subplot(2,2,4);
      pie([1E-10;entr([4 5],1)]'/entr(2,1),{'',string_transinformation,string_irr});
      title(sprintf('Output entropy (%s)',classname));
   end;   
end;
