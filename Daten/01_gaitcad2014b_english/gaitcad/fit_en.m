  function fit_return = fit_en(d,ykont,kp)
% function fit_return = fit_en(d,ykont,kp)
%
% 
% 
% design of curve fit fuunction using the MATLAB command fit
% 
% cflibhelp spline documentation about all fit arguments such as
% 'cubicspline'...
%
% The function fit_en is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

fit_return =  [];

%Check for NaN and Inf
if ~isempty(find(isnan(ykont))) || ~isempty(find(isinf(ykont))) || ~isempty(find(isnan(d))) || ~isempty(find(isinf(d)))
    mywarning('Dataset consist not only of numbers');
    return;
end;
%case weibull                   2D & int & no neg x
%case exp                       2D & int
%case fourier                   2D & int
%case gauss                     2D & int peak fitting
%case cubicinterp               2D 3D & no int
%case pchipinterp               2D & no int
%case biharmonicinterp          3D & int
%case poly                      2D 3D & int
%case power                     2D & int & no neg x
%case rat                       2D & int
%case sin1                      2D & int
%case cubicspline               2D & no int
%case smoothingspline           2D & int
%case lowess                    3D & int
%case splineinterp              3D ???

switch kp.fit % Matlab function fit
    % Spline models are only supported for curve fitting, not for surface fitting
    
    % case 1 interpolation & 2D
    case {'weibull', 'exp1', 'exp2',...
            'fourier1','fourier2','fourier3','fourier4','fourier5','fourier6','fourier7','fourier8',...
            'gauss1','gauss2','gauss3','gauss4','gauss5','gauss6','gauss7','gauss8',...
            'poly1','poly2','poly3','poly4','poly5','poly6','poly7','poly8','poly9',...
            'power1','power2',...
            'rat01','rat02','rat03','rat04','rat05','rat11','rat12','rat13','rat14','rat15',...
            'rat21','rat22','rat23','rat24','rat25','rat31','rat32','rat33','rat34','rat35',...
            'rat41','rat42','rat43','rat44','rat45','rat51','rat52','rat53','rat54','rat55',...
            'sin1','sin2','sin3','sin4','sin5','sin6','sin7','sin8',...
            'smoothingspline'}
        
        if size(d,2)~=1 %error message (dimensions)...
            mywarning('Function only works for one-dimensional input variables!');
            return;
        end;
        
        if max(strcmp(kp.fit,{'weibull','power1','power2'})) %error message negative numbers
           ind_pos = find(d>0);
           if length(ind_pos) < length(d)
               mywarning('Non-positive values will be ignored!');
               d = d(ind_pos);
               ykont = ykont (ind_pos);
           end;
        end;
        
        try
            fit_return = fit(d,ykont,kp.fit);
        catch
            mywarning('Internal error of the Matlab function fit!');
            return;
        end;
        
        
        % case 2 no interpolation and 2D
    case {'cubicspline', 'pchipinterp','splineinterp'}
        if size(d,2)~=1 %error message (dimensions)...
            mywarning(strcat('Function only works for one-dimensional input variables.','Dataset will not be computed!'));
            return;
        end;
        
        %interpolation works only with distinct values
        [tmp,ind_unique] = unique(d);
        tmp = length(d)-length(tmp);
        
        if length(tmp) ~= length(d)
            mywarning(['Function can assign only one y-value to one x-value.' 'Double values will be deleted!' ' ' int2str(tmp)...
                ' data points remain of  ' int2str(length(d))]);
        end;
        
        try
            fit_return = fit(d(ind_unique,:),ykont(ind_unique),kp.fit);
        catch
            mywarning('Internal error of the Matlab function fit!');
            return;
        end;
        
        % case 4 no interpolation 2D and 3D
    case 'cubicinterp'
        if size(d,2)>2 %error message (dimensions)...
            mywarning(['Function only works for one- and two-dimensional input variables.' ' ' 'Dataset will not be computed!']);
            return;
        end;
        
        %interpolation works only with distinct values
        [tmp,ind_unique] = unique(d);
        tmp = length(d)-length(tmp);
        
        if length(tmp) ~= length(d)
            mywarning(['Function can assign only one y-value to one x-value.' ' ' 'Double values will be deleted!' int2str(tmp)...
                ' data points remain of  ' int2str(length(d))]);
        end;
        
        try
            % fit(x-coordinates or x/y-coordinates(2D), y or z coordinates, Fittype)
            fit_return = fit(d(ind_unique,:),ykont(ind_unique),kp.fit);
        catch
            mywarning('Internal error of the Matlab function fit!');
            return;
        end;
        
        % case 5 interpolation 3D
    case {'biharmonicinterp','lowess','loess','poly11','poly12','poly13','poly14','poly15',...
            'poly21','poly22','poly23','poly24','poly25','poly31','poly32','poly33','poly34','poly35',...
            'poly41','poly42','poly43','poly44','poly45','poly51','poly52','poly53','poly54','poly55'}
        if size(d,2)~=2 %error message (dimensions)...
            mywarning(strcat('Function only works for two-dimensional input variables.',' Dataset will not be computed!'));
            return;
        end;
        
        try
            fit_return = fit(d,ykont,kp.fit);
        catch
            mywarning('Internal error of the Matlab function fit!');
            return;
        end;
        
    otherwise
        mywarning('No regression model found');
end;