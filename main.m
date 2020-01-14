clear;
addpath(genpath('./'))
%load data
M = readtable('interction.txt','Delimiter','\t','ReadRowNames',true,'ReadVariableNames',true);
Interction = table2array(M); 
sd = readtable('sd.txt','Delimiter','\t','ReadRowNames',true,'ReadVariableNames',true);
Sd = table2array(sd); 
sm = readtable('sm.txt','Delimiter','\t','ReadRowNames',true,'ReadVariableNames',true);
Sm = table2array(sm); 
norm=1;
rank=3;
iter =60;
tol = 1e-8;
lam1=0.1;
lam2=1;
lam4=1;
MatPredict=zeros(495,383);
Vp=find(Interction()==1);
Vn=find(Interction()==0);
Ip=crossvalind('Kfold',numel(Vp),5);
In=crossvalind('Kfold',numel(Vn),5);
for I=1:5
    vp=Ip==I;
    vn=In==I;
    matDT=Interction;
    matDT(Vp(vp))=0;
    Map=MAPS(matDT);
    I11=getAdjMA(matDT,Map);
    [X S Y dist]=OptSpaceII(I11,Sd,Sm,rank,iter,tol,lam1,lam2,lam4);
    recMatrix = X*S*Y';
    V=[Vn(vn);Vp(vp)];
    MatPredict(V)=recMatrix(V); 
end
[AUC,AUPR,Acc,Sen,Spe,Pre]=ROCcompute1(MatPredict,Interction,1);
