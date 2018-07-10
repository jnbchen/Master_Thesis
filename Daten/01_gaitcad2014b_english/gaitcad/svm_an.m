  function  [pos,md,prz,maxi_all]=svm_an(d_org,svm_system,ausgabe)
% function  [pos,md,prz,maxi_all]=svm_an(d_org,svm_system,ausgabe)
%
% ausgabe optional
%
% The function svm_an is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 3)
   ausgabe = 1;
end;

if (ausgabe)
   fprintf('Apply SVM ...\n');
end;

%[0,1]-Normierung durchführen
if svm_system.options.normierung==1
   d_org=matrix_normieren(d_org,2,svm_system.minimium,svm_system.differenz);
   %d_org=(d_org-ones(size(d_org,1),1)*svm_system.minimum)./(ones(size(d_org,1),1)*svm_system.differenz);
end;


%---------------------One Against All algorithms----------------
if svm_system.options.mehrklassentype==1
   [pos,maxi,maxi_all] = svmmultival(d_org,svm_system.xsup,svm_system.w,svm_system.b,svm_system.nbsv,svm_system.options.kernel,svm_system.options.kerneloption);
end;
%---------------------One Against One algorithms----------------
if svm_system.options.mehrklassentype==2
   [pos,maxi,maxi_all] = svmmultivaloneagainstone(d_org,svm_system.xsup,svm_system.w,svm_system.b,svm_system.nbsv,svm_system.options.kernel,svm_system.options.kerneloption);
end;

%Decodieren, falls Klassen nicht von 1...m_y durchnummeriert waren...
pos=svm_system.decode(pos);

%erstmal vorläufig einsen in die Prozente schreiben, in maxi stehen nur irgendwelche Entfernungen zu Null
prz=zeros(length(pos),svm_system.options.anz_klass_total);
prz(:,1:max(pos))=vecinmat(ones(length(pos),1),1:length(pos),pos');

%falls doch irgendjemand md haben will..
md=prz;

%Vorbereitung prz Ausgabe
%nur sinnvoll für 2-Klassen-Problem!!!!!!
%normierte Werte!!!!!!!!!!!!!!;
if (size(svm_system.xsup,1)==svm_system.nbsv(1))
   %phi_svm=svm_system.w'*svm_system.xsup;
   %md=d_org*phi_svm'+svm_system.b;
   % Aber darauf achten, dass md ebenfalls die richtige Größe behält!
   % und vor allen die Daten an den richtigen Stellen stehen!
   %prz(:, unique(pos)) = myResizeMat(md, 1, length(unique(pos)));
   % In den obigen Formeln werden die Kernel-Funktionen ignoriert.
   % Daher svm_md.ypred verwenden:
   temp =maxi_all(1,2).ypred; %, 1, length(unique(pos)));
   prz(:,1) = 50 + 50 * temp/max(abs(temp));
   prz(:,2) = 100 - prz (:,1);
   md = prz;
   
   %md = myResizeMat(md, 1, 2);
   %prz = md;
end;

if (ausgabe)
   fprintf('Complete.\n');
end;


