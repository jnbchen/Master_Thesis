  function [fehl_proz,fehl_kost,konf_test,relevanz_klass]=protokoll_crossvalidierung(code,pos,relevanz_cv_alle,versuch_cv,versuch_cv_nr,anz_cv,anz_cv_nr,automatik,par,L,texprotokoll,f_cv,type,feature_aktiv,evidenz_aktiv,var_bez)
% function [fehl_proz,fehl_kost,konf_test,relevanz_klass]=protokoll_crossvalidierung(code,pos,relevanz_cv_alle,versuch_cv,versuch_cv_nr,anz_cv,anz_cv_nr,automatik,par,L,texprotokoll,f_cv,type,feature_aktiv,evidenz_aktiv,var_bez)
%
% The function protokoll_crossvalidierung is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<14
    feature_aktiv=[];
end;
if nargin<15
    evidenz_aktiv=0;
end;
if nargin<16
    var_bez=[];
end;

%anz_cv=0 kodiert Bootstrap!!
if anz_cv_nr>0
    validierungsstring=sprintf('%d-fold cross-validation',anz_cv);
else
    validierungsstring='Bootstrap validation';
end;


%Teilprotokoll - nur eine Crossvalidierung
if (type==1)
    [konf_test,fehl_proz,fehl_kost,feat_kost,relevanz_klass]=klass9([],code,pos,zeros(size(pos,1),par(4)),0,1,0,0,[],[],L,feature_aktiv,evidenz_aktiv);
    ha=msgbox(sprintf('%s %d of %d: %g %% Errors, Cost: %g',validierungsstring,versuch_cv_nr,versuch_cv,fehl_proz,fehl_kost),validierungsstring,'replace');
    if ~texprotokoll
        fprintf(f_cv,'Confusion matrix %s - Total result:\n',validierungsstring);
        [konf_cv,fehl_proz,fehl_kost]=klass9([],code,pos,zeros(size(pos,1),par(4)),0,f_cv,0,0,[],[],L,feature_aktiv,evidenz_aktiv);
    else
        if versuch_cv_nr==1
            fprintf(f_cv,'\\clearpage\n\\subsection{Evaluation}\n');
        else
            fprintf(f_cv,'%d. Data set:\n\n',versuch_cv_nr);
        end;
        if ~automatik
            fprintf(f_cv,'\nConfusion matrix training data (error training data:  %5.2f \\%%) \n',fehl_proz);
            m_to_tex(konf_test,'d',f_cv,'C');
            if ~isempty(L)
                fprintf(f_cv,'\nCosts for confusion matrix test data:  %5.2f\n)',fehl_kost);
            end;
        end; %automatik
    end; %texprotokoll
    %Box wieder wegräumen
    if (versuch_cv==versuch_cv_nr)
        close(ha);
    end;
end; %type1


%Gesamtprotokoll über alle Crossvalidierungen
if (type==2) || (type == 3)
    %Parallelausgabe auf Bilschirm und in Datei
    fanz=[f_cv 1];
    if (type == 2)
        fboth(fanz,'\nTotal result %s with %d trials:\n\nPercent error:   ',validierungsstring,versuch_cv);
    end;
    if (type == 3)
        fboth(fanz,'\nTotal result %s for all %d trials:\n\n',validierungsstring,versuch_cv);
        fboth(fanz,'\nError:  ');
    end;
    if (texprotokoll)
        fprintf(f_cv,'\n');
    end;
    fboth(fanz,'%4.3f ',relevanz_cv_alle.fehl_proz_alle);
    fboth(fanz,'\n\nMean         :   %6.3f \n',mean(relevanz_cv_alle.fehl_proz_alle));
    if (texprotokoll)
        fprintf(f_cv,'\n');
    end;
    fboth(fanz,'Standard deviation :   %6.3f \n',std(relevanz_cv_alle.fehl_proz_alle));

    if (type == 3)
        fboth(fanz,'\nCorrelation coefficient:');

        if (texprotokoll)
            fprintf(f_cv,'\n');
        end;
        fboth(fanz,'%4.3f ',relevanz_cv_alle.fitness_corrcoef);
        fboth(fanz,'\n\nMean         :   %6.3f \n',mean(relevanz_cv_alle.fitness_corrcoef));
        if (texprotokoll)
            fprintf(f_cv,'\n');
        end;
        fboth(fanz,'Standard deviation :   %6.3f \n',std(relevanz_cv_alle.fitness_corrcoef));
    end;


    if ~isempty(L) && isfield (relevanz_cv_alle,'fehl_kost_alle')
        fboth(fanz,'\n\nMisclassification costs:   ');
        if (texprotokoll)
            fprintf(f_cv,'\n');
        end;
        fboth(fanz,'%4.3f ',relevanz_cv_alle.fehl_kost_alle);
        fboth(fanz,'\n\nMean         :   %6.3f \n',mean(relevanz_cv_alle.fehl_kost_alle));
        if (texprotokoll)
            fprintf(f_cv,'\n');
        end;
        fboth(fanz,'Standard deviation :   %6.3f \n',std(relevanz_cv_alle.fehl_kost_alle));

        % Ab hier Protokollierung Merkmlaskosten
        if isfield(relevanz_cv_alle,'feat_kost_alle')
            fboth(fanz,'\n\nFeature costs:   ');
            if (texprotokoll)
                fprintf(f_cv,'\n');
            end;
            fboth(fanz,'%4.3f ',relevanz_cv_alle.feat_kost_alle);
            fboth(fanz,'\n\nMean         :   %6.3f \n',mean(relevanz_cv_alle.feat_kost_alle));
            if (texprotokoll)
                fprintf(f_cv,'\n');
            end;
            fboth(fanz,'Standard deviation :   %6.3f \n',std(relevanz_cv_alle.feat_kost_alle));

            fboth(fanz,'\n\nTotal costs per decision:   ');
            if (texprotokoll)
                fprintf(f_cv,'\n');
            end;
            fboth(fanz,'%4.3f ',relevanz_cv_alle.gesamt_kost_alle);
            fboth(fanz,'\n\nMean         :   %6.3f \n',mean(relevanz_cv_alle.gesamt_kost_alle));
            if (texprotokoll)
                fprintf(f_cv,'\n');
            end;
            fboth(fanz,'Standard deviation :   %6.3f \n',std(relevanz_cv_alle.gesamt_kost_alle));
        end; % isfield(relevanz_cv_alle,'feat_kost_alle')
    end; %if L

    %Protokollierung der Anzahl Ebenen bei hierarchischer Klassifikation:
    if isfield(relevanz_cv_alle,'anz_ebene')
        fboth(fanz,'\n\nNumber of levels:   ');
        if (texprotokoll)
            fprintf(f_cv,'\n');
        end;
        fboth(fanz,'%4.3f ',relevanz_cv_alle.anz_ebene);
        fboth(fanz,'\n\nMean         :   %6.3f \n',mean(relevanz_cv_alle.anz_ebene));
        if (texprotokoll)
            fprintf(f_cv,'\n');
        end;
        fboth(fanz,'Standard deviation :   %6.3f \n',std(relevanz_cv_alle.anz_ebene));
    end;

    % Protokollierung der Verwendng der einzelnen Merkmale
    if (isfield(relevanz_cv_alle,'feature_aktiv_alle')) && ~isempty(var_bez)
        [ftmp,ind]=sort(-mean(relevanz_cv_alle.feature_aktiv_alle,1)/anz_cv);
        if (texprotokoll)
            fprintf(f_cv,'\n');
            texprot.kopf=sprintf('Feature&Frequency');
            texprot.name='Frequency of used features from cross-validation';
            texprot.tabtext='';
            for i=find((-ftmp)>0)
                texprot.tabtext=sprintf('%s %s & %g\n',texprot.tabtext,var_bez(ind(i),:),-ftmp(i));
            end;
            textable(texprot.kopf,texprot.tabtext,texprot.name,f_cv,0,'merkmale');
            fprintf(f_cv,'\n');
        end;
        tmp=sprintf('\n\nMean usage of features in multiple  trials:   ');
        fprintf(1,'%s \n',tmp);
        for i=find((-ftmp)>0)
            tmp1=sprintf('%s',var_bez(ind(i),:));
            tmp2=sprintf('%4.3f ',-ftmp(i));
            fprintf(1,'%s %s \n',tmp1,tmp2);
        end; % for
    end; % isfield
end;%type=2
