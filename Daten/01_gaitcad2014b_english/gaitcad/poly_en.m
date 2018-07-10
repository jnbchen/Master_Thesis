  function [poly_regr,merkmal_auswahl,merk,merk_archiv]=poly_en(d,ykont,anz_merk,poly_degree,preselection,interpret_merk,multivariat,weight_vector,anzeige)
% function [poly_regr,merkmal_auswahl,merk,merk_archiv]=poly_en(d,ykont,anz_merk,poly_degree,preselection,interpret_merk,multivariat,weight_vector,anzeige)
%
% 
% 
%
% The function poly_en is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<5)
   preselection=[];
end;

if (nargin<6)
   interpret_merk =[];
end;

if (nargin<7)
   multivariat = 1;
end;

if (nargin<8)
   weight_vector =[];
end;

if (nargin<9)
   anzeige = 1;
end;

if isempty(interpret_merk)
   interpret_merk=ones(1,size(d,2));
end;

if anzeige == 1
    fprintf('\nCompute multiple regression coefficients...\n');
end;

%no features - return...
if (anz_merk==0)
   merkmal_auswahl=[];
   poly_regr = [];
   merk = [];
   merk_archiv =[];
   return;
end;

%initialize data matrix with polynomial coefficients
data=[d zeros(size(d,1),size(d,2)*(poly_degree-1))];
counter=size(d,2);

%restore original feature descriptions for polynomial degree one
for i=1:size(d,2)
   poly_regr.feature_description_org(i,:) = [i 1];
end;

% higher order polynoms
for i_poly=2:poly_degree
   for i=1:size(d,2)
      counter = counter + 1;
      data(:,counter) = data(:,i).^i_poly;
      poly_regr.feature_description_org(counter,:) = [i i_poly];
      interpret_merk(counter) = interpret_merk(i);
   end;
end;

anz_merk=min(anz_merk,size(data,2));

if anz_merk==0
   myerror('No selected features or the selected single features are identical to the output variable!');
end;

%feature reduction if necessary
 
   data_mean  = data-ones(size(data,1),1)*mean(data);
   ykont_mean = ykont - mean(ykont);
   parameter.mode_bewertung = 9 + multivariat;
   parameter.merk_red = anz_merk;
   parameter.anzeige_details = 0;
   parameter.merkmal_vorauswahl  = preselection;
   [merkmal_auswahl,merk,merk_archiv] =feature_selection (data_mean, ykont_mean, interpret_merk',parameter);


%compute transformation vector
phi_mkorr=zeros(2*size(d,2)+1,1);
X=[ones(size(data,1),1) data(:,merkmal_auswahl)];

if rank(X)<size(X,2)
   mywarning('Rank deficient for the input variable of the regression! Please adapt the structure! The result might be insufficient.');
end;


if isempty(weight_vector) 
   adach=(pinv(X'*X)*X'*ykont);
else
   adach = (pinv(X'*diag(weight_vector)*X)*X'*diag(weight_vector)*ykont);
end;

   
%apply, if you want:
%ydach=X*adach;

poly_regr.phi_m_korr = adach;

%selected features
poly_regr.merkmal_auswahl = findd_unsort(poly_regr.feature_description_org(merkmal_auswahl,1));
%coding table
recoding(poly_regr.merkmal_auswahl) = 1:length(poly_regr.merkmal_auswahl);
%selected features with the old feature numbers
poly_regr.feature_description_raw   = poly_regr.feature_description_org(merkmal_auswahl,:);
%selected features with the new feature numbers
poly_regr.feature_description       = poly_regr.feature_description_raw;
poly_regr.feature_description(:,1)  = recoding(poly_regr.feature_description(:,1));

if anzeige == 1
   fprintf('Ready. \n');
end;

