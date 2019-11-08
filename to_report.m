%% Monte carlo results
clear all
clc
%%
type = { 'magnifying','shifting' };
dist = { 'sd-Normal' , 'logit' , 'Normal12' , 'logit12' , 'uniform' , 'exponential' , 'weibull' };
warning('off');
a = NaN( numel( dist ) , 4 );
M = 3;
S = 50;
for t = 1 : 2
    for d = 1 : numel( dist )
        a_i = mc4lhs( M , S , type{ t } , dist{ d } );
        if t == 1
            a( d , 1 : 2 ) = a_i;
        else
            a( d , 3 : 4 ) = a_i;
        end
    end
end

columnLabels = repmat({'bias','SD'} , [1,2]);
rowLabels    = {'N(0,1)','Logistic(0,$\pi/\sqrt{3}$)','N(1,2)',...
                'Logistic(1,2)','U(-4,4)','Exp(0.5)','Weibull(1,0.5)'}';

                    name = ['report_M',num2str(M),'_S',num2str(S)];
matrix2latex( a , name , 'rowLabels', rowLabels, 'columnLabels', columnLabels,...
              'alignment', 'c', 'format', '%-6.4f');
          
%% Monte carlo results
clear all
clc
%%
type = { 'magnifying','shifting' };
dist = 'sd-Normal';
warning('off');
M = [ 3 , 5 , 10 ];%, 50 ];
S = [ 1 , 10 , 50 , 100 ];
a = NaN( 4*2 , 4 );
for t = 1 : 2
    for m = 1 : numel( M )
        for s = 1 : numel( S ) 
            [~,a_i] = mc4lhs( M( m ) , S( s ) , type{ t } , dist );
            if t == 1
                a( s , m ) = a_i(1);
            else
                a( 4 + s , m ) = a_i(1);
            end
        end
    end
end

columnLabels = {'M=3','M=5','M=10','M=50'};
rowLabels    = repmat( {'S=1','S=10','S=50','S=100'}' , [ 2 ,1 ] );

name = ['report_MS_with',dist];

matrix2latex( a , name , 'rowLabels', rowLabels, 'columnLabels', columnLabels,...
              'alignment', 'c', 'format', '%-6.4f');