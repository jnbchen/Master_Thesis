% Script callback_makro_auswahlfenster
%
% Callback alter OK-Button rausholen
%
% The script callback_makro_auswahlfenster is part of the MATLAB toolbox Gait-CAD. 
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

callbacktext_ok=get(figure_handle(size(figure_handle,1),1),'callback');

%neues vor Fenster schlieﬂen einschmuggeln!!!
ind=strfind(callbacktext_ok,'delete(flipud(figure_handle(find_nonempty_handle(figure_handle(:)))));');
if (~isempty(ind))
	callbacktext_ok=strcat(callbacktext_ok(1:ind(1)-1),'callback_makro_ok_auswahl;',callbacktext_ok(ind(1):length(callbacktext_ok)));

	%in Callback OK-Button schreiben
   set(figure_handle(size(figure_handle,1),1),'callback',callbacktext_ok);
end;

