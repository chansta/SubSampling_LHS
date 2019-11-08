%%
clear all
clc
%%
M = 5;
S = 100;
type = 'shifting';
distX = 'normal';
distE = 'uniform';
MC = 100;
N = 10000;

[ b_yx , b_xy , b_yxs , Y_all , X_all ] = check_beta_xy_vs_yx( N , S , M , MC , type , distX , distE );

disp( mean( b_yx ) );
disp( mean( b_xy ) );
disp( mean( b_yxs ) );

%%
histogram( Y_all.Y_ts );
hold on
histogram( Y_all.Y_ws );
%%
figure;
histogram( X_all.X_ts );
hold on
histogram( X_all.X_ws );