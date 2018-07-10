  function show_plugintable(plugins,for_doku)
% function show_plugintable(plugins,for_doku)
%
% 
% gives a list of plugin infomation details for all available plugins in the given search path
% 
%
% The function show_plugintable is part of the MATLAB toolbox Gait-CAD. 
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

if nargin < 2
    for_doku = 0;
end;

if for_doku == 0
    filename = 'plugin_status.txt';
else
    filename = 'plugin_status.tex';
end;

f= fopen(filename,'wt');
%ID for main file
f_save = f;

%list of all open files
f_list = f;

filename_appl_list.names = {};
filename_appl_list.ids   = {};
if for_doku == 1
    fprintf(f,'\\chapter{Plugins}\\label{sec:appendix_plugin}\n\\begin{itemize}\n');
end;


for i=1:length(plugins.mgenerierung_plugins.info)
    
    try
        if for_doku == 0
            
            fprintf(f,'\n');
            fprintf(f,'Plugin No. %d\n',i);
            fprintf(f,'Description:     %s\n',plugins.mgenerierung_plugins.info(i).beschreibung);
            fprintf(f,'Explanation:      %s\n',plugins.mgenerierung_plugins.info(i).explanation);
            fprintf(f,'Short names:      %s\n',plugins.mgenerierung_plugins.info(i).bezeichner');
            fprintf(f,'Function name:    %s\n',which(kill_lz(plugins.mgenerierung_plugins.funktionsnamen(i,:))));
            fprintf(f,'Type:             %s\n',plugins.mgenerierung_plugins.info(i).typ);
            fprintf(f,'Input TS:          %g\n',plugins.mgenerierung_plugins.info(i).anz_benoetigt_zr);
            fprintf(f,'Output TS:        %g\n',plugins.mgenerierung_plugins.info(i).anz_zr);
            if plugins.mgenerierung_plugins.info(i).einzug_OK == 0
                cb_state = 'none';
            else
                cb_state = 'yes';
            end;
            fprintf(f,'Segments possible:%s\n',cb_state);
            fprintf(f,'Input SF:          %g\n',plugins.mgenerierung_plugins.info(i).anz_benoetigt_em);
            fprintf(f,'Output SF:        %g\n',plugins.mgenerierung_plugins.info(i).anz_em);
            fprintf(f,'Input Image:       %g\n',plugins.mgenerierung_plugins.info(i).anz_benoetigt_im);
            fprintf(f,'Output Image:     %g\n',plugins.mgenerierung_plugins.info(i).anz_im);
            if  isempty(plugins.mgenerierung_plugins.info(i).commandline);
                anz_par = 0;
            else
                anz_par = length(plugins.mgenerierung_plugins.info(i).commandline.description);
            end;
            
            if isempty(plugins.mgenerierung_plugins.info(i).callback);
                cb_state = 'none';
            else
                cb_state = 'yes';
            end;
            fprintf(f,'Direct callback:  %s\n',cb_state);
            
            fprintf(f,'Number of parameters: %g\n',anz_par);
            if anz_par>0
                for i_par = 1:anz_par
                    fprintf(f,'%s',char(plugins.mgenerierung_plugins.info(i).commandline.description(i_par)));
                    temp_tool = char(plugins.mgenerierung_plugins.info(i).commandline.tooltext(i_par));
                    if ~isempty(temp_tool)
                        fprintf(f,' (%s)',temp_tool);
                    end;
                    fprintf(f,'\n');
                end;
            end;
            
            
            
            
        else
            which(kill_lz(plugins.mgenerierung_plugins.funktionsnamen(i,:)))
            if isempty(strfind(which(kill_lz(plugins.mgenerierung_plugins.funktionsnamen(i,:))),'application_special'))
                %append information to plugin_status file for main Gait-CAD
                f = f_save;
            else
                %%append information to plugin_status file for extension package of Gait-CAD
                %get name of the related extension package
                temp_f = which(deblank(plugins.mgenerierung_plugins.funktionsnamen(i,:)));
                ind_filesep = strfind(temp_f,filesep);
                ind_appl_spec = strfind(temp_f,'application_special');
                if ~isempty(ind_appl_spec)
                    appl_name = temp_f(ind_filesep(length(ind_filesep)-3)+1:ind_filesep(length(ind_filesep)-2)-1);
                end;
                
                %switch to the ID of the open file or open it if necessary
                filename_appl = [appl_name '_' filename];
                new_appl_file = find(ismember(filename_appl_list.names,filename_appl));
                if isempty(new_appl_file) || new_appl_file == 0
                    new_appl_file = length(filename_appl_list.names)+1;
                    filename_appl_list.names{new_appl_file} = filename_appl;
                    filename_appl_list.ids{new_appl_file}   = fopen(filename_appl,'wt');
                    fprintf(filename_appl_list.ids{new_appl_file},'\\chapter{Plugins}\\label{sec:appendix_plugin}\n\\begin{itemize}\n');
                    f_list = [f_list filename_appl_list.ids{new_appl_file}];
                end;
                f = filename_appl_list.ids{new_appl_file};
            end;
            
            temp_str = plugins.mgenerierung_plugins.info(i).bezeichner';
            fprintf(f,'\n \\item {\\bf %s (%s)}: %s',plugins.mgenerierung_plugins.info(i).beschreibung,strrep(temp_str(:)','_','\_'),strrep(plugins.mgenerierung_plugins.info(i).explanation,'_','\_'));
            if ~isempty(plugins.mgenerierung_plugins.info(i).explanation_long)
                fprintf(f,' %s',plugins.mgenerierung_plugins.info(i).explanation_long);
            end;
            fprintf(f,'\n \\begin{itemize}\n');
            fprintf(f,'\\item ');
            fprintf(f,'Function name:    %s.m\n',strrep(kill_lz(plugins.mgenerierung_plugins.funktionsnamen(i,:)),'_','\_'));
            fprintf(f,'\\item ');
            fprintf(f,'Type:             %s\n',plugins.mgenerierung_plugins.info(i).typ);
            fprintf(f,'\\item ');
            if plugins.mgenerierung_plugins.info(i).einzug_OK == 0
                cb_state = 'none';
            else
                cb_state = 'yes';
            end;
            fprintf(f,'Time series: %d inputs, %d outputs, Segments possible:   %s\n',plugins.mgenerierung_plugins.info(i).anz_benoetigt_zr,plugins.mgenerierung_plugins.info(i).anz_zr,cb_state);
            fprintf(f,'\\item ');
            fprintf(f,'Single features: %d inputs, %d outputs\n',plugins.mgenerierung_plugins.info(i).anz_benoetigt_em,plugins.mgenerierung_plugins.info(i).anz_em);
            fprintf(f,'\\item ');
            fprintf(f,'Images: %d inputs, %d outputs\n',plugins.mgenerierung_plugins.info(i).anz_benoetigt_im, plugins.mgenerierung_plugins.info(i).anz_im);
            if  isempty(plugins.mgenerierung_plugins.info(i).commandline);
                anz_par = 0;
            else
                anz_par = length(plugins.mgenerierung_plugins.info(i).commandline.description);
            end;
            fprintf(f,'\\item ');
            if isempty(plugins.mgenerierung_plugins.info(i).callback);
                cb_state = 'none';
            else
                cb_state = 'yes';
            end;
            fprintf(f,'Direct callback:  %s\n',cb_state);
            
            fprintf(f,'\\item ');
            fprintf(f,'Number of parameters: %g\n',anz_par);
            
            
            
            
            if anz_par>0
                fprintf(f,'\n \\begin{itemize}\n');
                for i_par = 1:anz_par
                    fprintf(f,'\\item ');
                    fprintf(f,'%s',strrep(char(plugins.mgenerierung_plugins.info(i).commandline.description(i_par)),'_','\_'));
                    temp_tool = char(plugins.mgenerierung_plugins.info(i).commandline.tooltext(i_par));
                    if ~isempty(temp_tool)
                        fprintf(f,' (%s)',strrep(temp_tool,'_','\_'));
                    end;
                    fprintf(f,'\n');
                end;
                fprintf(f,'\\end{itemize}');
                
            end;
            
            fprintf(f,'\\end{itemize}');
        end;
        
    catch
        mywarning(sprintf('Error during showing plugin %s',plugins.mgenerierung_plugins.info(i).beschreibung));
    end;
    
end;


for i=1:length(f_list)
    if for_doku == 1
        fprintf(f_list(i),'\\end{itemize}\n');
    end;
    fclose(f_list(i));
end;

if for_doku == 1
    repair_file_content (pwd, 'µ', '$\mu$','*plugin_status.tex');
    repair_file_content (pwd, '_', '\_','*plugin_status.tex');
    repair_file_content (pwd, '\\_', '\_','*plugin_status.tex');
    repair_file_content (pwd, 'appendix\_', 'appendix_','*plugin_status.tex');
   
end;
edit(filename);