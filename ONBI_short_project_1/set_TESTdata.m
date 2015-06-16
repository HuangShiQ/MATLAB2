TESTdata = zeros(200,83);

TESTdata(:,1) = [TEST_ejectionFractions'];
%modes of variation
% TESTdata(:,2:6) = [TEST_sys_myo_b(:,1:5) ]; %from the PDM
% TESTdata(:,7:11) = [TEST_dia_myo_b(:,1:5) ];
TESTdata(:,2:16) = [TEST_dia_sys_myo_b(:,1:15) ];
%sphericity measure
TESTdata(:,17) = [TEST_dia_endo_AVratios ];
TESTdata(:,18) = [TEST_sys_endo_AVratios ];
TESTdata(:,19) = [TEST_dia_epi_AVratios ];
TESTdata(:,20) = [TEST_sys_epi_AVratios ];
% mean thickness
TESTdata(:,21) = [diaMeanT(data(1).TEST_indices)'];
TESTdata(:,22) = [sysMeanT(data(1).TEST_indices)' ];
% mean(sys thickness) - mean(dia thickness) e.g. change in mean thickness from diastole to systole
TESTdata(:,23) = [deltaMeanT(data(1).TEST_indices)' ];
%most common thickness];
TESTdata(:,24) = [diaModeT(data(1).TEST_indices)' ];
TESTdata(:,25) = [sysModeT(data(1).TEST_indices)' ];
% median thickness
TESTdata(:,26) = [diaMedianT(data(1).TEST_indices)' ];
TESTdata(:,27) = [sysMedianT(data(1).TEST_indices)' ];
%thickness variance for diastole and systole seperately
TESTdata(:,28) = [TESTdiaMyoThicknessVariance'  ];
TESTdata(:,29) = [TESTsysMyoThicknessVariance'  ];
% var(sys thickness - dia thickness)  e.g. variance in the difference between diastole and systole
TESTdata(:,30) = [TESTmyoTchangesVar' ];
% var([ dia thickness ; sys thickness])
 TESTdata(:,31) = [TEST_DiaSys_dEPI2ENDO_vars' ];
%variance of the thickness in each of the 3 different sections
TESTdata(:,32) = [cell2mat({data(data(1).TEST_indices).dia_vA_var})'  ];
TESTdata(:,33) = [cell2mat({data(data(1).TEST_indices).dia_vB_var})'  ];
TESTdata(:,34) = [cell2mat({data(data(1).TEST_indices).dia_vC_var})'  ];
TESTdata(:,35) = [cell2mat({data(data(1).TEST_indices).sys_vA_var})'  ];
TESTdata(:,36) = [cell2mat({data(data(1).TEST_indices).sys_vB_var})'  ];
TESTdata(:,37) = [cell2mat({data(data(1).TEST_indices).sys_vC_var})'  ];
TESTdata(:,38) = [cell2mat({data(data(1).TEST_indices).dia_sys_vA_var})' ];
TESTdata(:,39) = [cell2mat({data(data(1).TEST_indices).dia_sys_vB_var})' ];
TESTdata(:,40) = [cell2mat({data(data(1).TEST_indices).dia_sys_vC_var})' ];
%mean thickness for each of the 3 different sections
TESTdata(:,41) = [cell2mat({data(data(1).TEST_indices).dia_vA_mean})'  ];
TESTdata(:,42) = [cell2mat({data(data(1).TEST_indices).dia_vB_mean})'  ];
TESTdata(:,43) = [cell2mat({data(data(1).TEST_indices).dia_vC_mean})'  ];
TESTdata(:,44) = [cell2mat({data(data(1).TEST_indices).sys_vA_mean})'  ];
TESTdata(:,45) = [cell2mat({data(data(1).TEST_indices).sys_vB_mean})' ];
TESTdata(:,46) = [cell2mat({data(data(1).TEST_indices).sys_vC_mean})' ];
TESTdata(:,47) = [cell2mat({data(data(1).TEST_indices).dia_sys_vA_mean})'  ];
TESTdata(:,48) = [cell2mat({data(data(1).TEST_indices).dia_sys_vB_mean})'  ];
TESTdata(:,49) = [cell2mat({data(data(1).TEST_indices).dia_sys_vC_mean})' ];
TESTdata(:,50) = [sys_endo_volumes(data(1).TEST_indices) ];
TESTdata(:,51) = [sys_epi_volumes(data(1).TEST_indices)  ];
TESTdata(:,52) = [dia_endo_volumes(data(1).TEST_indices) ];
TESTdata(:,53) = [dia_epi_volumes(data(1).TEST_indices) ];
TESTdata(:,54) = [log(sys_endo_volumes(data(1).TEST_indices)) ];
TESTdata(:,55) = [log(sys_epi_volumes(data(1).TEST_indices)) ];
TESTdata(:,56) = [log(dia_endo_volumes(data(1).TEST_indices)) ];
TESTdata(:,57) = [log(dia_epi_volumes(data(1).TEST_indices)) ];
% sum(systole thickness)/sum(diastole thickness
% TESTdata(:,58) = [MyoThicknessSysDiaRatio(data(1).TEST_indices)' ];
TESTdata(:,58:72) = [TEST_dia_sys_dEPI2ENDOs_b(:,1:15) ];
%% training data labels
TESTdataLabels = [
    'EF                ' ;...
%     'sys myo b1        ' ;...
%     'sys myo b2        ' ;...
%     'sys myo b3        ' ;...
%     'sys myo b4        ' ;...
%     'sys myo b5        ' ;...
%     'dia myo b1        ' ;...
%     'dia myo b2        ' ;...
%     'dia myo b3        ' ;...
%     'dia myo b4        ' ;...
%     'dia myo b5        ' ;...
    'dia sys myo b1    ' ;...
    'dia sys myo b2    ' ;...
    'dia sys myo b3    ' ;...
    'dia sys myo b4    ' ;...
    'dia sys myo b5    ' ;...
    'dia sys myo b6    ' ;...
    'dia sys myo b7    ' ;...
    'dia sys myo b8    ' ;...
    'dia sys myo b9    ' ;...
    'dia sys myo b10   ' ;...
    'dia sys myo b11   ' ;...
    'dia sys myo b12   ' ;...
    'dia sys myo b13   ' ;...
    'dia sys myo b14   ' ;...
    'dia sys myo b15   ' ;...
    'diaendo sphericity' ;...
    'sysendo sphericity' ;...
    'diaepi sphericity ' ;...
    'sysepi sphericity ' ;...
    'diaMeanT          ' ;...
    'sysMeanT          ' ;...
    'deltameanT        ' ;...
    'diaModeT          ' ;...
    'sysModeT          ' ;...
    'diaMedianT        ' ;...
    'sysMedianT        ' ;...
    'diaMyoThicknessVar' ;...
    'sysMyoThicknessVar' ;...
    'myoTchangesVar    ' ;...
    'DiaSysdEPI2ENDOvar' ;...
    'dia_vA_var        ' ;...
    'dia_vB_var        ' ;...
    'dia_vC_var        ' ;...
    'sys_vA_var        ' ;...
    'sys_vB_var        ' ;...
    'sys_vC_var        ' ;...
    'dia_sys_vA_var    ' ;...
    'dia_sys_vB_var    ' ;...
    'dia_sys_vC_var    ' ;...
    'dia_vA_mean       ' ;...
    'dia_vB_mean       ' ;...
    'dia_vC_mean       ' ;...
    'sys_vA_mean       ' ;...
    'sys_vB_mean       ' ;...
    'sys_vC_mean       ' ;...
    'dia_sys_vA_mean   ' ;...
    'dia_sys_vB_mean   ' ;...
    'dia_sys_vC_mean   ' ;...
    'sys endo volume   ' ;...
    'sys epi volume    ' ;...
    'dia endo volume   ' ;...%62
    'dia epi volume    ' ;...%63
    'log sys endo vol  ' ;...%64
    'log sys epi vol   ' ;...%65
    'log dia endo vol  ' ;...%66
    'log dia epi vol   ' ;...%67
%     'sum(sysT)/sum(diaT' ;...
    'dia sys T b1      ' ;...
    'dia sys T b2      ' ;...
    'dia sys T b3      ' ;...
    'dia sys T b4      ' ;...
    'dia sys T b5      ' ;...
    'dia sys T b6      ' ;...
    'dia sys T b7      ' ;...
    'dia sys T b8      ' ;...
    'dia sys T b9      ' ;...
    'dia sys T b10     ' ;...
    'dia sys T b11     ' ;...
    'dia sys T b12     ' ;...
    'dia sys T b13     ' ;...
    'dia sys T b14     ' ;...
    'dia sys T b15     '] ;%72
    