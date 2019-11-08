%% Create artificial random variable to mimic the underlying distribution


function artX = create_artificial_distribution( obj , X_s )

% Create the variable for artificial random variable
Ns = size( X_s , 1 );
artX = NaN( Ns , obj.S );

% Brute force version
for s = 1 : obj.S
    for m = 1 : obj.M
        log_ID = X_s( : , s ) == obj.z_s( s , m );
        % Number of observation within the class in the given sub-sample
        n_a = sum( log_ID ~= 0 );
        % If no observation then skip
        if n_a > 0
            % Bounds for selecting potential mid-values from the working sample
            bounds = [ obj.c_s( s , m ) , obj.c_s( s , m + 1 ) ];
            % Select the potential working sample mid-values
            potential_z_b = obj.z_b( bounds( 1 ) <= obj.z_b & bounds( 2 ) >= obj.z_b );
            % Number of actual working sample values
            num_pot_z_b = numel( potential_z_b );
            
            % Identify the `directly transferable' observations in the subsample
            if num_pot_z_b == 1
                % If only one working sample value then put that value into
                % the artificial random variable
                artX( log_ID , s ) = potential_z_b;
                
            elseif ~strcmpi( obj.type , 'magnifying' )
            % this way we do not add `non-directly transferable' observations
            
                % Uniform probabilities for each potential mid value
                prob_u = 1 ./ num_pot_z_b;
                % Cummulative probabilities for easier classification
                cum_prob = [ 0 , cumsum( ones( 1 , num_pot_z_b ) .* prob_u ) ];
                % Create a vector for uniform probabilities
                rand_unif = NaN( Ns , 1 );
                % Fix the random seed in order to replicate
                %rng( obj.seed + s * m );
                rand_unif( log_ID ) = rand( n_a , 1 );
                for i = 1 : num_pot_z_b
                    artX( log_ID & ( rand_unif >= cum_prob( i ) & rand_unif <= cum_prob( i + 1 ) ) , s ) = potential_z_b( i );
                end
            end
        end
    end
end
% Create a column vector to emphasize it should not be used as paired
% values for estimation
artX = artX( : );
% Remove NaNs
artX = artX( ~isnan( artX ) );

end