% Script callback_matlab_parallel
%
% mode 2 only returns size of matlabpool
% 
% exist question for gcp depends on MATLAB version - exist only from MATLAB
% 2013b, matlabpool generates a warning in MATLAB 2014a and will be invalid
% in later versions
% 
%
% The script callback_matlab_parallel is part of the MATLAB toolbox Gait-CAD. 
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

switch mode
   case 1
      %starts MATLAB worker pool
      if exist('gcp','file')
         %new MATLAB
         if  isempty(gcp('nocreate'))
            try
               gcp;
            catch
               myerror('Error during starting MATLAB worker pool!');
            end;
         else
            mywarning('MATLAB Worker Pool was already started!');
         end;
      else
         %old MATLAB
         if  matlabpool('size') == 0
            try
               matlabpool(parameter.gui.allgemein.parallel_configuration);
            catch
               myerror('Error during starting MATLAB worker pool!');
            end;
         else
            mywarning('MATLAB Worker Pool was already started!');
         end;
      end;
   case 0
      if exist('gcp','file')
         %new MATLAB
         delete(gcp('nocreate'));
      else
         %old MATLAB
         matlabpool('close');
      end;
      parameter.allgemein.parallel = 0;
end;
if exist('gcp','file')
   %new MATLAB
   parameter.allgemein.parallel = ~isempty(gcp('nocreate'));
else
   %old MATLAB
   parameter.allgemein.parallel = matlabpool('size');
end;