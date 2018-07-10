  function [data,d_org,bez,code_alle,zgf_y_bez,bez_code,ind_output]=getdata(filename,i_start,j_start,xbez,trennzeichen,kommadurchpunkt,all_nan_mode)
% function [data,d_org,bez,code_alle,zgf_y_bez,bez_code,ind_output]=getdata(filename,i_start,j_start,xbez,trennzeichen,kommadurchpunkt,all_nan_mode)
%
%  liest Daten aus mit verschiedenen Trennzeichen getrenntem CSV- oder Excel-File filename ein und extrahiert Daten und Bezeichner
%  Dabei muss trennzeichen ein Zeilenvektor mit 2 Werten sein. Der erste Wert beschreibt die Trennzeichen für die Spalten, der zweite die Trennzeichen
%  für die Zeilen. (z.B. trennzeichen(1)=9 TAB für Spalten, trennzeichen(2)= 10 oder 13 = ENTER für Zeilen)
%  Wenn xbez gesetzt ist (also "xbez = 1" für true), wird die Bezeichnung in den Zeilen i_start+1 bis Ende gesucht (in Spalte j_start), sonst
%  in den Spalten ab j_start+1 der i_start. Zeile bis Ende.
%  Die Daten stehen ab der i_start+1. Zeile und der j_start+1. Spalte bis zum jeweiligen Ende. (Das heißt wenn die Daten in Spalte 5 beginnen, muss
%  j_start = 4 sein!)
%  Ist kommadurchpunkt=1 (default) werden Kommata durch Punkte ersetzt.
%  Beispiele:
%   1. [data,d_org,bez,code_alle,zgf_y_bez,bez_code,ind_output]=getdata('CI_Parameter_gesund.txt',3,1,1,[9 10],1);
%      Daten stehen in den Zeilen 4 bis Ende (i_start=3) und den Spalten 2 bis Ende (j_start=1), Bezeichnungen Zeilenweise angeordnet (xbez=1), also
%      in der 1. Spalte (j_start=1) ab der 4. Zeile (i_start=3). Alle Kommas werden durch Punkte ersetzt (-> Punkte als Dezimaltrennzeichen).
%   2. [data,d_org,bez,code_alle,zgf_y_bez,bez_code,ind_output]=getdata('D:\gangdaten\schweidler_convert\7112802.txt',25,0,0,[9 13],1);
%      Daten stehen in den Zeilen 26 (i_start = 25) bis Ende und den Spalten 1 bis Ende (j_start=0),Bezeichnungen Spaltenweise angeordnet (xbez=0), also
%      in der 1. Spalte (j_start=0) ab der 25. Zeile (i_start=25). Alle Kommas werden durch Punkte ersetzt (-> Punkte als Dezimaltrennzeichen).
% 
%  ACHTUNG:
%  Merkmale, für die nur qualitative Werte (also Strings vorliegen), werden als Ausgangsgröße erfasst (-> bez_code für Bezeichner sowie zgf_y_bez und code_alle für Daten).
%  Merkmale, für die quantitative (also floating point numbers) und eventuell auch qualitative Werte vorliegen, werden als Eingangsgrößen erfasst
%  (-> bez für Bezeichner und d_org für Daten). In letzterm Fall gehen die qualitativen Werte als NaN verloren.
% 
%  Die output-Variable data ist ein structure array mit den Dimensionen der kompletten ursprünglich eingelesenen Datei und dem Feld ''text'', in welchem der
%  Inhalt der jeweiligen Zelle als text string hinterlegt ist.
%  ind_output gibt die Indizes der Spalten der Ausgangsgrößen in den Originaldaten an.
%
% The function getdata is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Tim Pychynski, Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


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

if (nargin < 6)
   kommadurchpunkt = 1;
end;


if (nargin < 7)
   %löscht Datentupel, deren d_org nur aus Nan-Elementen besteht
   all_nan_mode = 1;
end;


%File laden
try 
   f=fopen(filename,'rt');
   a=fscanf(f,'%c');
   fclose(f);
catch
   myerror(sprintf('The file %s could not be opened!',filename));
end;


ind=strfind(a,',');
if kommadurchpunkt == 1 && ~isempty(ind)
   fprintf('Replace commas by points\n');
   a(ind)=46*ones(size(ind));
end;

%ftmp=fopen('tmp.txt','wt');fprintf(ftmp,'%s ',a);fclose(ftmp);
%Enters suchen
indz=[0 find(a==trennzeichen(2)) length(a)+1];

fprintf('Read numbers...\n');
for i=1:length(indz)-1
   %Tabs im entsprechenden Bereich raussuchen
   
   if i>=10000 && rem(i,10000) == 0
      fprintf('%d/%d\n',i,size(data,1));
   end;
   
   
   myline = a(indz(i)+1:indz(i+1)-1);
   
   indt=[0 find(myline==trennzeichen(1)) length(myline)+1];
   %alle Daten als String in data schreiben
   
   %initialize
   if i==1
      data(length(indz)-1,length(indt)-1).text = '';
      ind_empty_line = [];
   end;
   
   if isempty(myline)
      ind_empty_line = [ind_empty_line i];
   else
      if max(abs(myline))<33
         ind_empty_line = [ind_empty_line i] ;
      end;
   end;
   
   
   
   
   for j=1:length(indt)-1
      data(i,j).text=myline(indt(j)+1:indt(j+1)-1);
   end;
end;

%complete empty lines
if ~isempty(ind_empty_line)
   data(ind_empty_line,:) =[];
end;



%E!
if (i_start==-1)
   i_start=0;
   for i=1:size(data,1)
      if ~isempty(sscanf(data(i,1).text,'%f'))
         i_start=i-1;
         break;
      end;
   end;
end;


fprintf('Interpret elements as numbers...\n');

%relevante Daten als Zahlen einlesen
for i=i_start+1:size(data,1)
   if i>=10000 && rem(i,10000) == 0
      fprintf('%d/%d\n',i,size(data,1));
   end;
   for j=j_start+1:size(data,2)
      tmp=data(i,j).text;
      
      %der einzutragende Zahlenwert
      dummy_zahl=[];
      
      %nichtleeren String einlesen, hoffentlich ist es eine Zahl...
      if ~isempty(tmp)
         dummy_zahl=str2double(tmp);
      end;
      
      %keine Zahl eingelesen, also NaN setzen
      if isempty(dummy_zahl)
         dummy_zahl=NaN;
      end;
      
      %Zahl oder NaN reinschreiben
      d_org(i-i_start,j-j_start)=dummy_zahl(1);
   end;
end;

%Bezeichner einlesen
if (xbez)
   if j_start>0
      bez=char(data(i_start+1:i_start+size(d_org,1),j_start).text);
   else
      bez = '';
   end;
   d_org=d_org';
else
   if i_start >0
      bez=char(data(i_start,j_start+[1:size(d_org,2)]).text);
   else
      bez = '';
   end;
end;


%Ausgangsgrößen suchen
if nargout>4
   
   if xbez
      data_text = data(i_start+1:i_start+size(d_org,1),2:end)';
   else
      data_text = data(i_start+1:end,j_start+[1:size(d_org,2)]);
   end;
   
   %new: lines with more than 95% NaN values are handled as outputs
   %otherwise some problems with convertable names
   ind_output = find(mean(isnan(d_org))>0.95);
   
   %Namen der Ausgansgsgrößen
   bez_code = bez(ind_output,:);
   bez(ind_output,:) =[];
   
   code_alle = zeros(size(d_org,1),0);
   zgf_y_bez = [];
   
   for i_output = 1:length(ind_output)
      [temp_name,temp,code_alle(:,i_output)] = unique(char(data_text(:,ind_output(i_output)).text),'rows');
      for i_name = 1:size(temp_name,1)
         zgf_y_bez(i_output,i_name).name = temp_name(i_name,:);
      end;
   end;
   
   
   ind_allnan = all(isnan(d_org')) & all(isnan(code_alle'));   % Coderevision: &/| checked!
   
   
   %Einzelmerkmale löschen
   d_org(:,ind_output) =[];
   
   
   
   %Komplett leere Datentupel entsorgen
   if ~isempty(ind_allnan) && all_nan_mode == 1
      code_alle(ind_allnan,:) =[];
      d_org(ind_allnan,:) = [];
   end;
   
else
   %Komplett leere Datentupel entsorgen
   ind_allnan = all(isnan(d_org'));
   if ~isempty(ind_allnan) && all_nan_mode == 1
      d_org (ind_allnan,:) =[];
   end;
   
   
end;
