%% LHS simulation
clear all
clc

%% Check for reconstruction of the variable
type = 'shifting';
S   = 50;
M   = 3;
a_l = -4;
a_u =  4;
% Create object
obj = subsampling( type , S , M , a_l , a_u );
% Create boundaries
c_s = create_boundaries( obj );
%% DGP and discretization
rng( 100 );
N  = 1000;
MC = 1000;
X   = randn( N , 1 ) * 2;
pd = makedist( 'Exponential' , 0.5 );
eps = random( pd , N , MC );
Y = 0.5 * repmat( X , [ 1 , MC ] ) + eps;
artY = NaN( size( Y ) );
%% Estimation for each MC-sample
b1 = NaN( MC , 2 );
b2 = NaN( MC , 2 );
XX = [ ones( N , 1 ) , X ];
for mc = 1 : MC
    Y_s = discretize_rv( obj , Y( : , mc ) );
    %% Create artificial distribution
    artY_1 = create_artificial_distribution( obj , Y_s );
    %artY( : , mc ) = artY_1( 1 : N );
    % Create the working sample
    Y_ws = create_working_sample( obj, Y_s , artY_1 );
    %% Estimation
    Y_s_l = Y_s( : );
    logNaN1 = ~isnan( Y_ws );
    logNaN2 = ~isnan( Y_s );
    b1( mc , : ) = lscov( XX( logNaN1 , : ) , Y_ws( logNaN1 ) );
    b2( mc , : ) = lscov( XX( logNaN2 , : ) , Y_s_l( logNaN2 ) );
end
disp( ['With sub-sampling and reconstruction ' , type , 'the bias: ' mean( 0.5 - b1( : , 2 ) ) , ' the sd: ' std( b1( : , 2 ) ) ] )
disp( ['Only with sub-sample ' , type , 'the bias: ' mean( 0.5 - b2( : , 2 ) ) , ' the sd: ' std( b2( : , 2 ) ) ] )


