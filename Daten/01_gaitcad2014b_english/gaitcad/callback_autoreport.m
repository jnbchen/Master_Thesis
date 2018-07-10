% Script callback_autoreport
%
% The script callback_autoreport is part of the MATLAB toolbox Gait-CAD. 
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

switch mode_autoreport 
case 1
   set(gaitfindobj('CE_Show_ShortProtocol'),'value',1);
   eval(gaitfindobj_callback('CE_Show_ShortProtocol'));
   %% Ansicht,  Projektreport 
   eval(gaitfindobj_callback('MI_Projektreport'));
   % TEX-Protokoll
   set(gaitfindobj('CE_Tex_Protokoll'),'value',1);eval(gaitfindobj_callback('CE_Tex_Protokoll'));
   
   parameter.auto_report.subdirectories = 0;
   autoreport(parameter.projekt.pfad,['Project results ' parameter.projekt.datei],parameter, [parameter.projekt.datei '.prjz']);
case 2
   parameter.auto_report.subdirectories = 1;
   filename_report = pwd;
   
   %use the last subdirectory in the name as name for the project
   temp = find(filename_report == filesep);
   if ~isempty(temp)
      filename_report = filename_report(temp(end)+1:end);
   end;
      
   autoreport(parameter.projekt.pfad,['Project results ' filename_report],parameter);
end; 
