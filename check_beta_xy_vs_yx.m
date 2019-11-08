%% Monte-Carlo simulation for approximating the underlying distribution
%
% Case: Known domain

function [ b_yx , b_xy , b_yxs , Y_all , X_all ] = check_beta_xy_vs_yx( N , S , M , MC , type , distX , distE ) 

a_l = -1;
a_u = 1;
X = generate_rv( N   , MC , distX , false , a_l , a_u );
eps = generate_rv( N , MC , distE , false , a_l , a_u );

Y = X + eps;
% Create object
objY = subsampling( type , S , M , 2*a_l , 2*a_u );
objX = subsampling( type , S , M , a_l , a_u );
% Create boundaries
create_boundaries( objY );
create_boundaries( objX );

%
Y_ws = NaN( N , MC );
Y_ts = NaN( N , MC );
X_ws = NaN( N , MC );
X_ts = NaN( N , MC );
b_0 = NaN( MC , 2 );
b_i0 = NaN( MC , 2 );
b_d = NaN( MC , 2 );
b_t = NaN( MC , 2 );
b_id = NaN( MC , 2 );
b_it = NaN( MC , 2 );
b_0x = NaN( MC , 2 );
b_dx = NaN( MC , 2 );
b_tx = NaN( MC , 2 );
for mc = 1 : MC
    %% Discretize Y
    Ymc = Y( : , mc );
    Y_s = discretize_rv( objY , Ymc );
    % Create artificial distribution
    artY = create_artificial_distribution( objY , Y_s );
    % Check the differences in conditional means
    [ Y_ws( : , mc ) , Y_ts( : ,mc ) ] = check_working_sample( objY, Y_s , artY , Ymc );
    %% Discretize X
    Xmc = X( : , mc );
    X_s = discretize_rv( objX , Xmc );
    % Create artificial distribution
    artX = create_artificial_distribution( objX , X_s );
    % Check the differences in conditional means
    [ X_ws( : , mc ) , X_ts( : ,mc ) ] = check_working_sample( objX, X_s , artX , Xmc );
    
    %% Do some regressions
    logN       = ~isnan( Y_ws( : , mc ) );
    intercpt   = ones( sum( logN ) , 1 );
    % Simple
    b_0( mc , : )  = lscov( [ intercpt , X( logN , mc ) ] , Y( logN , mc ) );
    b_d( mc , : )  = lscov( [ intercpt , X( logN , mc ) ] , Y_ws( logN , mc ) );
    b_t( mc , : )  = lscov( [ intercpt , X( logN , mc ) ] , Y_ts( logN , mc ) );
    % Inverted
    b_i0( mc , : ) = lscov( [ intercpt , Y( logN , mc )    ] , X( logN , mc ) );
    b_id( mc , : ) = lscov( [ intercpt , Y_ws( logN , mc ) ] , X( logN , mc ) );
    b_it( mc , : ) = lscov( [ intercpt , Y_ts( logN , mc ) ] , X( logN , mc ) );
    % X is discretized
    logNX       = ~isnan( X_ws( : , mc ) );
    intercpt2   = ones( sum( logNX ) , 1 );
    b_0x( mc , : )  = lscov( [ intercpt2 , X( logNX , mc )    ] , Y( logNX , mc ) );
    b_dx( mc , : )  = lscov( [ intercpt2 , X_ws( logNX , mc ) ] , Y( logNX , mc ) );
    b_tx( mc , : )  = lscov( [ intercpt2 , X_ts( logNX , mc ) ] , Y( logNX , mc ) );
end

b_yx  = [ b_0( : , 2 )   , b_t( : , 2 )  , b_d( : , 2 ) ];
b_xy  = [ b_i0( : , 2 )  , b_it( : , 2 ) , b_id( : , 2 ) ];
b_yxs = [ b_0x( : , 2 )  , b_tx( : , 2 ) , b_dx( : , 2 ) ];

Y_all = struct;
Y_all.Y = Y;
Y_all.Y_ws = Y_ws;
Y_all.Y_ts = Y_ts;
X_all = struct;
X_all.X = X;
X_all.X_ws = X_ws;
X_all.X_ts = X_ts;

end