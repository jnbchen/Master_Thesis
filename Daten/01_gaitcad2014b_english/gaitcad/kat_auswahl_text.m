  function [string,info,callback]=kat_auswahl_text(zgf_em_bez, code_em,mode)
% function [string,info,callback]=kat_auswahl_text(zgf_em_bez, code_em,mode)
%
% The function kat_auswahl_text is part of the MATLAB toolbox Gait-CAD. 
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

for i=1:size(code_em,2)
   tmp='All';
   for j=findd(code_em(:,i)) 
      tmp=sprintf('%s|%s',tmp,zgf_em_bez(i,j).name);
   end;
   string(i,1:length(tmp))=tmp;
   tmp=sprintf('Selection %s',zgf_em_bez(1,1).katbez(i,:));
   info(i,1:length(tmp))=tmp;
end; 

%zum Speichern der Auswahl
%hier Unterscheidung, ob Zeitreihen, oder Einzelmerkmale
callback=sprintf('mode=%d;callback_kat_auswahl_text;aktparawin;',mode);
%   tmp=sprintf('    for i=1:size(code_zr,2)   ');
%   tmp=sprintf('%s     ind=get(figure_handle(i+1,1),''value'')-1;',tmp); % die '-1' wegen 'ALL'
%   tmp=sprintf('%s        if ind(1)==0 ind=findd(code_zr(:,i)); end;',tmp); %Wenn 'ALL' gewählt
%   tmp=sprintf('%s     zgf_zr_bez(i,1).auswahl=ind;',tmp);  
%   tmp=sprintf('%s  end;',tmp); 
%
%   tmp=sprintf('%s ind_katzr=kat_auswahl(zgf_zr_bez, code_zr); ',tmp);
   % Zeitreihen-Auswahl im Hauptfenster neu einstellen: 
%   tmp=sprintf('%s set(uihd(11,13),''value'',ind_katzr'');',tmp); % Tip: ind_katzr'' ist transponiert!!
   % speichert letzte Auswahl: Gehe durch alle Auswahlfenster, speicher 'values' in tmp, 				   speicher in Matrix (untersch. Längen werden mit 0 aufgefüllt) 
%   auswahl_speichern='auswahl.katzr=[]; for i=2:size(figure_handle,1)-1    tmp=get(figure_handle(i,1),''value''); auswahl.katzr(i-1,1:length(tmp))=tmp;end;';
%else % Wenn EM
%    callback='mode=2;callback_kat_auswahl_text;aktparawin;';   
%   tmp=sprintf('    for i=1:size(code_em,2)   ');
%   tmp=sprintf('%s     ind=get(figure_handle(i+1,1),''value'')-1;',tmp); % die '-1' wegen 'ALL'
%   tmp=sprintf('%s        if ind(1)==0 ind=findd(code_em(:,i)); end;',tmp); %Wenn 'ALL' gewählt
%   tmp=sprintf('%s     zgf_em_bez(i,1).auswahl=ind;',tmp);  
%   tmp=sprintf('%s  end;',tmp); 
   
%   tmp=sprintf('%s ind_katem=kat_auswahl(zgf_em_bez, code_em); ',tmp);
%   tmp=sprintf('%s set(uihd(11,14),''value'',ind_katem'');',tmp); %Einzelmerkmals-Auswahl im Hauptfenster neu einstellen
   %tmp=sprintf('%s set(uihd(11,16),''string'',num2str(ind_katem''));',tmp); %Einzelmerkmals-Auswahl im Textfeld ergänzen 
%   auswahl_speichern='auswahl.katem=[]; for i=2:size(figure_handle,1)-1    tmp=get(figure_handle(i,1),''value''); auswahl.katem(i-1,1:length(tmp))=tmp;end;';
%end

%tmp=sprintf('%s  aktparawin;',tmp);

%callback=sprintf('%s %s',auswahl_speichern,tmp); 


