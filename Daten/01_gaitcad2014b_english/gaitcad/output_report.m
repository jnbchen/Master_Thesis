  function  output_report(zgf_y_bez,code,bez_code,parameter)
% function  output_report(zgf_y_bez,code,bez_code,parameter)
%
% 
% 
%
% The function output_report is part of the MATLAB toolbox Gait-CAD. 
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

if parameter.gui.anzeige.tex_protokoll
   datei_name=sprintf('%s_output_%s.tex',parameter.projekt.datei,kill_lz(bez_code));
else 
   datei_name=sprintf('%s_output_%s.txt',parameter.projekt.datei,kill_lz(bez_code));
end;

%Dummy-File test.txt fuer sofortige Visualisierung
datei_name = repair_dosname(datei_name);
f=fopen(datei_name,'wt');
notep=1;

if parameter.gui.anzeige.tex_protokoll == 0
   fprintf(f,'%-50s \tNumber \n','Term');
   for i_term=1:length(zgf_y_bez) 
      fprintf(f,'%-50s \t %-8d\n',zgf_y_bez(1,i_term).name,sum(code == i_term));
   end;
else 
   %zusätzliche TEX-Tabelle - vorinitialisieren, sonst wirds lahm   
   tableinh=char(32*ones(1,length(zgf_y_bez)*50));
   table_z=1;
   for i_term=1:length(zgf_y_bez) 
      tmp=sprintf('%s & %-5d (%5.1f \\%%)\n ',zgf_y_bez(1,i_term).name,sum(code == i_term),100*sum(code == i_term)/length(code));
      tableinh(table_z+[1:length(tmp)])=tmp;
      table_z=table_z+length(tmp);
   end;
end;

if parameter.gui.anzeige.tex_protokoll == 1 
   textable('Term & Number',tableinh(1:table_z),sprintf('Number of linguistic terms  -- %s',kill_lz(bez_code)),f); 
   fprintf(f, '\\end{document}');
end;
if (notep) 
   fclose(f);
   if parameter.allgemein.makro_ausfuehren==0
      viewprot(datei_name);
   end;
end;	
