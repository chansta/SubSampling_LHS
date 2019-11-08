%% Check distributional approximation
clear all
%clc

%%
MC = 100;
N  = 10000;
S  = 50;
M  = 10;
type = 'magnifying';
dist = 'normal';

[ MSE , d_pcts , moments , cond_avg , X , artX ] = report_distance( N , S , M , MC , type , dist );


%%
histogram( X )
hold on
histogram(artX)

%%
disp( ['MSE: ' num2str( mean( MSE ) ) ])
disp( ['Quantiles: ' num2str( mean( d_pcts ) ) ])
disp( ['Moments: ' num2str( mean( moments ) ) ])
disp( ['Cond avg: ' num2str( mean( cond_avg ) ) ])