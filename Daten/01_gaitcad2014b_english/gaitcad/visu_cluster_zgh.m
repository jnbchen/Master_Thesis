  function visu_cluster_zgh(cluster_ergebnis,parameter_anzeige,ind_auswahl,mode,code_org)
% function visu_cluster_zgh(cluster_ergebnis,parameter_anzeige,ind_auswahl,mode,code_org)
%
% zeichnet die Cluster-Zugehörigkeiten
%
% The function visu_cluster_zgh is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(cluster_ergebnis)
   return;
end;


u_opt=cluster_ergebnis.cluster_zgh;

if parameter_anzeige.aktuelle_figure==0 || gcf==1
   figure;
end;

if nargin<3 || isempty(ind_auswahl)
   %im Regelfall nach Clustern sortiert über Datentupel...
   ind_auswahl=1:size(u_opt,1);
end;

[clust_farb,plot_style]=color_style;

switch mode
   
   case 1
      %nicht mit originalen DS-Nummern anzeigen, sondern sortiert nach Cluster-Reihenfolge
      set(gcf,'numbertitle','off','name',[sprintf('%d: ',get_figure_number(gcf)) 'Cluster memberships (sorted by clusters)']);
      [tmp,code]=max(u_opt');
      [tmp,ind]=sort(code);
      code=code(ind)';
      u_opt=u_opt(ind,:);
   case 2
      set(gcf,'numbertitle','off','name',[sprintf('%d: ',get_figure_number(gcf)) 'Cluster memberships (sorted by data points)']);
   case 3
      %hierarchical cluster visualization using dendrograms
      [myhandle,mydatapoint] = dendrogram(cluster_ergebnis.linkage,0);
      hold on;
      set(gcf,'numbertitle','off','name',[sprintf('%d: ',get_figure_number(gcf)) 'Dendrogram']);
           
      %reindexing to data point numbers
      set(gca,'xticklabel',num2str(cluster_ergebnis.ind_auswahl(str2num(get(gca,'xticklabel')))));
      
      %add symbols/colors for the selected output variable
      label_code   = str2num(get(gca,'xticklabel'));
      for i_symbol = 1:length(label_code)
         ha_star = plot(i_symbol,0,'k*');
         
         %color or symbol
         if parameter_anzeige.anzeige_grafiken~=3
            set(ha_star,'color',clust_farb(1+rem(code_org(label_code(i_symbol))-1,size(clust_farb,1)),:));
         else
            set(ha_star,'marker',plot_style(1+rem(code_org(label_code(i_symbol))-1,size(clust_farb,1))));
         end;
      end;
      
      %rescale axis (otherwise 0 is clipped)
      ax = axis;
      axis([ax(1:2) 0 ax(4)]);
      return;
end;

zgh_bar=bar(ind_auswahl,abs(u_opt),'stack');


% nun noch die entsprechenden Farben der Clusterzentren übernehmen:
for i=1:size(u_opt,2) % Es sollten jo so viele unterschiedliche Balken (ZGH) wie Cluster-Zentren geben!
   set(zgh_bar(i),'edgecolor',clust_farb(1+rem(i-1,size(clust_farb,1)),:));
   set(zgh_bar(i),'facecolor',clust_farb(1+rem(i-1,size(clust_farb,1)),:));
end;

axis([ 1 max(ind_auswahl) -0.05 1.3	]);

temp=sprintf('''%s'',',cluster_ergebnis.newtermname.name);
eval(sprintf('legend(%s);',temp(1:length(temp)-1)));
xlabel('Data points');
ylabel('Cluster memberships');
if (mode==1)
   ind_kl_wechsel=find(diff(code));
   if ~isempty(ind_kl_wechsel)
      x_linie=ones(2,1)*ind_kl_wechsel'+0.5; % wenn verschiedene Ausgangsklassen vorhanden, dann zeichne vertikale Linie
   else
      x_linie=ones(2,1)*0.5; % sonst zeichne nur eine am Anfang
   end;
   y_linie=[-0.1; 1.1]*ones(1,size(x_linie,2));
   line(x_linie,y_linie,'LineWidth',0.2,'color','k');
   %axis tight;
   colormap(clust_farb(1:min(size(clust_farb,1),size(u_opt,2)),:));
   
   %dann zeichne zgf_y_bez mit ins Bild
   x_linie=[ 0 x_linie(1,:) length(code) ];
   ind_kl_wechsel=[1;ind_kl_wechsel+1];
   for i=1:length(ind_kl_wechsel)
      tmp=ind_kl_wechsel(i);
      text( x_linie(i)+(x_linie(i+1) - x_linie(i))./2 , 1.05 ,num2str(code(tmp)),'HorizontalAlignment','center','rotation',90);
   end;
end;

