function [RV,C,I,RI]=VAT(R);
% Example function call: [DV,I] = VAT(D);
%
% *** Input Parameters ***
% @param R (n*n double): Dissimilarity data input
% 
% *** Output Values ***
% @value RV (n*n double): VAT-reordered dissimilarity data
% @value C (n int): Connection indexes of MST
% @value I (n int): Reordered indexes of R, the input data
%
% Copyright by Timothy Havens, Michigan Tech 
% http://www.ece.mtu.edu/~thavens/code/VAT.m
% 
% Modified by Ralf Mikut, KIT, 2013

[N,M]=size(R);

K=1:N;
J=K;

[y,i]=max(R);
[y,j]=max(y);
I=i(j);
J(I)=[];
[y,j]=min(R(I,J));
I=[I J(j)];
J(J==J(j))=[];
C(1:2)=1;

for r=3:N-1
    
    if rem(r,10) == 0
        fprintf('%d/%d\n',r,N);
    end;
    
    [y,i]=min(R(I,J));
    [y,j]=min(y);
    I=[I J(j)];
    J(J==J(j))=[];
    C(r)=i(j);
end;
[y,i]=min(R(I,J));
I=[I J];
C(N)=i;

for r=1:N,
    RI(I(r))=r;
end;

RV=R(I,I);