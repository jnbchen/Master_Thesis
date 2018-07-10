  function  textable2d(data,x_header,y_header,extension,parameter,par_percentage,tabletitle)
% function  textable2d(data,x_header,y_header,extension,parameter,par_percentage,tabletitle)
%
% 
% 
% Exampel: textable2d(histvaldeblank(char(zgf_y_bez(ind(1),unique(code_alle(ind_auswahl,ind(1)))).name)),deblank(char(zgf_y_bez(ind(2),unique(code_alle(ind_auswahl,ind(1)))).name)),'_hist2d',parameter,1,'2D-Histogramm');
% 
%
% The function textable2d is part of the MATLAB toolbox Gait-CAD. 
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

if parameter.gui.anzeige.tex_protokoll == 1
   datei_name=repair_dosname(sprintf('%s_%s.tex',parameter.projekt.datei,tabletitle));
else
   datei_name=repair_dosname(sprintf('%s_%s.txt',parameter.projekt.datei,tabletitle));
end;

f=fopen(datei_name,'wt');
headerline ='';
for i=1:size(x_header,1)
   headerline = strcat(headerline,sprintf('& %s',deblank(repair_texname(x_header(i,:)))));
end;

%zusätzliche TEX-Tabelle - vorinitialisieren, sonst wirds lahm
tableinh=char(1,32*ones(size(x_header,1) * size(y_header,1) * 50));
table_z=0;
for i=1:size(data,1)
   if par_percentage == 1
      tmp2 = [];
      for j=1:size(data,2)
         tmp2 = strcat(tmp2,sprintf('& %g (%4.1f\\%%,%4.1f\\%%)',data(i,j),100*data(i,j)/sum(data(i,:)),100*data(i,j)/sum(data(:,j))));
      end;
      
      tmp=[deblank(repair_texname(y_header(i,:))) tmp2 sprintf('\n')];
      
   else
      tmp=[deblank(repair_texname(y_header(i,:))) sprintf('& %g',data(i,:)) sprintf('\n')];
      
   end;
   
   tableinh(table_z+[1:length(tmp)])=tmp;
   table_z=table_z+length(tmp);
end;

textable(headerline,tableinh(1:table_z),tabletitle,f);
fprintf(f, '\\end{document}');
fclose(f);

if parameter.gui.anzeige.tex_protokoll == 0
   repair_file_content (datei_name, '\\ \hline', '');
   repair_file_content (datei_name, '\%', '%');
   repair_file_content (datei_name, '&', sprintf('\t'));   
end;

if parameter.allgemein.makro_ausfuehren==0
   viewprot(datei_name);
end;

