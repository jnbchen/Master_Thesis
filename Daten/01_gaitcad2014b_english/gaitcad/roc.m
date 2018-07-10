  function roc(d,code,class_of_interest,newfigure,zgf_y_bez,pos)
% function roc(d,code,class_of_interest,newfigure,zgf_y_bez,pos)
%
% zeichnet ROC-Kurve für laufenden Schwellwert des skalaren Merkmals d und die interessierende
% Klasse class of interest für
% Beispiel: class_of_interest=1;roc(prz(:,class_of_interest),code,class_of_interest,1,'',pos)
%
% The function roc is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<4) 
   newfigure=1;
end;

if (nargin<5) 
   zgf_y_bez='';
end;
if isempty(zgf_y_bez) 
   classname='';
else 
   classname=zgf_y_bez(class_of_interest).name;   
end;

if (nargin<6) 
   pos=[];
end; 

%nach aufsteigenden Merkmalswerten sortieren 
[dsort,indsort]=sort(d);
codesort=code(indsort)==class_of_interest;

%dreht Entscheidung, wenn interessierende Klasse eher bei höheren Werten liegt
tmp=mycorrcoef([dsort codesort]);
if (tmp(1,2)>0) 
   codesort=flipud(codesort);
   dsort=flipud(dsort);
end;

N_alle=length(code);
N_interest=sum(code==class_of_interest);

%von vor zählen für die richtige Entscheidung...
tp=[ cumsum(codesort)]/N_interest;
fp=[ cumsum(~codesort)]/(N_alle-N_interest);

%nur die Werte auswerten, an denen sich d wirklich ändert
[dsort,indsort]=unique(dsort);

if newfigure 
   figure;
end;
if (tmp(1,2)>0)    
   plot([fp(indsort);0],[tp(indsort);0],'.-');
else               
   plot([0;fp(indsort)],[0;tp(indsort)],'.-');
end;

xlabel(sprintf('1-specificity for class %s',classname));
ylabel(sprintf('Sensitivity for class %s',classname));
title('ROC curve');
set(gcf,'numbertitle','off','name',sprintf('%d: ROC curve for class %s',get_figure_number(gcf),classname));


if ~isempty(pos)
   tp=sum ( (code==class_of_interest) & (pos==class_of_interest) );  % Coderevision: &/| checked!
   tn=sum ( (code~=class_of_interest) & (pos~=class_of_interest) );  % Coderevision: &/| checked!
   fp=sum ( (code~=class_of_interest) & (pos==class_of_interest) );  % Coderevision: &/| checked!
   fn=sum ( (code==class_of_interest) & (pos~=class_of_interest) );  % Coderevision: &/| checked!
   fprintf('ROC analysis for class %s:\n',classname);
   fprintf('Specifity:    %g \n', tn / (tn+fp));
   fprintf('Sensitivity:  %g \n', tp / (tp+fn));
end;
axis([-0.05 1.05 -0.05 1.05]);