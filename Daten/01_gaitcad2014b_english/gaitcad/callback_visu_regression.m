% Script callback_visu_regression
%
% Makro mit neuen Bildern?
%
% The script callback_visu_regression is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

if parameter.gui.anzeige.aktuelle_figure
   if gcf~=1
      fig_name=gcf;
   else
      fig_name=figure;
   end;
   newfigureintern=1;
else
   fig_name=figure;
end;
if (~exist('newfigureintern', 'var'))
   newfigureintern = 0;
end;


if parameter.gui.anzeige.show_normalized_and_aggregated == 1 && mode_visu_regression ~= 5
   local_regression_plot_d       = regr_plot.d;
   if isfield(regr_plot,'gitterplot')
      local_regression_gitterplot_d = regr_plot.gitterplot.d;
   else
      local_regression_gitterplot_d = [];
      
   end;
   
   local_var_bez                 = regr_single.merkmalsextraktion.var_bez;
else
   local_regression_plot_d       = regr_plot.d_without_norm_and_aggregation;
   if isfield(regr_plot,'gitterplot')
      local_regression_gitterplot_d = regr_plot.gitterplot.d_without_norm_and_aggregation;
   else
      local_regression_gitterplot_d = [];
   end;
   local_var_bez                 = regr_single.merkmalsextraktion.var_bez_without_norm_and_aggregation;
end;

if ~isempty(regr_plot.ind_auswahl)
   %Einzelmerkmale!!
   mycode = code(regr_plot.ind_auswahl);
   my_ind_auswahl = regr_plot.ind_auswahl;
   my_zgf_y_bez = zgf_y_bez(par.y_choice,:);
else
   mycode = ones(length(regr_plot.ytrue_regr),1);
   my_ind_auswahl = 1:length(regr_plot.ytrue_regr);
   my_zgf_y_bez.name = 'Sample points';
end;

yname = deblank(regr_single.designed_regression.output_name);
yname_schaetzung = [yname ' (Estimation)'];
yname_fehler = [yname ' (Estimation error)'];


if (mode_visu_regression==1)
   %Wahres Ergebnis gegen Schätzung
   pl_2d([regr_plot.ytrue_regr regr_plot.ydach_regr],mycode,1,parameter.gui.anzeige,[],char(yname,yname_schaetzung),my_zgf_y_bez,0,0,[],my_ind_auswahl,[], 0, []);
   ax=axis;
   axis([min(ax([1 3])) max(ax([2 4])) min(ax([1 3])) max(ax([2 4])) ]);
   title(['Correlation coefficient = ', num2str(corr(regr_plot.ytrue_regr, regr_plot.ydach_regr))]);
end;

if (mode_visu_regression==2) || (mode_visu_regression == 3)
   %Eingang gegen Wahres Ergebnis mit Schätzkurve
   if size(local_regression_plot_d,2) == 1
      pl_2d([local_regression_plot_d regr_plot.ytrue_regr],mycode,1,parameter.gui.anzeige,[],char(local_var_bez(1,:),yname),my_zgf_y_bez,0,0,[],my_ind_auswahl,[], 0, []);
      hold on;
      plot(local_regression_gitterplot_d(:,1),regr_plot.gitterplot.ydach_regr);
   end;
   if size(local_regression_plot_d,2) == 2
      pl_2d([local_regression_plot_d regr_plot.ytrue_regr],mycode,1,parameter.gui.anzeige,[],char(local_var_bez(1,:),local_var_bez(2,:),yname),my_zgf_y_bez,0,0,[],my_ind_auswahl,[], 0, []);
      hold on;
      
      %gitterplot muss nicht existieren, da gibt es insebsondere Probleme bei späteren Merkmalstransformationen
      if isfield(regr_plot,'gitterplot')
         surf(reshape(local_regression_gitterplot_d(:,1),regr_plot.gitterplot.anz_gitterpunkte,regr_plot.gitterplot.anz_gitterpunkte),...
            reshape(local_regression_gitterplot_d(:,2),regr_plot.gitterplot.anz_gitterpunkte,regr_plot.gitterplot.anz_gitterpunkte),...
            reshape(regr_plot.gitterplot.ydach_regr,regr_plot.gitterplot.anz_gitterpunkte,regr_plot.gitterplot.anz_gitterpunkte));
         axis('auto');
      end;
   end;
end;

if (mode_visu_regression==5)
   % multidimensional graphic
   
   eingabe.true = check_eingabe_multiD(eingabe);
   if eingabe.true == 0
      myerror(['The data of the macro are incomplete or erroneous.',' ','Please generate a new macro.']);
   end;
   kp.check_eingabe_multi_d = 1;
   callback_regression_an;
   
   
   figure(fig_name);   % because callback_regression_an set Gait-CAD-GUI as current figure
   check_eingabe_multiD(eingabe);
   eingabe.d = local_regression_plot_d;
   eingabe.ytrue = regr_plot.ytrue_regr;
   local_regression_gitterplot_d = regr_plot.gitterplot.d_without_norm_and_aggregation;
   
   
   if eingabe.range_true == 1  % Only the points near the constant parameters are displayed
      for i_gitter = 1:length(eingabe.konst_ind)
         eingabe.d_ind = find(eingabe.d(:,eingabe.konst_ind(i_gitter)) >= eingabe.range(eingabe.konst_ind(i_gitter),1) & ...   % Coderevision: &/| checked!
            eingabe.d(:,eingabe.konst_ind(i_gitter)) <= eingabe.range(eingabe.konst_ind(i_gitter),2)); % Searching for points
         eingabe.d = eingabe.d(eingabe.d_ind,:); % Points that are not in the given range will be deleted
         eingabe.ytrue = eingabe.ytrue(eingabe.d_ind);
         mycode = mycode(eingabe.d_ind);
         my_ind_auswahl = my_ind_auswahl(eingabe.d_ind);
      end;
      if size(eingabe.d,1) ~= 0 % If there are points left -> draw
         fig_name = pl_2d([eingabe.d(:,[eingabe.var1_ind eingabe.var2_ind]) eingabe.ytrue],mycode,1,parameter.gui.anzeige,[],char(local_var_bez(eingabe.var1_ind,:),local_var_bez(eingabe.var2_ind,:),yname),my_zgf_y_bez,0,0,[],my_ind_auswahl,[], 0, []);
         hold on;
      end;
   else % All points are displayed ( maybe doesn't make sense because the Regression is a part of a multidimensional Object and the points are just 3-Dimensional)
      fig_name = pl_2d([local_regression_plot_d(:,[eingabe.var1_ind eingabe.var2_ind]) regr_plot.ytrue_regr],mycode,1,parameter.gui.anzeige,[],char(local_var_bez(eingabe.var1_ind,:),local_var_bez(eingabe.var2_ind,:),yname),my_zgf_y_bez,0,0,[],my_ind_auswahl,[], 0, []);
      hold on;
   end;
   % if the gitterplot exists draw it
   if isfield(regr_plot,'gitterplot')
      if ~isempty(eingabe.var2_ind)
         %2D Output
         surf(reshape(local_regression_gitterplot_d(:,eingabe.var1_ind),regr_plot.gitterplot.anz_gitterpunkte,regr_plot.gitterplot.anz_gitterpunkte),...
            reshape(local_regression_gitterplot_d(:,eingabe.var2_ind),regr_plot.gitterplot.anz_gitterpunkte,regr_plot.gitterplot.anz_gitterpunkte),...
            reshape(regr_plot.gitterplot.ydach_regr,regr_plot.gitterplot.anz_gitterpunkte,regr_plot.gitterplot.anz_gitterpunkte));
         axis('auto');
         ax = axis;
         ax(1:2)  = eingabe.range(eingabe.var1_ind,:);
         ax(3:4)  = eingabe.range(eingabe.var2_ind,:);
         axis(ax);
      else
         %1 D Output
         [temp,ind_temp] = sort(local_regression_gitterplot_d(:,eingabe.var1_ind));
         plot(local_regression_gitterplot_d(ind_temp,eingabe.var1_ind),regr_plot.gitterplot.ydach_regr(ind_temp),'.');
         axis('auto');
         ax = axis;
         ax(1:2)  = eingabe.range(eingabe.var1_ind,:);
         axis(ax);
      end;
   end;
   
   
   clear eingabe % the parameter created by the multiD.makrog
   lock_makro_erzeugen = 0;
end;

if mode_visu_regression == 3 && (size(local_regression_plot_d,2) == 2 )
   view(2);
   colorbar('vert');
end

if (mode_visu_regression==4)
   %Wahres Ergebnis gegen Fehler
   pl_2d([regr_plot.ytrue_regr regr_plot.ytrue_regr-regr_plot.ydach_regr],mycode,1,parameter.gui.anzeige,[],char(yname,yname_fehler),my_zgf_y_bez,0,0,[],my_ind_auswahl,[], 0, []);
   title(['Mean absolute error = ', num2str(mean(abs(regr_plot.ytrue_regr - regr_plot.ydach_regr)))]);
end;

set(fig_name,'numbertitle','off','name',sprintf('%d: Regression result %s vs. %s',get_figure_number(gcf),get(get(gca,'xlabel'),'string'),get(get(gca,'ylabel'),'string')));



clear ax mycode my_ind_auswahl my_zgf_y_bez yname yname_schaetzung mode_visu_regression;


