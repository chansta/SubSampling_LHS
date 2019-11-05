%% LHS simulation
clear all
clc

%% Check for reconstruction of the variable
type = 'magnifying';
S   = 50;
M   = 3;
a_l = -8;
a_u =  8;
% Create object
obj = subsampling( type , S , M , a_l , a_u );
% Create boundaries
c_s = create_boundaries( obj );
%% DGP and discretization
rng( 100 );
N  = 1000;
MC = 1000;
X  = randn( N , 1 ) * 2;
eps = randn( N , MC );
Y = 0.5 * repmat( X , [ 1 , MC ] ) + eps;
artY = NaN( size( Y ) );
%% Estimation for each MC-sample
b = NaN( MC , 2 );
XX = [ ones( N , 1 ) , X ];
for mc = 1 : MC
    Y_s = discretize_rv( obj , Y( : , mc ) );
    %% Create artificial distribution
    artY_1 = create_artificial_distribution( obj , Y_s );
    artY( : , mc ) = artY_1( 1 : N );
    % Create the working sample
    Y_ws = create_working_sample( obj, Y_s , artY );
    %% Estimation
    b( mc , : ) = lscov( XX , Y_ws );
end


