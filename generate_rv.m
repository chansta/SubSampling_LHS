%% Generate random variable

function x = generate_rv( N , MC , dist , eps , a_l , a_u )
% Generate continuous random variable
if eps
    rng( 101 );
else
    rng( 100 );
end

switch dist
    case 'uniform'
        pd  = makedist( 'unif' , a_l , a_u );
    case 'normal'
        pd  = makedist( 'normal' , 0 , 0.2 );
    case 'exponential'
        pd  = makedist( 'exponential' , 0.5 );
    case 'weibull'
        pd  = makedist( 'wbl' , 1 , 0.5 );
    case 'Logistic'
        pd  = makedist( 'Logistic' );
    otherwise
        error('No such distribution implemented')
end
% For shifting the distribution between a_u and a_l
if any( strcmp( dist , {'exponential','weibull'} ) )
    a_u = a_u - a_l;
end

% Truncate
t = truncate( pd , a_l , a_u );
% Generate
x = random( t , N , MC );
% If exponential or weibull -> make the domain between a_l and a_u
if any( strcmp( dist , {'exponential','weibull'} ) )
    x = x + a_l;
end

% Make the expected value to zero
if eps    
    x = x - mean( x );
end

end