  function [erg,zeit]=myxcorr(d,plotoption,time,erg,zeit,ta,scaling_type)
% function [erg,zeit]=myxcorr(d,plotoption,time,erg,zeit,ta,scaling_type)
%
% d zweispaltige Datenmatrix, plotoption=1 mit plot (optional), nur über time Abtastschritte (optional), sonst time=[]
% wenn Argumente erg, zeit (optional, sonst []) übergeben werden, wurde Ergebnis bereits berechnet -> nur Visualisierung
% ta - Abtastzeit (optional) beeinflusst nur Visualisierung
% z.B. d=rand(2000,5);d(3:2000,5)=d(3:2000,5)+d(1:1998,1);figure;[erg,zeit]=myxcorr(d(:,[1 5]),1,100)
% 
%
% The function myxcorr is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<7
    scaling_type = 'unbiased';
end;
if nargin<6 || isempty(ta)
    ta=1;
end;
if nargin<4
    erg=[];
    zeit=[];
end;
if nargin<3
    time=[];
end;
if (nargin<2)
    plotoption=1;
end;


if isempty(erg)
    
    if ~isempty(strfind(scaling_type,'_mean'))
        
        d(:,1)=(d(:,1)-mean(d(:,1)));
        d(:,2)=(d(:,2)-mean(d(:,2)));
        %delete mean at the end
        scaling_type = scaling_type(1:length(scaling_type)-5);
    end;
    
    if ~isempty(strfind(scaling_type,'_detrend'))
        d(:,1)=detrend(d(:,1));
        d(:,2)=detrend(d(:,2));
        %delete mean at the end
        scaling_type = scaling_type(1:length(scaling_type)-8);
    end;
   
    if strcmp(scaling_type,'coeff_local')
        %remove mean values and standardize - all other things handled by
        %MATLAB option biased
        a=(d(:,1)-mean(d(:,1)));
        b=(d(:,2)-mean(d(:,2)));
        a=a./std(a,1);
        b=b./std(b,1);
        scaling_type = 'biased';
    else
        %let the original MATLAB function work
        a=d(:,1);
        b=d(:,2);
    end;
    
    
    if ~isempty(time)
        time=min(time,size(a,1)-1);
        [erg,zeit]=xcorr(a,b,time,scaling_type);
    else
        [erg,zeit]=xcorr(a,b,scaling_type);
    end; %if ~isempty(time)
    %Abtastzeit
    zeit=zeit*ta;
end;  %if isempty(erg)

if plotoption
    plot(zeit,erg);
    xlabel('Time shift');
    ylabel('Cross correlation function');
    ax=axis;
    if strcmp(scaling_type,'coeff')
        axis([ax(1:2) -1.05 1.05]);
    end;
    grid on;
end;
