  function cmap = erzeugeColormap(colorindex, anz_farben)
% function cmap = erzeugeColormap(colorindex, anz_farben)
%
%  Gibt eine Colormap anhand Indexes zurück
%  Folgende sind möglich:
%     1:  jet        - Variant of HSV.
%     2:  gray       - Linear gray-scale color map (eigene mit 255 Farben)
%     3:  1-gray      - Umgedrehte gray-scale color map
%     4:  hsv        - Hue-saturation-value color map.
%     5:  hot        - Black-red-yellow-white color map.
%     6:  bone       - Gray-scale with tinge of blue color map.
%     7:  copper     - Linear copper-tone color map.
%     8:  pink       - Pastel shades of pink color map.
%     9:  flag       - Alternating red, white, blue, and black color map.
%     10:  lines      - Color map with the line colors.
%     11: colorcube  - Enhanced color-cube color map.
%     12: vga        - Windows colormap for 16 colors.
%     13: prism      - Prism color map.
%     14: cool       - Shades of cyan and magenta color map.
%     15: autumn     - Shades of red and yellow color map.
%     16: spring     - Shades of magenta and yellow color map.
%     17: winter     - Shades of blue and green color map.
%     18: summer     - Shades of green and yellow color map.
%  Anzahl Farben gibt die Anzahl der gewünschten Farben an (default: 256)
%
% The function erzeugeColormap is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

if (nargin < 2)
   anz_farben = 256;
end;

switch(colorindex)
case 1
   cmap = jet(anz_farben);
case 2
   fakt = 1/(anz_farben-1);
   cmap = [[0:fakt:1]' [0:fakt:1]' [0:fakt:1]'];
case {3,19}
   fakt = 1/(anz_farben-1);
   cmap = 1-[[0:fakt:1]' [0:fakt:1]' [0:fakt:1]'];
   
   if colorindex == 19
       cmap = 0.5+cmap/2;
   end;
case 4
   cmap = hsv(anz_farben); % Hue-saturation-value color map.
case 5
   cmap = hot(anz_farben); % Black-red-yellow-white color map.
case 6
   cmap = bone(anz_farben); % Gray-scale with tinge of blue color map.
case 7
   cmap = copper(anz_farben); % Linear copper-tone color map.
case 8
   cmap = pink(anz_farben); % Pastel shades of pink color map.
case 9
   cmap = flag(anz_farben); % Alternating red, white, blue, and black color map.
case 10
   cmap = lines(anz_farben); % Color map with the line colors.
case 11
   cmap = colorcube(anz_farben); % Enhanced color-cube color map.
case 12
   cmap = vga(anz_farben); % Windows colormap for 16 colors.
case 13
   cmap = prism(anz_farben); % Prism color map.
case 14
   cmap = cool(anz_farben); % Shades of cyan and magenta color map.
case 15
   cmap = autumn(anz_farben); % Shades of red and yellow color map.
case 16
   cmap = spring(anz_farben); % Shades of magenta and yellow color map.
case 17
   cmap = winter(anz_farben); % Shades of blue and green color map.
case 18
   cmap = summer(anz_farben); % Shades of green and yellow color map.
end;

