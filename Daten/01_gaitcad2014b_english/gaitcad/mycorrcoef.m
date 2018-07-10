  function [sigma,sigma_p,N_p]=mycorrcoef(dat,corr_type)
% function [sigma,sigma_p,N_p]=mycorrcoef(dat,corr_type)
%
% 
% 
%
% The function mycorrcoef is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<2 || isempty(corr_type)
   corr_type = 'Pearson';
end;

persistent warnstatus;

%leer vordefinieren
sigma  =eye(size(dat,2));
sigma_p=eye(size(dat,2));

%gibt es Nan's oder identische Spalten?
ind=find( std(dat)~=0 & all(~isnan(dat)) ); % Coderevision: &/| checked!

%wenn ja, Warnung ausgeben
if isempty(warnstatus) && length(ind)<size(dat,2)
   mywarning('Problems during correlation analysis (all values are equal or at least one NaN element). This warning will be only displayed once.');
   warnstatus=1;
end;

try
   %MATLAB NaN handling
   [sigma,sigma_p] = corr(dat,'type',corr_type,'rows','pairwise');
   
catch
   
   %try manual version if errors occur
   
   if length(ind)==size(dat,2)
      %für saubere Spalten Ergebnisse eintragen
      [sigma,sigma_p] = corr(dat,'type',corr_type);
   else
      if ~isempty(ind)
         [sigma(ind,ind),sigma_p(ind,ind)]=corr(dat(:,ind),'type',corr_type);
      end;
      for i=1:size(dat,2)-1
         if rem(i,20) == 1
            fprintf('%d of %d\n',i,size(dat,2));
         end;
         for j=i+1:size(dat,2)
            %look for not-NaN data points
            if ~all(ismember([i,j],ind))
               ind_nonan = find(all(~isnan(dat(:,[i,j])),2));
               if length(ind_nonan)>1 && std(dat(ind_nonan,j))~=0 && std(dat(ind_nonan,i))~=0
                  %compute correlation coefficient only for these data points
                  %if no data points found, that result remains to zero
                  [temp,temp_p] = corr(dat(ind_nonan,[i j]),'type',corr_type);
                  sigma(i,j) = temp(1,2);
                  sigma(j,i) = temp(1,2);
                  
                  sigma_p(i,j) = temp_p(1,2);
                  sigma_p(j,i) = temp_p(1,2);
               else
                  sigma(i,j) = NaN;
                  sigma(j,i) = NaN;
                  
                  sigma_p(i,j) = 1;
                  sigma_p(j,i) = 1;
               end;
            end;
         end;
      end;
   end;
end



