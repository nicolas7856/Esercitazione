clear all
close all
randn('state',0)
R=100;
N=4;
sigma=0.1;
mu=1;
Y=mu+sigma*randn(R,N)
mean=mean(Y)
std=std(Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

