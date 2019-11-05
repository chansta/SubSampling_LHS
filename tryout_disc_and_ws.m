%% Tryout script for discretization and creating of the working sample
clear all
clc

%% Check for reconstruction of the variable
type = 'shifting';
S = 10;
M = 3;
a_l = -4;
a_u =  4;
% Create object
obj = subsampling( type , S , M , a_l , a_u );
% Create boundaries
c_s = create_boundaries( obj );
% Discretize a continuous random variable
rng( 100 );
X = randn( 10000 , 1 );
X_s = discretize_rv( obj , X );
%% Create artificial distribution
artX = create_artificial_distribution( obj , X_s );

%% Create the working sample
X_ws = create_working_sample( obj, X_s , artX );