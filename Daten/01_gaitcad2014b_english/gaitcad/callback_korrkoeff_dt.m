% Script callback_korrkoeff_dt
%
% The script callback_korrkoeff_dt is part of the MATLAB toolbox Gait-CAD. 
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

tupel = ind_auswahl;
zr 	= parameter.gui.merkmale_und_klassen.ind_zr;
tau   = parameter.gui.zeitreihen.tau;

nr_tupel  = length(tupel);
nr_zr		 = length(zr);
nr_abtast = size(d_orgs,2);

corr_data = zeros(nr_zr, nr_abtast, nr_tupel);
for i = 1:nr_tupel
   corr_data(:, :, i) = squeeze(d_orgs(tupel(i), :, zr))';
end;
[czr, mczr] = corr_zr(corr_data, tau, parameter.gui.statistikoptionen);

if (plot_mode)
   clear names;
   names.axis  = 'Data points';
   if (mode == 1)
      for i = 1:size(czr,3)
         names.title = sprintf('Correlation coefficients data point, TS: %d, time-shift Tau = %d\n', zr(i), tau);
         korrmatrix([], [], 1:nr_tupel, [], squeeze(czr(:, :, i)), names,num2str(tupel));
      end;
   else
      names.title = sprintf('Mean correlation coefficients data point, Time shift: %d\n', tau);
      korrmatrix([], [], 1:nr_tupel, [], mczr, names,num2str(tupel));
   end;
end;

clear corr_data tupel zr nr_tupel nr_zr nr_abtast plot_mode mode names;
