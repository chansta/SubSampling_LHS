%% Creating working sample

function [ X_ws , X_ts ] = check_working_sample( obj, X_s , artX , X )

% Create variable for working sample
X_ws = NaN( size( X_s ) );
X_ts = X_ws;

% Brute force version
for s = 1 : obj.S
    for m = 1 : obj.M
        log_ID = X_s( : , s ) == obj.z_s( s , m );
        % Number of observation within the class in the given sub-sample
        n_a = sum( log_ID ~= 0 );
        % If no observation then skip
        if n_a > 0
            % Bounds for selecting values from the artificial rv
            bounds = [ obj.c_s( s , m ) , obj.c_s( s , m + 1 ) ];
            % Conditional sample average using the artificial rv
            cond_avg      = mean( artX( artX >= bounds( 1 ) & artX <= bounds( 2 ) ) );
            true_cond_avg = mean( X( X >= bounds( 1 ) & X <= bounds( 2 ) ) );
            X_ws( log_ID , s ) = cond_avg;
            X_ts( log_ID , s ) = true_cond_avg;
        end
    end
end

X_ws = X_ws( : );
% Remove the NaNs if added
X_ws( end - obj.added_nan + 1 : end ) = [];

X_ts = X_ts( : );
% Remove the NaNs if added
X_ts( end - obj.added_nan + 1 : end ) = [];

end