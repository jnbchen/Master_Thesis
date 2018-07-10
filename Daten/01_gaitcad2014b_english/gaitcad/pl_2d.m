  function  [fig_handles]=pl_2d(dat,code,not_figure,parameter_gui_anzeige_or_za_mode,sw_mode,var_bez,zgf_bez,nulldetektion,mw_berechnung,legende_an,ind_auswahl,x_y_tausch,grautoene,farb_variante)
% function  [fig_handles]=pl_2d(dat,code,not_figure,parameter_gui_anzeige_or_za_mode,sw_mode,var_bez,zgf_bez,nulldetektion,mw_berechnung,legende_an,ind_auswahl,x_y_tausch,grautoene,farb_variante)
%
% default  [fig_handles]=pl_2d(dat,code,1,0,0,'',[],0,0,1,...
%                              0,0,0,4)
% zeigt Daten im Farbcode der Klassifikation
% 
% Eingangsvariablen:
% dat     -> Datenmatrix
% code        -> Klassencode
%            (!!!code von 1 bis kl_anz!!!)
% not_figure     -> kein neues Bild, wenn Argument existiert
% nulldetektion wird ignoriert
% 
% damit wir uns nicht mit imaginären Anteilen bei bestimmten Problemen rumärgern...
%
% The function pl_2d is part of the MATLAB toolbox Gait-CAD. 
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

dat=real(dat);

if (nargin<3) 
   not_figure=1;
end;


if (nargin<4)
   parameter_gui_anzeige_or_za_mode=0;
end;
if isstruct(parameter_gui_anzeige_or_za_mode)
   parameter_gui_anzeige = parameter_gui_anzeige_or_za_mode;
   
   %switch for old or new parameter style, all other parameters
   za_mode       = parameter_gui_anzeige.anzeige_nr_datentupel;
   sw_mode       = parameter_gui_anzeige.anzeige_grafiken;
   legende_an    = parameter_gui_anzeige.legende;
   x_y_tausch    = parameter_gui_anzeige.em_anzeige_xy_tausch;
   farb_variante = parameter_gui_anzeige.farbvariante;
   grautoene     = 0;
else
   parameter_gui_anzeige = [];
   za_mode = parameter_gui_anzeige_or_za_mode;   
   inverse_order = 0;
end;

if (nargin<5)
   sw_mode=0;
end;
if (nargin<6)
   var_bez='';
end;
if (nargin<7)
   zgf_bez=[];
end;
if (nargin<9)
   mw_berechnung=0;
end;
if (nargin<10)
   legende_an=1;
end;
if (nargin<11)
   ind_auswahl=0;
end;
if (nargin<12)
   x_y_tausch=0;
end;
if (nargin<13)
   grautoene=0; 
end; % zum darstellen unterschiedlicher Helligkeiten ( Vektor: Laenge=size(d,1) ), Empfehlung: Grautöne im SW-Modus (z.B. max Cluster-ZGH) 
if (nargin<14) 
   farb_variante=[]; 
end 

kl_anz=max(code);  
if (size(dat,2)>3) 
   dat=dat(:,1:3);
end;

%zur Berechnung des Mittelwerts für das Label
if mw_berechnung 
   for i=findd(code) 
      zgf_bez(i).name=sprintf('%s Mean: %2.2f',zgf_bez(i).name,mean(dat(find(code==i),1)));
   end;
end;

%Bild 1 ausschließen!!!
if ~not_figure || gcf==1
   figure;  
end;
if nargout 
   fig_handles(1)=gcf;
end;

if ~isempty(parameter_gui_anzeige)
   %new parameter style
   plotfarb(dat,code,parameter_gui_anzeige,0,var_bez,zgf_bez,0,ind_auswahl);
else
   %old parameter style
   plotfarb(dat,code,za_mode,sw_mode,var_bez,zgf_bez,legende_an,ind_auswahl,x_y_tausch,grautoene,farb_variante);
end;

for i=1:size(dat,2) 
   if (min(dat(:,i))==max(dat(:,i))) 
      return;
   end;
end;

if ~x_y_tausch
   dim = 1:size(dat,2);
else
   dim = size(dat,2):-1:1;
end;
if (size(dat,2)>1)
	axis([min(dat(:, dim(1))) max(dat(:,dim(1))) min(dat(:,dim(2))) max(dat(:,dim(2)))]);
else
	axis([min(dat(:,1)) max(dat(:,1)) -1 1]);
end;
if (size(dat,2)>2) 
	axis([min(dat(:,dim(1))) max(dat(:,dim(1))) min(dat(:,dim(2))) max(dat(:,dim(2))) min(dat(:,dim(3))) max(dat(:,dim(3)))]);
end;

