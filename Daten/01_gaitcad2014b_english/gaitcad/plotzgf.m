  function t=plotzgf(a,fig,xmin,xmax,memmax,name,xname,yname,setjoin,pedge)
% function t=plotzgf(a,fig,xmin,xmax,memmax,name,xname,yname,setjoin,pedge)
%
% 
% PLOTZGF plots a set of standard MBF of a fuzzy set
% E.g. plotzgf(zgfyp,3,-1,11,1.1,str2mat('NVB','NB','NS','Z','PS','PB','PVB'),'yp','Membership')
% plots the membership fuctions with the y-axis 0 to 1.1 of the variable zgfyp in the figure 3
% from yp=-1 to yp=11 with the term names 'NVB','NB','NS','Z','PS','PB','PVB' and the axis labels
% yp and Membership
% the membership functions with the smallest and biggest values will be plotted
% pedge==0  with membership 1 to infinity
% pedge==1  symmetrically.
% pedge==2  as singletons.
% plotzgf([-5 -1 0 1 5],1,-7,7,1.1,str2mat('NEG','Z','POS'),'yp','ZGF',[2 3])
% plotzgf([-5 -1 0 1 5],1,-10,10,1.1,str2mat('NG','NK','Z','PK','PG'),'yp','ZGF',[],1)
%
% The function plotzgf is part of the MATLAB toolbox Gait-CAD. 
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

if (length(a)<2)
   mywarning('There exist only one term resp. membership function. A visualization is impossible.');
   return;
end;

mycol='k';

join=zeros(length(a),1);
if nargin>=9 
   if (max(setjoin)>0) 
      for i=1:length(setjoin) 
         join(setjoin(i))=1; 
      end;
   end;
end;

if nargin<10 
   pedge=0;
end;

if (fig>0) 
   figure(fig); 
end;
hold off;
if (pedge==0) 
   plot([xmin,a(1),a(2)],[1 1 0],mycol);
end;
if (pedge==1) 
   plot([2*a(1)-a(2),a(1),a(2)],[0 1 0],mycol);
end;
if (pedge==2)
   plot([a(1) a(1)],[0 1],mycol);  
end;
hold on;
for i=2:(length(a)-1)
   if (join(i-1)==0)
      if (join(i)==0) 
         if (pedge==2) 
            plot([a(i) a(i)],[0 1],mycol);  
         else       
            plot([a(i-1) a(i) a(i+1)],[0 1 0],mycol);
         end;
      else       
         for k=i:(length(a)-1) 
            if (join(k+1)==0) 
               break;
            end;
         end;
         if (k<(length(a)-1)) 
            plot([a(i-1) a(i) a(k+1) a(k+2)],[0 1 1 0],mycol);
         end;
         
      end;
   end;
end;
if (pedge==0) 
   plot([a(length(a)-1) a(length(a)) xmax],[0 1 1],mycol);
end;
if (pedge==1) 
   plot([a(length(a)-1) a(length(a)) 2*a(length(a))-a(length(a)-1)],[0 1 0 ],mycol); 
end;
if (pedge==2) 
   plot([a(length(a)) a(length(a))],[0 1],mycol);  
end;
axis([xmin xmax 0 memmax]);
t=text(a(1),1+(memmax-1)/2,name(1,:));
j=2;
set(t,'HorizontalAlignment','center');
for i=2:length(a) 
   if join(i-1)==0
      if (join(i)==0) 
         t=text(a(i),1+(memmax-1)/2,name(j,:));
         j=j+1;
      else         
         t=text((a(i)+a(i+1))/2,1+(memmax-1)/2,name(j,:));
         j=j+1;  	
      end;
   end;
   
   set(t,'HorizontalAlignment','center');
end; 
xlabel(xname);
ylabel(yname);
