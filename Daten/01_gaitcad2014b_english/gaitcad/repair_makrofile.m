% Script repair_makrofile
%
% Makro nochmals einlesen
%
% The script repair_makrofile is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

f=fopen(teach_modus.makro_name,'rt');
tmp=fscanf(f,'%c');
fclose(f);

%Zeilen raus extrahieren mit Handles in neuer Zeile  (keine Kommentare usw.)
tempstring_1=[10 'set(gaitfindobj('];
tempstring_2=[10 'eval(gaitfindobj_callback('];
tempstring_3=[10 'set_textauswahl_listbox(gaitfindobj('];

%Zeile, die mit Handle anfängt
ind_uihd_zeile=findd([strfind(tmp,tempstring_1) strfind(tmp,tempstring_2) strfind(tmp,tempstring_3) length(tmp)+1]);
k=1;
ind_neuezeile(k)=1;
old_tag='';


for i=ind_uihd_zeile(1:length(ind_uihd_zeile)-1)
  ind_neuezeile(k)=1;
  
  %wo steht der 1. Tag?
  local_string = tmp(i:min(i+100,length(tmp)));
  pos_tag=sort([ strfind(local_string,'CE_') strfind(local_string,'MI_')]);
  if ~isempty(pos_tag)
    %die Nummern raussuchen, wenn vorhanden...
    act_tag=tmp(i+pos_tag(1)+[-1:min(50,length(tmp)-i-pos_tag(1)-2)]);
    ind_klammer=strfind(act_tag,''')');
    if ~isempty(ind_klammer)
      act_tag=act_tag(1:ind_klammer(1)-1);
    end;
    if isempty(act_tag)
      act_tag='';
    end;
    if strcmp(act_tag,old_tag) && ~isempty(act_tag) && ~isempty(old_tag)
      %for some commands (like feature extraction) make multiple commands sense!
      %be careful - ignore headers MI_ and CE_!!!
      if ~strcmp(act_tag,'MI_Extraktion_ZRZR') && ...
          ~strcmp(act_tag,'MI_Kl_Kl_Und')&& ...
          ~strcmp(act_tag,'MI_Ansicht_Ausgang2D') && ...
          ~strcmp(act_tag,'MI_Umbenennen')
        
        ind_neuezeile(k)=0;
      end;
    end;

    %confusion for plugin list and time series combinations
    if strcmp(act_tag,'MI_Extraktion_ZRZR_Kombi') && strcmp(old_tag,'CE_PlugListExec')
       ind_neuezeile(k)=0;      
    end;

    
    old_tag=act_tag;
  else
    old_tag='';
  end;
  k=k+1;
end;

%neue Zeile, damit auch die kompletten Kommentare mit rauslöschen werden
ind_zeile=[1 strfind(tmp,[10 10])];

loesch=[];
for i=find(~ind_neuezeile)
  loesch=[loesch ind_zeile(i-1):ind_zeile(i)-1];
end;
tmp(loesch)=[];

%korrigiertes Makro reinschreiben
f=fopen(teach_modus.makro_name,'wt');
fprintf(f,'%c',tmp);
fclose(f);

