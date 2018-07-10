  function show_polynom_results(regr_single,parameter,uihd)
% function show_polynom_results(regr_single,parameter,uihd)
%
% 
% 
% 
%
% The function show_polynom_results is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

if parameter.gui.anzeige.tex_protokoll == 1
   datei_name=sprintf('%s_regression_%s_poly.tex',parameter.projekt.datei,regr_single.designed_regression.output_name);
else
   datei_name=sprintf('%s_regression_%s_poly.txt',parameter.projekt.datei,regr_single.designed_regression.output_name);
end;

f=fopen(datei_name,'wt');
if ~isempty(uihd) 
   prottail=protkopf(f,uihd,parameter.gui.anzeige.tex_protokoll,parameter.projekt.datei,'Polynomial regression model',1);
end;

fprintf(f,'\nPolynomial model:\n\n%s =\n',deblank(regr_single.designed_regression.output_name));
fprintf(f,'%+-g\n',regr_single.polynom.phi_m_korr(1));

for i=2:length(regr_single.polynom.phi_m_korr) 
   %Koeffizeint * Merkmal
   temp_string = sprintf('%+-g * (%s)',regr_single.polynom.phi_m_korr(i),...
      deblank(regr_single.merkmalsextraktion.var_bez(regr_single.polynom.feature_description(i-1,1),:)));
   
   %Polynom-Exponent
   if regr_single.polynom.feature_description(i-1,2)>1
      temp_string = strcat(temp_string,sprintf('^%d',regr_single.polynom.feature_description(i-1,2)));
   end;
   
    
   fprintf(f,'%-100s (|R (%2d feature(s))| = %0.3f) \n',temp_string,i-1,regr_single.merk_archiv.merk_selection(i-1));
end;

fprintf(f,'\n\nParameters for the protocol generation (not for polynomial models!):\n');

fprintf(f,'%s',prottail);
fclose(f);
viewprot(datei_name);















