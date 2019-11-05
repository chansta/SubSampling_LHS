classdef subsampling < handle
    %% Class for sub-sampling methods   
    properties
        % Type of creating the sub-sample boundaries
        type
        % Number of sub-samples 
        S
        % Number of choice values
        M
        % Lower bound for class boundaries
        a_l
        % Upper bound for class boundaries
        a_u
        % Censored (t/f)
        censored = false
    end
    
    properties
        % Boundary values for each sub-samples
        c_s 
    end
    properties ( Access = private )
        seed = 1000;
    end
    properties ( Access = private )
        % Boundary values for working sample
        c_b
        % Mid values for sub-samples
        z_s
        % Mid values for working sample
        z_b
    end
    
    
    
    methods
        function obj = subsampling( type , S , M , a_l , a_u )
            obj.type = type;
            obj.S = S;
            obj.M = M;
            obj.a_l = a_l;
            obj.a_u = a_u;
        end
        
        %% Type of sub-sampling method
        function set.type( obj , val )
            if ~ischar( val )
                error( 'Type of sub-sample methods must be a char' );
            elseif ~any( strcmpi( val , { 'magnifying', 'shifting', 'custom' } ) )
                error( [ 'Type of sub-samples methods must be one of the following: \n' , ...
                        'simple: using only one questionnaire, S must be equal to 1 \n' , ...
                        'magnifying: magnifies into small bin parts within subsamples \n',...
                        'shifting: shifts the boundaries across the support \n',...
                        'custom: custom set sub-sample boundaries'] )
            else
                obj.type = val;
            end            
        end
        function set.S( obj , val )
           if ~isnumeric( val ) && numel( val ) ~= 1 && val < 0 && mod( val , 0 ) ~= 1
               error('Number of sub-samples must be a positive integer')
           else
               obj.S = val;
           end
        end
        function set.M( obj , val )
           if ~isnumeric( val ) && numel( val ) ~= 1 && val < 0 && mod( val , 0 ) ~= 1
               error('Number of choice values must be a positive integer')
           else
               obj.M = val;
           end
        end
        function set.a_l( obj , val )
           if ~isnumeric( val ) && numel( val ) ~= 1
               error('Lowest choice boundary must be a a numerical value')
           else
               obj.a_l = val;
           end
        end
        function set.a_u( obj , val )
           if ~isnumeric( val ) && numel( val ) ~= 1
               error('Highest choice boundary must be a a numerical value')
           else
               obj.a_u = val;
           end
        end
        function set.censored( obj , val )
            if ~islogical( val )
                error('Censoring parameter must be a logical!')
            else
                obj.censored = val;
            end
        end
        
        %% Get functions
        function set_basics( obj )
            get_c_b( obj );
            get_z_b( obj );
            get_z_s( obj );
        end
        function get_c_b( obj )
            obj.c_b = unique( obj.c_s );
        end
        function get_z_b( obj )
            obj.z_b = ( obj.c_b( 1 : end - 1 ) + obj.c_b( 2 : end ) ) ./ 2;
            if obj.censored
               obj.z_b(   1 ) = ( obj.a_l + obj.c_b( 2       ) ) ./ 2; 
               obj.z_b( end ) = ( obj.a_u + obj.c_b( end - 1 ) ) ./ 2; 
            end
        end
        function get_z_s( obj )
            obj.z_s = NaN( obj.S , obj.M );
            for s = 1 : obj.S
                obj.z_s( s , : ) = ( obj.c_s( s , 1 : end - 1 ) + obj.c_s( s , 2 : end ) ) ./ 2;
                if obj.censored
                    obj.z_s( s , 1   ) = ( obj.a_l + obj.c_s( s , 2 )       ) ./ 2;
                    obj.z_s( s , end ) = ( obj.a_u + obj.c_s( s , end - 1 ) ) ./ 2;
                end
            end
        end
    end
    
    
    methods
        %% Functions of the object
        c_s  = create_boundaries( obj );
        X_s  = discretize_rv( obj , X );
        artX = create_artificial_distribution( obj , X_s );
        X_ws = create_working_sample( obj, X_s , artX );
    end
    
    
    
    
end