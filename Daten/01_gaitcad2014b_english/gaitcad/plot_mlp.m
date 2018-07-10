  function plot_mlp(net,newfigure,feature_names_input,feature_names_output,parameter)
% function plot_mlp(net,newfigure,feature_names_input,feature_names_output,parameter)
%
% 
% 
%
% The function plot_mlp is part of the MATLAB toolbox Gait-CAD. 
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

if length(net.layers) == 2
   if nargin<3
      feature_names_input = [];
      feature_names_output = [];
   end;
   
   if nargin<5
      parameter.gui.anzeige.anzeige_grafiken = 1;
   end;
   
   if newfigure==1
      figure;
      set(gcf,'numbertitle','off','name',sprintf('%d: Structure of the MLP net',get_figure_number(gcf)));
   end;
   
   hold off;
   
   place_factor = size(net.IW{1},1)/ size(net.IW{1},2);
   
   %Eingangsschicht zu erster Hidden-Schicht
   for i=1:size(net.IW{1},1)
      for j=1:size(net.IW{1},2)
         ha = plot([0 1],[(j-1)*place_factor+place_factor/2 i-0.5]);
         
         if i==1
            hold on;
            %erstes Neuron mit Marke kennzeichnen
            hb = plot(0,(j-1)*place_factor+place_factor/2,'ko');
            set(hb,'markersize',20,'markerfacecolor',[0 0 0]);
            
         end;
         if ~isempty(feature_names_input)
            text(0,(j-1)*place_factor+place_factor/2,['  ' feature_names_input(j,:)]);
         end;
         int = log(1+abs(net.IW{1}(i,j)))/(1+log(1+abs(net.IW{1}(i,j))));
         if net.IW{1}(i,j)>0
            if parameter.gui.anzeige.anzeige_grafiken == 1
               %grün
               set(ha,'color',[1 1-int 1-int]);
            else
               set(ha,'color',[0 0 0],'linestyle','-','linewidth',3*(1-int));
            end;
            
         else
            if parameter.gui.anzeige.anzeige_grafiken == 1
               %rot
               set(ha,'color',[1-int 1 1-int ]);
            else
               set(ha,'color',[0 0 0],'linestyle',':','linewidth',3*(1-int));
            end;
         end;
         
      end;
   end;
   
   
   %Hidden zu Ausgangsschicht
   %Position berechnen
   place_factor = size(net.LW{2,1},2)/ size(net.LW{2,1},1);
   
   for i=1:size(net.LW{2,1},1)
      for j=1:size(net.LW{2,1},2)
         ha = plot([1 2],[j-0.5 (i-1)*place_factor+place_factor/2]);
         int = log(1+abs(net.LW{2,1}(i,j)))/(1+log(1+abs(net.LW{2,1}(i,j))));
         
         if i==1
            %Neuronen Hiddenschicht mit Marke kennzeichnen
            hb = plot(1,j-0.5,'ko');
            set(hb,'markersize',20,'markerfacecolor',[0 0 0]);
            
         end;
         if j==1
            %Neuronen Ausgangssschicht mit Marke kennzeichnen
            hb = plot(2,(i-1)*place_factor+place_factor/2,'ko');
            set(hb,'markersize',20,'markerfacecolor',[0 0 0]);
            
         end;
         
         if net.LW{2,1}(i,j)>0
            if parameter.gui.anzeige.anzeige_grafiken == 1
               %grün
               set(ha,'color',[1 1-int 1-int]);
            else
               set(ha,'color',[0 0 0],'linestyle','-','linewidth',3*(1-int));
            end;
            
         else
            if parameter.gui.anzeige.anzeige_grafiken == 1
               %rot
               set(ha,'color',[1-int 1 1-int ]);
            else
               set(ha,'color',[0 0 0],'linestyle',':','linewidth',3*(1-int));
            end;
         end;
      end;
   end;
   
   %Namen Ausgangsschicht
   if ~isempty(feature_names_output)
      ha = text(2,(size(net.LW{2,1},1)-1)*place_factor+place_factor/2,[deblank(feature_names_output) ' (Estimation)']);
      set(ha,'HorizontalAlignment','right');
   end;
   
   %Achsenbezeichnungen
   set(gca,'xtick',[0 1 2]);
   set(gca,'xticklabel',char('Input','Hidden','Output'));
   xlabel('Layer');
   set(gca,'ytick',[]);
   set(gca,'yticklabel',[]);
   
   ax= axis;
   
   axis([ax(1)-0.5 ax(2)+0.5 ax(3)-0.5 ax(4)+0.5 ] );
else
   net.view;
end;