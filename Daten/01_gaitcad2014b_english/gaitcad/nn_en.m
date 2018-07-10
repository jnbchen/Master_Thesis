  function [net, net_param] = nn_en(d, code, net_param)
% function [net, net_param] = nn_en(d, code, net_param)
%
%  net_param.norm = 1;
%  net_param.neurperclass =1;
%  net_param.norm_param = [];
%  net_param.mlp.layer =15;
%  net_param.rbf.spreizung = 10;
%  net_param.rbf.err_goal = 5;
%  net_param.type= 1;      1: MLP, 2:RBF
% 
%
% The function nn_en is part of the MATLAB toolbox Gait-CAD. 
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

if nargin < 3
    neurperclass=1; 		% Ausgangsneuron für jede Klasse
    net_param.norm=1;
    spreizung=1;
    type=1;
    layer=12;
    lernalg     = 'trainlm';
    neur_layer1 = 'tansig';
    eingangswichtung='dotprod';
    eingangsfunktion='netsum';
    lernepochen  	= 20;
    mlp_zeichnen_details    = 0;
    net_param.mlp.internal_stepwidth = 10;
    net_param.minimal_gradient  = 1E-10;
    net_param.trainParam.mu_max = 1E100;
else
    neurperclass	     = net_param.neurperclass;
    spreizung		     = net_param.rbf.spreizung;
    type				 = net_param.type;
    layer				 = net_param.mlp.layer;
    lernalg              = net_param.mlp.lernalg;
    mlp_zeichnen_details = net_param.mlp.zeichnen;
          
    ind_left  = find( net_param.mlp.lernalg =='(');
    ind_right = find( net_param.mlp.lernalg ==')');
    if length(ind_left)~=1 ||length(ind_right)~=1
        myerror(sprintf('Invalid training method %s',net_param.mlp.lernalg));
    else
        lernalg = net_param.mlp.lernalg(ind_left+1:ind_right-1);
    end;
    
    
    neur_layer1     =net_param.mlp.neur_layer1;
    eingangswichtung=net_param.mlp.eingangswichtung;
    eingangsfunktion=net_param.mlp.eingangsfunktion;
    lernepochen     = net_param.mlp.lernepochen;
    net_param.minimal_gradient  = 1E-10;
    net_param.trainParam.mu_max = 1E100;
    
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Train Artificial Neural Networks ...\n')
num_class=max(code);

%Änderung Ralf: neuronale Netze mit einem Ausgangsneuron
%brauchen in der Anwendungsphase die Anzahl Klassen, um prz auszurechnen
net_param.num_class=num_class;

% Wenn für jede Klasse ein eigenes Ausgangsneuron zur Verfügung stehen soll
if neurperclass==1
    newcode=zeros(num_class, length(code));
    for i = 1: length(code)
        newcode(code(i),i)=1;
    end;
    code= newcode';
    if type==1
        layer=[layer num_class];
    end; % Nur für MLP, Anzahl Ausgangsneuronen hinzufügen
else
    layer=[layer 1];
end;

% Wenn Eingangsdaten normiert werden sollen.
if net_param.norm == 1
    norm_param.sub=min(d);
    norm_param.denum=max(d)-min(d);
    norm_param.denum(find(norm_param.denum==0))=1;		% Wenn keine Abweichung in Merkmal vorhanden
    net_param.norm_param=norm_param;
end;

% Anlernen in Abh. von der Art des gewählten Netzes
% MLP anlernen
switch type
    case {1,3}
        % neues MLP oder FeedForwardNetz generieren
        
        %WARNING Warning: NEWFF used in an obsolete way.
        %In nntobsu at 18
        %depends on incompatible argument lists for NN toolbox depending on
        %version
        %needs an internal version check!!
        switch type
            case 1
                net=newff([minmax(d')],layer,{neur_layer1,'purelin'},lernalg);
                % Initialisieren
                net=init(net);
                
                net.inputWeights{1}.weightFcn=eingangswichtung;
                net.layers{1}.netInputFcn=eingangsfunktion;
                
            case 3
                net = feedforwardnet(layer(1)*ones(1,net_param.mlp.number_of_layers),lernalg);
                
                %initialization with one period of training
                net.trainParam.epochs = 1;
                net.trainParam.showWindow = logical(net_param.showWindow);
                net=train(net,d',code');
        end;
        
        
        % Trainieren (mit dem gesamten Datensatz, sonst "learn" anstatt "train"
        net.trainParam.goal       = net_param.goal;
        net.trainParam.min_grad   = net_param.minimal_gradient;
        if isfield(net.trainParam,'mu_max')
           net.trainParam.mu_max     = net_param.trainParam.mu_max;
        end;
        net.trainParam.epochs     = net_param.mlp.lernepochen;
        net.trainParam.show       = Inf;
        net.trainParam.showWindow = logical(net_param.showWindow);
        
        %spezielle Anzeige - geht nur für Regression!!!
        
        if mlp_zeichnen_details == 1
            figure_output        = figure;
            %f_ann_iteration = [];
            
            set(figure_output,'position',get(1,'position')+[10 0 0 0]);
            
            
            lernepochen = ceil(lernepochen/net_param.mlp.internal_stepwidth);
            net.trainParam.epochs   = net_param.mlp.internal_stepwidth;
            
            ehist = zeros(lernepochen,1);
            
            whist = [];
            
            for i_lernepochen=1:lernepochen
                
                % Training wird in jeder Iterationen gestoppt zur Ergebnisausgabe
                figure(figure_output);
                
                ynn=sim(net,d');
                ehist(i_lernepochen)=1/size(code,1)*norm(code'-ynn,2);  % mittlerer quadratischer Fehler
                
                % Darstellung der Lerndaten
                subplot(2,4,1);
                plot(d(:,1),code,'r+');
                hold on;
                
                % Darstellung Netzausgang
                plot(d(:,1),ynn,'go');
                ylabel('y,y_{est}');
                xlabel('x');
                hold off;
                title('y_{est}=f(x)');
                
                % Darstellung des Fehlers
                subplot(2,4,5);
                plot(ynn-code','.');
                xlabel('Number of data set');
                ylabel('Error');
                
                subplot(2,4,2);
                plot(ynn,code','r.');
                xlabel('y');
                ylabel('y_{est}');
                hold off;
                title('x-y Plot');
                ax=axis;
                axis([min(ax([1 3])) max(ax([2 4])) min(ax([1 3])) max(ax([2 4])) ]);
                
                
                % Darstellung der Parameterhistorie
                subplot(2,4,4);
                w1=net.IW{1,1};
                b1=net.b{1,1};
                w2=net.LW{2,1};
                b2=net.b{2,1};
                if isempty(whist) 
                    temp_length = length([w1(:)' w2(:)' b1(:)' b2(:)']);
                    whist        = zeros(lernepochen, temp_length);
                end;
                whist(i_lernepochen,:)=[w1(:)' w2(:)' b1(:)' b2(:)'];
                plot([0:i_lernepochen-1]*net.trainParam.epochs,whist(1:i_lernepochen,:));
                title(sprintf('%d Net parameters ',size(whist,2)));
                xlabel('Iterations No.');
                ylabel('Net parameter');
                
                subplot(2,4,8);
                plot_mlp(net,0);
                
                % Darstellung der Fehlerhistorie
                subplot(2,4,3);
                semilogy([0:i_lernepochen-1]*net.trainParam.epochs,ehist(1:i_lernepochen,:)');
                title('Error');
                xlabel('Iterations No.');
                ylabel('MSE');
                
                % Training des MLP
                subplot(2,4,7);
                
                [net,tr_temp]=train(net,d',code');
                
                %Ende wegen erreichtem Fehlerziel
                if tr_temp.perf(end)<=net_param.goal
                    break;
                end;
                
                
                %bei BPX-Lernen die Lernrate merken
                if strcmp(lernalg,'traingdx')
                    net.trainParam.lr=tr_temp.lr(length(tr_temp.lr));
                end;
                set(gcf,'numbertitle','off','name',sprintf('%d: Intermediate results Artificial Neuronal Net',get_figure_number(gcf)));
            end;
        else
            net=train(net, d', code');
            
        end;
        
        
    case 2
        % RBF anlernen
        %net=newrbe(d',code',spreizung);	% variiert die Anzahl der Neuronen, bis 100% ueber Lerndaten erreicht sind
        net=newrb(d',code',net_param.goal,spreizung,net_param.mlp.layer);	% variiert die Anzahl der Neuronen, bis 100% ueber Lerndaten erreicht sind
        % 	net=newpnn(d',code',spreizung);	% variiert die Anzahl der Neuronen, bis 100% ueber Lerndaten erreicht sind
        
        
end;


