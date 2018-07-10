  function [my,mstd,codeind,my_org,mstd_org]=plotmeanstd(d_orgs,code,d_org,klassenbez)
% function [my,mstd,codeind,my_org,mstd_org]=plotmeanstd(d_orgs,code,d_org,klassenbez)
%
% 
% berechnet Mittelwerte (my) und Standardabweichungen (mstd) aller Merkmale (Zeitreihen) in
% d_orgs fuer unterschiedliche codes und gibt sie als Tensor my(Klasse,Zeitreihe,Merkmale) zurück
% 
%
% The function plotmeanstd is part of the MATLAB toolbox Gait-CAD. 
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

fprintf('Compute mean values and standard deviations\n');
if nargin<3 
   d_org=[];
end;
if nargin<4 
   klassenbez='';
end;

k=0;
%beteiligte Klassen
codeind=findd(code);

%Initialisieren
my=zeros(length(codeind),size(d_orgs,2),size(d_orgs,3));
mstd=my;
my_org=zeros(length(codeind),size(d_org,2));
mstd_org=zeros(length(codeind),size(d_org,2));


for i=codeind 
   
   %Zeitreihen für die jeweiligen Klassen raussuchen
   k=k+1;
   ind=find(code==i)';  
   fprintf('Class %d: %s\n',i,klassenbez);
   
   if ~isempty(d_orgs)
      %Mittelwerte und Standardabweichungen von Zeitreihen
      my(k,:,:)=squeeze(mean(d_orgs(ind,:,:),1));
      mstd(k,:,:)=squeeze(std(d_orgs(ind,:,:),0,1));
      
      %Mittelwerte Einzelmerkmale
      if ~isempty(d_org) 
         my_org(k,:)=mean(d_org(ind,:),1);
         mstd_org(k,:,:)=std(d_org(ind,:),0,1);
      end;
   end; %d_orgs
end; %i

fprintf('Ready\n');

