  function [plot_color, plot_style,color_and_style]=color_style(variante)
% function [plot_color, plot_style,color_and_style]=color_style(variante)
%
%  liefert in plot_color Farbeinstellungen (versch. varianten möglich)
%  liefert in plot_color style-Einstellungen (versch. varianten möglich)
%
% The function color_style is part of the MATLAB toolbox Gait-CAD. 
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

color_and_style = 0;

if nargin<1 || isempty(variante)
   % ACHTUNG!!!!!!! globales Überladen der Varianten-Wahl!!!
   temp_hndl=findobj('userdata','Color style');
   if ~isempty(temp_hndl)
      variante=get(temp_hndl,'value');
   else
      variante = 1;
   end;
end;

switch variante
   case 1
      plot_color=[1 0 0;0 1 0;0 0 1;1 0 1;0.5 0.5 0.5;0 1 1;0 0 0];
      plot_color=[plot_color;0.5*plot_color(1:7,:)];
      plot_style=char('.', 'o', 'x', '+', 's', '*', 'd', 'v', '^', '<', '>', 'p', 'h');
   case {2,3}
      % wie case 2:
      plot_color=[1 1 0;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;0 0 0];
      % für Einzelmerkmale und Zeitreihen geeignet:
      plot_style=char('.', 'o', 'x', '+', 's', '*', 'd', 'v', '^', '<', '>', 'p', 'h');
   case 4
      %plot_color=[1 0 0;0 1 0;0 0 1;0 1 1;  1 0 1;1 1 0; 0 0 0];
      %plot_color=[0.7*plot_color(1:7,:); plot_color];
      plot_color = [255 0 0; 0 255 0; 0 0 255; 110 75 2; 250 172 12; 0 0 0; 170 170 33]./255;
      plot_color=[plot_color;0.5*plot_color(1:7,:)];
      %plot_style=['oxsvd+*<>.'];
      plot_style=char('.', 'd', 's', '+', 'x', 'o', '*', 'v', '^', '<', '>', 'p', 'h');
   case 5
      %plot_color=[[0:0.2:0.8]']*[1 1 1];
      plot_color = [0 0 0;
         .8 .8 .8;
         .2 .2 .2;
         .6 .6 .6;
         .4 .4 .4];
      %plot_style=['oxsvd+*<>.'];
      plot_style=char('.', 'd', 's', '+', 'x', 'o', '*', 'v', '^', '<', '>', 'p', 'h');
      
   case 6
      plot_color=[1 0 1;0 1 1;0 1 0; 1 0 0;0 0 1;0 0 0];
      plot_color=[plot_color;0.5*plot_color(1:6,:)];
      %plot_style=['oxsvd+*<>.'];
      plot_style=char('.', 'd', 's', '+', 'x', 'o', '*', 'v', '^', '<', '>', 'p', 'h');
   case 7
      plot_color ='rgbc';
      
      %plot_style=char('.', 'o', 'x', '+', 's', '*', 'd', 'v', '^', '<', '>', 'p', 'h');
      plot_style=char('s', 'o', '*', '.', 'x', 's', 'd', 'v', '^', '<', '>', 'p', 'h');
      
   case {8,9,10}
      mycolors=get(findobj('tag','CE_Anzeige_UsrDefCol'),'string');
      plot_style = get(findobj('tag','CE_Anzeige_UsrDefSym'),'string')';
      
      plot_color = zeros(length(mycolors),3);
      for i=1:length(mycolors)
         switch mycolors(i)
            case 'b'
               plot_color(i,:) = [0 0 1];
            case 'g'
               plot_color(i,:) = [0 1 0];
            case 'r'
               plot_color(i,:) = [1 0 0];
            case 'c'
               plot_color(i,:) = [0 1 1];
            case 'm'
               plot_color(i,:) = [1 0 1];
            case 'y'
               plot_color(i,:) = [1 1 0];
            case 'w'
               plot_color(i,:) = [1 1 1];
            case 'k'
               plot_color(i,:) = [0 0 0];
         end;
      end;
      if (variante >= 9)
         color_and_style = 1;
      end;
end;

