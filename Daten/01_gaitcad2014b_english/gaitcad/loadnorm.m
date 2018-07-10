  function [ref,d_orgs,par,zgf_y_bez,ind_auswahl,d_org,code,code_alle]=loadnorm(var_bez_neu,par_neu,size_zeitreihe,obsolete_value,d_orgs,par,zgf_y_bez,ind_auswahl,d_org,code,code_alle,dorgbez_neu, datei)
% function [ref,d_orgs,par,zgf_y_bez,ind_auswahl,d_org,code,code_alle]=loadnorm(var_bez_neu,par_neu,size_zeitreihe,obsolete_value,d_orgs,par,zgf_y_bez,ind_auswahl,d_org,code,code_alle,dorgbez_neu, datei)
%
% lädt Normdaten aus *.norm-Datei
%
% The function loadnorm is part of the MATLAB toolbox Gait-CAD. 
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

fprintf('Load normative data ... \n');

%wenn keine Datei ausgewählt wird, werden leere Argumente zurückgegeben
ref=[];

if (nargin < 13) || isempty(datei)
   [datei,pfad]=uigetfile('*.norm','Import normative data');
else                
   %wichtig um Makros laden zu können: datei_load kann durch ein anderes Skript übergeben werden!!!
   [pfad,datei,extension] = fileparts(datei);
   if ~isempty(pfad)
      cd(pfad);
   end;
   tmp=which([datei extension]);    
   if isempty(tmp) 
      myerror(sprintf('File %s not found!',datei));
   end;
   [pfad,datei,extension] = fileparts(tmp);
end;

if datei 
   cd(pfad);
   [muell,datei]=fileparts(datei);
   load([datei '.norm'],'-mat');
   
   %Umkodierungstabelle auf der Basis von Variablenbezeichnungen (Zeitreihen!!!!!!!)
   pos=zeros(1,size(my,3));
   for i=1:size(my,3) 
      pos(i)=find_merk(kill_lz(var_bez(i,:)),var_bez_neu); 
   end;    
   
   fprintf('Selected features:\n');
   fprintf('%d  ',pos);
   fprintf('\n');
   
   if isempty(find(pos>0))
      myerror('No corresponding normative data found!');
   end;
      
   %Default: gleich 
   if max(pos==0) 
      warning('Some features with normative data are not found in the project!');
   end;
   
   tmp=findd(pos(find(pos>0)));
   if (length(tmp)<par_neu.anz_merk)                       
      warning('The normative data are undefined for some features!');
   else 
      if max(tmp(1:par_neu.anz_merk)~=[1:par_neu.anz_merk]) 
         warning('The normative data are undefined for some features!');
      end;
   end;
   
   
   %Transformationsvektor belegen, alles andere bleibt gleich
   ref.my=zeros(1,size_zeitreihe,par_neu.anz_merk);
   ref.mstd=zeros(1,size_zeitreihe,par_neu.anz_merk);
   
   ind=find(pos); pos=pos(find(pos));
   ref.my(1,:,pos)  =resample(squeeze(my  (1,:,ind)),size_zeitreihe,size(my  ,2));
   
   ref.mstd(1,:,pos)=resample(squeeze(mstd(1,:,ind)),size_zeitreihe,size(mstd,2));
   ref.titelzeile=titelzeile;
   
   
   %Umkodierungstabelle auf der Basis von Variablenbezeichnungen (Einzelmerkmale!!!!!!!)
   if ~exist('my_em','var')
      my_em=[];      
   end;
   if ~exist('mstd_em','var')
      mstd_em=[];      
   end;
   
   
   pos=zeros(1,size(my_em,2));
   for i=1:size(my_em,2)  
      if ~rem(i,20) 
         fprintf('%d\n',i);
      end;  
      
      %Shortcut - vielleicht ist es ja das nächste
      %complicated but no version problems...
      shortcut = 1;
      if i>1 
        if (pos(i-1)+1)>= size(dorgbez_neu,1)
          shortcut = 0;
        end;
      end;
      
      if (i>1) && shortcut && (strcmp(deblank(dorgbez(i,:)),deblank(dorgbez_neu(pos(i-1)+1,:))))  
         pos(i) = pos(i-1)+1;
      else 
         %sonst halt alle durchsuchen...
         pos(i)=find_merk(deblank(dorgbez(i,:)),dorgbez_neu); 
      end;
      
   end;    
   
   fprintf('Selected features:\n');
   fprintf('%d  ',pos);
   fprintf('\n');
   
   %Default: gleich 
   if max(pos==0) 
      warning('Some features with normative data are not found in the project!');
   end;
   
   tmp=findd(pos(find(pos>0)));
   if (length(tmp)<par_neu.anz_einzel_merk)  
      warning('The normative data are undefined for some features!');
   else 
      if max(tmp(1:par_neu.anz_einzel_merk)~=[1:par_neu.anz_einzel_merk]) 
         warning('The normative data are undefined for some features!');
      end;
   end;
   
   
   %Transformationsvektor belegen, alles andere bleibt gleich
   ref.my_em=zeros(1,par_neu.anz_einzel_merk);
   ref.mstd_em=zeros(1,par_neu.anz_einzel_merk);
   
   ind=find(pos); 
   pos=pos(find(pos));
   ref.my_em(pos)  =my_em  (ind);
   ref.mstd_em(pos)   =mstd_em (ind);
   
   
   fprintf('Ready: Load normative data\n');
   
end;

