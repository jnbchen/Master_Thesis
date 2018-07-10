  function [leftright,subplotid,variante]=aufloesung_gait_kategorien(code_zr,zgf_zr_bez)
% function [leftright,subplotid,variante]=aufloesung_gait_kategorien(code_zr,zgf_zr_bez)
%
% leftright=1 : rechts
% leftright=2 : links
% leftright=0 : unbekannt
% Subplot-Aufruf mit subplot(subplotid.anzx,subplotid.anzy,subplotid.nr)
% LINKS-RECHTS-AUFL÷SUNG
%
% The function aufloesung_gait_kategorien is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

pos_koerperseite=getpos(zgf_zr_bez(1,1).katbez,'Body side','rows');
if pos_koerperseite~=0
   ind=1:max(zgf_zr_bez(pos_koerperseite,1).auswahl);
else
   ind=[];
end;
if ~isempty(ind)
   pos_left=getpos({zgf_zr_bez(pos_koerperseite,ind).name},'Left');
   pos_right=getpos({zgf_zr_bez(pos_koerperseite,ind).name},'Right');
   leftright=(code_zr(:,pos_koerperseite)==pos_right)+2*(code_zr(:,pos_koerperseite)==pos_left);
else 
   leftright=zeros(size(code_zr,1),1);
end;


%EBENEN-AUFL÷SUNG
pos_ebene=getpos(zgf_zr_bez(1,1).katbez,'Plane','rows');
if pos_ebene~=0
   ind=1:max(zgf_zr_bez(pos_ebene,1).auswahl);
else
   ind=[];
end;
if ~isempty(ind)
   pos_sag=getpos({zgf_zr_bez(pos_ebene,ind).name},'sagittal');
   pos_front=getpos({zgf_zr_bez(pos_ebene,ind).name},'frontal');
   pos_trans=getpos({zgf_zr_bez(pos_ebene,ind).name},'transversal');
   subplotid.x=(code_zr(:,pos_ebene)==pos_sag)+2*(code_zr(:,pos_ebene)==pos_front)+3*(code_zr(:,pos_ebene)==pos_trans);
else 
   subplotid.x=zeros(size(code_zr,1),1);
end;


%SEGMENT-AUFL÷SUNG
pos_gelenk=getpos(zgf_zr_bez(1,1).katbez,'Joint resp. segment','rows');
if pos_gelenk~=0
   ind=1:max(zgf_zr_bez(pos_gelenk,1).auswahl);
else
   ind=[];
end;
if ~isempty(ind)
   pos_trunk= getpos({zgf_zr_bez(pos_gelenk,ind).name},'Trunk');
   pos_pel=   getpos({zgf_zr_bez(pos_gelenk,ind).name},'Pelvis');
   pos_hip=   getpos({zgf_zr_bez(pos_gelenk,ind).name},'Hip');
   pos_kne=   getpos({zgf_zr_bez(pos_gelenk,ind).name},'Knee');
   pos_ank=   getpos({zgf_zr_bez(pos_gelenk,ind).name},'Ankle');
   pos_fuss=   getpos({zgf_zr_bez(pos_gelenk,ind).name},'Foot');
   subplotid.y= (code_zr(:,pos_gelenk)==pos_trunk)+ 2*(code_zr(:,pos_gelenk)==pos_pel)+3*(code_zr(:,pos_gelenk)==pos_hip)+4*(code_zr(:,pos_gelenk)==pos_kne)+5*( (code_zr(:,pos_gelenk)==pos_ank) | (code_zr(:,pos_gelenk)==pos_fuss) ); % Coderevision: &/| checked!
   
   %im Zweifelsfall alle transversalen Fuﬂgelenken nullen
   if pos_fuss~=0
      ind_doppelt_ank_fuss = find( (subplotid.x == 3) & (code_zr(:,pos_gelenk)==pos_ank) );   % Coderevision: &/| checked!
      if ~isempty(ind_doppelt_ank_fuss) 
         subplotid.y(ind_doppelt_ank_fuss)=0;
         subplotid.x(ind_doppelt_ank_fuss)=0;
      end;      
   end;
      
   ind=find(subplotid.y);
   subplotid.y(ind)=1+subplotid.y(ind)-min(subplotid.y(ind));    
else 
   subplotid.y=zeros(size(code_zr,1),1);
end;


%max. Anzahl subplots 
subplotid.anzx=max(subplotid.x);
subplotid.anzy=max(subplotid.y); 
ind=find(subplotid.x & subplotid.y);  % Coderevision: &/| checked!
subplotid.nr=zeros(size(subplotid.x));
subplotid.nr(ind)=subplotid.x(ind)+(subplotid.y(ind)-1)*(subplotid.anzx);

%Variantenbestimmung - ergibt dann verschiedene Charts
ind=1:size(code_zr,2);
ind_loesch=[pos_koerperseite pos_ebene pos_gelenk ];
ind(ind_loesch(find(ind_loesch)))=[];
[temp1,temp2,variante]=unique(code_zr(:,ind),'rows');
variante = generate_rowvector(variante);

%function 
function pos=getpos(bezeichner,text,reihen)
%
if (nargin<3) 
   [temp,pos]=   intersect(deblank(bezeichner),deblank(text));
else       
   [temp,pos]=   intersect(deblank(bezeichner),deblank(text),'rows');
end;
if isempty(pos) 
   pos=0;
end;

