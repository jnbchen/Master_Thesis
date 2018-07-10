  function [lp_detect] = lp_ausreisser_detection_en(daten, param_strukt)
% function [lp_detect] = lp_ausreisser_detection_en(daten, param_strukt)
%
%  Sucht mit Hilfe einer Art SVM-Optimierung nach Ausreißern innerhalb
%  eines Datensatzes.
%  Für den Algorithmus siehe Campbell 2000, "A Linear Programming Approach
%  to Novelty Detection", Proc. Neural Information Processing Systems Conference
% 
%  Es wird eine Abbildung f(z) = sum_i( a_i * K(z, x_i) + b) bestimmt, wobei
%  die x_i die Lerndaten darstellen. Diese Abbildung ist für alle Lerndaten
%  >= 0, für Ausreißer < 0. Falls in den Lerndaten bereits Ausreißer vorhanden
%  sind, kann mit einem Parameter lambda angegeben werden, wie weit Lerndaten
%  von der Bedingung f(x_i) >= 0 abweichen dürfen.
%  Minimiert W(a,b) = sum_i( sum_j( a_j * K(x_i, x_j) + b) ) + lambda * sum_i(xi_i)
%  Für die genauen Formeln siehe angegebene Literatur.
% 
%  Eingaben:
%  daten: Daten mit bekannten Daten einer Klasse (Dimension #Lerndaten x #Merkmale)
%  param_strukt: Parameter-Strukt mit folgenden Inhalten
%  param_strukt.kernel: Zu verwendender Kernel: 'rbf', 'poly', 'polyhomog' (default: 'rbf').
%  param_strukt.kernel_parameter: Parameter des Kernels
%  param_strukt.lambda: Sollen "weiche" Klassengrenzen berechnet werden?
%  Je größer Lambda, desto härter die Grenzen. Alternative ist,
%  diesen Parameter leer oder wegzulassen. (default: [])
%  param_strukt.algorithmus: Algorithmus für die Optimierung. Verwendet entweder die lp_solve-Toolbox
%  oder die Matlab-Optimierung linprog (dabei Wahl zwischen 'LargeScale' und 'MediumScale')
%  (default: 'lp_solve'). Für die Matlab-Optimierung wird die Optimization-Toolbox verwendet.
%  param_strukt.max_iter: maximale Anzahl Iterationen (default: 150)
% 
%  Ausgaben:
%  lp_detect: Strukt mit:
%  lp_detect.a: geschätzte a_i
%  lp_detect.b: geschätztes b
%  lp_detect.xi: geschätzte xi_i ([], wenn lambda == [])
%  lp_detect.algorithmus: Verwendeter Algorithmus
%  lp_detect.iterationen: Anzahl benötigter Iterationen (nur bei Matlab-Toolbox)
%  lp_detect.exitflag: >0, falls Optimierung erfolgreich (nur bei Matlab-Toolbox)
%  lp_detect.kernel: übergebener Kernel
%  lp_detect.kernel_parameter: übergebener Kernel-Parameter
%  lp_detect.lerndaten: Kopie der Lerndaten
% 
%
% The function lp_ausreisser_detection_en is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 2)
   param_strukt = [];
end;

% Wenn kein Kernel angegeben wurde, verwende RBF
if (~isfield(param_strukt, 'kernel'))
   param_strukt.kernel = 'rbf';
end;
% Wenn kein Parameter angegeben wurde, verwende 0.6
if (~isfield(param_strukt, 'kernel_parameter'))
   param_strukt.kernel_parameter = 0.6;
end;
if (~isfield(param_strukt, 'lambda'))
   lambda = [];
else
   lambda = param_strukt.lambda;
end;
if (~isfield(param_strukt, 'algorithmus'))
   param_strukt.algorithmus = 'lp_solve';
end;
if (~isfield(param_strukt, 'max_iter'))
   param_strukt.max_iter = 150;
end;

% Die Daten müssen normiert sein. Das wird hier sichergestellt:
lp_detect = [];
lp_detect.normierung.typ = 2;
[daten, lp_detect.normierung.par1, lp_detect.normierung.par2] = matrix_normieren(daten, lp_detect.normierung.typ);


matlab_toolbox = ~strcmp(param_strukt.algorithmus, 'lp_solve');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erst einmal die Kernel-Matrix zusammenbauen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = size(daten,1);
% Die Kernelmatrix ist eine quadratische Matrix der Größe m x m
K = berechne_kernel_matrix(daten, daten, param_strukt.kernel, param_strukt.kernel_parameter);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETER FÜR DIE LINPROG-FUNKTION ZUSAMMENBAUEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Die eigentliche Funktion sieht so aus:
% W(a,b) = sum_i( sum_j( a_j * K(x_i, x_j) + b) ) + lambda * sum_i(xi_i)
% Die Matlab Linprog Funktion erwartet folgende Form: f' * a
% f entspricht daher hier einem Vektor mit den Spaltensummen von k
f = sum(K, 1);
% Nun fehlt aber noch das b. Das wird am Ende des Vektors angehängt:
f = [f m*m];
% Sollen "weiche" Grenzen verwendet werden?
% Dann muss auch noch lambda als zu optimierend angehängt werden.
if (~isempty(lambda))
   f = [f lambda*ones(1,m)];
end; % if (~isempty(lambda))
% Baue die erste Nebenbedingung zusammen:
% Die Nebenbedingung ist sum_j( a_j * K(x_i, x_j) + b ) >= 0 für alle i,
% bzw. sum_j( a_j * K(x_i, x_j) + b) >= -xi_i für alle i.
% Im Ergebnis wird die Matrix K verwendet plus ein wenig für b
% und evtl. lambda angehängt.
if (isempty(lambda))
   A = -[K m*ones(m, 1)]; nb = zeros(m, 1);
else
   % Die Xi werden in den einzelnen Gleichungen ebenfalls verwendet.
	% Jeweils nur eins pro Zeile, also Einheitsmatrix verwenden:
   A = -[K m*ones(m,1) eye(m)]; nb = zeros(m,1);
end; % if (isempty(lambda
% Baue die zweite Nebenbedingung zusammen:
% Die a_i sollen in der Summe eins ergeben.
Aeq = [ones(1, m) 0]; nbeq = 1;
if (~isempty(lambda))
   % Die Xi spielen in dieser Nebenbedingung keine Rolle.
   % Trotzdem muss der Vektor aufgefüllt werden: mit nullen.
   Aeq = [Aeq zeros(1,m)];
end; % if (~isempty(lambda))

% Nun noch die Grenzen einbauen. Die a_i sollen >= 0 sein, ebenso die xi_i.
% b ist nicht beschränkt
lb = [zeros(1,m) -Inf];
if (~isempty(lambda))
   % Die Xi sollen ebenfalls größer als Null sein.
   lb = [lb zeros(1,m)];
end; % if (~isempty(lambda))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if (~matlab_toolbox)
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% LP_SOLVE-TOOLBOX VERWENDEN:
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % lp_solve hat ein klein wenig ein anderes Format als
   % der Matlab-Optimierer:
   % Hier müssen die zweiten Nebenbedingungen unten angehängt werden und über e mitgeteilt werden,
	% dass es eine Gleichheit ist:
	e = -1*ones(size(A,1),1);
	A = [A; Aeq]; nb = [nb; nbeq];
	e = [e; zeros(size(Aeq,1),1)];
   
   % Die Toolbox verwendet zwei dll-Dateien. Die müssen in ein spezielles Verzeichnis
   % kopiert werden, damit die Funktion funktioniert.
   % Versuche die Funktion auszuführen und bei einem bestimmten Fehler einen Hinweis auf
   % diese Fehlermöglichkeit zu geben.
   try
	   lp = lp_maker(f, A, nb, e, lb, [], [], 0, 1);
		solvestat = mxlpsolve('solve', lp);
		obj = mxlpsolve('get_objective', lp);
      X = mxlpsolve('get_variables', lp);
   catch
      errstr = lasterr; errstr=errstr(1:length(errstr)-1);
      if (strcmp(errstr, 'Failed to initialise lpsolve library.'))
         errordlg(sprintf('Error! lp_solve library not found. Please copy *.dll from the toolbox path in %s\\bin', matlabroot), 'Error', 'modal');
      else
         mywarning('Error in the lp_solve toolbox');
         X=[];
      end;
      return;
   end;
else
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% NUN MATLAB-OPTIMIERUNG AUFRUFEN:
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	options = optimset;
	switch(param_strukt.algorithmus)
	case 'LargeScale'
	   options = optimset(options, 'LargeScale', 'on');
	case 'MediumScale'
	   options = optimset(options, 'LargeScale', 'off');
	otherwise
	   options = optimset(options, 'LargeScale', 'off');
	end; % switch(param_strukt.algorithmus)
	options = optimset(options, 'MaxIter', param_strukt.max_iter);
	[X, X_lambda, EXITFLAG, output] = linprog(f, A, nb, Aeq, nbeq, lb, [], [], options);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUSGABEN VORBEREITEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (matlab_toolbox)
   lp_detect.exitflag = EXITFLAG;
end;
lp_detect.a = X(1:m);
lp_detect.b = X(m+1);
if (~isempty(lambda))
   lp_detect.xi = X(m+2:end);
else
   lp_detect.xi = [];
end;
if (matlab_toolbox)
   lp_detect.algorithmus = output.algorithm;
   lp_detect.iterationen = output.iterations;
else
   lp_detect.algorithmus = 'lp_solve';
end;
lp_detect.kernel = param_strukt.kernel;
lp_detect.kernel_parameter = param_strukt.kernel_parameter;
lp_detect.lerndaten = daten;
lp_detect.lambda = lambda;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%