  function  [pos,nm,prz,s_return]=klf_an6(dat,kl,su,s,s_invers,log_s,d_schalter,anzeige,L,apriori_schalter,p_apriori,typ_ent)
% function  [pos,nm,prz,s_return]=klf_an6(dat,kl,su,s,s_invers,log_s,d_schalter,anzeige,L,apriori_schalter,p_apriori,typ_ent)
%
%   Durchführung der Klassifizierung
% 
%   Eingangsvariablen:
%   dat -> Datenmatrix
%   kl  -> Klassenmittelpunkte
%   su  -> biasfreie Kovarianzmatrix des gesamten Datenmaterials
%   s   -> Kovarianzmatrizen der Klassen s - als Blockmatrix
% 
%   optional:
%   d_schalter  -> Wahl des Distanzmaßes
%              (1:= Euklidische Distanz (default) 2:=Mahalanobis-Distanz  3:=Tatsuoka-Distanz )
%   Ausgangsvariablen:
%   pos -> Klassenzugehörigkeit
%   nm  -> Wahrscheinlichkeitsdichte
%   prz -> Klassifizierungswahrscheinlichkeiten in
%   Umgang mit unbesetzten Klassen
%
% The function klf_an6 is part of the MATLAB toolbox Gait-CAD. 
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

kl_max=size(kl,1);
kl_besetzt=find(~isnan(kl(:,1)))';
kl_anz=length(kl_besetzt);

s_return=s;

if nargin<7  
   d_schalter=1;
end; %Wahl des Distanzmaßes 
if nargin<8  
   anzeige=1;
end;
if nargin<9  
   L=[]; 
end;
if (nargin<10) || (nargin<11) 
   apriori_schalter=0; 
end;
if (nargin<12) 
   typ_ent=1; 
end;

if anzeige 
   fprintf('\nApply classifier ...\n');
   fprintf('%d data points %d features ...\n',size(dat));
end;

anz_merk=size(dat,2);
su_invers=pinv(su);

if (d_schalter==5) || (d_schalter==6) 
   sk=zeros(size(anz_merk,anz_merk));
   for i=kl_besetzt 
      sk=sk+s((i-1)*anz_merk+[1:anz_merk],:); 
   end;
   sk=sk/kl_anz;
   sk_invers=pinv(sk);
end;

%Distanz md
for i=kl_besetzt 
   
   %Klassenmittelpunkte abziehen
   v=dat-ones(size(dat,1),1)*kl(i,:);
   
   %inverse Klassenkovarianzmatrix auswählen
   if d_schalter==1   %Euklidische-Distanz
      s_kl_invers=eye(size(su));
      log_kl=0;     
   end;
   
   if d_schalter==2   %Mahalanobis-Distanz 
      s_kl_invers=su_invers;
      log_kl=log(det(su));
   end;
   
   if d_schalter==3   %Tatsuoka-Distanz
      s_kl_invers=s_invers((i-1)*anz_merk+[1:anz_merk],:);
      log_kl=log_s(i);     
   end;
   
   if d_schalter==4   %Varianznormierung (HD)
      s_kl_invers=pinv(su.*eye(anz_merk));
      log_kl=log(det(su.*eye(anz_merk)));
   end;
   
   if d_schalter==5   %Gemittelte Klassenkovarianz
      s_kl_invers=sk_invers;
      log_kl=log(det(sk));     
   end;
   
   if d_schalter==6   %Gemittelte Klassenkovarianz (HD)
      s_kl_invers=pinv(sk.*eye(anz_merk));
      log_kl=log(det(sk));     
   end;
   
   if d_schalter==7   %Kompromiss Tatsuoka + Mahalanobis + Minimalstreuung
      minstreu=zeros(size(su))+0.01*diag(~diag(su));
      s_kl_invers=pinv(minstreu+0.1*su+0.9*s((i-1)*anz_merk+[1:anz_merk],:));
      log_kl=0;     
   end;
   
   
   if isinf(log_kl) 
      log_kl=0;
   end;
   
   %Änderung Ralf: da stand früher mal eine Begrenzung log_s >10 auf 1 (Numerik?) 
   %die schlägt voll ein, wenn ein Wert knapp über und ein Wert knapp unter 10 ist...
   if (log_kl>100) 
      log_kl=100;
   end;
   
   
   if (nargout>3) 
      s_return((i-1)*anz_merk+[1:anz_merk],:)=pinv(s_kl_invers);
   end;
   
   %Abstandsmaß (Term im Exponenten der e-Funktion)    
   v_1=v*s_kl_invers;
   
   %Log. der Determinante der Kovarianzmatrix addieren  
   %kommt nach späteren Exponieren wieder runter: det(S)^(-0.5) exp(-1/2*x'Sx)
   if (anz_merk>1)
      md(:,i)=sum((v_1.*v)')'+log_kl; 
   else
      md(:,i)=v_1.*v+log_kl; 
   end;  
end

%äquidistante Verteilung (a-priori Wahrscheinlichkeiten werden auf konstante gesetzt
%Optional apriori aus Lerndatensatz. Nur wenn aktiviert.
if apriori_schalter
   p=ones(size(md,1),1)*p_apriori;   
else
   p(:,kl_besetzt)=ones(size(md,1),1)*(1/kl_anz*ones(1,kl_anz));
end;
nm=p(:,kl_besetzt).*exp(-0.5*md(:,kl_besetzt));

%Wahrscheinlichkeitsdichte genau Null gibt numerische Probleme, wird auf fast Null gesetzt
ind=find(isnan(nm) | (nm == 0)); % Coderevision: &/| checked!
nm(ind)=1E-100;
nm = max(nm,1E-100);

%Prozentuale Zugehörigkeiten
prz=zeros(size(nm,1),kl_max);
prz(:,kl_besetzt)=100*nm./(sum(nm')'*ones(1,kl_anz));
nm(:,kl_besetzt)=nm;


%Entscheidung der Zugehörigkeit nach der maximalen Wahrscheinlichkeit
if (typ_ent==1) 
   [w,pos]=max(prz');
else            %aber nur für besetzte Klassen!!!
   
   [w,pos]=min(L.ld(:,1:kl_max)*prz');
   prz_neu=1./(L.ld(1:kl_max,1:kl_max)*prz');
   prz=(100*prz_neu./(sum(prz_neu)'*ones(1,kl_max))')';                
end; 

pos=pos';

if anzeige 
   fprintf('Complete ... \n');
end;