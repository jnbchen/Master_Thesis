  function fitensemble_system=fitensemble_en(d,code,parameter_fitensemble)
% function fitensemble_system=fitensemble_en(d,code,parameter_fitensemble)
%
% 
%  function fitensemble_system=fitensemble_en(d,code,parameter_fitensemble)
% 
%  
%  
%       
% 
%  Die Funktion fitensemble_en ist Teil der MATLAB-Toolbox Gait-CAD. 
%  Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]
% 
% 
%  Letztes Änderungsdatum: 28-Apr-2014 18:36:15
%  
%  Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU General Public License,
%  wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, 
%  entweder gemäß Version 2 der Lizenz oder jeder späteren Version.
%  
%  Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, dass es Ihnen von Nutzen sein wird,
%  aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder 
%  der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK.
%  Details finden Sie in der GNU General Public License.
%  
%  Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm erhalten haben.
%  Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
%  
%  Weitere Erläuterungen zu Gait-CAD finden Sie in der beiliegenden Dokumentation oder im folgenden Konferenzbeitrag:
%  
%  MIKUT, R.; BURMEISTER, O.; BRAUN, S.; REISCHL, M.: The Open Source Matlab Toolbox Gait-CAD and its Application to Bioelectric Signal Processing.  
%  In:  Proc., DGBMT-Workshop Biosignal processing, Potsdam, pp. 109-111; 2008 
%  Online verfügbar unter: https://sourceforge.net/projects/gait-cad/files/mikut08biosig_gaitcad.pdf/download
%  
%  Bitte zitieren Sie diesen Beitrag, wenn Sie Gait-CAD für Ihre wissenschaftliche Tätigkeit verwenden.
% 
%
% The function fitensemble_en is part of the MATLAB toolbox Gait-CAD. 
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

fitensemble_system = fitensemble(d,code,parameter_fitensemble.method,parameter_fitensemble.NLearn,parameter_fitensemble.Learners);


