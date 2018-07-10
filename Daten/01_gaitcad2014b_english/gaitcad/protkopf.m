  function prottail=protkopf(f,uihd,texprotokoll,datei,titel,texalone)
% function prottail=protkopf(f,uihd,texprotokoll,datei,titel,texalone)
%
% The function protkopf is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<6) 
   texalone=0;
end;

if f==-1
   myerror(sprintf('File %s could not be opened.\n',datei));
end;

if texprotokoll 
   trenn='&';
   zeilenende='\\';
   if texalone 
      fprintf(f, '\\documentclass[11pt,a4paper]{article}');
      fprintf(f, '\\usepackage[dvips]{epsfig}\n\\usepackage[ansinew]{inputenc}\n\\usepackage{supertabular}\n');
      fprintf(f, '\\usepackage{graphics}\n\\begin{document}\n\n');
   end;
   
   if ~isempty(titel) 
      fprintf(f,'\\section{%s - Project %s}\n',titel,char(datei(find(datei~='_'))));
   end;
   
   prottail=sprintf('\\subsection{Parameter}\n');
else         
   fprintf(f,'%s - Project:   %s.prjz\n',titel,datei);
   prottail=sprintf('\n\nParameter:\n');
   trenn='';
   zeilenende='';
end;


fprintf(f,'\nPath:   %s\n\n',strrep(strrep(pwd,'\','/'),'_','\_'));
if texprotokoll
   fprintf(f,'\n');
end;
tmp=clock;
fprintf(f,'Generated:  %d.%d.%d %02d:%02d %s\n',tmp([3 2 1 4 5]),zeilenende);
if texprotokoll
   fprintf(f,'\n');
end;

if (texprotokoll)
   prottail=[prottail sprintf('\n\\begin{tabular}[l]{|p{10cm}|l|}\n')];
end;

%chcek for a short protocol - only project statistics will be plotted 
hndl_short_protocol=findobj('tag','CE_Show_ShortProtocol');
if ~isempty(hndl_short_protocol)
   short_protocol= get(hndl_short_protocol,'value');
else
   short_protocol=0;
end;

%Optionen merken
%for feld=[10 11]

hndl_list = [ findobj('style','edit')' findobj('style','checkbox')' findobj('style','popupmenu')'];

%ind=find(uihd(feld,:));

%alle Schalterelemente werden dokumentiert und in Datei geschrieben, Unterscheidung je nach Typ
for hndl = hndl_list
   sty=get(hndl,'style');
   val=get(hndl,'value');
   str=get(hndl,'string');
   tag=get(hndl,'tag');
   userdata=get(hndl,'userdata');
   
   %sonst macht TEX einen Kommentar draus:
   if texprotokoll
      if (~isempty(userdata))
         userdata(userdata=='%')=' ';
      end;
      if (~isempty(str))
         str(str=='%')=' ';       
      end;
   end;   
   
   if short_protocol == 0 || ~isempty(strfind(tag,'IN_'))
      
      %Elemente reinschreiben
      if strcmp(sty,'checkbox') 
         if val  
            prottail=[prottail sprintf('%s: %s yes %s\n',str,trenn,zeilenende)];
         else 
            prottail=[prottail sprintf('%s: %s no %s \n',str,trenn,zeilenende)];
         end; %if
      end; %if
      
      if strcmp(sty,'edit')      
         prottail=[prottail sprintf('%s: %s %s %s \n',userdata,trenn,str,zeilenende)]; 
      end;
      if strcmp(sty,'popupmenu') 
         prottail=[prottail sprintf('%s: %s%s %s \n',userdata,trenn,str(val,:),zeilenende)]; 
      end; %if
   end;
end; %ind
%end; %j
if (texprotokoll) 
   prottail=[strrep(prottail,'_','\_') sprintf('\\end{tabular}\n')];
end;

if nargout==0
   fprintf(f,'%s',prottail);
end;

