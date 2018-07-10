function [ypred,vote,maxi_all]=svmmultivaloneagainstone(x,xsup,w,b,nbsv,kernel,kerneloption,Sigma)
% USAGE [ypred,vote,maxi_all]=svmmultivaloneagainstone(x,xsup,w,b,nbsv,kernel,kerneloption,Sigma)
% 
% Process the class of a new point x.
% 
% This function should be used in conjuction with the output of
% svmmulticlassoneagainstone
%
%

%  modified : AR 07/03/2003  Added Sigma for dealing with particular scaling
%
% 29/07/2000 Alain Rakotomamonjy
% Modification: 
% additional output value maxi_all for the sub-classification problems of all class pairs (class c against i)
% 16/03/2006 Ralf Mikut
% Correct usage of exist to avoid search for files
% 13/07/2006 Ole Burmeister
%
% 18/01/2013 Ralf 
% small technical corrections: 
% & -> &&
% nbclass=(1+ sqrt(1+4*2*length(find(nbsv))))/2 instead of nbclass=(1+ sqrt(1+4*2*length(nbsv)))/2;

if exist('Sigma', 'var') &&  (~strcmp(kernel,'gaussian') && ~(kerneloption==1))
   warning('Adaptive scaling is available only for gaussian kernel...');
end;



[n1,n2]=size(x);
nbclass=(1+ sqrt(1+4*2*length(find(nbsv))))/2;
vote=zeros(n1,nbclass);
nbsv=[0 nbsv];
aux=cumsum(nbsv);
k=1;
for i=1:nbclass-1;
   for j=i+1:nbclass;
      if nargin < 8;
         xsupaux=xsup(aux(k)+1:aux(k)+nbsv(k+1),:);
         xaux=x;
         
      else    
         xsupaux=xsup(aux(k)+1:aux(k)+nbsv(k+1),:).*repmat(Sigma(i,:),nbsv(k+1),1);
         xaux= x.*repmat(Sigma(i,:),n1,1);
      end;
      waux=w(aux(k)+1:aux(k)+nbsv(k+1));
      baux=b(k);
      
      ypred= svmval(xaux,xsupaux,waux,baux,kernel,kerneloption);
      
      %BEGIN MODIFICATION
      maxi_all(i,j).ypred=ypred;
      %END MODIFICATION
      
      indi=find(ypred>=0);
      indj=find(ypred<0);
      vote(indi,i)=vote(indi,i)+1;
      vote(indj,j)=vote(indj,j)+1;
      k=k+1;
   end;
end;
[maxi,ypred]=max(vote');
ypred=ypred';