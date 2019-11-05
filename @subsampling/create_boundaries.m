%% Create Sub-Sample questionnaires (boundary points)

function c_s = create_boundaries( obj )

switch obj.type
    case 'simple'
        if obj.S ~= 1
            error('Using simple questionnaire requires to set S=1')
        end
        c_s = linspace( obj.a_l ,obj.a_u , obj.M + 1 );
    case 'magnifying'
        % Number of classes in the working sample
        B = obj.S * ( obj.M - 2 ) + 2;
        % Width of the classes in the sub-samples
        h = ( obj.a_u - obj.a_l ) / B;
        % Distances for s-sample's first choice class boundary
        h_m = h .* ( 1 : ( obj.M - 1 ) );
        % Matrix for sub-samples
        c_s = NaN( obj.S , obj.M + 1 );
        % First and last boundary points are always the end of the domain
        c_s( : , 1 )   = obj.a_l;
        c_s( : , end ) = obj.a_u;
        % Initialize the for loop
        c_last = obj.a_l;
        for s = 1 : obj.S
            c_s( s , 2 : end - 1 ) = c_last + h_m;
            c_last = c_s( s , end - 2 );
        end
    case 'shifting'
        % Number of classes in the working sample
        B = obj.S * ( obj.M - 1 );
        % Width of the shift
        h = ( obj.a_u - obj.a_l ) / B;
        % Matrix for sub-samples
        c_s = NaN( obj.S , obj.M + 1 );
        % First and last boundary points are always the end of the domain
        c_s( : , 1 )   = obj.a_l;
        c_s( : , end ) = obj.a_u;
        % The first sub-sample is special
        c_s( 1 , : ) = [ obj.a_l , linspace( obj.a_l , obj.a_u , obj.M ) ];
        % Shift each sub-sample by h
        for s = 2 : obj.S
            c_s( s , 2 : end - 1 ) = c_s( s - 1 , 2 : end - 1 ) + h;
        end
    otherwise
        error( ['No such sub-sampling method as' , obj.type '\n', 'Use magnifying or shifting methods.' ] )
end

if obj.censored
    c_s( : , 1 )   = -Inf;
    c_s( : , end ) =  Inf;
end

obj.c_s = c_s;
set_basics( obj );

end