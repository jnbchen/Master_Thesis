  function [d_fuz,d_quali,anz_quali]=fuzz(d_org,zgf)
% function [d_fuz,d_quali,anz_quali]=fuzz(d_org,zgf)
%
% fuzzifiziert Werte in Matrix d_org mit gegegebenen Zugeh�rigkeitsfunktionen
% d_fuz und gibt fuzzifizierte Werte d_fuz, die qualitativen Werte (max. ZG-Wert)
% d_quali und relative H�ufigkeiten der Intervalle (links von 1. ZGF-Max., zwischen Max.
% 1. und 2. Maxima ZGF, ..., rechts von letztem Max. ZGF
% 
% Dummy-Variable f�r eine fuzzifizierte Variable
%
% The function fuzz is part of the MATLAB toolbox Gait-CAD. 
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

if size(zgf,2) == 1 && size(zgf,1) > size(zgf,2)
   zgf = zgf';
end;


anz_fuzzy=size(zgf,2);
fuz_var0=zeros(size(d_org,1),anz_fuzzy);
d_fuz=zeros(size(d_org,1),anz_fuzzy*size(d_org,2));
if (nargout>1) 
   d_quali=zeros(size(d_org));
end;
if (nargout>2) 
   anz_quali=zeros(size(d_org,2),anz_fuzzy+1);
end;

for i=1:size(d_org,2)
   
   d_org_var=d_org(:,i);
   
   %ZGF f�r betreffende Variable
   %alle die von hinten rausschneiden, die nicht aufsteigend sind 
   zgf_var=zgf(i,:);
   ind=find(diff(zgf_var)<=0);
   if ~isempty(ind) 
      anz_fuzzy=ind(1);zgf_var=zgf_var(1:anz_fuzzy);fuz_var=zeros(size(d_org,1),anz_fuzzy);
   else          
      anz_fuzzy=size(zgf,2);fuz_var=fuz_var0;
   end;    
   
   %Breite der Abschnitte
   zgf_breite=diff(zgf_var);
   
   %Werte und ZGF-St�tzpunkte sortieren
   [tmp,ind]=sort([zgf_var d_org_var']);
   
   %ZGF-St�tzpunkte wiederfinden
   for j=1:anz_fuzzy 
      indz(j)=find(ind==j);
   end;
   ind=ind-anz_fuzzy;
   
   %kleiner als erste ZGF?
   fuz_var(ind(1:indz(1)-1),1)=ones(indz(1)-1,1);
   
   %gr��er als letzte ZGF?
   %fuz_var(ind(indz(anz_fuzzy)+1:length(ind)),anz_fuzzy)=ones(length(ind)-indz(anz_fuzzy),1);
   ind_last=find(zgf_breite>0);
   if ~isempty(ind_last) 
      ind_last=1+ind_last(length(ind_last));
   else               
      ind_last=1;
   end;    
   fuz_var(ind(indz(anz_fuzzy)+1:length(ind)),anz_fuzzy)=ones(length(ind)-indz(anz_fuzzy),1);
   
   %dazwischen - aber nur, wenn Intervallbreite >0?
   for j=find(zgf_breite>0) 
      indj=ind(indz(j)+1:indz(j+1)-1);
      fuz_var(indj,j+1)=(d_org_var(indj)-zgf_var(j))/zgf_breite(j);
      fuz_var(indj,j)=1-fuz_var(indj,j+1);
   end;
   
   d_fuz(:,(i-1)*size(zgf,2)+[1:anz_fuzzy])=fuz_var;    
   if (nargout>1) 
      %Bevorzugung bestimmter Terme
      fuz_var=round(fuz_var+(1E-10*ones(size(fuz_var,1),1)*(0.5-rem(1:size(fuz_var,2),2))));
      [tmp,tmp1]=max(fuz_var');
      d_quali(:,i)=tmp1';
   end;
   if (nargout>2) 
      anz_quali(i,1:anz_fuzzy+1)=(diff([0 indz size(d_fuz,1)+anz_fuzzy+1])-1)/size(d_fuz,1); 
   end;
end; 

