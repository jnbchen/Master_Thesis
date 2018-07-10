% Script callback_qual_ausgangs
%
% The script callback_qual_ausgangs is part of the MATLAB toolbox Gait-CAD. 
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

nraus=parameter.gui.merkmale_und_klassen.ausgangsgroesse;

codes = unique(code_alle(ind_auswahl, nraus));
tit = sprintf('Output variable: %s',bez_code(nraus,:));
bez = sprintf('Qualitative output classes');
% Besorge den Color-Style aus der Oberfl‰che
[col, sty] = color_style;

figure;
for(i = 1:length(codes))
   indx = find(code_alle(ind_auswahl, nraus) == codes(i));
   h = plot(ind_auswahl(indx), i*ones(length(indx),1), '.'); hold on;
   % Nicht schwarz-weiﬂ?
   if (parameter.gui.anzeige.anzeige_grafiken ~= 3)
      set(h, 'Marker', '*', 'Color', col(1+rem(codes(i)-1,size(col,1)),:));
   else
      set(h, 'Marker', sty(1+rem(codes(i)-1,size(col,1))), 'Color', [0 0 0]);
   end;
end;

xlabel('Data points');
ylabel(bez);
title(tit);
set(gcf,'numbertitle','off','name',sprintf('%d: %s',get_figure_number(gcf), bez));

bez = [num2str(codes) 32*ones(length(codes),1) char(zgf_y_bez(nraus,codes).name)];
set(gca, 'YTick', [1:length(codes)]);
set(gca, 'YTickLabel', num2str(codes));
% Alternative Version mit angezeigter Legende ohne Symbole vorne dran.
l = legend(bez, 0);
%hndls = get(l, 'UserData');
%for(i = 1:length(hndls.LabelHandles))
%   if (~strcmp(get(hndls.LabelHandles(i), 'type'), 'text'))
%      set(hndls.LabelHandles(i), 'visible', 'off');
%   end;
%end;

clear bez tit nraus col sty codes i indx h l; 