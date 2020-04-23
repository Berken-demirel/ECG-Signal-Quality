function [Sensitivity,PPV] = get_my_score(labels, result)
PEAK_WINDOW = 17;               % accepted R-peak window, ~150 ms

TP = 0; % True positive
FP = 0; % False positive
FN = 0; % False negative

for i = 1:length(labels)
    if( (labels(i,1) == 1 && result(i) == 1) || ((labels(i,1) == 0 && result(i,1) == 0)))
        TP = TP + 1;
    elseif( labels(i) == 0 && result(i) == 1)
        FP = FP + 1;
    else
        FN = FN + 1;
    end
    
end
            

Sens = TP/(TP+FN);
PPV = TP/(TP+FP);


    fprintf('\t True Positive  = %d \n\t False Negative = %d \n\t False Positive = %d \n',TP, FN, FP);
    fprintf('--------------------------------------------------\n');
    fprintf('\t Sens = %.3f\n\t PPV  = %.3f\n',Sens, PPV);
   
% Sensitivity = Sens;
% PPV = PPV;
end