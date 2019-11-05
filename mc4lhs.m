%% To get MC results

function a = mc4lhs( type , dist )
%% Check for reconstruction of the variable
%type = 'shifting';
S   = 50;
M   = 3;
a_l = -8;
a_u =  8;
% Create object
obj = subsampling( type , S , M , a_l , a_u );
% Create boundaries
create_boundaries( obj );
%% DGP and discretization
rng( 100 );
N  = 1000;
MC = 1000;
X   = randn( N , 1 ) * 2;
switch dist
    case 'sd-Normal'
        pd = makedist( 'Normal' );
    case 'Normal12'
        pd = makedist( 'Normal' , 1 , 2 );
    case 'logit'
        pd = makedist( 'Logistic' );
    case 'logit12'
        pd = makedist( 'Logistic' , 1 , 2 );
    case 'uniform'
        pd = makedist( 'unif' , -4 , 4 );
    case 'exponential'
        pd = makedist( 'exponential' , 0.5 );
    case 'weibull'
        pd = makedist( 'wbl' , 1 , 0.5 );
    otherwise
        error('no such distribution')        
end
eps = random( pd , N , MC );
Y = 0.5 * repmat( X , [ 1 , MC ] ) + eps;
%artY = NaN( size( Y ) );
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
disp( ['With distribution: ' dist ] );
disp( ['With sub-sampling and reconstruction ' , type , 'the bias: ' num2str( mean( 0.5 - b1( : , 2 ) ) ) , ' the sd: ' , num2str( std( b1( : , 2 ) ) ) ] )
disp( ['Only with sub-sample ' , type , 'the bias: ' num2str( mean( 0.5 - b2( : , 2 ) ) ) , ' the sd: ' num2str( std( b2( : , 2 )  ) ) ] )

a = [ mean( 0.5 - b1( : , 2 ) ) , std( b1( : , 2 ) ) , mean( 0.5 - b2( : , 2 ) ) , std( b2( : , 2 )  ) ];

end


