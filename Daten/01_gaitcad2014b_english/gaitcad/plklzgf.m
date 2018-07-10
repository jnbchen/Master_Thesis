  function f=plklzgf(zgf,i,var_bez,zgf_bez,grenzen,f)
% function f=plklzgf(zgf,i,var_bez,zgf_bez,grenzen,f)
%
% plottet Zugehörigkeitsfunktionen der i-ten Eingangsgröße
%
% The function plklzgf is part of the MATLAB toolbox Gait-CAD. 
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

ind=find(diff(zgf(i,:))<0);
if (ind) 
   zgf=zgf(:,1:ind(1));
else  
   ind=size(zgf,2);   
end;

if (nargin<4) || isempty(zgf_bez)  
   tmp_zgf=sprintf('''Term %d'',',1:size(zgf,2));
   eval(sprintf('tmp_zgf=char(%s);',tmp_zgf(1:length(tmp_zgf)-1)));
else       
   tmp_zgf=char(zgf_bez(i,1:ind(1)).name);
end;

if (nargin<3) 
   var_bez=sprintf('%d. feature',i);
else       
   var_bez=var_bez(i,:);
end;

if (nargin<5) || isempty(grenzen)
   grenzen=[min(zgf(i,:)),max(zgf(i,:))];
else       
   grenzen=[min([zgf(i,:) grenzen(1)]),max([zgf(i,:) grenzen(2)])];      
end;

if (nargin<6) 
   f=figure;
end;
plotzgf(zgf(i,:),gcf,grenzen(1),grenzen(2),1.2,tmp_zgf,var_bez,'MBF');

set(gcf,'numbertitle','off','name',sprintf('%d: MBF %s',get_figure_number(gcf),var_bez));      