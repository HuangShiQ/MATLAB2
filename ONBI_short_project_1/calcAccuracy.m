function[data, accuracy, sensitivity, specificity] = calcAccuracy(data, positive, negative,accMin,accMax,factor)
% 
% for n = 1:100
%     n
%     for d = data(1).DETERMINE_indices(n)
%        d
%         positive(n) = data(d).ejectionFraction;       
%     end
%     for m = data(1).MESA_indices(n)
%       m
%         negative(n) = data(m).ejectionFraction;       
%     end
%     
% end
positive(1,:) = positive(:)*factor;
negative(1,:) = negative(:)*factor;

for i = accMin:accMax
    % if we class over threshold as MESA ('negative') and under threshold as
    % DETERMINE ('positive')
    i;
    
    nfalse_negative = sum(positive>i);
    ntrue_negative = sum(negative>i);
    ntrue_positive = sum(positive<i);
    nfalse_positive = sum(negative<i);
       
%%
clear EFpositive
clear EFnegative
clear EFs_train
clear EFs_test
clear accuracy
clear specificity
clear sensitivity



figure
grid on
grid minor
kfold_n = 200;
EFpositive =  zeros(100,200);
EFnegative =  zeros(100,200);
ntrue_negative = zeros(100,1);
ntrue_positive = zeros(100,1);
nfalse_negative = zeros(100,1);
nfalse_positive = zeros(100,1);
%
    pause(0.2)
    
  
        c = cvpartition(names, 'kfold',kfold_n)
        D_EFs = [DETERMINE_ejectionFractions];
        M_EFs = [MESA_ejectionFractions];
        

        
        for i = 1:kfold_n
            EFs_train(:,i) = training(c,i);
            EFs_test(:,i) = test(c,i);
            for threshold = 1:100
                threshold = threshold
             
                %DETERMINE
                if sum(EFs_test(1:100,i))>0
                    sum(EFs_test(1:100,i));
                    EFpositive(threshold,i) = D_EFs(find(EFs_test(1:100,i)));
                end
                %MESA
                if sum(EFs_test(101:200,i))>0
                    sum(EFs_test(101:200,i));
                    EFnegative(threshold,i) = M_EFs(find(EFs_test(101:200,i)));
                end
            end
            
        end
        
        
         
            
            for threshold = 1:100
                for i = 1:200
                    if EFpositive(threshold,i) ~= 0
                        if EFpositive(threshold,i) > threshold
                            nfalse_negative(threshold) = nfalse_negative(threshold) + 1;
                        end
                        if EFpositive(threshold,i) < threshold
                            ntrue_positive(threshold) = ntrue_positive(threshold) + 1;
                        end
                        
                    end
                    nfalse_negative(threshold) = nfalse_negative(threshold);
                    ntrue_positive(threshold) = ntrue_positive(threshold);
                    
                    if EFnegative(threshold,i) ~= 0
                        if EFnegative(threshold,i) > threshold
                            ntrue_negative(threshold) = ntrue_negative(threshold) + 1;
                        end
                        if EFnegative(threshold,i) < threshold
                            nfalse_positive(threshold) = nfalse_positive(threshold) + 1;
                        end
                    end
                    ntrue_negative(threshold) = ntrue_negative(threshold);
                    nfalse_positive(threshold) = nfalse_positive(threshold);
                end
                
                
           
                
            sensitivity(threshold) = ntrue_positive(threshold) ./ (ntrue_positive(threshold) + nfalse_negative(threshold)) ;
            specificity(threshold) = ntrue_negative(threshold) ./ (ntrue_negative(threshold) + nfalse_positive(threshold) );

            accuracy(threshold) = (ntrue_positive(threshold) + ntrue_negative(threshold))./(ntrue_positive(threshold) + nfalse_positive(threshold) + nfalse_negative(threshold) + ntrue_negative(threshold));
            end
            

            
        
      figure
      hold on
        plot(accuracy)
        plot(specificity)
        plot(sensitivity)
      
        
        
       
        


        %%
            
            
%           cverror = kfoldLoss(cvmodel);
                       
%             scores = zeros(1,200)
%             for i = 1:200
%                 if yfit2(i) == 'd'
%                     scores(i) = 1
%                 end
%             end
%             [X,Y] = perfcurve(names,scores,'d') %ROC curve
    %fraction, not percentage
    accuracy(i) = (ntrue_positive + ntrue_negative)/(ntrue_positive + nfalse_positive + nfalse_negative + ntrue_negative);
    
    sensitivity(i) = ntrue_positive / (ntrue_positive + nfalse_negative );
    specificity(i) = ntrue_negative / (ntrue_negative + nfalse_positive );
end

end

