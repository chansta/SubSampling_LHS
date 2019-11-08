%% Monte-Carlo simulation for approximating the underlying distribution
%
% Case: Known domain

function [ MSE , d_pcts , moments , cond_avg , X , artX , X_ws , X_ts ] = report_distance( N , S , M , MC , type , dist ) 
% Lower and higher boundaries
a_l = -4;
a_u =  4;
% Create object
obj = subsampling( type , S , M , a_l , a_u );
% Create boundaries
create_boundaries( obj );
% Discretize a continuous random variable
rng( 100 );
switch dist
    case 'uniform'
        pd  = makedist( 'unif' , -4 , 4 );
    case 'normal'
        pd  = makedist( 'normal' , 0 , 2 );
    case 'exponential'
        pd  = makedist( 'exponential' , 0.5 );
    case 'weibull'
        pd  = makedist( 'wbl' , 1 , 0.5 );
    case 'Logistic'
        pd  = makedist( 'Logistic' );
    otherwise
        error('No such distribution implemented')
end

if any( strcmpi( dist , {'exponential','weibull'} ) )
    a_u = 8;
end

% Truncate
t = truncate( pd , a_l , a_u );
X   = random( t , N , MC );
switch dist
    case {'exponential','weibull'}
        X = X + a_l;
end

% Check differences in 7 percentiles and first 7 moments
prctile_n = [ 1 , 10 , 25 , 50 , 75 , 90 , 99 ]; 
n_p = numel( prctile_n );
d_pcts  = NaN( MC , n_p );
moments = d_pcts;
cond_avg = NaN( MC , n_p - 1 );
MSE = NaN( MC , 1 );
for mc = 1 : MC
    Xmc = X( : , mc );
    X_s = discretize_rv( obj , Xmc );
    % Create artificial distribution
    artX = create_artificial_distribution( obj , X_s );
    % Check the differences in conditional means
    [ X_ws , X_ts ] = check_working_sample( obj, X_s , artX , Xmc );
    % MSE for differences
    logNaN = ~isnan( X_ws );
    MSE( mc ) = mean( ( X_ts( logNaN ) - X_ws( logNaN ) ).^2 );
    % Percentiles
    pcts_X  = prctile( Xmc , prctile_n );
    pcts_aX = prctile( artX , prctile_n );
    d_pcts( mc , : )  = ( pcts_X - pcts_aX );
    % Moments
    for i = 1 : 7
        moments( mc , i ) = ( ( moment( Xmc , i ) - moment( artX , i ) ) );
    end
    % Conditional averages
    for i = 1 : ( n_p - 1 )
       cond_avg( mc , i ) =  mean( Xmc( Xmc >= pcts_X( i )    & Xmc <= pcts_X( i + 1 ) ) ) - ...
                             mean( artX( artX >= pcts_aX( i ) & artX <= pcts_aX( i + 1 ) ) );

    end
end

end