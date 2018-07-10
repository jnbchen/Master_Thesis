% Script callback_button_plugseq
%
% Execute plugin as shortcut for menu functions
% 
% image -> X ?
%
% The script callback_button_plugseq is part of the MATLAB toolbox Gait-CAD. 
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

if plugins.mgenerierung_plugins.info(plugins.mgenerierung_plugins.typ_beschreibung.plugin(plugins.mgenerierung_plugins.sequence.plugins(1))).anz_benoetigt_im > 0
   mode_images = 2; 
   callback_handle_images;
else
   % Anzeige Ergebnisse
   % {'Save final result'}
   set_textauswahl_listbox(gaitfindobj('CE_Plugins_IgnoreIntermediates'),{'Save final result'});eval(gaitfindobj_callback('CE_Plugins_IgnoreIntermediates'));
   
   eval(gaitfindobj_callback('MI_Extraktion_ZRZR_Kombi'));
end;

