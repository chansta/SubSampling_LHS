%% Toz example for cond expectations
clear all
clc

MC = 100;
N = 1000;
eps = randn( N , MC );
X = rand( N , MC );
y = 0.5 * X + eps;
b1 = NaN(MC,1);
b2 = b1;
b3 = b1;
b4 = b1;
for m = 1 : MC
    
    b1( m ) = lscov( X( : , m ) , y( : , m ) );
    y_b = repmat( mean( y( : , m ) ) , [ N , 1 ] );
    b2( m ) = lscov( X( : , m ) , y_b );
    x_b = repmat( mean( X( : , m ) ) , [ N , 1 ] );
    b3( m ) = lscov( x_b , y( : , m ) );
    b4( m ) = lscov( y_b , X( : , m ) );
    
end
%%
mean( b1 )
mean( b2 )
mean( b3 )
mean( b4 )

%%
histogram( b3 - 0.5 )
hold on
histogram( b4 - 2 )
% histogram( b2 )
% histogram( b3 )