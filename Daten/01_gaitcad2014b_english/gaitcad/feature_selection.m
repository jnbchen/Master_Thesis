  function  [merkmal_auswahl,merk,merk_archiv] =feature_selection (d_org, code, interpret_merk,parameter)
% function  [merkmal_auswahl,merk,merk_archiv] =feature_selection (d_org, code, interpret_merk,parameter)
%
% 
%   d_org: Datenmatrix
%   code:  Kodierung
%   parameter.merk_red: Anzahl auszuwählender Merkmale
% 
%   Ausgänge:
%   merkmla_auswahl: Indices der ausgewählten Merkmale
%   merk :           Merkmalsrelevanzen
%   merk_archiv:     umfassende Statistiken über alle Details
%                    .verfahren:              verwendetes Verfahren
%                    .guete:                  Merkmalsrelevanzen (zeilenweise alle multivariaten Zwischenschritte!!)
%                    .merk_selection:         Relevanzen der ausgewählten Merkmale (mit A-Priori-Relevanzen)
%                    .merk_selection_no_int:  Relevanzen der ausgewählten Merkmale (ohne A-Priori-Relevanzen)
%                    .merkmal_auswahl:        Indices der ausgewählten Merkmale
%                    .best_guete:
%                    .rueckstufung:           Infos über Korrelationsrückstufungen
% 
% 
%
% The function feature_selection is part of the MATLAB toolbox Gait-CAD. 
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

if parameter.anzeige_details
   fprintf('Compute feature relevances and select features\n');
end;
%Warnungen werden nur beim 1. Mal angezeigt
start_warning=1;


ind_nan = find(isnan(code));

if isfield(parameter,'ykont')
   ind_nan_ykont = find(isnan(parameter.ykont));
   ind_nan = unique([generate_rowvector(ind_nan) generate_rowvector(ind_nan_ykont)]);
end;

if ~isempty(ind_nan)
   mywarning(sprintf('The output variable has %d data points with NaN values! These data points will be ignored!',length(ind_nan)));
   code(ind_nan) = [];
   d_org(ind_nan,:) = [];
   if isfield(parameter,'ykont')
      parameter.ykont(ind_nan) =[];
   end;
   if isempty(code)
      myerror('No data points remain!');
      return;
   end;
end;

%Bezeichner vorbereiten
switch parameter.mode_bewertung
   %1 (alle) und 2 (bereits ausgeqählt) werden hier nicht behandelt!
   case 3
      merk_archiv.verfahren=sprintf('Univariate analysis\n(Likelihood-quotients-test)\nSelection of %d features',parameter.merk_red);
      parameter.mode_univariat=1;
   case 4
      merk_archiv.verfahren=sprintf('Multivariate analysis\n(Likelihood-quotients-test)\nSelection of %d features',parameter.merk_red);
      parameter.mode_univariat=2;
   case 5 %Informationstheoretische Maße
      parameter.mode_univariat=1;
      %ZGFs entwerfen - aber nur, wenn sie noch nicht existieren
      %if ~isfield(parameter,'zgf')
      [parameter.zgf,muell,parameter.par.par_d_org]=zgf_en(d_org,parameter.fuzzy_system,parameter.par);
      %end;
      
      anz_fuzzy = max(parameter.par.par_d_org(5:end));
      %Fuzzifizieren - über alle, nicht nur über ausgewählte Beispiele
      [d_fuz,d_quali]=fuzz(d_org,parameter.zgf(:,1:anz_fuzzy));
      
      %feature lists with only selected features, implementation via a
      %priori relevances (set to zero for non selected ones)
      if isfield(parameter,'feature_candidates') && ~isempty(parameter.feature_candidates)
         if isempty(interpret_merk)
            interpret_merk = ones(parameter.par.anz_einzel_merk,1);
         end;
         interpret_merk_rett = interpret_merk;
         interpret_merk      = zeros(size(interpret_merk));
         interpret_merk(parameter.feature_candidates)  = interpret_merk_rett(parameter.feature_candidates);
      end;
      
      %Baum berechnen
      %um alles andere kümmert sich die Funktion mulbaum!!
      [tmp,merk,merkmal_auswahl,verfahren,texprot,merk_archiv]=mulbaum(...
         d_quali,code,parameter.par.par_d_org,parameter.fuzzy_system.dectree.baumtyp,1,parameter.merk_red,0,1,interpret_merk,[],[],0,1,parameter.fuzzy_system);
      merk_archiv.merk=merk;
   case 6   %Klassifikationsgüte
      merk_archiv.verfahren='Classification accuracy';
      if parameter.mode_univariat==2
         merk_archiv.verfahren = [merk_archiv.verfahren '(multivariate)'];
      end;
      
   case 7	%Fuzzy Klassifikationsgüte
      merk_archiv.verfahren='Fuzzy classification accuracy';
      if parameter.mode_univariat==2
         merk_archiv.verfahren = [merk_archiv.verfahren '(multivariate)'];
      end;
   case 8	%modifizierte Fuzzy Klassifikationsgüte
      merk_archiv.verfahren='Weighted fuzzy classification accuracy';
      if parameter.mode_univariat==2
         merk_archiv.verfahren = [merk_archiv.verfahren '(multivariate)'];
      end;
   case {9,15}
      merk_archiv.verfahren='Linear regression coefficients (univariate)';
      parameter.mode_univariat=1;
      if parameter.mode_bewertung == 15
         regr_plot.ytrue_regr = parameter.ykont;
      end;
      parameter.kp.regression.type ='polynom';
      parameter.kp.regression.poly_degree = 1;
   case {10,16}
      merk_archiv.verfahren='Linear regression coefficients (multivariate)';
      parameter.mode_univariat=2;
      if parameter.mode_bewertung == 16
         regr_plot.ytrue_regr = parameter.ykont;
      end;
      parameter.kp.regression.type ='polynom';
      parameter.kp.regression.poly_degree = 1;

   case 11
      merk_archiv.verfahren='Regression accuracy (univariate)';
      merk_archiv.output_name = parameter.kp.regression.output_name;
      parameter.mode_univariat=1;
      regr_plot.ytrue_regr = parameter.ykont;
   case 12
      merk_archiv.verfahren='Regression accuracy (multivariate)';
      merk_archiv.output_name = parameter.kp.regression.output_name;
      parameter.mode_univariat=2;
      regr_plot.ytrue_regr = parameter.ykont;
   case 13
      merk_archiv.verfahren='Regression accuracy via improvement of the mean error (univariate)';
      merk_archiv.output_name = parameter.kp.regression.output_name;
      parameter.mode_univariat=1;
      regr_plot.ytrue_regr = parameter.ykont;
   case 14
      merk_archiv.verfahren='Regression accuracy via improvement of the mean error (multivariate)';
      merk_archiv.output_name = parameter.kp.regression.output_name;
      parameter.mode_univariat=2;
      regr_plot.ytrue_regr = parameter.ykont;
end;

if parameter.anzeige_details
   fprintf('%s\n',merk_archiv.verfahren);
end;

%Merkmal-Auswahl setzen
if parameter.mode_univariat==1
   if ~isempty(parameter.merkmal_vorauswahl)
      mywarning('The preselection of features will be ignored for univariate methods!');
   end;
   parameter.merkmal_vorauswahl=[];
end;

%Informationstheoretsche Maße sind jetzt fertig!!
if parameter.mode_bewertung==5
   return;
end;


merkmal_auswahl=[];

%Vorauswahl kennzeichnen
if ~isempty(parameter.merkmal_vorauswahl)
   merk_archiv.verfahren= strcat(merk_archiv.verfahren,strcat('Preselection:',num2str(parameter.merkmal_vorauswahl)));
end;

%Nummer der möglichen Merkmale, diese müssen wenigstens einen unterschiedlichen Wert aufweisen ,
%Nan-Merkmale nicht einbeziehen
ind=find(max(isnan(d_org)));

if ~isempty(ind)
   mywarning(sprintf('%d features have NaN values and will be ignored!',length(ind)));
end;

merkmal_such=find(max(d_org,[],1)-min(d_org,[],1));
merkmal_such=setdiff(merkmal_such,ind);

if isfield(parameter,'feature_candidates')
   merkmal_such = intersect(merkmal_such,parameter.feature_candidates);
end;


%Validierung Merkmalsanzahl
if (parameter.merk_red > length(parameter.merkmal_vorauswahl)+length(merkmal_such))
   parameter.merk_red = length(parameter.merkmal_vorauswahl)+length(merkmal_such);
   mywarning('The number of features to be selected is greater than the number of candidate features.');
   if parameter.merk_red == 0
      merkmal_auswahl =[];
      merk = [];
      merk_archiv = [];
      return;
   end;
   
end;

%Rückgabewerte vorinitialisieren
if parameter.mode_univariat==2
   merk_archiv.guete=zeros(parameter.merk_red,size(d_org,2));
end;


%A-Priori-Relevanzen von Merkmalen
if isempty(interpret_merk)
   interpret_merk=ones(size(d_org,2),1);
end;

%Anzeige von Wartefenstern
if (parameter.anzeige_details)
   waitb1=[];
   waitb2=[];
   if parameter.mode_univariat==2 % einen Waitbar erstellen
      waitb1=waitbar(0,'multivariate cycles...');
      tmp=get(waitb1,'position');
      tmp(2)=tmp(2)+100;
      set(waitb1,'position',tmp);
   end ;
end; %if anzeige

%zur Sicherheit...
clear i j k

for i_multi=1:parameter.merk_red							% parameter.merk_red - mal durchlaufen
   
   %reine Anzeigeverwaltung (Balken usw.)
   if parameter.anzeige_details
      fprintf('%i-th feature\n', i_multi);
      if parameter.mode_univariat==2
         waitbar((i_multi-1)/parameter.merk_red,waitb1);
      end;
      if ~isempty(waitb2)
         close(waitb2);
      end;
      waitb2 = [];
      if length(merkmal_such)>10
         waitb2=waitbar(0,'Cycles over features...');
         letzt_kand=merkmal_such(length(merkmal_such));
      end;
   end;
   
   % univariat und 2. Durchlauf: Feierabend!!
   if (parameter.mode_univariat==1) && (i_multi>1)
      break;
   end;
   
   %multivariat: alle bereits ausgewählten Merkmale streichen
   merkmal_such=setdiff(merkmal_such,merkmal_auswahl);
   if isempty(merkmal_such)
      break;
   end;
   
   %Relevanzen leer vorinitialisieren
   merk=zeros(size(d_org,2),1);
   
   if isempty(parameter.merkmal_vorauswahl)
      merkmal_kandidaten = merkmal_such;
   else
      merkmal_kandidaten = parameter.merkmal_vorauswahl(1);
      parameter.merkmal_vorauswahl(1)=[];
   end;
   
   
   %über alle Kandidaten...
   for i_merk=merkmal_kandidaten
      
      %Anzeige: Verwaltung Balken
      if parameter.anzeige_details && ~isempty(waitb2) && ~rem(i_merk,100)
         waitbar(i_merk/(letzt_kand-rem(letzt_kand,100)),waitb2);
      end;
      
      % Daten mit zu testendem Merkmal zusammenstellen
      d=d_org(:,[merkmal_auswahl i_merk]);
      
      %Datensatz vorbereiten
      switch parameter.mode_bewertung
         case {6,7,8}
            
            [d,klass_single]=erzeuge_ds_feature_selection(d,code,parameter.kp);
            if ~isempty(klass_single)
               klass_single = klassifizieren_en(klass_single, parameter.kp, d, code);
            end;
            if ~isempty(klass_single)
               [pos, md, prz] = klassifizieren_an(klass_single, d, parameter.kp);
            else
               pos = [];
            end;
            if isempty(klass_single) || isempty(pos)
               pos = zeros(size(code));
               prz = zeros(size(code,1),max(code));
            end;
            
            
            %[kl,su,s,s_invers,log_s,p_apriori]=klf_en6(d,code,0);
            %[pos,md,prz]=klf_an6(d,kl,su,s,s_invers,log_s,parameter.bayes.metrik,0,[],parameter.bayes.apriori,p_apriori);
         case {11,12,13,14,15,16}
            parameter.kp.regression.anzeige = 0;
            
            %normalization of single features
            switch parameter.regression.normierung
               case 1
                  %keine Normierung
                  norm_merkmale_type=0;
               case 2
                  %[0 - 1 Normierung]
                  norm_merkmale_type=2;
               case 3
                  %MW0 - STD 1
                  norm_merkmale_type=1;
               case 4
                  %MW0 - STD unchanged
                  norm_merkmale_type=5;
                  
            end;
            d = matrix_normieren(d,norm_merkmale_type);
            
            regr_single = regression_en([], parameter.kp, d, parameter.ykont);
            if ~isempty(regr_single)
               regr_plot.ydach_regr = regression_an(regr_single, d, parameter.kp);
               regr_plot.valid      = 1;
            else
               regr_plot.valid      = 0;
            end;
      end;
      
      %Bewertung berechnen
      switch parameter.mode_bewertung
         case {3,4} %ANOVA und MANOVA
            
            %Gesamt-Kovarianz
            ges_cov=size(d,1)*cov(d,1);
            
            % Problem: Wenn Innerklassenkovarianz Null
            %					und addierter Wert zu klein, dann MANOVA-Wert so groß, dass kein weiteres Merkmal ausgewählt wird
            %					und addierter Wert zu groß, dann wird Merkmal nicht ausgewählt
            % deshalb: addierten Wert relativ über ges_cov berechnen (eigentlich auch nicht ganz sauber, weil bei großer Streuung der Klassenzentren
            %					die Innerklassenkov.mat. zu groß genommen wird)
            
            % Problem: ges_cov kann auch Null sein. Daraus würden immer konstante oder zufällige Eigenwerte (EW) folgen, die je nach Streuung im Datensatz
            %					dazu führen, dass entweder das Merkmal nicht gewählt wird, oder das Merkmal alle anderen überragt. Diese Zufälligkeit ist
            %					unlogisch.
            % deshalb: MANOVA-Wert manuell zu Null setzen
            
            % Problem: 	Wenn erstes Merkmal keine Innerklassenstreuung hat, dann kann u.U. jedes weitere Merkmal den MANOVA-Koeff. nur
            % 				verschlechtern, da zwar die Auswahl des ersten Merkmals ein künstliche Streuung einbaut, beim Hinzufügen eines weiteren
            %				ist diese aber nicht mehr vorhanden, es wird kein weiteres Merkmal ausgewählt
            % hierfür noch keine Lösung eingefügt
            
            % Problem: in_cl_cov kann auch nahe Null sein, dann ist (det(in_cl_cov)==0) nicht wahr und der MANOVA Wert wird wiederum eins gesetzt
            % deshalb: (det(in_cl_cov)<det(add)) einführen, Determinante als Maß für den Inhalt des Streuellipsoiden verwenden
            
            if det(ges_cov)== 0		% Wenn keinerlei Streuung im Merkmal, dann nicht verwenden
               merk(i_merk)=0;
            else
               
               %Innerklassen-Kovarianz
               in_cl_cov=zeros(size(d,2),size(d,2));
               for i_code=findd(code)
                  in_cl_cov=in_cl_cov+length(find(code==i_code))*cov(d(find(code==i_code),:),1);
               end
               
               %Regularisierung Innerklassenkoarianzmatrizen bei identischen Merkmalen
               delta_c=1e-3/size(d,1)*length(findd(code));
               add = ges_cov;
               if (det(in_cl_cov)< (det(add)*delta_c) )
                  if start_warning
                     warning(sprintf('Rank deficit of class covariance matrix for feature %d (selection of  %d-th feature)\nTry a regularization...',i_merk,i_multi));
                     warning('Possible future warnings for rank deficits will be hidden!');
                     start_warning=0;
                  end;
                  in_cl_cov=(1-delta_c)*in_cl_cov + delta_c*add;
               end;
               
               %Likelihood-Quotienten-Test
               ew=eig((pinv(in_cl_cov)*(ges_cov-in_cl_cov)));
               ew=ew(find(ew>0));
               merk(i_merk)=1-prod(1./(1+ew));
            end;
            
            %5: Informationstheoretische Maße hier nicht notwendig!!
         case 6
            %Klassifikationsgüte
            [konf,fehlproz]=klass9(d,code,pos,prz,-1); % und klassifizieren
            merk(i_merk)=(100-fehlproz)/100;
         case 7
            %graduelle Klassifikationsgüte
            for j=findd(code)
               merk(i_merk)=merk(i_merk)+mean(prz(find(code==j),j)./100)*length(find(code==j))/length(code);
            end;
         case 8
            %modifizierte graduelle Klassifikationsgüte
            %[konf,fehlproz]=klass9(d,code,pos,prz,-1); 	% und klassifizieren
            prz_richtig=[];							% Güte berechnen
            for j=findd(code)
               prz_richtig=[prz_richtig; prz(find(code==j),j)];
            end;
            prz_richtig = prz_richtig/100;						% und falsch klassifizierte Tupel stärker wichten
            ind_richtig = find(prz_richtig>=0.5);
            ind_falsch  = find(prz_richtig< 0.5);
            %modifizierte Formel nach [Reischl06]
            prz_richtig(ind_richtig) = 1+prz_richtig(ind_richtig);
            prz_richtig(ind_falsch)  = 3.*prz_richtig(ind_falsch);
            % Normierung auf 1
            merk(i_merk)=sum(prz_richtig)/2/size(prz_richtig,1);
         case {9,10}
            %lineare Regressionskoeffizienten
            dims=2:size(d,2)+1;
            s=[code';d']*[code d];
            merk(i_merk)=sqrt(s(1,dims)*pinv(s(dims,dims))*s(dims,1)/s(1,1));
         case {11,12,15,16}
            %lineare Regressionskoeffizienten
            if regr_plot.valid  == 1
               regr_plot.anzeige_erg = 0;
               merk(i_merk) = regression_statistics(regr_plot);
            end;
         case {13,14}
            %improvement of mean error
            if regr_plot.valid  == 1
               regr_plot.anzeige_erg = 0;
               [temp,temp,merk(i_merk)] = regression_statistics(regr_plot);
            end;
      end;
   end;
   
   %A-Priori-Relevanz modifizieren
   %bei univariaten Maßen einfach reinmultiplizieren
   %bei multivariaten Maßen Differenz zur Vorverbesserung
   %(ACHTUNG: originaler multivariater Wert in Guete, nicht interpret.-modifiziert!!!!)
   %Vorsicht ist angebracht!!
   
   %vorsichtshalber nur Realteile nehmen (manchmal spinnt die Numerik)
   merk = real(merk);
   
   if (i_multi==1)
      merk_int=merk.*interpret_merk;
   else
      merk_int=merk-(1-interpret_merk).*(merk-merk_archiv.merk_selection_no_int(i_multi-1))-sum(diff([0; merk_archiv.merk_selection_no_int']).*(1-interpret_merk(merkmal_auswahl)));
      merk_int=merk_archiv.merk_selection_no_int(i_multi-1) + max(0,(merk-merk_archiv.merk_selection_no_int(i_multi-1)) .*interpret_merk);
   end;
   
   %bestes Merkmal raussuchen
   [tmp,ind]=sort(-merk_int);
   
   %Relevanzen merken, ausgewählte Merkmale werden auf 1 gesetzt
   if (i_multi>1)
      if (merk_archiv.merk_selection_no_int(i_multi-1)>=merk(ind(1)))
         warning(sprintf('No improvement by %d-th feature, abort!',i_multi));
         merk_archiv.guete(i_multi:end,:)=[];
         break;  %for j
      end; %if guete
   end; %if j
   
   %zusätzliches Merken aller Werte
   merk_archiv.guete(i_multi,merkmal_such)   = merk_int(merkmal_such);
   merk_archiv.merk_selection(i_multi)       = merk_int(ind(1));
   merk_archiv.merk_selection_no_int(i_multi)= merk(ind(1));
   merk=merk_int;
   
   if (parameter.mode_univariat==1)
      merkmal_auswahl=ind(1:parameter.merk_red)';
   end;
   if (parameter.mode_univariat==2)
      merkmal_auswahl=[merkmal_auswahl ind(1)'];
      merk_archiv.guete(i_multi,merkmal_auswahl) = max(merk(merkmal_such));
   end;
   
   % Zugriff auf MATLAB ermöglichen
   drawnow;
end;

%Anzeigen wieder aufräumen...
if (parameter.anzeige_details)
   close(waitb1);
   if ~isempty(waitb2)
      close(waitb2);
   end;
end;


%beste Merkmale merken
merk_archiv.merkmal_auswahl=merkmal_auswahl;
merk_archiv.merk=merk;


%bei multivariaten Merkmalen werden fuer die ausgewählten besten noch
%Integer-Werte addiert, sonst sind die besten Merkmale hinten
if (parameter.mode_univariat==2)
   merk(merkmal_auswahl)=merk_archiv.merk_selection'+[length(merkmal_auswahl)-1:-1:0]';
end;

if parameter.anzeige_details
   fprintf('Complete!\n');
end;
