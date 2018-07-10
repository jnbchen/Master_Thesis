  function  merk_report(merk,var_bez,anz,f,verfahren,texprotokoll,sortieren,datei_name,uihd,rueckstufung,feature_numbers,parameter,p_values)
% function  merk_report(merk,var_bez,anz,f,verfahren,texprotokoll,sortieren,datei_name,uihd,rueckstufung,feature_numbers,parameter,p_values)
%
% protokolliert alle  Merkmale nach ihrer heuristischen Bewertung aus Baum-Test in merk
% mit ihren Klarnamen var_bez in Datei f (==1 : Monitor - default, ==-1 Datei test.txt)
% verfahren (optional) kennzeichnet einen String, in dem das verwendete Verfahren steht
% sortieren: 1 (absteigend), 2 (aufsteigend), 3 (Betrag aufsteigend)
%  datei_name gibt optinal den Titel als "datei_name.txt" Datei an (diese Änderung wurde von Tobias vorgenommen)
% die mofifizierte Anzeige bei Werten >1 wird nur eingesetzt, wenn 'Multivariat' im Titel des Verfahrens vorkommt
%
% The function merk_report is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<4)
    f=1;
end;
if (nargin<5)
    verfahren='unknown';
end;
if isempty(verfahren)
    verfahren='unknown';
end;
if (nargin<6)
    texprotokoll=0;
end;
if (nargin<7)
    sortieren=1;
end;
if (nargin<8)
    datei_name='test';
end;
if (nargin<9)
    uihd=[];
end;
if (nargin<10)
    rueckstufung = [];
end;
if (nargin<11)
    feature_numbers = [];
end;
if isempty(feature_numbers)
    feature_numbers = 1:length(merk);
end;
if (nargin<12)
    parameter =[];
end;
if isempty(parameter)
    parameter.allgemein.makro_ausfuehren = 0;
    parameter.gui.anzeige.featurenumber_list_check = 1;
end;
if (nargin<13)
    p_values = [];
end;

if (texprotokoll)
    datei_name=sprintf('%s.tex',datei_name);
else
    datei_name=sprintf('%s.txt',datei_name);
end;


prottail = [];

if isempty(var_bez)
    var_bez=32*ones(length(merk),1);
end;

%bei TEX keine _, % in den Variablennamen
if texprotokoll
    var_bez(find(var_bez==95))=45;
    verfahren(find(verfahren==95))=45;
    var_bez(find(var_bez==37))=80;
    verfahren(find(verfahren==37))=80;
end;

%Dummy-File test.txt fuer sofortige Visualisierung
if (f==-1)
    datei_name = repair_dosname(datei_name);
    f=fopen(datei_name,'wt');
    if f==-1
        myerror(sprintf('File %s could not be opened.\n',datei_name));
    end;
    
    notep=1;
    if ~isempty(uihd)
        prottail=protkopf(f,uihd,texprotokoll,datei_name,verfahren,1);
    end;
else
    notep=0;
end;

%nach den besten Merkmalen sortieren
if isempty(strfind(verfahren,'T-Test'))
    if ~texprotokoll
        fprintf(f,'\n\n');
        fprintf(f,'Selection of most relevant features:\n');
        fprintf(f,'Method: %s \n\n',verfahren);
    end;
    mv=strfind(lower(verfahren),'multivariat');
else
    sortieren=2;
    if ~texprotokoll
        fprintf(f,'%s \n\n',verfahren);
    end;
    mv=0;
end;

ind=1:length(merk);
if sortieren==1
    [tmp,ind]=sort(-merk);
end;
if sortieren==2
    [tmp,ind]=sort(merk);
end;
if sortieren==3
    [tmp,ind]=sort(-abs(merk));
end;

if sortieren>0 &&  parameter.gui.anzeige.featurenumber_list_check == 0
    ind  = ind(1:min(length(ind),parameter.gui.anzeige.feature_number));
end;





if ~texprotokoll
    fprintf(f,' Pos. \tFeature no. \tFeature                              \tFitness \n');
    for i=1:min(anz,length(ind))
        if (exist('rueckstufung', 'var') && ~isempty(rueckstufung) && (size(rueckstufung.von,1) == length(ind)) && rueckstufung.von(ind(i)) ~= 0)
            str = sprintf('\tDowngrading by %s (correlation coefficient: %5.3f)', deblank(var_bez(rueckstufung.von(ind(i)), :)), rueckstufung.ccoeff(ind(i)));
        else
            str = sprintf('\t');
        end;
        
        if ~isempty(p_values) && isfield(p_values,'features')
            if p_values.features(ind(i)) < p_values.sigma_p_krit_bonf(ind(i))
                str = [sprintf(' (p=%g) ',p_values.features(ind(i))) str];
            else
                str = [sprintf(' (p=%g, n.s.) ',p_values.features(ind(i))) str];
            end;
        end;
        
        if isempty(mv) || (merk(ind(i))<=1)
            fprintf(f,'%d \tx%d \t%20s \t%5.3f %s\n',i,feature_numbers(ind(i)),var_bez(ind(i),:),merk(ind(i)), str);
        else
            fprintf(f,'%d \tx%d \t%20s \t----- (%5.3f) %s\n',i,feature_numbers(ind(i)),var_bez(ind(i),:),rem(merk(ind(i)),1), str);
        end;
    end;
    %zusätzliche TEX-Tabelle
else
    %zusätzliche TEX-Tabelle - vorinitialisieren, sonst wirds lahm
    tableinh=char(32*ones(1,min(anz,length(ind))*(size(var_bez,2)+20)));
    table_z=1;
    for i=1:min(anz,length(ind))
        if (exist('rueckstufung', 'var') && ~isempty(rueckstufung) && (size(rueckstufung.von,1) == length(ind)) && rueckstufung.von(ind(i)) ~= 0)
            str = sprintf('Downgrading by %s (correlation coefficient: %5.3f)', deblank(var_bez(rueckstufung.von(ind(i)), :)), rueckstufung.ccoeff(ind(i)));
            str = strrep(str, '_', '-'); str = strrep(str, '%', '\%');
        else
            str = '';
        end;
        
        if ~isempty(p_values) && isfield(p_values,'features')
            str = [sprintf(' (p=%g) ',p_values.features(ind(i))) str];
        end;
        
        if isempty(mv) || (merk(ind(i))<=1)
            tmp=sprintf('%d & $x_{%d}$ & %s & %5.3f %s\n',i,feature_numbers(ind(i)),var_bez(ind(i),:),merk(ind(i)), str);
        else
            tmp=sprintf('%d & $x_{%d}$ & %s & ----- (%5.3f) %s\n',i,feature_numbers(ind(i)),var_bez(ind(i),:),rem(merk(ind(i)),1), str);
        end;
        tableinh(table_z+[1:length(tmp)])=tmp;
        table_z=table_z+length(tmp);
    end;
end;

if (texprotokoll)
    textable('Position & Feature & Name & Fitness',tableinh(1:table_z),sprintf('Feature relevances -- %s',verfahren),f);
    if ~isempty(prottail)
        fprintf(f,'%s',prottail);
        prottail = '';
    end;
    
    fprintf(f, '\\end{document}');
end;
if (notep)
    if ~isempty(prottail)
        fprintf(f,'%s',prottail);
    end;
    fclose(f);
    if parameter.allgemein.makro_ausfuehren==0
        viewprot(datei_name);
    end;
end;
