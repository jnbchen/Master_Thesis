  function [num_einzuege] = plugin_einzugausmerkmalen(paras, einzug_struct, d_org)
% function [num_einzuege] = plugin_einzugausmerkmalen(paras, einzug_struct, d_org)
%
%  Eingaben:
% 
%  paras: Parameter-Strukt
%         - par (Parametervektor aus Gait-CAD)
%         - dorgbez (Bezeichnungen der Einzelmerkmale)
%  einzug_struct: Strukt, dass mit Hilfe von plugin_einzugausdatei erstellt wurde
%         (oder das gleiche Format wie das hat)
%  d_org: Matrix mit Einzelmerkmale
% 
%  Ausgaben:
% 
%  num_einzuege: Matrix der Größe paras.par.anz_dat x 2 x length(einzug_struct)
%         Enthält die numerischen Einzüge (also die Indizes).
%         Waren Merkmalsbezeichner angegeben und ein Bezeichner ist in paras.dorgbez
%         nicht zu finden, werden die Einzüge auf 0 gesetzt und führen dadurch zu
%         einem Fehler bei der Merkmalsgenerierung oder dem Zugriff auf die Matrix d_orgs.
%  Wenn keine Einzüge übergeben wurde, beenden.
%
% The function plugin_einzugausmerkmalen is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

if (isempty(einzug_struct))
   num_einzuege = [];
   return;
end;

num_einzuege = zeros(size(d_org,1), 2, length(einzug_struct));

% Structs sind manchmal etwas blöd. Vor allem wenn man etwas mit mehreren Daten
% machen will.
enzCount = 1;
for i = einzug_struct
   % Prüfen, ob der Start vom Einzug eine Nummer ist. Ansonsten Extra-Behandlung
   if (isnumeric(i.einzug.start))
      num_einzuege(:, 1, enzCount) = i.einzug.start;
   else
      % Zeichenkette in eine mit eval auswertbare konvertieren und
      % ausführen
      try
         tmpEinzug = getEvalString(i.einzug.start, paras.dorgbez);
      catch
         tmpEinzug=[];
         i.einzug.start ='';
      end;
      if (isempty(tmpEinzug))
         mywarning(sprintf('Could not compute  ''%s''!!! Set segment to 0 ...\n', i.einzug.start));
         num_einzuege(:, 1, enzCount) = 0;
      else
         num_einzuege(:, 1, enzCount) = eval(tmpEinzug);
         %fprintf(1, 'Old string: %s\n New string: %s\n\n', i.einzug.start, tmpEinzug);
      end;
   end; % if(isnumeric...)
   
   % Genau das gleiche noch mal für den Stop des Einzugs.
   if (isnumeric(i.einzug.stop) && i.einzug.stop > 0)
      num_einzuege(:, 2, enzCount) = i.einzug.stop;
   else
      % Hier auch Kontrolle, ob -1 als Stop angegeben ist => heißt Ende der Zeitreihe
      if (i.einzug.stop == -1)
         num_einzuege(:, 2, enzCount) = paras.par.laenge_zeitreihe;
      else
         % Zeichenkette in eine mit eval auswertbare konvertieren und
         % ausführen
         try
            tmpEinzug = getEvalString(i.einzug.stop, paras.dorgbez);
         catch
            tmpEinzug=[];
            i.einzug.stop ='';
         end;
         if (isempty(tmpEinzug))
            mywarning(sprintf('Could not compute  ''%s''!!! Set segment to 0 ...\n', i.einzug.stop));
            num_einzuege(:, 2, enzCount) = 0;
         else
            num_einzuege(:, 2, enzCount) = eval(tmpEinzug);
            %fprintf(1, 'Old string: %s\n New string: %s\n\n', i.einzug.stop, tmpEinzug);
         end;
      end; % if (i.einzug.stop == 1)
   end; % if (isnumeric...)
   
   enzCount = enzCount + 1;
end; %for i = einzug_struct
% Einzüge jetzt noch mal runden:
num_einzuege = floor(num_einzuege);

% Überprüfen, ob es nicht erlaubte Einzüge gibt (z.B. 0, Inf oder NaN)
if (~isempty(find(isinf(num_einzuege) | isnan(num_einzuege) | num_einzuege == 0)))  % Coderevision: &/| checked!
   mywarning('Invalid time segments (0, Inf or NaN)!');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HILFSFUNKTION
% Konvertiert die Zeichenkette mit den EM-Bezeichnern in eine Zeichenkette,
% die mit eval ausgewertet werden kann.
% Tritt ein Fehler auf, wird eine leere Matrix zurückgegeben.
function strRet = getEvalString(strMitBez, dorgbez)
delim = ['+', '-', '*', '/', '(', ')', ' '];
strRet = strMitBez;
str = strMitBez;

% ein do...while würde hier besser passen, aber das gibt es nicht...
while(1)
   if length(str)>1 && str(1) == '{'
      %allow regular entries within {},e.g. for variable names with blanks
      ind_klammer = strfind(str,'}');
      if isempty(ind_klammer)
         strRet = [];
         return;
      end;
      %repair_token includes the complete string incl. {}, otherwise
      %problems for string repair later
      repair_token = str(1:ind_klammer(1));
      token = str(2:ind_klammer(1)-1);
      remainder = str(ind_klammer(1)+1:end);
   else
      [token, remainder] = strtok(str,delim);
      repair_token = token;
   end;
   str = remainder;
   % Kann die Zeichenkette in eine Zahl umgewandelt werden?
   % Vorsicht: ein einfaches isstring oder isnumeric reicht nicht!!!
   mylocalnumber = str2num(token);
   
   if isempty(mylocalnumber) || any(isnan(mylocalnumber))
      if strcmp('maxtime',token)
         strRet = strrep(strRet, token, 'paras.par.laenge_zeitreihe');
      else
         [indx] = find(strcmp(cellstr(dorgbez), token));
         % Wurde kein solches Merkmal gefunden, empty zurückgeben
         if (isempty(indx))
            strRet = [];
            return;
         else
            strRet = strrep(strRet, repair_token, sprintf('d_org(:,%d)', indx(1)));
         end;
      end;
   end;
   
   if (isempty(remainder))
      break;
   end;
end;
