  function [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,newcodename,newtermname)
% function [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,newcodename,newtermname)
%
% hängt neue Ausgangsklasse an
% spezielle Eingangsvariable:
% newcode:      Klassenwerte für neue Ausgangsgröße
% newcodename:  Name für neue Ausgangsgröße
% newtermname:  Name für Terme der neuen Ausgangsgröße (optional)
%
% The function new_output is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<7) 
   newtermname=[];
end;

%Klassenwerte für alle Datentupel anhängen
anz_newclass=max(max(newcode),length(newtermname));
code_alle(:,end+1)=newcode;

%Name Ausgangsklasse anhängen
bez_code=char(bez_code,newcodename);

%Termnamen für neue Ausgangsklasse
if isempty(newtermname)
   for i=1:anz_newclass 
      newtermname(i).name=sprintf('%s %d',newcodename,i);
   end;
end;
zgf_y_bez(end+1,1:anz_newclass)=newtermname;

%Korrektur Entscheidungstheorie
if isfield(L,'ld_alle')  
   L.ld_alle(end+1).ld=ones(anz_newclass,anz_newclass)-eye(anz_newclass);
end;

par.anz_ling_y = max(code_alle);
repair_outputterms;



