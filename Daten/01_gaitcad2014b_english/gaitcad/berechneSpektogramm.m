  function spect = berechneSpektogramm(d_orgs, param, anzeige, var_bez, ind_bez, fig_handle, spect)
% function spect = berechneSpektogramm(d_orgs, param, anzeige, var_bez, ind_bez, fig_handle, spect)
%
% Berechnet die Spektogramme der übergebenen Daten.
% Eingaben:
% d_orgs: Daten, für die Spektogramm berechnet werden soll (Größe: #Datentupel x #Samplepunkte x #Zeitreihen)
% param: Parameterstrukt mit folgenden Feldern:
%    param.fA (zwingend)
%    param.fensterLaenge (default: 64)
%    param.farbwerte_verteilen (default: 0) nutzt den kompletten Farbraum
%    param.colormap  (default: 1=Jet) (für Indizes siehe erzeugeColormap)
%    param.kennlinie_art (default: 1) 1=Linear, 2=Wurzel, 3=umg. Exponentiell
%    param.kennlinie_parameter (default: 1) Parameter für die Kennlinie
%    param.kennlinie_anzeigen (default: 0) zeigt verwendete Kennlinie an
%    param.kennlinie_name Wird fürs Plotten verwendet. Sonst siehe kennlinie_art
%    param.colorbar_anzeigen (default: 0)
%  param.caxis (default []) begrenzt die Farbskala auf caxis(1) caxis(2)
% anzeige: Spektogramme plotten: 1, Spektogramme nicht plotten: 0, nur plotten: -1 (spect darf dann nicht leer sein!)
%    default: 0
% var_bez: Bezeichner der Zeitreihen, default: []
% ind_bez: Bezeichner der Datentupel (nur für Anzeige), default: []
% fig_handle: Soll in eine spezielle figure geplottet werden, kann das Handle hier übergeben werden
% spect: Soll ein altes Ergebnis nur noch einmal angezeigt werden, kann spect übergeben werden.
% Rückgabe:
% spect: Cell-Array der Größe #Datentupel x #Zeitreihen x 3 (Betrag des Spektogramms, Frequenzen, Zeit)
%
% The function berechneSpektogramm is part of the MATLAB toolbox Gait-CAD. 
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

if(~isfield(param, 'fA'))
    error('Unknown sampling frequency! Function canceled!');
end;

if (nargin < 3)
    anzeige = 0;
end;
if (nargin < 4)
    var_bez = [];
end;
if (nargin < 5)
    ind_bez = [];
end;
if (nargin < 6)
    fig_handle = 0;
end;
if (nargin < 7)
    spect = [];
end;

if (anzeige >= 0)
    spect = cell(size(d_orgs,1), size(d_orgs, 3), 3);
end;

% Erst mal die Parameter sammeln:
abtastFrequenz = param.fA;
if (~isfield(param, 'fensterLaenge'))
    fensterLaenge = 64;
else
    fensterLaenge 	= param.fensterLaenge;
end;
if (~isfield(param, 'phasengang'))
    param.phasengang = 0;
end;

if (~isfield(param, 'korr_freqs'))
    param.korr_freqs = 0;
end;

% Kann zwar eigentlich nicht passieren, aber trotzdem lieber abfragen.
if (~isempty(d_orgs) && fensterLaenge >= size(d_orgs,2))
    warning('The windows size to compute the spectrogram is larger than the number of sample points in the project');
    fensterLaenge = 2^floor(log2(size(d_orgs,2)));
end;

if (anzeige >= 0)
    anz_ds = size(d_orgs,1);
    anz_zr = size(d_orgs,3);
else
    anz_ds = size(spect, 1);
    anz_zr = size(spect, 2);
end;

for i = 1:anz_ds
    for j = 1:anz_zr
        if (size(spect{i, j, 2}, 2) > 1)
            spect{i, j, 2} = spect{i, j, 2}';
        end;
        if (size(spect{i, j, 3}, 2) > 1)
            spect{i, j, 3} = spect{i, j, 3}';
        end;
        
        % soll berechnet werden oder das Spektogramm exisitert nicht?
        if (anzeige >= 0)
            [spect{i,j,1},spect{i,j,2},spect{i,j,3}] = specgram(squeeze(d_orgs(i, :, j)),fensterLaenge,abtastFrequenz);
            if param.phasengang
                myphase = angle(spect{i,j,1}(1:end,:));
                spect{i,j,4} = (myphase-min(min(myphase)))./(max(max(myphase))-min(min(myphase)));
            else
                spect{i,j,4} =[];
            end;
            spect{i,j,1} = abs(spect{i,j,1}(1:end,:));
            % Spektrogramm auf [0,1] normieren.
            spect{i,j,1} = (spect{i,j,1}-min(min(spect{i,j,1})))./(max(max(spect{i,j,1}))-min(min(spect{i,j,1})));
            spect{i,j,2} = spect{i,j,2}(1:end);
            
            %Zeitverschiebung berücksichtigen
            spect{i,j,3} = spect{i,j,3} + param.zeitverschiebung;
        end; % if (anzeige > 0)
        
        % Spektogramm anzeigen?
        if (anzeige ~= 0)
            if (isempty(ind_bez))
                ind_bezeichner = [];
            else
                ind_bezeichner = deblank(ind_bez(i,:));
            end;
            if (isempty(var_bez))
                var_bezeichner = [];
            else
                var_bezeichner = deblank(var_bez(j,:));
            end;
            show_spectrogram({spect{i,j,:}},param,fig_handle,ind_bezeichner,var_bezeichner);
        end; % if (anzeige ~= 0)
    end; % for(j = 1:size(d_orgs,3))
end; % for(i = 1:size(d_orgs,1))

