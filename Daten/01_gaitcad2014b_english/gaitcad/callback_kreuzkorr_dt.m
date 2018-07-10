% Script callback_kreuzkorr_dt
%
% 
%  Parameter festlegen
%
% The script callback_kreuzkorr_dt is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

params.plot = parameter.gui.anzeige.figures_korr;
params.mean = mode;

params.coeffs = 0;
params.tau = 0;
params.ta = 1/parameter.gui.zeitreihen.abtastfrequenz;
params.scaling_type = parameter.gui.statistikoptionen.scaleopt_type_text;

% Welche Datentupel?
ind_dt1=get(figure_handle(2,1),'value');
ind_dt2=get(figure_handle(3,1),'value');

% Die Rückgabe wird hier in der Regel ausgeschaltet. Dann ist die Rückgabe leer.
params.ausgabe = parameter.gui.anzeige.par_korr;
kkfs = kreuzkorr_dt(d_orgs(:,parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende,:), [ind_dt1(1), ind_dt2], parameter.gui.merkmale_und_klassen.ind_zr, params);

