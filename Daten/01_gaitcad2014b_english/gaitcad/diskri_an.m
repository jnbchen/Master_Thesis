  function [d, phi_last, phi_text, phi_last_n,d_dis] = diskri_an(d_org, merk_diskri,phi_dis,phi_dis_n,option_bestldf)
% function [d, phi_last, phi_text, phi_last_n,d_dis] = diskri_an(d_org, merk_diskri,phi_dis,phi_dis_n,option_bestldf)
%
%  wendet Linearkombinationen an. Die Koeffizienten sind in phi_dis enthalten, d enthält die linear kombinierten
%  Merkmale, phi_text einen Erklärungstext.
% 
%  d_org:            Datensatz (n Beispiele, s Merkmale)
%  merk_diskri:       Skalar der Anzahl der zu suchenden Linearkombinationen
%  option_bestldf    : Binärer Schalter zwischen normaler und bester LDF (beeinflusst nur die Anzeige!!!)
% 
%
% The function diskri_an is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

if (nargin<5) 
   option_bestldf=0;
end;

%Berechnung nur möglich, wenn Eigenvektoren zum Datenmaterial passen und
%mindestens soviele Eigenvektoren wie geforderte Merkmale zur Verfügung stehen
if (size(d_org,2)==size(phi_dis,1)) && (size(phi_dis,2)>=merk_diskri) 
   d_dis=d_org*phi_dis(:,1:merk_diskri);
else 
   fprintf('Format of eigenvectors of data not compatible!\n');
end; 	 	 	

%Aktuelle Daten aus Diskriminanz
d=d_dis;

%Letzte Transformation
phi_last=phi_dis(:,1:merk_diskri);
if option_bestldf 
   phi_text=sprintf('Optimized Discriminant Analysis: from %d to %d aggregated features',size(phi_dis,1),merk_diskri);
else           
   phi_text=sprintf('Discriminant analysis from %d to %d transformed features',size(phi_dis,1),merk_diskri);
end;

%und wieder Betrag des Vektors 1 erzwingen
phi_last_n=phi_dis_n;

