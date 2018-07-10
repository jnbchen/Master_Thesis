  function autoreport(mydirectory,mytitle,parameter,myextension)
% function autoreport(mydirectory,mytitle,parameter,myextension)
%
% 
% 
% plots a complete report called autoreport.text and autoreport.pdf
% for all project files in the directory ''mydirectory''
% The main file is produced by copying reporttemplate.tex from Gait-CAD to the working directory.
% 
% The content
%  - a file called general_comments.tex with general comments to all projects
%  - for each Gait-CAD project file [projectname].prjz
%    - optional: a file called [projectname].protocol.tex with project statistics like number of time series ...
%    - optional: a file called [projectname].report.tex with manual comments
%    - optional: all figures related with the project
% 
% Example:
% autoreport('C:\rohdaten\eng\karlsruhe_0807\2007-08-14_FZK5','Arbeitsbericht Nervendaten',parameter)
% 
% 
%
% The function autoreport is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

if nargin<4
   myextension = '*.prjz';
end;


%style for pictures 
parameter.auto_report.picture_style = '\\\\includegraphics[bb=0 0 %d %d,width=.8\\\\columnwidth]{%%s}\\n';
parameter.auto_report.picture_type  = 'jpeg';
parameter.auto_report.picture_path  = sprintf('%simages',filesep);

if ~isfield(parameter.auto_report,'subdirectories')
   parameter.auto_report.subdirectories = 1;
end;


cd(mydirectory);
repair_filenames(mydirectory,parameter.auto_report.subdirectories);

%get project list
project_list = getsubdir(mydirectory,myextension,parameter.auto_report.subdirectories);

if ~exist('report','dir')
   mkdir('report'); 
end
cd report;

if ~exist('source','dir')
   mkdir('source'); 
end;   
cd(mydirectory);

%generate titlepage 
f_tex = fopen(strrep('report\source\titlepage.tex','\',filesep),'wt');
fprintf(f_tex,'\\title{%s}',repair_texname(mytitle));
fclose(f_tex);

%include command for general comments
f_tex = fopen(strrep('report\source\report_content.tex','\',filesep),'wt');
if exist('general_comments.tex','file')
   fprintf(f_tex,'\\input{../general_comments.tex}');
end;

%include error logfile
if exist([mydirectory filesep 'error.log'],'file')
   fprintf(f_tex,'\\section{Error protocol}\n');
   fprintf(f_tex,'\\begin{tiny}\n');
   %   fprintf(f_tex,'\\begin{verbatim}\n');
   f_error = fopen('error.log','rt');
   
   
   temp = fscanf(f_error,'%c');
   fclose(f_error);
   
   temp = strrep(temp,'\','/');
   temp = strrep(temp,'_','\_');
   fprintf(f_tex,'%c',temp);
   %  fprintf(f_tex,'\\end{verbatim}\n');
   fprintf(f_tex,'\\end{tiny}\n');
   
end;

%list of existing pictures in the path bilder
picture_list = getsubdir([mydirectory parameter.auto_report.picture_path],['*.' parameter.auto_report.picture_type],0);   
if ~isempty(picture_list)
   fprintf(f_tex,'\n\\clearpage \\section{Images}\n');
   autoreport_picturelist;
end;


%cut extensions - necessary to find redundant names valid for a project with a longer and a shorter name
for i_project = 1:length(project_list)
   [local_wd,project_name] = fileparts(project_list(i_project).name);
   project_list(i_project).name = fullfile(local_wd,project_name);
end;
for i_project = 1:length(project_list)
   project_list(i_project).redundant = getfindstr(char(project_list.name),project_list(i_project).name); %project_list(i_project).redundant = strmatch(project_list(i_project).name,char(project_list.name));
   project_list(i_project).redundant(project_list(i_project).redundant == i_project) = [];
end;




%for all projects
for i_project = 1:length(project_list)
   
   [local_wd,project_name] = fileparts(project_list(i_project).name);
   
   %list of existing pictures for the project
   project_name_picture_list  = project_name (find ( project_name~=' ' & project_name~=',' & project_name~='.')); % Coderevision: &/| checked!
   picture_list = getsubdir(local_wd,[ project_name_picture_list '*.' parameter.auto_report.picture_type],0);   
   
   
   
   
   
   fprintf(f_tex,'\n\\clearpage \\section{%s}\n General project comments\n\n',strrep(project_name,'_','\_'));
   if length(local_wd)<80 
      fprintf(f_tex,'Path: \n\\begin{verbatim}\n%s\n\\end{verbatim}\n',repair_texname(local_wd));
   else
      fprintf(f_tex,'Path: \n\\begin{verbatim}\n%s\n',repair_texname(local_wd(1:80)));
      fprintf(f_tex,'         %s\n\\end{verbatim}\n',repair_texname(local_wd(81:end)));
   end;
   
   %link to the all latex files if any
   prot_file = getsubdir(local_wd,[project_name '*.tex'],0);
   
   %delete mismatched latex files from the list
   for i_redundant = project_list(i_project).redundant'  
      if isempty(prot_file) || isempty(i_redundant)
         break;
      end;         
      del_prot = getfindstr(char(prot_file.name),project_list(i_redundant).name); %del_prot = strmatch(project_list(i_redundant).name,char(prot_file.name));
      if ~isempty(del_prot)
         prot_file(del_prot) = [];
      end;
   end;      
   
   
   for i_prot = 1:length(prot_file)
      %search and replace misleading \section comments in protocol files
      f_rep = fopen(prot_file(i_prot).name,'rt');
      temp=fscanf(f_rep,'%c');
      temp=strrep(temp,'\section', '\subsection');
      
      ind = strfind(temp,'\begin{document}');
      if ~isempty(ind)
         temp(1:ind(1)+length('\begin{document}')) = [];         
      end;
      ind = strfind(temp,'\end{document}');
      if ~isempty(ind)
         temp(ind(1):end) = [];         
      end;
      ind = strfind(temp,'\subsection{Parameter}');
      if ~isempty(ind)
         temp(ind(1):end) = [];         
      end;
      
      temp = strrep(temp,'->','$\rightarrow$');
      temp = strrep(temp,'+-','$\pm$');
      temp = strrep(temp,'\bm{','\mathbf{');
      temp = strrep(temp,'_','\_');
      temp = strrep(temp,'\\_','\_');
     

      
      fclose(f_rep);
      f_rep = fopen(prot_file(i_prot).name,'wt');
      temp=fprintf(f_rep,'%s',temp);
      fclose(f_rep);
      fprintf(f_tex,'\\clearpage\n');
      fprintf(f_tex,'\\input{%s}\n',strrep(prot_file(i_prot).name,'\','/'));
   end;
   
   if ~isempty(picture_list)
      %delete mismatched images
      if ~isempty(project_list(i_project).redundant) 
         for i_redundant = project_list(i_project).redundant'  
            del_pic = getfindstr(char(picture_list.name),project_list(i_redundant).name); %del_pic = strmatch(project_list(i_redundant).name,char(picture_list.name));
            if ~isempty(del_pic)
               picture_list(del_pic) = [];
            end;
            if isempty(picture_list)
               break;
            end;         
         end;    
      end;
      
      %make image protocol
      if ~isempty(picture_list) 
         autoreport_picturelist;      
      end;      
   end;
   
end;
fclose(f_tex);

%get main file

cd report;

mytitle = [mydirectory filesep 'report' filesep strrep(mytitle,' ','_')];
if ~exist([mytitle '.tex'],'file')
   eval(sprintf('!copy %s%sstandardmakros%sreporttemplate.tex "%s.tex"',parameter.allgemein.pfad_gaitcad,filesep,filesep,mytitle));
end;


%start latex
eval(sprintf('!texify "%s.tex"',mytitle));  

%make pdf
%start latex
eval(sprintf('!dvipdfm "%s.dvi"',mytitle));  

%open pdf
eval(sprintf('!"%s.pdf" &',mytitle)); 

cd ..




function plot_tex_figure(fileid,filename,mystyle)
%plots a figure framework in the tex file with ID fileid 
%filename is the name of the related Gait-CAD project
%mystyle is a semi-standard template 

fprintf(fileid,'\\begin{figure}[!htb]\n');
fprintf(fileid,'\\centering\n');
filename=strrep(filename,'\','/');
fprintf(fileid,mystyle,filename);

[temp,filename_short] = fileparts(filename); 

%avoid problems with underscores in texts and labels
%german umlaute should be removed from repair_filenames 
filename_short=strrep(filename_short,'_',' ');
%filename_short=strrep(filename_short,'ü','ue');

fprintf(fileid,'\\caption{\\label{fig:%s} %s}\n',filename_short,filename_short);
fprintf(fileid,'\\end{figure}\n');


function mystyle = crack_jpg(filename,mystyle)
%reads width and height from jpeg-file for the bb-command of latex \includegraphics


%open figure
f_info=imfinfo(filename);

%modify figure template for tex
mystyle = sprintf(mystyle, f_info.Width,f_info.Height);

