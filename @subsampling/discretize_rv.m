%% Dicretize a given random variable


function X_s = discretize_rv( obj , X )

if isempty( obj.c_s )
    error('No boundary points are given for questionnaires!')
end

N = numel( X );
% Create S partition of the data
N_s = ceil( N ./ obj.S );
X_s = NaN( N_s , obj.S );
% Reshape original random variable X first add NaNs to be able to reshape
obj.added_nan = ( N_s .* obj.S ) - N;
Xr = [ X( : ) ; NaN( obj.added_nan , 1 ) ];
Xr = reshape( Xr , N_s , obj.S );

mid_values = obj.z_s;

for s = 1 : obj.S
    n_z = numel( mid_values( s , : ) );
    for n = 2 : ( n_z + 1 )
        log_ID = obj.c_s( s , n - 1 ) <= Xr( : , s ) & obj.c_s( s , n ) >= Xr( : , s );
        X_s( log_ID , s ) = mid_values( s , n - 1 );
    end
end

if sum( isnan( X_s ) ) > obj.added_nan
    warning('Some observations are outside of the domain of the survey! We replace those with NaN in the data!')
end


end