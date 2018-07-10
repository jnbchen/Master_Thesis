  function display_filter_bode(parameter,plugins)
% function display_filter_bode(parameter,plugins)
%
% 
% plots the Bode diagram for the recently selected filter parameters of plugin_filter
% 
%
% The function display_filter_bode is part of the MATLAB toolbox Gait-CAD. 
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

try
   %Plugin with the filter
   ind_filter = find(ismember(plugins.mgenerierung_plugins.funktionsnamen,'plugin_filter','rows'));
   
   %localize filter type
   ind_filtertyp = find(ismember(plugins.mgenerierung_plugins.info(ind_filter).commandline.description,'Filter type')); 
   filtertyp = plugins.mgenerierung_plugins.info(ind_filter).commandline.parameter_commandline{ind_filtertyp};
   
   %localize frequencies
   ind_frequenzen = find(ismember(plugins.mgenerierung_plugins.info(ind_filter).commandline.description,'Frequencies')); 
   filterfreq = plugins.mgenerierung_plugins.info(ind_filter).commandline.parameter_commandline{ind_frequenzen};
   
   %localize degree of the filter
   ind_filterordnung = find(ismember(plugins.mgenerierung_plugins.info(ind_filter).commandline.description,'Filter order (FIL)')); 
   filterordnung = plugins.mgenerierung_plugins.info(ind_filter).commandline.parameter_commandline{ind_filterordnung};
   
   if (filtertyp == 3)
      wn = 2*filterfreq ./ parameter.gui.zeitreihen.abtastfrequenz;
   else
      wn = 2*filterfreq(1) ./ parameter.gui.zeitreihen.abtastfrequenz;
   end;
   
   if (filtertyp == 1)
      [B, A] = butter(filterordnung, wn, 'high');
   else
      [B, A] = butter(filterordnung, wn);
   end;
   
   fprintf('Polynom A (discrete time):\n');
   disp(A);
   
   fprintf('Roots A (discrete time):\n');
   disp(roots(A));
   
   fprintf('Absolute values roots A (discrete time):\n');
   disp(abs(roots(A)));
   

   fprintf('Polynom B (discrete time):\n');
   disp(B);


   % 
   [bc,ac] = d2cm(B,A,1/parameter.gui.zeitreihen.abtastfrequenz);
   
   fprintf('Polynom A (continuous time):\n');
   disp(ac);
   
   fprintf('Roots A (continuous time):\n');
   disp(roots(ac));
   
   fprintf('Polynom B (continuous time):\n');
   disp(bc);

   figure;
   bode(tf(bc,ac));
   
   figurename = sprintf('%d: Bode plot filter',get_figure_number(gcf));
   set(gcf,'numbertitle','off','name',kill_lz(figurename));
   
   %correct label for selected frequency
   temp_string =    get(get(gca,'xlabel'),'string');  
   temp_string = strrep(temp_string,'/sec',strcat('/',parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)));
   set(get(gca,'xlabel'),'string',temp_string);

catch
   myerror('Error for the visualization of filter parameters.');
end;


