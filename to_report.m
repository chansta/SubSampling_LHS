%% Monte carlo results
clear all
clc
%%
type = { 'magnifying','shifting' };
dist = { 'sd-Normal' , 'logit' , 'Normal12' , 'logit12' , 'uniform' , 'exponential' , 'weibull' };
warning('off');
a = NaN( numel( type ) * numel( dist ) , 4 );
ct = 1;
for t = 1 : 2
    for d = 1 : numel( dist )
        a( ct , : ) = mc4lhs( type{ t } , dist{ d } );
        ct = ct+1;
    end
end

columnLabels = repmat({'bias','SD'} , [1,2]);
rowLabels    = repmat( {'N(0,1)','Logistic(0,$\pi/\sqrt{3}$)','N(1,2)',...
                        'Logistic(1,2)','U(-4,4)','Exp(0.5)','Weibull(1,0.5)'}' , [2,1]);
matrix2latex( a , 'report_mc_LHS', 'rowLabels', rowLabels, 'columnLabels', columnLabels,...
              'alignment', 'c', 'format', '%-6.4f');