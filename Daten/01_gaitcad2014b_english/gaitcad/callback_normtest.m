  function callback_normtest(d_org,dorgbez,code,zgf_y_bez,bez_code,par,parameter,uihd)
% function callback_normtest(d_org,dorgbez,code,zgf_y_bez,bez_code,par,parameter,uihd)
%
% 
% 
%
% The function callback_normtest is part of the MATLAB toolbox Gait-CAD. 
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

if ~exist('ttest2','file')
   myerror('The function could not been executed because the Statistic Toolbox was not found.');
end;



%Prepare format strings for Latex and text files
zahlenstring=get_zahlenstring;
if parameter.gui.anzeige.tex_protokoll
   rowtemplate      =sprintf('%%s & %s ',zahlenstring);
   rowtemplate_empty=sprintf('%%s & - ');
   fileextension = '.tex';
else
   rowtemplate=sprintf('%%s  \t %s ',zahlenstring);
   rowtemplate_empty=sprintf('%%s \t - ');
   fileextension = '.txt';
end;

%Prepare different methods
switch parameter.gui.statistikoptionen.normtest
   case 1 
      myextension = sprintf('chi_square');
      prottext = 'Chi Square Test';
   case 2 
      myextension = sprintf('lillie');
      prottext = 'Lillie Test';
   case 3 
      myextension = sprintf('adtest');
      prottext = 'Anderson Darling Test';
   case 4 
      myextension = sprintf('jbtest');
      prottext = 'Jarque Bera Test';  
end;
prottext = sprintf('%s\n%s\n%s\n\n',prottext,'-  : Null hypothesis of normal distribution cannot be rejected,','NaN: The test can not be done in a avlid way.');  

%prepare file and table header
myfilename=strcat(parameter.projekt.datei,'_',repair_dosname(deblank(bez_code(par.y_choice,:))),'_',myextension,fileextension);
myf = fopen(myfilename,'wt');
prottail=protkopf(myf,uihd,parameter.gui.anzeige.tex_protokoll,parameter.projekt.datei,prottext);

%prepare line template
tableinh=char(32*ones(1,100*(length(parameter.gui.merkmale_und_klassen.ind_em)*size(dorgbez,2)+20)));
table_z=1;
a = zeros(par.anz_einzel_merk,max(code)+1);

if parameter.gui.anzeige.tex_protokoll == 1
   tablekopf='Feature & All';
   for i_code = generate_rowvector(unique(code))
      tablekopf=sprintf('%s & %s',tablekopf,zgf_y_bez(par.y_choice,i_code).name);
   end;
else
   fprintf(myf,'Feature \t All');
   for i_code = generate_rowvector(unique(code))
      fprintf(myf,'\t%s',zgf_y_bez(par.y_choice,i_code).name);
   end;
end;

%Tests for all selected features
for i_feat = parameter.gui.merkmale_und_klassen.ind_em
   tablezeile ='';
   switch parameter.gui.statistikoptionen.normtest
      case 1
         [temp,a(i_feat,1)] = chi2gof(d_org(:,i_feat));
      case 2
         [temp,a(i_feat,1)] = lillietest(d_org(:,i_feat));
      case 3
         [temp,a(i_feat,1)] = adtest(d_org(:,i_feat));
           case 4
         [temp,a(i_feat,1)] = jbtest(d_org(:,i_feat));
   end;
   
   if a(i_feat,1)<parameter.gui.statistikoptionen.p_krit || isnan(a(i_feat,1))
      %relevant difference
      tablezeile=sprintf(rowtemplate,tablezeile,a(i_feat,1));
   else
      %irrelavant difference
      tablezeile=sprintf(rowtemplate_empty,tablezeile);
   end;
   
   %class-specific tests
   for i_code = generate_rowvector(unique(code))
      
      switch parameter.gui.statistikoptionen.normtest
         case 1
            [temp,a(i_feat,i_code+1)] = chi2gof(d_org(find(code==i_code),i_feat));
         case 2
            [temp,a(i_feat,i_code+1)] = lillietest(d_org(find(code==i_code),i_feat));
         case 3
            [temp,a(i_feat,i_code+1)] = adtest(d_org(find(code==i_code),i_feat));
            case 4
            [temp,a(i_feat,i_code+1)] = jbtest(d_org(find(code==i_code),i_feat));
            
      end;
      
      if a(i_feat,i_code+1)<parameter.gui.statistikoptionen.p_krit || isnan(a(i_feat,i_code+1))
         %relevant difference
         tablezeile=sprintf(rowtemplate,tablezeile,a(i_feat,i_code+1));
      else
         %irrelavant difference
         tablezeile=sprintf(rowtemplate_empty,tablezeile);
      end;
   end;
   %feature-wise output
   if parameter.gui.anzeige.tex_protokoll
      %Latex
      tablezeile=sprintf('$x_{%3d}$ (%s) %s\n',i_feat,dorgbez(i_feat,:),tablezeile);
      tableinh(table_z+[1:length(tablezeile)])=tablezeile;
      table_z =table_z+length(tablezeile);
   else
      %Text
      fprintf(myf,'\nFeature %3d (%s) %s',i_feat,dorgbez(i_feat,:),tablezeile);
   end; %j
end;

if parameter.gui.anzeige.tex_protokoll == 1
   %plot latex table
   textable(tablekopf,tableinh(1:table_z),prottext,myf);
end;

%File handling
fprintf(myf,'%s',prottail);
fclose(myf);
viewprot(myfilename);

