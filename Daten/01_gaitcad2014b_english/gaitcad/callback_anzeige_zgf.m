  function callback_anzeige_zgf(d_org,code,var_bez,dorgbez,parameter,par,merkmalsextraktion,fuzzy_system,mode_merkmale,mode_zgf)
% function callback_anzeige_zgf(d_org,code,var_bez,dorgbez,parameter,par,merkmalsextraktion,fuzzy_system,mode_merkmale,mode_zgf)
%
% The function callback_anzeige_zgf is part of the MATLAB toolbox Gait-CAD. 
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

if mode_merkmale==1
   %Originale Merkmale
   ind_alle_merkmale=parameter.gui.merkmale_und_klassen.ind_em;
else
   %Über alle aggregierten Merkmale
   ind_alle_merkmale=1:size(merkmalsextraktion.phi_aggregation,2);
   
   %hier dorgbez erst aufstellen!
   dorgbez=char(fuzzy_system.dorgbez_all);   
end;

for ind_merkmal=ind_alle_merkmale
   
   %neues Bild 
   if parameter.gui.anzeige.aktuelle_figure 
      f=gcf;
   else
      f=figure;
   end;
   
   %erstmal ZGFs plotten%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %Originale Merkmale
   d_intern=d_org(:,ind_merkmal);
   
   
   %gibt es passende entworfene ZGFs? 
   if ~isempty(fuzzy_system)
      ind_zgf=find(fuzzy_system.indr_merkmal==ind_merkmal);
   else 
      ind_zgf=[];        
   end;
   
   %wenn ja raussuchen, wenn nein neu entwerfen
   if ~isempty(ind_zgf)
      zgf_temp=fuzzy_system.zgf(ind_zgf,:);
      zgf_temp_name=fuzzy_system.zgf_bez([ind_zgf end],:);
   else         
      [zgf_temp,zgf_temp_name]=zgf_en(d_intern,parameter.gui.klassifikation.fuzzy_system,par);
      zgf_temp=zgf_temp(1,1:parameter.gui.klassifikation.fuzzy_system.anz_fuzzy);
      zgf_temp_name=zgf_temp_name(1,:);
   end;
   
   if (length(zgf_temp)<2)
      mywarning('There exist only one term resp. membership function. A visualization is impossible.');
      return;
   end;
   
   %ZGF reinplotten
   if mode_zgf~=3
      %nur die ZGF 
      f=plklzgf(zgf_temp,1,deblank(dorgbez(ind_merkmal,:)),zgf_temp_name(1,:),[min(d_intern) max(d_intern)],f);
   else
      %spezielle Funktion für ZGF und Klassenhistogramm
      if (length(d_intern)<2)
         mywarning('The displayed feature needs at least data points for a histogram.');
         return;
      end;
      
      plothist(d_intern,code,char(dorgbez(ind_merkmal,:),var_bez(end,:)),zgf_temp_name,zgf_temp,f,parameter.gui.anzeige);
   end;   
   
   
   
   if mode_zgf==2
      
      if (length(d_intern)==1)
         mywarning('The displayed feature needs at least data points for a histogram.');
         return;
      end;
      
      %Histogramme
      zoom on;
      %auf Bild umschalten
      f=figure(f);
      
      %Histogramm einzeichnen
      hold on;
      if parameter.gui.anzeige.histauto == 1
         [tmp1,tmp2]=hist(d_intern,min(100,ceil(size(d_intern,1)/5)));
      else
         [tmp1,tmp2]=hist(d_intern,parameter.gui.anzeige.histvalue);
      end;
      
      bar(tmp2,tmp1/max(tmp1));
      zoom on;
   end;
end;


