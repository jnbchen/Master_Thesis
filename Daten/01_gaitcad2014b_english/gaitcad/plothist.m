  function hcl=plothist(d,code,var_bez,zgf_bez,zgf,f,parameter_anzeige)
% function hcl=plothist(d,code,var_bez,zgf_bez,zgf,f,parameter_anzeige)
%
% The function plothist is part of the MATLAB toolbox Gait-CAD. 
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

if (length(d)<2)
   hcl=[];
   mywarning('The displayed feature needs at least data points for a histogram.');   
   return;
end;

if (nargin<5) || isempty(zgf) 
   zgfmode=0;
else 
   zgfmode=1;
end; 

if nargin<6
   f=figure;
else
   figure(f);
end;

if nargin<7
   parameter_anzeige.histauto = 1;
end;



d=d(:,1);

if parameter_anzeige.histauto == 1
   stuetzpunkte=10;
   if length(unique(d))<10 
      x=unique(d);
   else
      x=min(d):(max(d)-min(d))/stuetzpunkte:max(d);  
     
      
   end;
else
   x = parameter_anzeige.histvalue;
end;


codeind=fliplr(findd(code));
for i=1:length(codeind)
   ind=find(code==codeind(i));
   if length(x) == 1 && (x==0)
       hcl(i,:) = 1;
   else
       hcl(i,:)=hist(d(ind),x)/length(ind);
   end;
   subplot(length(codeind)+zgfmode,1,i);
   bar(x,hcl(i,1:length(x)));
   ax=axis;
   axis([ax(1:2) 0 1.05]);
   if (i==1) 
      title(sprintf('Histogram (%s)',deblank(var_bez(2,:)))); 
   end;   
   ylabel(zgf_bez(size(zgf_bez,1),codeind(i)).name);
end;

%nur wenn Histogramm mit Klassen-ZGFs:
if zgfmode 
   subplot(length(codeind)+zgfmode,1,length(codeind)+zgfmode);
   %ZGF zeichnen
   plklzgf(zgf,1,var_bez,zgf_bez,[min(d(:,1)) max(d(:,1))],gcf);
   ax=axis;
   
   %gleiche Achsen wie bei Histogramm!!
   for i=1:length(codeind) 
      subplot(length(codeind)+zgfmode,1,i);axis([ax(1:2) 0 1.05]);
   end;
else
   xlabel(kill_lz(var_bez(1,:)));
end;

set(gcf,'numbertitle','off','name',sprintf('%d: %s vs. %s',get_figure_number(gcf),deblank(var_bez(1,:)),deblank(var_bez(2,:))));
