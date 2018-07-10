% Script spectrogram_pca
%
% The script spectrogram_pca is part of the MATLAB toolbox Gait-CAD. 
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

hidden_option_project = 0;

for i_data_point=1:size(spect,1)
   for i_multispect=1:size(spect,2)
      fenster_name_merkmale_dt = ['_' deblank(param_spect.var_bez(i_multispect,:))];
      if size(spect,1)>1
         fenster_name_merkmale_dt = [ fenster_name_merkmale_dt sprintf('_DT_%d',param_spect.ind_auswahl(i_data_point))];
      end;
      
      
      %compute principal components from a given spectrum
      [l,hkvp,sigma,hkv]=hauptk_ber(spect{i_data_point,i_multispect,1}',0);
      
      %plot eigenvectors
      figure;
      hold on;
      yticklabel_text='';
      plot([0 max(spect{i_data_point,i_multispect,2})],[0 0]);
      for i=1:parameter.gui.zeitreihen.num_pca_spect
         %prefer positive eigenvectors
         if mean(l(:,i))<0
            l(:,i) = -l(:,i);
         end;   
         stairs(spect{i_data_point,i_multispect,2},2*i+l(:,i)/max(abs(l(:,i)))-1);  
         plot([0 max(spect{i_data_point,i_multispect,2})],2*[i i]);
         plot([0 max(spect{i_data_point,i_multispect,2})],2*[i i]-1,':');
         yticklabel_text=strvcatnew(yticklabel_text,['EV' num2str(i)]);
      end;
      set(gca,'ytick',[1:2:2*parameter.gui.zeitreihen.num_pca_spect]);
      set(gca,'yticklabel',yticklabel_text);
      axis([0 max(spect{i_data_point,i_multispect,2}) 0 2*parameter.gui.zeitreihen.num_pca_spect]);
      xlabel('Frequency');
      %ylabel('Ratio of eigenvectors');
      set(gcf,'numbertitle','off','name',[sprintf('%d: Eigenvector vs. Frequency',get_figure_number(gcf)) fenster_name_merkmale_dt ]);
      
      %plot eigenvectors
      figure;
      subplot(2,1,1);
      bar(100*hkvp);
      xlabel('Number of the eigenvalue');
      ylabel('Percentage');
      subplot(2,1,2);
      bar(cumsum(100*hkvp));
      xlabel('Number of the eigenvalue');
      ylabel('Cummulated percentage');
      set(gcf,'numbertitle','off','name',[sprintf('%d: Percentage eigenvalues',get_figure_number(gcf)) fenster_name_merkmale_dt]);
      
      %plot eigenvectors
      %figure;
      %imagesc(spect{i_data_point,i_multispect,2},1:parameter.gui.zeitreihen.num_pca_spect,sqrt(abs(l(:,1:parameter.gui.zeitreihen.num_pca_spect)))');
      %view(2)
      %xlabel('Frequency');
      %ylabel('Ratio of eigenvectors');
      %set(gcf,'numbertitle','off','name',sprintf('%d: Eigenvector vs. Frequency',get_figure_number(gcf)));
      
      
      %plot eigenvalues vs. time
      figure;
      hold on;
      yticklabel_text='';
      plot([0 max(spect{i_data_point,i_multispect,2})],[0 0]);
      temp_aggregation = filter(1-parameter.gui.zeitreihen.iirfilter,[1 -parameter.gui.zeitreihen.iirfilter],spect{i_data_point,i_multispect,1}'*l(:,1:parameter.gui.zeitreihen.num_pca_spect));
      for i=1:parameter.gui.zeitreihen.num_pca_spect
         stairs(spect{i_data_point,i_multispect,3},2*(i-1)+2*matrix_normieren(temp_aggregation(:,i),2));  
         plot([0 max(spect{i_data_point,i_multispect,3})],2*[i i]);
         plot([0 max(spect{i_data_point,i_multispect,3})],2*[i i]-1,':');
         yticklabel_text=strvcatnew(yticklabel_text,['Aggr.' num2str(i)]);
      end;
      set(gca,'ytick',[1:2:2*parameter.gui.zeitreihen.num_pca_spect]);
      set(gca,'yticklabel',yticklabel_text);
      axis([0 max(spect{i_data_point,i_multispect,3}) 0 2*parameter.gui.zeitreihen.num_pca_spect]);
      xlabel('Time');
      set(gcf,'numbertitle','off','name',[sprintf('%d: Aggregated features vs. Time',get_figure_number(gcf)) fenster_name_merkmale_dt]);  
      
   end;
end;

if hidden_option_project
   save_spectrogram_pca(kuerze_zeitreihen(d_orgs, parameter.gui.zeitreihen.fenstergroesse/2, 'mean'),var_bez,temp_aggregation,parameter);   
end;

clear temp_aggregation
