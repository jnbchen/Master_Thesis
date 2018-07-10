% Script callback_makro_ok_auswahl
%
% Auswahlfenster rausholen....
%
% The script callback_makro_ok_auswahl is part of the MATLAB toolbox Gait-CAD. 
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

auswahlstring=get(gaitfindobj(tmptag),'userdata');
inhaltauswahl=eval(auswahlstring);
dimauswahl=size(inhaltauswahl,1);

fprintf(teach_modus.f,'%% MACRO CONFIGURATION WINDOW %s\n',get(gaitfindobj(tmptag),'label'));
fprintf(teach_modus.f,'%s=[];\n',auswahlstring);

for i_dim=1:dimauswahl 
   daten=inhaltauswahl(i_dim,:);
   daten=daten(find(daten));
   %   fprintf(teach_modus.f,'%s(%d,1:%d)=[',auswahlstring,i_dim,length(daten));
   %   fprintf(teach_modus.f,'%d ',daten);   
   %   fprintf(teach_modus.f,'];\n');
   temp_hndl = figure_handle(i_dim+1,1);
   
   %must be a valid element - could be a problem for some hidden elements during renaming
   if (strcmp(get(temp_hndl,'style'),'listbox') || strcmp(get(temp_hndl,'style'),'popupmenu') || strcmp(get(temp_hndl,'style'),'edit')) && ~isempty(get(temp_hndl,'string')) && ~isempty(deblank(get(temp_hndl,'string')))
      fprintf(teach_modus.f,'%s{%d}=%s;\n',auswahlstring,i_dim,get_textauswahl_listbox(temp_hndl));
   end;
   
end;

fprintf(teach_modus.f,'eval(gaitfindobj_callback(''%s''));\n',tmptag);

%und dann beim Ausführen des MAKROS virtuell auf den OK-Button des Auswahlfensters drücken...
fprintf(teach_modus.f,'eval(get(figure_handle(size(figure_handle,1),1),''callback''));\n\n');
