  function [d_org,var_bez,dorgbez,par,merk_einzel_relev,ref,categories]=merkmalsgenerierung_plugins(merk_uihd, mgenerierung_plugins, einzuege_plugins, d_org, var_bez, dorgbez, par, merk_einzel_relev, ref,  akt_bez_code,code,code_alle,merk_red, ind_auswahl, parameter,categories)
% function [d_org,var_bez,dorgbez,par,merk_einzel_relev,ref,categories]=merkmalsgenerierung_plugins(merk_uihd, mgenerierung_plugins, einzuege_plugins, d_org, var_bez, dorgbez, par, merk_einzel_relev, ref,  akt_bez_code,code,code_alle,merk_red, ind_auswahl, parameter,categories)
%
% The function merkmalsgenerierung_plugins is part of the MATLAB toolbox Gait-CAD. 
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

global d_orgs

warn_status=1;

fprintf('Compute new features from time series...(with plugins)\n');

% Auswahl aus angezeigtem Fenster auslesen.
ind_merkmale=get(merk_uihd(1,1),'value');
ind_einzug=get(merk_uihd(2,1),'value');

ind_merk_neu=get(merk_uihd(3,1),'value');

%NEU: die Nummern der Plugins für die ausgewählten angezeigten Elemente
ind_merk_neu = mgenerierung_plugins.typ_beschreibung.plugin(mgenerierung_plugins.typ_beschreibung.show_now(ind_merk_neu));
%aber ohne Nullen!
ind_merk_neu = ind_merk_neu(find(ind_merk_neu));


bess_schlecht_bez=char('S+','S-');

% Aktualisiere die Informationen der Plug-Ins:
paras.par = par;
paras.anz_gew_merk = length(ind_merkmale);
paras.parameter = parameter;
mgenerierung_plugins = aktualisiereMPluginInfos(mgenerierung_plugins, paras);

% ist_zeitreihe ist ein Vektor, mit deren Hilfe der neue Speicher berechnet wird.
% Diese Variable stammt aus der alten Version ohne Plug-Ins und wird hier weiter
% verwendet. Das "Umformatieren" aus dem mgenerierung_plugins struct ist allerdings
% etwas aufwändig...
ist_zeitreihe = cell(length(mgenerierung_plugins.info),1 );
[ist_zeitreihe{:}] = deal(mgenerierung_plugins.info.anz_zr);
ist_zeitreihe = myCellArray2Matrix(ist_zeitreihe)';
% Genau das gleiche für ist_em
ist_em = cell(length(mgenerierung_plugins.info),1 );
[ist_em{:}] = deal(mgenerierung_plugins.info.anz_em);
ist_em = myCellArray2Matrix(ist_em)';


% Genau das gleiche für anz_benoetigt_zr
anz_bzr = cell(length(mgenerierung_plugins.info),1 );
[anz_bzr{:}] = deal(mgenerierung_plugins.info.anz_benoetigt_zr);
anz_bzr = myCellArray2Matrix(anz_bzr)';
% Hier ist ein Trick nötig. Es gibt Zeitreihen, die beliebig viele Zeitreihen übergeben bekommen können.
% Dies wird durch "Inf" gekennzeichnet. Mit Inf kann man aber einigermaßen schlecht rechnen, daher muss Inf
% durch die Anzahl der tatsächlich markierten Zeitreihen ersetzt werden:
anz_bzr(isinf(anz_bzr)) = length(ind_merkmale);

% Problem: wenn z.B. drei ZR markiert sind, ein Plug-In aber nur zwei benötigt,
% hilft auch die untere Umrechnung bei der Speicherreservierung nicht mehr.
% Zunächst: alles abfangen, was Probleme machen könnte:
% - mehr als eine von eins verschiedene Anzahl ist schlecht
% - ist zwar nur eine Anzahl von eins verschieden, aber zu viele Markiert ist das schlecht
[B, I, J] = unique(anz_bzr(ind_merk_neu));
% Die 1 ist uninteressant
B(B==1) = [];
if ( (size(B,2) > 1) ) % es sind mehr als eine von eins verschiedene Anzahlen nötig => Abbrechen
   mywarning('Error! Need more than one time series to compute this feature.');
   return;
end;
if (length(ind_merkmale) ~= B) % Es sind nicht genügend oder zu viele Merkmale markiert => Abbruch
   mywarning('Error! Wrong number of selected features');
   return;
end;

%if (max(anz_bzr(ind_merk_neu)) > length(ind_merkmale))
%   warning('Error! Too few selected features !...');
%   return;
%end;

% Beim Einlesen der PlugIns werden auch gleich die Einzüge bestimmt.
% Die dabei bestimmten Einzüge müssen nun in Indizes  umgerechnet
% werden.
paras_e.par = par; 
paras_e.dorgbez = dorgbez;
einzuege (:,:,ind_einzug)= plugin_einzugausmerkmalen(paras_e, einzuege_plugins(ind_einzug), d_org);
einzuege_bez(ind_einzug,:) = char(einzuege_plugins(ind_einzug).kurzbezeichner);

% Bezeichner in Cellstrings ablegen
var_bez_cell = cellstr(var_bez(1:size(var_bez,1)-1,:));
einzuege_bez_cell = cellstr(einzuege_bez);
dorgbez_cell = cellstr(dorgbez);

% Berechne den benötigen Speicher für die neu zu berechnen ZR und EM
anz_zeitreihe=length(ind_merkmale)*sum(ist_zeitreihe(ind_merk_neu));
anz_merkmale =length(ind_merkmale)*length(ind_einzug)*sum(ist_em(ind_merk_neu));
% Plug-Ins, die mehrere ZR benötigen, werden mit zu vielen Zeitreihen  und
% Merkmalen in anz_zeitreihe und anz_merkmale eingerechnet.
% Diese wieder abziehen:
% Aber: negative Anzahlen sind nicht gewünscht, also Minimum mit 0 bilden...
anz_zeitreihe = max(anz_zeitreihe - (sum( (anz_bzr(ind_merk_neu)-1).*ist_zeitreihe(ind_merk_neu))), 0);
anz_merkmale = max(anz_merkmale - (sum( (anz_bzr(ind_merk_neu)-1).*ist_em(ind_merk_neu))), 0);
% Einige Plug-Ins verbieten die Verwendung von Einzügen. Dennoch werden alle gewählten
% Einzüge für die Berechnung des benötigten Speichers verwendet.
% Also hier wieder eine bestimmte Anzahl Merkmale abziehen:
einzugOK = myCellArray2Matrix({mgenerierung_plugins.info.einzug_OK});
% Zeitreihen dürfen grundsätzlich keine Einzüge verwenden und es wird auch nicht
% in den  benötigten Speicher einbezogen.
% Also nur bei den Einzelmerkmalen abziehen:
anz_merkmale = max(anz_merkmale - ( length(ind_merkmale) * sum(~einzugOK(ind_merk_neu)) * (length(ind_einzug)-1) ), 0);

%Ort für nächstes Merkmal
nummer_neu_org=size(d_org,2)+1;
nummer_neu_orgs=size(d_orgs,3)+1;
ungueltiges_merkmal_org =zeros(1,size(d_org,2)+anz_merkmale);
ungueltiges_merkmal_orgs=zeros(1,size(d_orgs,3)+anz_zeitreihe);

%Vorinitialisieren
umstaendliches_speicherschonen = parameter.gui.merkmale_und_klassen.speicherschonend_einfuegen;
if umstaendliches_speicherschonen
   for i=1:size(d_orgs,3) 
      fprintf('Save TS%g\n',i);
      eval(sprintf('temp%g=d_orgs(:,:,%g);',i,i));
   end; 
   dim_d_orgs=size(d_orgs)+[0 0 anz_zeitreihe];
   d_orgs=[];
   save([parameter.allgemein.pfad_temp filesep 'temp'],'temp*');
   clear temp*
   d_orgs=zeros(dim_d_orgs);
   load([parameter.allgemein.pfad_temp filesep 'temp']);
   for i=1:size(d_orgs,3)-anz_zeitreihe 
      fprintf('Load TS%g\n',i);
      eval(sprintf('d_orgs(:,:,%g)=temp%g;clear temp%g;',i,i,i));
   end;
else 
   d_orgs(1:par.anz_dat,:,size(d_orgs,3)+[1:anz_zeitreihe])=zeros(par.anz_dat,par.laenge_zeitreihe,anz_zeitreihe);
end;

d_org(1:par.anz_dat,size(d_org,2)+[1:anz_merkmale])     =zeros(par.anz_dat,anz_merkmale);
if ~isempty(ref) 
   ref.my  (1,:,size(ref.my,3)+[1:anz_zeitreihe])=zeros(1,par.laenge_zeitreihe,anz_zeitreihe);
   ref.mstd(1,:,size(ref.my,3)+[1:anz_zeitreihe])=zeros(1,par.laenge_zeitreihe,anz_zeitreihe);
end;

fprintf('\nCompute feature(s) from time series: \n');

for j=ind_merkmale %gehe durch alle ausgewählten Merkmale (Zeitreihen wie Kniewinkel, Hüftwinkel,...)
   fprintf('%d (%s)\n',j, kill_lz(var_bez(j,:)));
   for k=ind_merk_neu %gehe durch alle neuen Merkmale
      
      %ZEITBEREICHE
      for i=ind_einzug
         % Hier eine Statusvariable, um das Einfügen eines Bezeichners abschalten zu können.
         % Für Zeitreihen wird zwar die Verwendung von Einzügen vermieden, aber die Bezeichner
         % werden trotzdem angehängt. Das muss verhindert werden...
         no_bez = 0;
         mehrfach_zr = 0;
         if (j == ind_merkmale(1) && mgenerierung_plugins.info(k).anz_benoetigt_zr > 1)
            mehrfach_zr = 1;
         end;
         
         % Fehler-Abfrage. Um viele if-Abfragen zu vermeiden, wird diese Variable eingeführt.
         % Stimmt irgendwo etwas nicht, kann ok auf 0 gesetzt werden, die Berechnung dieses Merkmals
         % wird nicht durchgeführt, kein Bezeichner angelegt.
         % Ist ok_msg nicht leer, wird ok_msg als warning ausgebenen.
         ok = 1;
         ok_msg = '';
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Eingaben für die Plug-Ins vorbereiten:
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         datenIn.ref = ref;
         paras.par = par;
         paras.code = code;
         paras.code_alle = code_alle;
         paras.var_bez = var_bez;
         paras.merk_red = merk_red;
         paras.anz_gew_merk = length(ind_merkmale);
         paras.parameter = parameter;
         paras.einzuege = [];
         if (mehrfach_zr == 1)
            %paras.ind_zr_merkmal = ind_merkmale(1:mgenerierung_plugins.info(k).anz_benoetigt_zr);
            % In den Plug-In-Infos stehen die "alten" Anzahlen (also auch Inf) drin. Also lieber aus anz_bzr den Wert holen
            paras.ind_zr_merkmal = ind_merkmale(1:anz_bzr(k));
         else
            paras.ind_zr_merkmal = j;
         end;
         % Weitere Parameter:
         paras.iirfilter = parameter.gui.zeitreihen.iirfilter;
         paras.iirfilter_aS_aL_aSigma = parameter.gui.zeitreihen.iirfilter_aS_aL_aSigma;
         paras.abtastfrequenz = parameter.gui.zeitreihen.abtastfrequenz;
         paras.samplepunkt = parameter.gui.zeitreihen.samplepunkt;
         paras.fenstergroesse = parameter.gui.zr_klassifikation.fenstergroesse;
         paras.ind_auswahl = ind_auswahl;
         
         % Hier unterscheiden, ob das PlugIn mit einem Einzug arbeitet oder nicht.
         % ACHTUNG: Bei einer Zeitreihe wird die Verwendung von Einzügen verboten!
         % Das ist dann ein Problem, wenn Zeitreihen unterschiedliche Längen haben dürfen und
         % dann Einzüge erlaubt sind. In einem solchen Fall muss lediglich der erste Term ~ist_zeitreihe(k)
         % entfernt werden. Die restliche Abfrage ist in Ordnung.
         if (~ist_zeitreihe(k) && isfield(mgenerierung_plugins.info(k), 'einzug_OK') && mgenerierung_plugins.info(k).einzug_OK == 1)
            
            % Einzug auslesen
            einzug = einzuege(:, :, i);
            paras.einzuege = einzug;
            % einzug ist jetzt eine size(d_orgs,1) x 2 Matrix
            % Dies in einer for-Schleife aufzuräumen ist zu aufwändig...
            % einzug = einzug(1,:);
            
            [B, I, J] = unique(einzug, 'rows');
            % In B stehen nun alle Zeilenvektoren der Matrix einzug, wobei alle doppelten
            % Vorkommen entfernt wurden.
            % I sind die Indizes für die Umrechnung zwischen B und einzug, hier uninteressant.
            % In J stehen nun für jeden Zeilenvektor von einzug derjenige Index, der diesen Vektor in
            % der Matrix B wiederspiegelt.
            % In J stehen die Vektoren ausserdem sortiert. Nun kann für jede Gruppe (es gibt size(B,1) viele)
            % in einem Schleifendurchlauf ein identischer Einzug genutzt werden.
            for eIndx = 1:size(B,1)
               indx = find(J == eIndx);
               if (size(indx,1) ~= 1)
                  indx = indx';
               end;
               % Die Datensätze sind nun d_orgs(indx, :, merkmal);
               % Der Einzug ist B(i)
               % Ein falscher Einzug führt zum Absturz. Hier eine Warnung ausgeben und Einzug ignorieren...
               if (~isempty(find(B(eIndx,:) == 0 | isnan(B(eIndx,:)) | isinf(B(eIndx,:)))) || (B(eIndx,1) > B(eIndx,2)) ) % Coderevision: &/| checked!
                  fprintf(1,'Forbidden time segment %d->%d will be ignored (values set to 0!)\nTime segment: %s, data point %s', B(eIndx,1), B(eIndx, 2), einzuege_plugins(i).kurzbezeichner, num2str(indx));
                  if (warn_status==1) 
                     mywarning('Illegal segment (details see command window)');
                     warn_status=0;
                  end;                  
               else
                  if B(eIndx,2)>par.laenge_zeitreihe
                     d_orgs=d_orgs(:,:,1:par.anz_merk);
                     d_org=d_org(:,1:par.anz_einzel_merk);
                     mywarning('Cancel: Maximal value of the time segment is greater as the length of the time series!');
                     return;
                  end;
                  if (mehrfach_zr == 1)
                     ind_zeitreihe=ind_merkmale(1:anz_bzr(k));
                  else
                     ind_zeitreihe=j;
                  end;
                  datenIn.dat = d_orgs(indx, B(eIndx,1):B(eIndx,2), ind_zeitreihe);
                  
                  
                  paras.einzuege = B(eIndx,:);
                  
                  % Alles ok?
                  if (ok > 0)
                     
                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     %evtl. Parameter aus der Kommandozeile übernehmen
                     if ~isempty(mgenerierung_plugins.info(k).commandline)
                        paras.parameter_commandline = mgenerierung_plugins.info(k).commandline.parameter_commandline;
                     else
                        paras.parameter_commandline = '';
                     end;
                     
                     
                     % Plug-In Funktion aufrufen
                     [datenOut, ret, info] = eval( [mgenerierung_plugins.funktionsnamen(k,:) '(paras, datenIn)'] );
                     
                     % Daten müssen schon mal kopiert werden, da die Größe der zurückgegegeben Matrix
                     % nicht alle Datentupel umfasst.
                     if (ist_zeitreihe(k))
                        d_orgs(indx, B(eIndx,1):B(eIndx,2), nummer_neu_orgs:nummer_neu_orgs+ist_zeitreihe(k)-1) = datenOut.dat_zr;
                        
                        %Kategorie: Plugin merken  
                        categories.zr=save_categories(categories.zr,nummer_neu_orgs:nummer_neu_orgs+ist_zeitreihe(k)-1,mgenerierung_plugins.funktionsnamen(k,:),'',categories.zr,ind_zeitreihe);
                        
                     else
                        d_org(indx, nummer_neu_org:nummer_neu_org+ist_em(k)-1) = datenOut.dat_em;
                        
                        %Kategorie: Plugin merken  
                        categories.em=save_categories(categories.em,nummer_neu_org:nummer_neu_org+ist_em(k)-1,mgenerierung_plugins.funktionsnamen(k,:),einzuege_plugins(i).kurzbezeichner,categories.zr,ind_zeitreihe);
                     end;
                  end; % if (ok > 0)
               end; 
            end; % for eIndx = 1:size(B,1)
         else
            if (i == ind_einzug(1)) % => if ~einzug_OK, aber nur beim ersten Durchgang. Sonst wird das Merkmal mehrfach berechnet.
               % Daten
               if (mehrfach_zr == 1)
                  ind_zeitreihe=ind_merkmale(1:anz_bzr(k));
               else
                  ind_zeitreihe=j;
               end;
               datenIn.dat = d_orgs(:, :, ind_zeitreihe);
               
               % Datenerhebung erfolgreich?
               if (ok > 0)
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  % Plug-In Funktion aufrufen
                  try 
                     %evtl. Parameter aus der Kommandozeile übernehmen
                     if ~isempty(mgenerierung_plugins.info(k).commandline)
                        paras.parameter_commandline = mgenerierung_plugins.info(k).commandline.parameter_commandline;
                     else
                        paras.parameter_commandline = '';
                     end;
                     [datenOut, ret, info] = eval( [mgenerierung_plugins.funktionsnamen(k,:) '(paras, datenIn)'] );
                  catch
                     d_org=d_org(:,1:par.anz_einzel_merk);
                     d_orgs=d_orgs(:,:,1:par.anz_merk);
                     mywarning(sprintf('Error by executing a plugin (%s):\n%s',mgenerierung_plugins.info(k).beschreibung, lasterr));
                     return;
                  end;
                  
                  
                  % Daten kopieren
                  if (ist_zeitreihe(k))
                     d_orgs(:, :, nummer_neu_orgs:nummer_neu_orgs+ist_zeitreihe(k)-1) = datenOut.dat_zr;
                     %Kategorie: Plugin merken  
                     categories.zr=save_categories(categories.zr,nummer_neu_orgs:nummer_neu_orgs+ist_zeitreihe(k)-1,mgenerierung_plugins.funktionsnamen(k,:),'',categories.zr,ind_zeitreihe);
                     
                  else
                     d_org(:, nummer_neu_org:nummer_neu_org+ist_em(k)-1) = datenOut.dat_em;
                     %Kategorie: Plugin merken  
                     categories.em=save_categories(categories.em,nummer_neu_org:nummer_neu_org+ist_em(k)-1,mgenerierung_plugins.funktionsnamen(k,:),einzuege_plugins(i).kurzbezeichner,categories.zr,ind_zeitreihe);
                  end;
               end; % if (ok > 0)
               no_bez = 0;
            else
               no_bez = 1;
            end;  % if (i == ind_einzug(1))
         end; % if einzug_OK
         
         % Auch wenn die Berechnung fehlerhaft war (z.B. wg. zuwenigen Zeitreihen),
         % muss der Bezeichner angehängt werden.
         % Etwas weiter unten werden die entsprechenden Zeitreihen auf ungueltig
         % gesetzt und damit wieder gelöscht. Wurde der Bezeichner nicht eingefügt,
         % fehlen Bezeichner => Daten sind nicht mehr konsistent.
         % Wenn ein Bezeichner im ret-Strukt enthalten ist (ist parameterabhängiger Bezeichner),
         % den verwenden, ansonsten den Bezeichner aus dem Info-Strukt.
         if (~no_bez)
            if (isfield(ret, 'bezeichner') && ~isempty(ret.bezeichner) && ischar(ret.bezeichner))
               bezeichner = ret.bezeichner;
            else
               bezeichner = mgenerierung_plugins.info(k).bezeichner;
            end;
            
            % Nun den Bezeichner anfügen und nummer_neu_org(s) erhöhen
            % Das darf _nicht_ in der Schleife oben geschehen, da der Bezeichner dann mehrfach angehängt wird
            if (ist_zeitreihe(k))
               if (ok == 0 || ( isfield(ret, 'bezeichner') && ret.ungueltig==1 )) 
                  ungueltiges_merkmal_orgs(nummer_neu_orgs:nummer_neu_orgs+ist_zeitreihe(k)-1)=1;
               end;
               nummer_neu_orgs = nummer_neu_orgs + ist_zeitreihe(k);
               % Hier unterscheiden, ob Einzüge erlaubt waren
               if (isfield(mgenerierung_plugins.info(k), 'einzug_OK') && mgenerierung_plugins.info(k).einzug_OK == 1)
                  % Neue Bezeichnungsteile hinten anhängen.
                  tmp = strcat(var_bez_cell(j) ,'~', cellstr(bezeichner), '~', einzuege_bez_cell(i));
               else
                  tmp = strcat(var_bez_cell(j) ,'~', cellstr(bezeichner));
               end;
               % LR-Bezeichner entfernen, wenn gewünscht
               if (isfield(mgenerierung_plugins.info(k), 'richtung_entfernen') && mgenerierung_plugins.info(k).richtung_entfernen == 1)
                  % Suche in allen Bezeichnern, ob [R bzw. [L verwendet wird (alte Bezeichnung)
                  if isempty(getfindstr(var_bez, '[Right' ))  %if isempty(strmatch('[Right', var_bez)) 
                     tmp2=1:2;
                  else % sonst sollte es [Right oder [Left geben
                     tmp2=1:5; %dann ist wenigstens mehr gelöscht
                  end;
                  % Aus Bezeichnung entfernen.
                  tmp(:,tmp2) = '';
               end; % if richtung_entfernen == 1
               % Neuen Bezeichner in Bezeichnungsmatrix kopieren
               var_bez_cell = [var_bez_cell ; tmp];
            else % if ~ist_zeitreihe(k) => if ist_em(k)
               if (ok == 0 && ( isfield(ret, 'bezeichner') && ret.ungueltig==1 ))
                  ungueltiges_merkmal_org (nummer_neu_org:nummer_neu_org+ist_em(k)-1)=1;
               end;
               nummer_neu_org = nummer_neu_org + ist_em(k);
               
               % Hier unterscheiden, ob Einzüge erlaubt waren
               if (isfield(mgenerierung_plugins.info(k), 'einzug_OK') && mgenerierung_plugins.info(k).einzug_OK == 1)
                  % Neuen Bezeichnungsteile vorne anhängen.
                  tmp = strcat(cellstr(bezeichner), '~', einzuege_bez_cell(i) ,'~', var_bez_cell(j));
               else
                  tmp = strcat(cellstr(bezeichner), '~', var_bez_cell(j));
               end;
               % Neue Bezeichnungen in Matrix kopierern
               dorgbez_cell = [dorgbez_cell;tmp];
            end; % if ist_zeitreihe(k)
         end; % if(~no_bez)
         % Wenn ein Plug-In mit Mehrfachauswahl berechnet wurde, dann muss dieses Plug-In aus der
         % Auswahl entfernt werden, da immer die ersten anz_benoetigt_zr Zeitreihen verwendet werden.
         if (mehrfach_zr == 1)
            ind_merk_neu(ind_merk_neu == k) = [];
         end;
         
         if (ok == 0 && ~isempty(ok_msg))
            mywarning(ok_msg);
         end;
      end; %i = gehe durch alle Einzugsgebiete 
   end; % k gehe durch alle ausgewählten neuen Merkmale
end; % j gehe durch alle ausgewählten Merkmale (Zeitreihen wie Kniewinkel, Hüftwinkel,...)

% Bezeichner zurückwandeln
if ~isempty(dorgbez_cell{1})
   dorgbez = char(dorgbez_cell);
else
   dorgbez = char(dorgbez_cell{2:end});
end;

% y am Ende der Schleife EINMAL anhängen
var_bez = char([var_bez_cell; {'y'}]);

%Nullwerte in Bezeichner mit Leerzeichen auffüllen, Abfrage, ob EM oder ZR existieren, sonst Fehlermeldung
if ~isempty(dorgbez) 
   dorgbez(find(dorgbez==0))=32;
   dorgbez=char(dorgbez); 
end; 
if ~isempty(var_bez) 
   var_bez(find(var_bez==0))=32; 
end;

%Checke gültige Einzelmerkmale: 
ind=find(ungueltiges_merkmal_org);
if ~isempty(ind) 
   dorgbez(ind,:)=[];
   d_org(:,ind)=[];
   mywarning('Delete invalid computed single features');
end;

%Checke gültige Zeitreihen: 
ind=find(ungueltiges_merkmal_orgs);
if ~isempty(ind) 
   var_bez(ind,:)=[];
   d_orgs(:,:,ind)=[];
   mywarning('Delete invalid computed time series');
   fprintf('The computation of features for left and right body sides require a selection of the left body side\n');
   fprintf('no doubled computation for complete selecetion\n');
end;

if ~isempty(ref)
   ref.my(:,:,ind)=[];
   ref.mstd(:,:,ind)=[];      
end; 

fprintf('Complete!\n');


function my_category=save_categories(my_category,ind,plugin_name,einzug_name,my_copy_category,ind_copy_cat)
%Funktion merkt sich Plugins und Einzüge, aus den das neue Merkmal erzeugt wurde, für eine spätere Kategorisierung

%besser erstmal in Struct schreiben und erst später in cellstr umwandeln!
for i_feat=ind 
   my_category(i_feat,1).plugin  = deblank(plugin_name);
   my_category(i_feat,1).einzug  = ['einzug_' deblank(einzug_name)];
   
   %merkt sich alle Plugins der alten Zeitreihe, aus der das neue Merkmal erzeugt wird
   %das funktioniert aber nicht für Mehrfach-Zeitreihen!!
   if length(ind_copy_cat)==1 && ~isempty(my_copy_category)
      for i_copy=1:size(my_category,2)
         if isempty(my_copy_category(ind_copy_cat,i_copy).plugin)
            break;
         else 
            my_category(i_feat,i_copy+1).plugin  = my_copy_category(ind_copy_cat,i_copy).plugin;      
         end;         
      end;      
   end;
   
end;





