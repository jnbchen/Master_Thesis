  function  svm_system=svm_en(d_org,code,svm_options)
% function  svm_system=svm_en(d_org,code,svm_options)
%
% The function svm_en is part of the MATLAB toolbox Gait-CAD. 
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

fprintf('Create SVM ...\n');
[svm_system.decode,tmp,code]=unique(code);
nbclass=length(svm_system.decode);

if nbclass<2 
   myerror('Too few classes! Check selected data. ');
   return;
end; 
if nbclass==2  
   svm_options.mehrklassentype=2;
end; 

%SVM-Parameter
svm_system.options=svm_options;

%[0,1]-Normierung durchführen
if svm_options.normierung==1
   [d_org,svm_system.minimium,svm_system.differenz]=matrix_normieren(d_org,2);
   %svm_system.minimum=min(d_org,[],1); 
   %svm_system.differenz=(max(d_org,[],1) - min(d_org,[],1)); 
   %svm_system.differenz(find(svm_system.differenz==0))=1;
   %d_org=(d_org-ones(size(d_org,1),1)*svm_system.minimum)./(ones(size(d_org,1),1)*svm_system.differenz);
end;   

%---------------------One Against All algorithms----------------
if svm_options.mehrklassentype==1 
   [svm_system.xsup,svm_system.w,svm_system.b,svm_system.nbsv]=svmmulticlass(d_org,code,nbclass,svm_system.options.c,svm_system.options.lambda,svm_system.options.kernel,svm_system.options.kerneloption,svm_system.options.verbose);
end;

%---------------------One Against One algorithms----------------
if svm_options.mehrklassentype==2 
   [svm_system.xsup,svm_system.w,svm_system.b,svm_system.nbsv,svm_system.classifier]=svmmulticlassoneagainstone(d_org,code,nbclass,svm_system.options.c,svm_system.options.lambda,svm_system.options.kernel,svm_system.options.kerneloption,svm_system.options.verbose);
end;

%die nichtnorimierte Fassung der Support-Vektoren - nur zu Anzeigezwecken...   
if svm_options.normierung==1 
   svm_system.xsupanzeige=matrix_normieren(svm_system.xsup,-2,svm_system.minimium,svm_system.differenz);   
else
   svm_system.xsupanzeige=svm_system.xsup;
end;


fprintf('Complete!\n');

