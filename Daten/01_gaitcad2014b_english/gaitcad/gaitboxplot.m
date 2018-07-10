  function gaitboxplot(d_org,dorgbez,code,zgf_y_bez,bez_code)
% function gaitboxplot(d_org,dorgbez,code,zgf_y_bez,bez_code)
%
% 
% plots boxplots for all features in d_org for the separate classes in code
% 
% 
%
% The function gaitboxplot is part of the MATLAB toolbox Gait-CAD. 
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

for i_em =  1:size(d_org,2)
   myclasses = unique(code)';
   
   for i_class = 1:length(myclasses)
      value{i_class} = d_org(code == myclasses(i_class),i_em);
      mylength(i_class) = length(value{i_class});
   end;
   
   myvalues = zeros(max(mylength),length(myclasses));
   
   for i_class = 1:length(value)
      myvalues (1:mylength(i_class),i_class) = value{i_class};
      myvalues (mylength(i_class)+1:end,i_class) = NaN;
   end;
   
   if size(d_org,2) == 1
      %nur dann neues Bild zeichnen, wenn Makrooption gewählt - ACHTUNG!!!! geht ein wenig hintenrum
      checkfornewfigure;
   else
      figure;
   end;
   
   % falls je Klasse nur ein Wert
   if size(myvalues,1) == 1
       myvalues = [myvalues;myvalues];
   end
   
   boxplot(myvalues,0);
   
   xlabel(deblank(bez_code));
   
   xtickinfo = {};
   j=1;
   for i=myclasses
      xtickinfo{j} = kill_lz(zgf_y_bez(1,i).name);
      j=j+1;
   end;
   
   %delete all identical information for long names
   if size(xtickinfo,2)>10
      xtickinfo = char(xtickinfo);
      ind = find(all(diff(abs(xtickinfo),1) == 0));
      if ~isempty(ind)
         xtickinfo(:,ind) =[];
      end;
   end;
   set(gca,'xticklabel',xtickinfo,'xtick',1:length(xtickinfo));
   
    
   
   ylabel(deblank(dorgbez(i_em,:)));
   figurename=sprintf('%d: Boxplot %s',get_figure_number(gcf),deblank(dorgbez(i_em,:))');
   set(gcf,'numbertitle','off','name',figurename);
end;



