% Script callback_kurzzeit_kkf
%
% Berechnet und plottet kurzzeit Kreuzkorrelationsfunktionen für ausgewählte Zeitreihen
% 
% ind_auswahl gibt die ausgewählten Datentupel an.
% Warnung, falls viele Datentupel angezeigt werden sollen
%
% The script callback_kurzzeit_kkf is part of the MATLAB toolbox Gait-CAD. 
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

parts_step=parameter.gui.zeitreihen.fenstergroesse; 

% Für jeden ausgewählten Datentupel
for ds = ind_auswahl'
   %Matrizen vorbereiten 
   xc_parts.erg=zeros(1,(round(size(d_orgs,2)/parts_step)-1),2*parts_step-1);
   xc_parts.zeit=xc_parts.erg;
   xc_parts=[];
   ij=0;
   
   for i=zr_i 
      for j=zr_j
         %Kombination Zeitreihe i - Zeitreihe j
         ij=ij+1;   
         
         anz_fenster=(round(size(d_orgs,2)/parts_step)-1);
         if anz_fenster<2 
            myerror(sprintf('The time series are too short for a short-time analysis with window length %d',parts_step));
         end;
         
         
         for k=1:anz_fenster 
            %Sample in der Mitte des KKF-Fensters
            xc_parts.basissample(k) = round((k-0.5)*parts_step);
            
            %eigentliche KKF berechnen
            [xc_parts.erg(ij,k,:),xc_parts.zeit(ij,k,:)]=myxcorr(squeeze(d_orgs(ds, (k-1)*parts_step+[1:parts_step],[i j])), 0, [], [], [], ta,parameter.gui.statistikoptionen.scaleopt_type_text);
         end; % for k
         
         
         %die Werte braucht man, weil surf die Rechtecke nicht mittig einzeichnet
         diff_t_zeit=xc_parts.zeit(1,1,2)-xc_parts.zeit(1,1,1);
         diff_t_basissample=(xc_parts.basissample(2)-xc_parts.basissample(1))*ta;
         
         %Korrelationswerte einzeichnen 
         plot_korrmatrix((squeeze(xc_parts.erg(ij,:,:)))',0,xc_parts.basissample*ta-diff_t_basissample/2, xc_parts.zeit(1,1,:)-diff_t_zeit/2);
         
         
         if (zr_i == zr_j)
            name = sprintf('%d: Short-time auto correlation function data point %d, %s', get_figure_number(gcf),ds, deblank(var_bez(zr_i,:)));
            ylabel('Short-time auto correlation function');
         else
            name = sprintf('%d: Short-time Cross Correlation Function data point %d, %s - %s', get_figure_number(gcf),ds, deblank(var_bez(zr_i,:)), deblank(var_bez(zr_j,:)));
         end;
         set(gcf, 'Name', name, 'NumberTitle', 'off');
         xlabel(['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']']);
         ylabel(['Time shift [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']']);
         shading flat;                              
      end; % for j
   end; % for i  
   
end; % for ds

disp('Ready...');

