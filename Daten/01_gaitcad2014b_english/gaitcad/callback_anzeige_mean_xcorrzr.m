% Script callback_anzeige_mean_xcorrzr
%
% Zeigt die berechneten gemittelten Korrelationskoeffizienten an
%
% The script callback_anzeige_mean_xcorrzr is part of the MATLAB toolbox Gait-CAD. 
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

if parameter.gui.anzeige.figures_korr == 0
   return;
end;

if ~exist('mcxcoeff', 'var') || ~isfield(mcxcoeff, 'mcxcorr')
   myerror('Error! No correlation coefficients found!');
   return;
end;


warnstatus=0;
% Über DS gemittelt?
if (length(mcxcoeff) == 1)
   for i = 1:size(mcxcoeff.mcxcorr,1)
      for j = i:size(mcxcoeff.mcxcorr,2)
         werte=squeeze(mcxcoeff.mcxcorr(i, j, :));
         if any(isnan(werte))
            warnstatus=1;
         end;
         
         if ~any(isnan(werte)) && any(werte)            
            f = figure;
            if strcmp(mcxcoeff.bez(i,:),mcxcoeff.bez(j,:))
               name = sprintf('%d: Auto correlation function %s (mean for data points)', get_figure_number(f), deblank(mcxcoeff.bez(i,:)));
               title_str = sprintf('ACF %s (mean for selected data points)', deblank(mcxcoeff(1).bez(i,:)));
               ylabel_str = 'Auto correlation function (ACF)';
            else
               name = sprintf('%d: Cross correlation function %s / %s (mean for data points)', get_figure_number(f), deblank(mcxcoeff.bez(i,:)), deblank(mcxcoeff.bez(j,:)));
               title_str = sprintf('CCF %s / %s  (mean for selected data points)', deblank(mcxcoeff(1).bez(i,:)), deblank(mcxcoeff(1).bez(j,:)));
               ylabel_str = 'Cross correlation function';
            end;
            plot(mcxcoeff.zeit,werte );
            set(f, 'Name', name, 'NumberTitle', 'off');
            set(gca, 'XGrid', 'on', 'YGrid', 'on');
            title(title_str);
            ylabel(ylabel_str);
            xlabel(['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']']);
         end;
         
      end;
   end;
else
   %über Klassen gemeittelt? 
   for i = 1:size(mcxcoeff(1).mcxcorr,1)
      for j = i:size(mcxcoeff(1).mcxcorr,2)
         werte=squeeze(mcxcoeff(1).mcxcorr(i, j, :));
         if any(isnan(werte))
            warnstatus=1;
         end;         
        if ~any(isnan(werte)) && any(werte)            
            f = figure;
            if strcmp(mcxcoeff(1).bez(i,:),mcxcoeff(1).bez(j,:))
               name = sprintf('%d: ACF %s über %s gemittelt', get_figure_number(f), deblank(mcxcoeff(1).bez(i,:)), deblank(mcxcoeff(1).bez_code));
               title_str = sprintf('ACF %s (mean for %s)', deblank(mcxcoeff(1).bez(i,:)), deblank(mcxcoeff(1).bez_code));
               ylabel_str = 'Auto correlation function (ACF)';
            else
               name = sprintf('%d: CCF %s / %s over %s (mean)', get_figure_number(f), deblank(mcxcoeff(1).bez(i,:)), deblank(mcxcoeff(1).bez(j,:)), deblank(mcxcoeff(1).bez_code));
               title_str = sprintf('CCF %s / %s  (mean for %s)', deblank(mcxcoeff(1).bez(i,:)), deblank(mcxcoeff(1).bez(j,:)), deblank(mcxcoeff(1).bez_code));
               ylabel_str = 'Cross correlation function';
            end;
            l = [];
            c = color_style;
            for kl = 1:length(mcxcoeff)
               l_ = plot(mcxcoeff(1).zeit, squeeze(mcxcoeff(kl).mcxcorr(i, j, :))); hold on;
               set(l_, 'Color', c(mod(kl, size(c,1)),:));
               
               l = [l l_];
            end;
            legend(l, char(mcxcoeff(:).zgf_bez));
            title(title_str);
            set(f, 'Name', name, 'NumberTitle', 'off');
            set(gca, 'XGrid', 'on', 'YGrid', 'on');
            ylabel(ylabel_str);
            xlabel(['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']']);
         end;
      end;
   end;
end;

if warnstatus==1
   mywarning('Some Auto and Cross Correlation Functions will not be displayed due to identical values for the complete time series.');
end;
