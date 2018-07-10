% Script callback_bt_special_selection
%
% The script callback_bt_special_selection is part of the MATLAB toolbox Gait-CAD. 
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

ax = axis;

%identify all selected data points which are visible in the recent figure
ind = find( d_org(ind_auswahl,myselection.ind_em(get_figure_number(gcf),1)) >= ax(1) & d_org(ind_auswahl,myselection.ind_em(get_figure_number(gcf),1)) <= ax(2) & ...   % Coderevision: &/| checked!
    d_org(ind_auswahl,myselection.ind_em(get_figure_number(gcf),2)) >= ax(3) & d_org(ind_auswahl,myselection.ind_em(get_figure_number(gcf),2)) <= ax(4) );              % Coderevision: &/| checked!
ind = myselection.ind_auswahl(ind);

switch mode
    case 0
        %reset all selections
        myselection.ind_selection = [];
    case 1
        %add marked data points to the selection
        myselection.ind_selection = unique([myselection.ind_selection ind']);
    case 2
        %remove marked data points to the selection
        myselection.ind_selection = setdiff(myselection.ind_selection,ind);
    case 3
        %generate a new output variable
        if ~isempty(myselection.ind_selection)
            newcode = ones(par.anz_dat,1);
            newcode(myselection.ind_selection) = 2;
            newcodename = 'Data selection';
            newtermname(1).name = 'none';
            newtermname(2).name = 'yes';
            save_figure_name = gcf;
            [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,newcodename,newtermname);
            aktparawin;
            figure(save_figure_name);
            
        end;
    case 4
        %change the value of the selected output variable
        code_alle(ind,myoutput) = myterm;
        code(ind) = myterm;
        if myterm>par.anz_ling_y(myoutput)
            zgf_y_bez(myoutput,myterm).name = ['New term' sprintf('B%d%d',myoutput,myterm)];
            par.anz_ling_y(myoutput) = myterm;
        end;
    case 5
        %select marked data points
        if ~isempty(myselection.ind_selection)
            ind_auswahl = myselection.ind_selection';
        end;
    case 6
        %show the related images
        if ~isempty(ind)
            myselection.ind_auswahl_rett = ind_auswahl;
            %     ind_auswahl = ind;
            mode_images = 1;
            %     callback_handle_images;
            for ind_auswahl = ind'
                callback_handle_images;
                if ~isempty(parameter.gui.image.rectangle)
                    figure(max(get_figure_number(get(0,'children'))));
                    callback_plot_rectangles;
                end;
            end;
            ind_auswahl = myselection.ind_auswahl_rett;
        end;
        
    case 7
        %show the related data points as list
        if ~isempty(ind)
            myselection.ind_auswahl_rett = ind_auswahl;
            ind_auswahl = ind;
            
            %% Ansicht,  Klassenzugehörigkeiten ausgewählter Datentupel anzeigen
            eval(gaitfindobj_callback('MI_Anzeige_Datentupel'));
            ind_auswahl = myselection.ind_auswahl_rett;
        end;
        
    case 8
        %show the related videos
        if ~isempty(ind)
            myselection.ind_auswahl_rett = ind_auswahl;
            %     ind_auswahl = ind;
            mode_images = 4;
            %     callback_handle_images;
            for ind_auswahl = ind'
                callback_handle_images;
            end;
            ind_auswahl = myselection.ind_auswahl_rett;
        end;
        
end;

callback_special_selection;


