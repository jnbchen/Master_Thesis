% Script callback_frequencyhitlist
%
% 
% list of the most dominant frequencies
%
% The script callback_frequencyhitlist is part of the MATLAB toolbox Gait-CAD. 
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

[tmp,ind_freq] = sort(-lastfft.fc);
ind_freq=sort(ind_freq((1:min(parameter.gui.anzeige.ffthitliste,length(ind_freq)))));

%names for frequency features
var_freq = num2str(lastfft.f(ind_freq),'%01g');
einheit.frequenz = [' ' char(parameter.gui.zeitreihen.einheit_abtastfrequenz_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz))];
var_freq = strcat(var_freq,einheit.frequenz); 

%name for protocol file
f_prot_name = [parameter.projekt.datei 'fft_hitlist.tex'];
f_prot = fopen(f_prot_name,'wt');

%list for predefined frequencie segments (from variable freqlist) 
if exist('freqlist','var') 
  
   fprintf(f_prot,'\n\nAbsolute signal ratio (in percent):\n\n');
   
   %overtones 
   for i_freq=1:length(freqlist.multiples)
      
      %overtone frequencies n*f +- ftol
      ind_list     = find( abs( rem(lastfft.f+ freqlist.multiples(i_freq).ftol,freqlist.multiples(i_freq).f)< 2*freqlist.multiples(i_freq).ftol)  );
      
      %neighboring zone of overtone frequencies n*f + [1-2]*ftol  and  n*f - [1-2]*ftol   
      ind_neighbor = find( abs( rem(lastfft.f+2*freqlist.multiples(i_freq).ftol,freqlist.multiples(i_freq).f)<4*freqlist.multiples(i_freq).ftol) & ... % Coderevision: &/| checked!
         abs( rem(lastfft.f+ freqlist.multiples(i_freq).ftol,freqlist.multiples(i_freq).f) >2*freqlist.multiples(i_freq).ftol)    );
      
      %ratios overtones/neighbors
      freqlist.multiples(i_freq).factor  = sum(lastfft.fc(ind_list))/length(ind_list)/sum(lastfft.fc(ind_neighbor))*length(ind_neighbor);
      
      %ratios overtones/all
      freqlist.multiples(i_freq).part    = 100*sum(lastfft.fc(ind_list))/sum(lastfft.fc);
      
      %protocol
      temp_name = sprintf('%s ( %g +- %g %s)', freqlist.multiples(i_freq).name,freqlist.multiples(i_freq).f, freqlist.multiples(i_freq).ftol,einheit.frequenz);
      fprintf(f_prot,'%-50s: %2.2f', temp_name,freqlist.multiples(i_freq).part);
      fprintf(f_prot,' Amplitude amplification factor (1: no amplification): %g\n\n', freqlist.multiples(i_freq).factor);
   end;
   
   %segments
   for i_freq=1:length(freqlist.segments)
      %designated segment
      ind_list     =  find( lastfft.f >=freqlist.segments(i_freq).f(1) & ...     % Coderevision: &/| checked!
         lastfft.f <=freqlist.segments(i_freq).f(2) );
      %ratio
      freqlist.segments(i_freq).part    = 100*sum(lastfft.fc(ind_list))/sum(lastfft.fc);
      %protocol
      temp_name = sprintf('%s (%g-%g %s)', freqlist.segments(i_freq).name,freqlist.segments(i_freq).f,einheit.frequenz);
      fprintf(f_prot,'%-50s: %2.2f\n\n', temp_name,freqlist.segments(i_freq).part);
   end;   
end;

%show list 
merk_report(100*lastfft.fc(ind_freq)'/sum(lastfft.fc),var_freq,parameter.gui.anzeige.ffthitliste,...
   f_prot,'FFT dominant frequencies (percentage signal)',0,mode,[],uihd,[],ind_freq);

%report
fclose(f_prot);
viewprot(f_prot_name);

clear einheit temp_name ind_list ind_neighbor f_prot_name f_prot ind_freq var_freq i_freq

