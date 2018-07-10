  function show_datenauswahl(parameter,code_alle,ind_auswahl,bez_code,zgf_y_bez)
% function show_datenauswahl(parameter,code_alle,ind_auswahl,bez_code,zgf_y_bez)
%
% 
%  function show_datenauswahl(datei,code_alle,ind_auswahl,bez_code,zgf_y_bez)
% 
%  zeigt aktuelle Datenauswahl (ausgewählte Datentupel) an
%  
% 
%  Die Funktion show_datenauswahl ist Teil der MATLAB-Toolbox Gait-CAD. 
%  Copyright (C) 2007  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Markus Reischl]
% 
% 
%  Letztes Änderungsdatum: 10-May-2007 17:50:35
%  
%  Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU General Public License,
%  wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, 
%  entweder gemäß Version 2 der Lizenz oder jeder späteren Version.
%  
%  Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, dass es Ihnen von Nutzen sein wird,
%  aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder 
%  der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK.
%  Details finden Sie in der GNU General Public License.
%  
%  Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm erhalten haben.
%  Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
%  
%  Weitere Erläuterungen zu Gait-CAD finden Sie in der beiliegenden Dokumentation oder im folgenden Konferenzbeitrag:
%  
%  MIKUT, R.; BURMEISTER, O.; REISCHL, M.; LOOSE, T.:  Die MATLAB-Toolbox Gait-CAD. 
%  In:  Proc., 16. Workshop Computational Intelligence, S. 114-124, Universitätsverlag Karlsruhe, 2006
%  Online verfügbar unter: http://www.iai.fzk.de/projekte/biosignal/public_html/gaitcad.pdf
%  
%  Bitte zitieren Sie diesen Beitrag, wenn Sie Gait-CAD für Ihre wissenschaftliche Tätigkeit verwenden.
% 
%
% The function show_terms is part of the MATLAB toolbox Gait-CAD. 
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

datei_name=sprintf('%s_ind_terms.txt',parameter.projekt.datei);     
f=fopen(datei_name,'wt');

if f==-1
    myerror(sprintf('Error by opening of %s',datei_name));
end;

fprintf(f,'Data selection:  %d Data points\n',size(code_alle(ind_auswahl,:),1));
fprintf(f,'Existing classes:\n');

if parameter.gui.allgemein.show_few_terms_first
   %sort by the number 
   [temp,nr_of_classes] = sort(parameter.par.anz_ling_y);
else
   nr_of_classes = 1:size(bez_code,1);
end;

for i=nr_of_classes 
   ind_class_i=findd(code_alle(ind_auswahl,i));
   fprintf(f,'\ny%d: %s (%d classes)\n',i,bez_code(i,:),length(ind_class_i));
   temp = hist(code_alle(ind_auswahl,i),1:max(ind_class_i));
   for j=find(temp>2) 
      fprintf(f,'%d (%s) - %d Data points\n',j,zgf_y_bez(i,j).name,temp(j));      
   end;
   if ~isempty(temp) && sum(temp==2)>0
      fprintf(f,'Further %d terms with two data points each\n',sum(temp==2));      
   end;
   if ~isempty(temp) && sum(temp==1)>0
      fprintf(f,'Further %d terms with one data point each\n',sum(temp==1));      
   end;
end; %i

if (f~=1) 
   fclose(f);
   viewprot(datei_name);
end; 

