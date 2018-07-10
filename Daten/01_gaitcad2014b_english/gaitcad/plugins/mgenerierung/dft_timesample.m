  function [coeff, app] = dft_timesample (x, wl, max_level, plot_details, plot_apps, compare_to_matlab)
% function [coeff, app] = dft_timesample (x, wl, max_level, plot_details, plot_apps, compare_to_matlab)
%
%  calculates dft for each level and each time sample
% 
%  x:     Signal
%  wl: kind of wavelet to use, i.e. 'db4' for Daubechies 4, see also wavefiltercoeff.m
%  max_level: maximum level of decomposition
%  plot_details:
%  plot_apps:
%  compare_to_matlab:
% 
%  Examples for testsignals:
%  x=[sin(0.1*[1:500]) sin(0.3*[1:500])];                                                                      frequency step
%  x=[sin(0.1*[1:500]) sin(0.3*[1:500])]; x(300)=10;                                                       frequency step + peak
%  x=[sin(0.1*[1:500])+0.001*[1:500] sin(0.1*[501:1000])+0.5-0.001*[501:1000]];                ramp
%  x = [sin(0.1*[1:1000])].*[ones(1,300) 1.0025:0.0025:2 2.*ones(1,300)];                              amplitude changing
%  x=[sin(0.6*[1:1500]) + sin(0.05*[1:1500])+ sin(0.3*[1:1500])];                                                                      frequency step
% 
%
% The function dft_timesample is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

if nargin<6
   compare_to_matlab=0;
end;
if nargin<5
   plot_apps=0;
end;
if nargin<4
   plot_details=0;
end;
if nargin<3
   max_level=5;
end;
if nargin<2
   wl='db1';
end;

[lo_d,hi_d]= wavefiltercoeff(wl);

num_coef=length(lo_d);
app=zeros(max_level+1,length(x));			% contains original app(1,:) and low-pass-filtered signals app(level+1,:)  	Problem in c++ - implementation
coeff=zeros(max_level+1, length(x));		% contains original coeff(1,:) and high-pass-filtered signals coeff(level+1,:) 	Problem in c++ - implementation

% for each time sample
for i=1:length(x)
   app(1,i)=x(i); coeff(1,i)=x(i);
   
   %[app, coeff] = calc_new (app, coeff, max_level, num_coef, lo_d, hi_d, i);
   %[app, coeff] = calc_frame (app, coeff, max_level, num_coef, lo_d, hi_d, i);
   for level=1:max_level
      [app, coeff] = calc(app, coeff, level, num_coef, lo_d, hi_d, i);
   end;
end;

% plot details
if plot_details
   figure; title('details');
   for i = 1: max_level+1
      subplot(max_level+1,1,i); plot(coeff(i,:)'); hold on;
   end;
end;

% plot coefficients from wavedec (MATLAB-Toolbox is needed)
if compare_to_matlab
   [c,l] = WAVEDEC(x,max_level,wl);
   for i=1:max_level
      tmp = (detcoef(c,l,i));
      subplot(max_level+1,1,i+1); hold on;
      plot(2^i-1+[1:2^i:length(tmp)*2^i],tmp, 'r.'); % time shift for causal algorithm: 2^level-1
   end;
end;

% plot approximations
if plot_apps
   figure; title('approximations');
   for i = 1: max_level+1
      subplot(max_level+1,1,i); plot(app(i,:)'); hold on;
   end;
end;

coeff=coeff';
app=app';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tmp, coeff] = calc(tmp, coeff, level, num_coef, lo_d, hi_d, i)

tmp2=zeros(num_coef,1);
for j=1:num_coef			% tmp2: Vector for filter calculation a'x
   
   sample = (j-1)*2^(level-1);		% contains time samples to use
   if i > sample
      tmp2(j)= tmp(level, i-sample);	% if we have enough i's
   else
      tmp2(j)=0;							% otherwise intitialize with 0
   end;
end;
tmp(level+1, i)=lo_d*tmp2;
coeff(level+1, i)=hi_d*tmp2;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions underneath are not used but work in another way and give back same results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tmp, coeff] = calc_new (tmp, coeff, max_level, num_coef, lo_d, hi_d, i)

%	Anzahl der benötigten Tupel
j=1:max_level; tmp_num = sum((num_coef-1)*2.^(max_level-j))+2^(max_level-1);
hilf=tmp(1,i:-1:i-tmp_num+1)';  % Achtung mit Index i


for num_level=1:max_level
   for k = 1:length(hilf)-num_coef+1
      tmp_neu(k)=lo_d*hilf(k:k+num_coef-1);
   end;
   coeff(num_level+1,i)=hi_d*hilf(1:num_coef);
   hilf=tmp_neu(1:2:length(tmp_neu))'; 
   clear tmp_neu;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tmp, coeff] = calc_frame (tmp, coeff, max_level, num_coef, lo_d, hi_d, i)

%	Anzahl der benötigten Tupel
j=1:max_level;
tmp_num = sum((num_coef-1)*2.^(max_level-j))+2^(max_level-1);

if mod(i,tmp_num)==0
   
   hilf=tmp(1,i:-1:i-tmp_num+1)';  % enthält die zu filternden Datentupel
   
   for num_level=1:max_level
      for k = 1:length(hilf)-num_coef+1
         tmp_neu(k)=lo_d*hilf(k:k+num_coef-1);
      end;
      coeff(num_level+1,i)=hi_d*hilf(1:num_coef);
      hilf=tmp_neu(1:2:length(tmp_neu))'; 
      clear tmp_neu;
   end;
end;




