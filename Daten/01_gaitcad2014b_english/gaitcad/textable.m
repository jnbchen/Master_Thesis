  function textable(kopf,text,title,f,supertab,label)
% function textable(kopf,text,title,f,supertab,label)
%
% druckt Tabelle mit Kopf und Inhalt in File f für TEX (supertab.sty)
% Inhalt in text muss Zeilentrennung \n enthalten
% Beispiel: textable('Position & Merkmal & Bezeichnung & Güte',sprintf('1&2&3&4\n1&2&3&4\n'),'Merkmalsrelevanzen',1)
% ist supertab (optional=0) gesetzt, wird immer eine seitenübergreifende Supertabelle erzeugt, sonst eine Normaltabelle
% oder eine Supertabelle (ab>30 Zeilen) je nach Anzahl Tabellenzeilen
% ist label nicht gesetzt, wird als Label wird immer tab:??? vergeben
% Copyright: Ralf Mikut, Forschungszentrum Karlsruhe, IAI, 2000, E-Mail: mikut@iai.fzk.de
% 
%
% The function textable is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<5
   supertab=0;
end;
if nargin<6
   label='tab:???';
end;

anz_spalten=length(strfind(kopf,'&'))+1;
ind=strfind(text,10);
ind=[0 ind];
anz_zeilen=length(ind)-1;
supertabmin=30;

if supertab  ~= -1
   supertab=(anz_zeilen>=supertabmin)+supertab;
else
   supertab = 0;
end;


if supertab
   fprintf(f,'\n\\begin{footnotesize}\n\\begin{center}\n');
   fprintf(f,'\\bottomcaption{\\label{%s} %s} \n',label,title);
   
   fprintf(f,'\\tablehead {\\hline %s \\\\ \\hline }\n',kopf);
   fprintf(f,'\\tabletail{\\hline \\multicolumn{%d}{|r|} {to be continued} \\\\ \\hline} \n',anz_spalten);
   fprintf(f,'\\tablelasttail{\\hline} \n');
   
   fprintf(f,'\\begin{supertabular}{|');
else
   fprintf(f,'\\begin{table}[hp]\n\\begin{footnotesize}\n\\begin{center}\n\\begin{tabular}{|');
end;

for i=1:anz_spalten 
   fprintf(f,'c|');
end;
fprintf(f,'}\n');
if (~supertab)
   fprintf(f,'\\hline\n %s \\\\ \\hline\n ',kopf);
end;

for i=1:anz_zeilen 
   fprintf(f,'%s \\\\ \\hline\n',text(ind(i)+1:ind(i+1)-1) );
end;

if (supertab) 
   fprintf(f,'\\end{supertabular}\n\\end{center}\n\\end{footnotesize} \n');
else
   fprintf(f,'\\end{tabular}\n\\end{center}\n');
   fprintf(f,'\\caption{\\label{tab:%s} %s} \n',label,title);
   fprintf(f,'\\end{footnotesize}\n\\end{table}\n');
end;
