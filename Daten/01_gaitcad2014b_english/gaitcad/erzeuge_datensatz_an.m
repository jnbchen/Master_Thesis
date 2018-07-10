  function d=erzeuge_datensatz_an(d_org,merkmalsextraktion)
% function d=erzeuge_datensatz_an(d_org,merkmalsextraktion)
%
% erstmal alles reparieren, falls notwendig...
%
% The function erzeuge_datensatz_an is part of the MATLAB toolbox Gait-CAD. 
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

if ~isfield(merkmalsextraktion,'merkmal_auswahl') 
   merkmalsextraktion.merkmal_auswahl=[];
end;
if ~isfield(merkmalsextraktion,'norm_merkmale')    
   merkmalsextraktion.norm_merkmale.type=0;
end;
if ~merkmalsextraktion.norm_merkmale.type
   merkmalsextraktion.norm_merkmale.par1=[];
   merkmalsextraktion.norm_merkmale.par2=[];
end;
if ~isfield(merkmalsextraktion,'norm_aggregation') 
   merkmalsextraktion.norm_aggregation.type=0;
end;
if ~merkmalsextraktion.norm_aggregation.type
   merkmalsextraktion.norm_aggregation.par1=[];
   merkmalsextraktion.norm_aggregation.par2=[];
end;
if ~isfield(merkmalsextraktion,'phi_aggregation')  
   merkmalsextraktion.phi_aggregation=[];
end;


%Merkmalsauswahl
if ~isempty(merkmalsextraktion.merkmal_auswahl)
   d=d_org(:,merkmalsextraktion.merkmal_auswahl);
else 
   d=d_org;
end;

%Normierung Merkmale anwenden
if merkmalsextraktion.norm_merkmale.type
   d = matrix_normieren(d,merkmalsextraktion.norm_merkmale.type,merkmalsextraktion.norm_merkmale.par1,merkmalsextraktion.norm_merkmale.par2);
end;

%Aggregation
if ~isempty(merkmalsextraktion.phi_aggregation)
   d = d*merkmalsextraktion.phi_aggregation;
end;


%Normierung aggregierte Merkmale 
if merkmalsextraktion.norm_aggregation.type
   d = matrix_normieren(d,merkmalsextraktion.norm_aggregation.type,merkmalsextraktion.norm_aggregation.par1,merkmalsextraktion.norm_aggregation.par2);
end;





   
