function [data, TEST_dia_myo_mean, TEST_sys_myo_mean, TEST_dia_sys_myo_mean, TEST_training_diastolic_myo_shapes, TEST_training_systolic_myo_shapes , TEST_training_dia_sys_myo_shapes] = calcProcrustes(data, TEST_pI, TEST_dia_myo_reference, TEST_sys_myo_reference, TEST_dia_sys_myo_reference, indices)

TEST_training_diastolic_myo_shapes = zeros(401, 6534);
TEST_training_systolic_myo_shapes = zeros(401, 6534);
TEST_training_dia_sys_myo_shapes = zeros(401, 13068);



for p = 1:TEST_pI
    
    % iterate so that procrustes is performed on each case (400 patients).
    % for i = 1:400
        
    for   i = indices';
        % % transform endo and epi (individually)
        % [data(i).diastolic.endo.procrustes_d, data(i).diastolic.endo.xyz] = procrustes(dia_endo_reference, data(i).diastolic.endo.xyz(:));
        % [data(i).diastolic.epi.procrustes_d, data(i).diastolic.epi.xyz] = procrustes(dia_epi_reference, data(i).diastolic.epi.xyz(:));
        % [data(i).systolic.endo.procrustes_d, data(i).systolic.endo.xyz] = procrustes(sys_endo_reference, data(i).systolic.endo.xyz(:));
        % [data(i).systolic.epi.procrustes_d, data(i).systolic.epi.xyz] = procrustes(sys_epi_reference, data(i).systolic.epi.xyz(:));
        
        % transform endo and epi as one shape vector
        [data(i).diastolic.myo.procrustes_d, TEST_diastolic_myo_shapes(i).xyz, dia_myo_transform(i)] = procrustes(TEST_dia_myo_reference, data(i).diastolic.myo.xyz,'scaling',false,'reflection',false);
        [data(i).systolic.myo.procrustes_d, TEST_systolic_myo_shapes(i).xyz, sys_myo_transform(i)] = procrustes(TEST_sys_myo_reference, data(i).systolic.myo.xyz,'scaling',false,'reflection',false); %,'scaling',false); % with scaling SMM0362 goes much smaller than the others...
        [data(i).dia_sys.myo.procrustes_d, TEST_dia_sys_myo_shapes(i).xyz, dia_sys_myo_transform(i)] = procrustes(dia_sys_myo_reference, data(i).dia_sys.myo.xyz, 'scaling', false, 'reflection', false);
        
        TEST_training_diastolic_myo_shapes(i,:) = TEST_diastolic_myo_shapes(i).xyz(:);
        TEST_training_systolic_myo_shapes(i,:) = TEST_systolic_myo_shapes(i).xyz(:);
        TEST_training_dia_sys_myo_shapes(i,:) = TEST_dia_sys_myo_shapes(i).xyz(:);
        
        TEST_dia_myo_procrustes_d(i,p) = data(i).diastolic.myo.procrustes_d;
        TEST_sys_myo_procrustes_d(i,p) = data(i).systolic.myo.procrustes_d;
        TEST_dia_sys_myo_procrustes_d(i,p) = data(i).dia_sys.myo.procrustes_d;
         
    end
    
    TEST_dia_shapes = TEST_training_diastolic_myo_shapes;
    TEST_sys_shapes = TEST_training_systolic_myo_shapes;
    TEST_dia_sys_shapes = TEST_training_dia_sys_myo_shapes;
    
    TEST_dia_shapes( ~any(TEST_dia_shapes,2), : ) = [];
    TEST_sys_shapes( ~any(TEST_sys_shapes,2), : ) = [];
    TEST_dia_sys_shapes( ~any(TEST_dia_sys_shapes,2), : ) = [];
    
    TEST_dia_myo_mean = mean(TEST_dia_shapes);
    TEST_sys_myo_mean = mean(TEST_sys_shapes );
    TEST_dia_sys_myo_mean = mean(TEST_dia_sys_shapes) ;
    
    %calculate means
    TEST_dia_myo_reference = reshape(TEST_dia_myo_mean,[2*1089 3]);
    TEST_sys_myo_reference = reshape(TEST_sys_myo_mean,[2*1089 3]);
    TEST_dia_sys_myo_reference = reshape(TEST_dia_sys_myo_mean, [4*1089 3]);
    
    procrustes_iteration = p
    
    
%      for   i = data(1).TEST_indices';
%         % % transform endo and epi (individually)
%         % [data(i).diastolic.endo.procrustes_d, data(i).diastolic.endo.xyz] = procrustes(dia_endo_reference, data(i).diastolic.endo.xyz(:));
%         % [data(i).diastolic.epi.procrustes_d, data(i).diastolic.epi.xyz] = procrustes(dia_epi_reference, data(i).diastolic.epi.xyz(:));
%         % [data(i).systolic.endo.procrustes_d, data(i).systolic.endo.xyz] = procrustes(sys_endo_reference, data(i).systolic.endo.xyz(:));
%         % [data(i).systolic.epi.procrustes_d, data(i).systolic.epi.xyz] = procrustes(sys_epi_reference, data(i).systolic.epi.xyz(:));
%         
%         % transform endo and epi as one shape vector
%         [data(i).diastolic.myo.procrustes_d, diastolic_myo_shapes(i).xyz, dia_myo_transform(i)] = procrustes(dia_myo_reference, data(i).diastolic.myo.xyz,'scaling',false,'reflection',false);
%         [data(i).systolic.myo.procrustes_d, systolic_myo_shapes(i).xyz, sys_myo_transform(i)] = procrustes(sys_myo_reference, data(i).systolic.myo.xyz,'scaling',false,'reflection',false); %,'scaling',false); % with scaling SMM0362 goes much smaller than the others...
%         [data(i).dia_sys.myo.procrustes_d, dia_sys_myo_shapes(i).xyz, dia_sys_myo_transform(i)] = procrustes(dia_sys_myo_reference, data(i).dia_sys.myo.xyz, 'scaling', false, 'reflection', false);
%         
%         all_training_diastolic_myo_shapes(i,:) = diastolic_myo_shapes(i).xyz(:);
%         all_training_systolic_myo_shapes(i,:) = systolic_myo_shapes(i).xyz(:);
%         all_training_dia_sys_myo_shapes(i,:) = dia_sys_myo_shapes(i).xyz(:);
%         
%         dia_myo_procrustes_d(i,p) = data(i).diastolic.myo.procrustes_d;
%         sys_myo_procrustes_d(i,p) = data(i).systolic.myo.procrustes_d;
%         dia_sys_myo_procrustes_d(i,p) = data(i).dia_sys.myo.procrustes_d;
%          
%      end
%      
%     TEST_dia_shapes = all_training_diastolic_myo_shapes;
%     TEST_sys_shapes = all_training_systolic_myo_shapes;
%     TEST_dia_sys_shapes = all_training_dia_sys_myo_shapes;
%     
%     TEST_dia_shapes( ~any(TEST_dia_shapes,2), : ) = [];
%     TEST_sys_shapes( ~any(TEST_sys_shapes,2), : ) = [];
%     TEST_dia_sys_shapes( ~any(TEST_dia_sys_shapes,2), : ) = [];
%     
%     dia_myo_mean = mean(TEST_dia_shapes);
%     sys_myo_mean = mean(TEST_sys_shapes );
%     dia_sys_myo_mean = mean(TEST_dia_sys_shapes) ;
%     
%     %calculate means
%     dia_myo_reference = reshape(dia_myo_mean,[2*1089 3]);
%     sys_myo_reference = reshape(sys_myo_mean,[2*1089 3]);
%     dia_sys_myo_reference = reshape(dia_sys_myo_mean, [4*1089 3]);
%     
%      
%      
     
     
     
end


    
    figure
    hold on
    plot(1:TEST_pI,TEST_dia_myo_procrustes_d(:,1:TEST_pI),'o')
    plot(1:TEST_pI,TEST_sys_myo_procrustes_d(:,1:TEST_pI),'o')
    plot(1:TEST_pI,TEST_dia_sys_myo_procrustes_d(:,1:TEST_pI),'o')
    xlabel 'iteration'
    ylabel ' procrustes dissimilarity measure d '
  
    
disp('finished procrustes')
end