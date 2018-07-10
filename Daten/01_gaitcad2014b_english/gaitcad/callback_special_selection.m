% Script callback_special_selection
%
% The script callback_special_selection is part of the MATLAB toolbox Gait-CAD. 
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

if ~exist('mode_figure','var')
    mode_figure =[];
end;

if ~isnumeric(mode_figure) && ~isgraphics(mode_figure)  
    %mode_figure is neither a number or a valid graphics object - then
    %delete it completly
    mode_figure = [];
end;


if isempty(mode_figure)
    mode_figure = gcf;
end;

if length(parameter.gui.merkmale_und_klassen.ind_em) ~= 2
    myerror('The interactive selection of data points is only available if two single features have been selected.');
end;


%set field with seleceted data points
if ~exist('myselection','var') ||  ~isfield(myselection,'fig_name')
    %the selection is always defined for all open figures to avoid chaos
    myselection.ind_selection = [];
    myselection.fig_name(get_figure_number(gcf))=0;
end;

%new figure;
if length(myselection.fig_name)<get_figure_number(mode_figure) || get_figure_number(myselection.fig_name(get_figure_number(mode_figure))) <2
    figure;
    mode_figure = gcf;
    myselection.fig_name(get_figure_number(mode_figure))=mode_figure;
    myselection.callback{get_figure_number(mode_figure)} = mode_callback;
    myselection.ind_em(get_figure_number(mode_figure),1:2) = parameter.gui.merkmale_und_klassen.ind_em(1:2);
else
    %clear figure
    figure(myselection.fig_name(get_figure_number(mode_figure)));
end;

%save data point selection and single features
myselection.ind_auswahl = ind_auswahl;

%set menu points for adding and removing of data points
hndl_menu = findobj('type','uimenu','parent',mode_figure);
if ~isempty(hndl_menu)
    delete(hndl_menu);
end;
clear hndl_menu ;

%call the related callback to show the objects
eval(myselection.callback{get_figure_number(mode_figure)});

set(mode_figure,'deletefcn','myselection.fig_name(get_figure_number(gcf))=0;myselection.ind_em(get_figure_number(gcf),:)=0; myselection.callback{get_figure_number(gcf)}=[];','toolbar','figure','menubar','none');
uimenu('parent',myselection.fig_name(get_figure_number(mode_figure)),'label','Refresh', 'callback','for i_cbss = find(myselection.fig_name) mode_figure = i_cbss;callback_special_selection;end;');
ha_mark = uimenu('parent',myselection.fig_name(get_figure_number(mode_figure)),'label','Mark');
uimenu('parent',ha_mark,'label','Reset', 'callback','mode = 0;callback_bt_special_selection;');
uimenu('parent',ha_mark,'label','Add',   'callback','mode = 1;callback_bt_special_selection;');
uimenu('parent',ha_mark,'label','Remove','callback','mode = 2;callback_bt_special_selection;');
uimenu('parent',ha_mark,'label','Show class memberships for the selected data points','callback','mode = 7;callback_bt_special_selection;');
uimenu('parent',ha_mark,'label','Save as output variable','separator','on','callback','mode = 3;callback_bt_special_selection;');
uimenu('parent',ha_mark,'label','Select data points','callback','mode = 5;callback_bt_special_selection;');
if par.anz_image > 0
    uimenu('parent',myselection.fig_name(get_figure_number(mode_figure)),'label','Show images','callback','mode = 6;callback_bt_special_selection;');
    uimenu('parent',myselection.fig_name(get_figure_number(mode_figure)),'label','Show videos','callback','mode = 8;callback_bt_special_selection;');
end;



%... and to change selected output terms
hndl_change = uimenu('parent',myselection.fig_name(get_figure_number(mode_figure)),'label',['Change: Term of the output variable ' deblank(bez_code(par.y_choice,:))]);
for i_cl = 1:min(50,par.anz_ling_y(par.y_choice))
    temp_callback = sprintf('mode= 4; myterm = %d;myoutput =%d; callback_bt_special_selection;',i_cl,par.y_choice);
    uimenu('parent',hndl_change,'label',deblank(zgf_y_bez(par.y_choice,i_cl).name),'callback',temp_callback);
end;
%mark it as a new term
temp_callback = sprintf('mode= 4; myterm = %d;myoutput =%d; callback_bt_special_selection;',par.anz_ling_y(par.y_choice)+1,par.y_choice);
uimenu('parent',hndl_change,'label','New term','callback',temp_callback);
clear hndl_change temp_callback

mode_figure =[];



