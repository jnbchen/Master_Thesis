% Script callback_anzeige_fehldaten
%
% The script callback_anzeige_fehldaten is part of the MATLAB toolbox Gait-CAD. 
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

filename=sprintf('%s_suspect.txt',parameter.projekt.datei);
f=fopen(filename,'wt');

%Indizes heraussuchen und in Matrix suspect schreiben
if ~isempty(d_orgs)
   
   %FÜR ZEITREIHEN.....
   %Nan und Inf und Nullzeitreihen in ZR suchen 
   ind=find( isinf(d_orgs) + isnan(d_orgs) );
   clear temp;
   suspect= squeeze( (min(d_orgs,[],2)==0) &  (max(d_orgs,[],2)==0) ) ;   %% Coderevision: &/| checked!
   
   if (size(suspect,2)~=size(d_orgs,3)) && (size(d_orgs,1) == 1)
      suspect=suspect';
   end;
   
   %Indizes ausrechnen...
   if ~isempty(ind)
      [temp(:,1),temp(:,2),temp(:,3)]=ind2sub(size(d_orgs),ind);
      suspect(sub2ind(size(suspect),temp(:,1),temp(:,3)))=1;
   end;
   
   
   %Ergebnis plotten
   if max(max(suspect)) && plotmodus==1
      figure;
      colormap('gray');
      image(255*(~suspect));
      xlabel('Features TS');ylabel('Data points');
      set(gcf,'NumberTitle','off');
      set(gcf,'name',sprintf('%d: Missing data points for time series',get_figure_number(gcf)));
   end;
   
   
   fprintf(f,'\n\nMissing data points in time series:\n');
   for i=1:size(d_orgs,3)
      fprintf(f,'TS %3d %-50s: %g%% fehlende Werte\n',i,var_bez(i,:),100*mean(suspect(:,i)));
   end;   
end;


%FÜR EINZELMERKMALE....
%Nan und Inf in ZR suchen
if ~isempty(d_org)
   ind=find(isinf(d_org)+isnan(d_org));
   suspect_dorg=zeros(size(d_org));
   suspect_dorg(ind)=1;
   
   %Ergebnis plotten
   if max(max(suspect_dorg)) && plotmodus==1
      figure;
      colormap('gray');
      image(255*(~suspect_dorg));
      xlabel('Single features');ylabel('Data points');
      set(gcf,'NumberTitle','off');
      set(gcf,'name',sprintf('%d: Missing data points for single features',get_figure_number(gcf)));
   end;
   
   fprintf(f,'\n\nMissing data points in single features\n');
   for i=1:size(d_org,2)
      fprintf(f,'SF %3d %-50s: %g%% missing values\n',i,dorgbez(i,:),100*mean(suspect_dorg(:,i)));
   end;   
end;

fclose(f);
viewprot(filename);

