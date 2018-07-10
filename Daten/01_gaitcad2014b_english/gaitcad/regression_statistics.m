  function [fitness_corrcoeff,mean_abs_error,fitness_rel_error] = regression_statistics(regr_plot,f)
% function [fitness_corrcoeff,mean_abs_error,fitness_rel_error] = regression_statistics(regr_plot,f)
%
% 
% 
% compute correlation coefficient true values and estimations
%
% The function regression_statistics is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<2
   f = [];
end;

if isempty(f)
   f = 1;
end;

%compute correlation coefficient true values and estimations 
temp = corrcoef([regr_plot.ydach_regr regr_plot.ytrue_regr]);

if size(temp,2) == 2
   fitness_corrcoeff = temp(1,2);
else
   %anything is wrong...
   fitness_corrcoeff = NaN;
end;

%mean value of absolute error
mean_abs_error = mean(abs(regr_plot.ydach_regr-regr_plot.ytrue_regr));

%fitness (improvement to trivial estimation), similar to Eq. (3.76) in
%Mikut08, but with additional limits [0,1]
fitness_rel_error = min(1,max(0,1-mean(abs(regr_plot.ydach_regr-regr_plot.ytrue_regr))/mean(abs(regr_plot.ytrue_regr-mean(regr_plot.ytrue_regr)))));

%show results 
if regr_plot.anzeige_erg == 1
   fboth(f,'Fitness of regression:\n');
   fboth(f,'Mean absolute value: %g\n',mean_abs_error);
   fboth(f,'Fitness improvement for the mean absolute error to the trivial estimation (0-1): %g\n',fitness_rel_error);
   fboth(f,'Correlation coefficient between true value and estimation: %g\n',fitness_corrcoeff);
   fboth(f,'Coefficient of determination R^2 between true value and estimation: %g\n',(fitness_corrcoeff)^2);
end;



