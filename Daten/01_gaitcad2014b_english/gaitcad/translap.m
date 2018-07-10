  function rulename=translap(plausall,par,d,code,zgf,sw_mode,za_mode,var_bez,zgf_bez,farb_variante)
% function rulename=translap(plausall,par,d,code,zgf,sw_mode,za_mode,var_bez,zgf_bez,farb_variante)
%
% druckt Regelbasis plausall auf Bildschirm
% mode=1 Anzeige Nr. Datentupel
%
% The function translap is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

if (nargin<8) 
   var_bez='';
end;
if (nargin<9) 
   zgf_bez='';
end;
if (nargin<10) 
   farb_variante=[];
end;

%ohne Fileparameter: Druck auf Bildschirm
file=1;

%Regelname
rulename=[];

%Nullterme wegschneiden
zgf=zgf(1:par(2),1:max(par(5:length(par))));

if isempty(plausall) 
   fprintf('No rules !\n');
   return;
end;
[wert,pos]=sort(-plausall(:,1));

plausall=plausall(pos,:);
if isempty(plausall)
   fprintf('No rules !\n');
   return;
end;

for j=find(plausall(:,1))'
   m=pla2mas(plausall(j,:),par);
   ind=[];
   for i=1:par(2) %Grenzen eintragen - entweder minimaler Wert im Datensatz 
      %oder Mitte zwischen den ZGFs
      if (m(i,1)~=0) && (length(ind)<3) 
         ind=[ind i];
         
         if (m(i,1)>0)  
            term=m(i,1);
         else        
            term=find(m(i,2:size(m,2)));
         end; 
         
         if min(term)==1 
            gr(length(ind),1)=1.1*min(d(:,i))-0.1*max(d(:,i));
         else     
            gr(length(ind),1)=mean(zgf(i,min(term)-[1 0]));
         end;
         
         if max(term)==par(i+4) 
            gr(length(ind),2)=1.1*max(d(:,i))-0.1*min(d(:,i));
         else            
            gr(length(ind),2)=mean(zgf(i,max(term)+[0 1]));
         end;
      end;
   end;
   if ~isempty(ind)
      figure;
      %Titel wird Regel
      
      f=fopen('tmp.txt','wt');
      translat9(plausall(j,:),par,f,[],0,var_bez,zgf_bez);
      fclose(f);
      
      f=fopen('tmp.txt','rt');
      tmp=fscanf(f,'%c');
      fclose(f);             
      ind_wenn=strfind(tmp,'IF');
      set(gcf,'name',tmp(1:ind_wenn-1));
      rulename=tmp(ind_wenn:length(tmp)-1);
      title(rulename);
      set(gcf,'numbertitle','off','name',sprintf('%d: %s',get_figure_number(gcf),rulename));       
      
      %Tobi's Spezial Hack fuerirgendwelche Cluster, braucht niemand ausser ihm und geht auch nur in einem Projekt
      plotfarb (d(:,ind),code,sw_mode,za_mode,var_bez(ind,:),zgf_bez,1,0,0,0,farb_variante); % jetz mit Farb-Variante
      set(get(gcf,'CurrentAxes'),'XTick',findd(zgf(ind(1),:)));
      if (length(ind)>1) 
         set(get(gcf,'CurrentAxes'),'YTick',findd(zgf(ind(2),:)));
      end;
      if (length(ind)>2) 
         set(get(gcf,'CurrentAxes'),'ZTick',findd(zgf(ind(3),:)));
      end;
      
      if (length(ind)==1) 
         rectangle('position',[gr(1,1) 0 diff(gr(1,1:2)) 1]);
      else             
         rectangle('position',[gr(1,1) gr(2,1) diff(gr(1,1:2)) diff(gr(2,1:2))]);
      end;
      
      %Achsen auf jeweilige Minimal- und Maximalwerte einstellen                   
      ax=axis;
      for i=1:min(3,length(ind)) 
         minax=min([d(:,ind(i))' zgf(ind(i),:)]);
         maxax=max([d(:,ind(i))' zgf(ind(i),:)]);
         ax(2*i-[1 0])=[1.1*minax-0.1*maxax 1.1*maxax-0.1*minax];
      end;                   
      axis(ax);
   end;
end;



