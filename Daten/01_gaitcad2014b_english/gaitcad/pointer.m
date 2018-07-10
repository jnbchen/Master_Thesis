  function pointer(nr,text)
% function pointer(nr,text)
%
% setzt Mauszeiger fuer Fenster 1 auf
% nr=1 - Pfeil
% nr=2 - Uhr
%
% The function pointer is part of the MATLAB toolbox Gait-CAD. 
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

f=gcf;
figure(1);
if (nr==1) 
   set(1,'Pointer','arrow');
   title('STATE: Waiting for user action');
   set(1,'HitTest','on');
end;
if (nr==2) 
   set(1,'Pointer','watch');
   if (nargin==2) 
      title(sprintf('STATE: %s',text));
   end;
   set(1,'HitTest','off');
end;
if (nr == 3)
   evalin('base', 'disp(lasterr)');
   set(1, 'Pointer', 'arrow');
   title('State: Error by processing a function');
   set(1, 'HitTest', 'on');
end;
set(0,'PointerLocation',get(0,'PointerLocation'));
figure(f);
drawnow;


 