  function [baum,merk,texprot,merk_wurzel,absich]=genbaum(ulern,ylern,par,unterscheid_krit,baumtyp,merk,texprotokoll,interpret_merk,weights,L,anzeige,parameter_regelsuche)
% function [baum,merk,texprot,merk_wurzel,absich]=genbaum(ulern,ylern,par,unterscheid_krit,baumtyp,merk,texprotokoll,interpret_merk,weights,L,anzeige,parameter_regelsuche)
%
%   Baumstruktur: Zeilen: neue Äste
%   Spalten:
%    1       - Elternknoten
%    2       - Entscheidung Ausgangsgröße
%    3       - Aufzweigung nach Eingangsvariable (0 - Ende)
%    4       - 4+max(par(5:4+par(2))) Naechster Ast für Klassen-Nummern von 3 (maximal Anzahl der Verzweigungen:
%              ist maximale Klassenanzahl
%    unterscheid_krit - Anzahl von Datentupeln, ab der der Baum nicht mehr verzweigt wird (optional,
%              Standard=1)
%   baumtyp(optional) : =1 : ID3 ohne Abschätzung
%                       =2 : C4.5 ohne Abschätzung
%                       =3 : ID3 mit Abschätzung (default)
%                       =4 : C4.5 mit Abschätzung
%   merk       gibt ein heuristisches Bewertungsmaß für Merkmale, das auf den Entropien
%              bei der Baumsuche ermittelt wird, je höher desto wichtiger
%   merk_wurzel wie merk, aber nur der Wurzelknoten
%   interpret_merk - expliziert ermittelte Interpretierbarkeit zwischen 0 und 1, um interpretierbare Merkmale
%                    bei Baumbildung zu bevorzugen
%   texprotokoll File-ID, in die Protokoll geschrieben werden soll, wenn 0, dann kein Protokoll
%   absich Rückgabe Fehler/Beispiele
% 
%   keine Interpretierbarkeiten? dann alle 1!
% 
%
% The function genbaum is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<8) 
   interpret_merk=[];
end;
if isempty(interpret_merk) 
   interpret_merk=ones(par(2),1);
end;

%keine Wichtungen? dann leer setzen
if (nargin<9) 
   weights=[];
end;
if isempty(weights) 
   weights=ones(1,size(ulern,1));
end;

%kein Entscheidungsstrukt? dann leer setzen
if (nargin<10) 
   L=[];
end;
%wegen ind_auswahl muss par nicht mehr stimmen:
par(1)=size(ulern,1);

%diverse Plottereien
if (nargin<11) 
   anzeige=1;
end;
fmon=[1 anzeige];

%diverse Plottereien
if (nargin<12) 
   parameter_regelsuche=[];
end;


%Interne Größe, detailliertes Protokoll mit Zwischenwerten
protokoll=0;
if (nargin<8) 
   texprotokoll=0;
end;

texprotokoll=1;
texprot=[];
%immer plotten!
fprintf('Look for decision tree ... \n');
tmp_e=zeros(1,par(2));

%Grenze, ab der Datensatz mit unterscheid_krit Beispielen weiter unterteilt werden
if (nargin<4) 
   unterscheid_krit=0;
end;

%Festlegung Typ Entscheidungsbaum
if (nargin<5) 
   baumtyp=3;
end;
%Spart massiv Rechenzeit
if (baumtyp<5) 
   L=[];
end;


%Heuristische Merkmalsguete, wird entweder uebergeben oder Null gesetzt 
if (nargin<6) 
   merk=zeros(2,par(2));
end;
merk_wurzel=zeros(2,par(2));

baum=sparse(100,3+max(par(5:4+par(2))));
entro_null=zeros(size(ulern,2),7);
pu_null=zeros(size(ulern,1),par(4));

% Lernbaum: Zeilen wie Baum, Spalten:
% danach:   Indizes der Datentupel in der Lernmenge, die zu diesem Ast gehört (Zeile)
lernbaum=sparse(100,par(1));
lernbaum(1,:)=1:par(1);

while 1 
   %neuer Zweig
   [zeile,spalte]=find(baum(:,4:size(baum,2)));
   wert=full(baum(zeile+(2+spalte)*size(baum,1)));
   zeile=full(zeile);
   spalte=full(spalte);
   letzter_ast=max(find(baum(:,1)));	
   
   %Anzeige Fortschritt
   if ~rem(letzter_ast,20) 
      fboth(fmon,'%d\n',letzter_ast);
   end;
   if isempty(letzter_ast)
      %Start
      wert=1;zeile=1;
      ind=lernbaum(1,:);
      baum(1,1)=-1;
      ast=1;
      
   else  %Suche nach offenen Ästen
      ind_ast=find(wert<=letzter_ast);
      if ~isempty(ind_ast) 
         wert(ind_ast)=[];
         zeile(ind_ast)=[];
         spalte(ind_ast)=[];
      end;
      
      %keine offenen Äste
      if isempty(wert) 
         break;
      end;
      [tmp,ast]=min(wert);
      
      %Raussuchen der Lerndaten, die zum Elternknoten gehoeren und die Auftrennbedingung
      %(Variable steht in Elternzeile des Baumes an 3. Stelle, die Klasse kommt aus der Spalte)
      ind=lernbaum(zeile(ast),:);
      ind=find( ulern(ind(find(ind)),baum(zeile(ast),3))==spalte(ast) );
      ind=lernbaum(zeile(ast),ind);
      lernbaum(wert(ast),1:length(ind))=ind; 
      baum(wert(ast),1)=zeile(ast); %Elternknoten
   end;
   
   
   %existieren Unterscheidungen ?
   if (length(ind)>1) 
      uwahl=find(interpret_merk'.*max(abs(diff(ulern(ind,:))),[],1));
      ywahl=find(max(abs(diff(ylern(ind))),[],1));
   else 
      uwahl=[];           
      ywahl=[];
   end;
   
   
   %Abbruch Zweig: keine weitere Unterscheidung in Ein- oder Ausgangsvariablen
   if isempty(uwahl) || isempty(ywahl) || (length(ind)<unterscheid_krit)
      
      if ~isempty(ind) 
         p_baum=hist(ylern(ind),1:par(4));
         if isempty(L) || (baumtyp<5) || (baumtyp>7) 
            [tmp,baum(wert(ast),2)]=max(p_baum); %optimale Entscheidung 
         else                         
            baum(wert(ast),2)=decision_opt_cost(L,1,p_baum'/sum(p_baum),1,[],0); %ET
         end;  
      else %wenn alles leer, Entscheidung Elternknoten übernehmen
         baum(wert(ast),2)=baum(zeile(ast),2);
      end;           
      uwahl=[];
      absich(wert(ast),:)=[0 0];   
   else  %Werte-Reset Entropie und Entscheidungsvariable
      entro=entro_null;
      pu=pu_null;
      
      %Suche nach maximalem Entropiegewinn
      for jj=uwahl 
         cl=[ulern(ind,jj) ylern(ind)];
         %Vorbereitung Entscheidungsfunktionen  
         if ~isempty(L) 
            L.ind_merkmal=jj;
            L.p_premise=length(ind)/par(1);
         end;
         
         %Inf-theor. Maße, Ausgangs- und Eingangsverteilung berechnen
         [entro(jj,:),py,pu_var,tmp,tmp,ent_dec_y]=entropall(cl,max(cl),0,weights(ind)',L,parameter_regelsuche);
         
         %besetzte Eingangsklassen merken
         pu(jj,1:length(pu_var))=pu_var;
      end;
      
      %ACHTUNG MODIFIKATION - hier kommen explizite Mermalsrelevanzen dazu
      entro=entro.*(interpret_merk*ones(1,size(entro,2)));
      
      %Pluspunkte für Merkmale
      %je mehr Entropie und je mehr Beispiele, desto wichtiger
      %der alte Wert basiert auf merk(1,:) Auswertungen > 0 
      tmp_e=max(0,entro(:,baumtyp))';
      merk(2,uwahl)=(merk(1,uwahl).*merk(2,uwahl)+length(ind)*tmp_e(uwahl))./(length(ind)+merk(1,uwahl));
      
      merk(1,uwahl)=merk(1,uwahl)+length(ind)*ones(1,length(uwahl));
      
      %Merkmalsrelevanzen Wurzelknoten merken
      if (wert(ast)==1) 
         merk_wurzel=merk;
      end;
      
      %Sortieren nach Transinformation/Ausgangsentropie (entspricht ID3) mit entro(:,3)
      %oder nach Transinformation/Eingangsentropie (entspricht C4.5) mit entro(:,4)
      [pos1,pos2]=max(entro(:,baumtyp));
      
      %sinnvolle Auftrennung
      if (baumtyp<5) || (baumtyp>7) 
         [tmp,baum(wert(ast),2)]=max(py);        %größte Häufigkeit
      else                    
         [tmp,baum(wert(ast),2)]=max(ent_dec_y); %optimale Entscheidung
      end;
      
      if (pos1>0) 
         baum(wert(ast),3)=pos2;              %Auftrennvariable 
         besetzte_klassen=find(pu(pos2,:)~=0)'; %neue Äste
         %welche Eingangsklassen sind besetzt -> nur da neue Äste bilden
         if ~isempty(besetzte_klassen) 
            baum(wert(ast),3+besetzte_klassen)=max(wert)+(1:length(besetzte_klassen));
         end;
      end; %pos
   end; %isempty ...
   
   if ~isempty(ind)  
      absich(wert(ast),:)=[sum(ylern(ind)~=baum(wert(ast),2)) length(ind)];
   end;
   
   if texprotokoll || protokoll
      tmp_em=-1*ones(size(tmp_e));
      tmp_em(uwahl)=tmp_e(uwahl);
      if (length(tmp_em)>5) 
         tmp_em=[];
      end;
      if (protokoll) 
         if (wert(ast)==1) 
            fboth(fmon,'Node Parent    y=   xi=   Entropies  Number of errors\n');
         end;
         fboth(fmon,'%5d %5d %5d %5d  ',wert(ast),full(baum(wert(ast),[1 2 3])));
         fboth(fmon,'%+4.3f ',tmp_em);
         fboth(fmon,'%d  %d\n',absich(wert(ast),:));
      end;   
      if (texprotokoll) 
         if (wert(ast)==1) 
            tabtext=sprintf('$v_{1} (R) $ & -- & -- & $B_{%d}$ & $x_{%d}$ &',full(baum(wert(ast),2:3)));
         else              
            elter=full(baum(wert(ast),1));
            elter_var=baum(elter,3);
            lingterm_elter=find(baum(elter,4:size(baum,2))==wert(ast));
            if full(baum(wert(ast),3)) 
               tabtext=sprintf('%s $v_{%d}    $ & $v_{%d}$ & $A_{%d,%d}$ & $B_{%d}$& $x_{%d}$ &',tabtext,wert(ast),elter,full(elter_var),lingterm_elter,full(baum(wert(ast),2:3)));
            else 
               tabtext=sprintf('%s $v_{%d} (E)$ & $v_{%d}$ & $A_{%d,%d}$ & $B_{%d}$&  -- &',tabtext,wert(ast),elter,full(elter_var),lingterm_elter,full(baum(wert(ast),[2])));
            end;
         end; 
         for i=1:length(tmp_em) 
            if (tmp_em(i)==-1) 
               tabtext=sprintf('%s  -- &',tabtext);
            else           
               tabtext=sprintf('%s %4.2f &',tabtext,tmp_em(i));
            end;  
         end;        
         tabtext=sprintf('%s%d & %d \n',tabtext,full(absich(wert(ast),:)));
      end;
   end;
end; 
if texprotokoll
   texprot.kopf=sprintf('Nodes&Parent&Branching&$y$&$x_i$');
   for i=1:length(tmp_em) 
      texprot.kopf=sprintf('%s & $x_{%d}$',texprot.kopf,i);
   end;
   texprot.kopf=sprintf('%s & Errors & Examples',texprot.kopf);
   texprot.tabtext=tabtext;
   texprot.name='Relevance of feature from decision tree';
end;

fboth(fmon,'Complete ... \n');
