  function [string,info,callback]=callback_umbenennen_teil1
% function [string,info,callback]=callback_umbenennen_teil1
%
% Funktionshierarchie:
% Teil 1: statische Fensterdefinition und Platzhalter
% Teil 2: Callbacks für dynamisches Fensterausfüllen vorbereiten
% Teil 3 (ok): Was passiert beim Ausführen?
% 
% Was kann man alles umbenennen - nur leichte Unterschiede in den Bezeichnungen, aber gleiche Nummerierung!
%
% The function callback_umbenennen_teil1 is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

tmp=poplist_popini(char('Single feature','Linguistic term of single feature','Output variable','Linguistic term of output variable (class)','Time series'));


string(1,1:length(tmp))=tmp;
tmp='Rename  resp. change';info(1,1:length(tmp))=tmp;

tmp=' ';string(2,1:length(tmp))=tmp;
tmp='Selected Object (1)';info(2,1:length(tmp))=tmp;

tmp=' ';string(3,1:length(tmp))=tmp;
tmp='Selected Object (2)';info(3,1:length(tmp))=tmp;

tmp=' ';string(4,1:length(tmp))=tmp;
tmp='Selected Object (3)';info(4,1:length(tmp))=tmp;

tmp=' ';string(5,1:length(tmp))=tmp;
tmp='New name resp. value';info(5,1:length(tmp))=tmp;

callback='callback_umbenennen_ok;';




