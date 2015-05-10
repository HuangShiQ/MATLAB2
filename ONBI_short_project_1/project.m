%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ONBI SHORT PROJECT 1
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jack Allen
% Supervisor: Vicente Grau
%

%% Initialise
clear all
close all
clc

setenv('path',[getenv('path'),';','C:\Users\jesu2687\Documents\MATLAB\ErnestoCode\Tools\MESHES\vtk_libs']);
addpath('C:\Users\jesu2687\Documents\MATLAB\ONBI_short_project_1')
addpath C:\Users\jesu2687\Documents\MATLAB\ErnestoCode\Tools\MESHES\
addpath C:\Users\jesu2687\Documents\MATLAB\ErnestoCode\Tools
addpath C:\Users\jesu2687\Documents\MATLAB\ErnestoCode\
load('C:\Users\jesu2687\Documents\MATLAB\ONBI_short_project_1\project1_data.mat');
load('C:\Users\jesu2687\Documents\MATLAB\ONBI_short_project_1\labels.mat');

%store indices that allow us to indentify which study (DETERMINE or MESA)
%each case belongs to.
% (DETERMINE = mycardium has been infarcted)
% (MESA = asymptomatic)
DETERMINE_indices = Labels(2:101,3);
MESA_indices = Labels(102:201,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make lid for myocardium
% disp('make lid for myocardium')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALCULATE ENDO AND EPI VOLUMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('calculating endo and epi volumes')
%!!!!!!!!!!!!SPLIT calcVolumes INTO MULTIPLE FUNCTIONS!!!!!!!!!!!
%[transformed_data.systolic.epi.tri, transformed_data.systolic.endo.tri, transformed_data.diastolic.epi.tri, transformed_data.diastolic.endo.tri ] = addLid(transformed_data);

% [sys_epi_volumes, sys_endo_volumes, dia_epi_volumes, dia_endo_volumes] = calcVolumes(transformed_data);
[sys_epi_volumes, sys_endo_volumes, dia_epi_volumes, dia_endo_volumes,] = calcVolumes(data);
%store volumes
for i = 1:400
    data(i).diastolic.endo.volume = dia_endo_volumes(i,1);
    data(i).diastolic.epi.volume = dia_epi_volumes(i,1);
    data(i).systolic.endo.volume = sys_endo_volumes(i,1);
    data(i).systolic.epi.volume = sys_epi_volumes(i,1);
    
%     data(i).diastolic.endo.volume = dia_endo_volumes(i,1);
%     data(i).diastolic.epi.volume = dia_epi_volumes(i,1);
%     data(i).systolic.endo.volume = sys_endo_volumes(i,1);
%     data(i).systolic.epi.volume = sys_epi_volumes(i,1);
end

%store volumes
% DETERMINE_indices = sort(DETERMINE_indices);
for i = DETERMINE_indices 
    for d = find(DETERMINE_indices==i)
    DETERMINE_diastolic_endoVolumes(d,1) = dia_endo_volumes(i,1);
    DETERMINE_systolic_endoVolumes(d,1) = sys_endo_volumes(i,1);
    DETERMINE_diastolic_epiVolumes(d,1) = dia_epi_volumes(i,1);
    DETERMINE_systolic_epiVolumes(d,1) = sys_epi_volumes(i,1);
    end
end
% MESA_indices = sort(MESA_indices);
for i = MESA_indices
    for m = find(MESA_indices==i)
        i;
        m;
    MESA_diastolic_endoVolumes(m,1) = dia_endo_volumes(i,1);
    MESA_systolic_endoVolumes(m,1) = sys_endo_volumes(i,1);
    MESA_diastolic_epiVolumes(m,1) = dia_epi_volumes(i,1);
    MESA_systolic_epiVolumes(m,1) = sys_epi_volumes(i,1);
    end
end

disp('finished calculating endo and epi volumes')

%% plot volume histograms - comparing DETERMINE with MESA
% 1mm^3 = 0.001ml
%diastolic endocardium volumes
figure
hold on
nbins = 25;
histogram((DETERMINE_diastolic_endoVolumes*0.001),nbins)
histogram(MESA_diastolic_endoVolumes*0.001,nbins)
legend 'DETERMINE' ' MESA'
title 'diastolic endocardium volumes'
xlabel 'endocardium volume (ml)'
ylabel 'frequency'
print('compare diastolic endocardium volumes','-dpng')

% systolic endocardium volumes
figure
hold on
nbins = 25;
histogram(DETERMINE_systolic_endoVolumes*0.001,nbins)
histogram(MESA_systolic_endoVolumes*0.001,nbins)
legend 'DETERMINE' ' MESA'
title 'systolic endocardium volumes'
xlabel 'endocardium volume (ml)'
ylabel 'frequency'
print('compare systolic endocardium volumes','-dpng')

%calculate endocardium ejection fractions EF
% SV = diastolic volume - systolic volume
% EF = (SV/(diastolic volume))*100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  CALCULATE EJECTION FRACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = DETERMINE_indices 
    i;
    for d = find(DETERMINE_indices==i)
DETERMINE_SV(d,1) = DETERMINE_diastolic_endoVolumes(d,1) - DETERMINE_systolic_endoVolumes(d,1);
DETERMINE_EF(d,1) = (DETERMINE_SV(d,1)./DETERMINE_diastolic_endoVolumes(d,1))*100;
    end
end
for i = MESA_indices 
    for d = find(MESA_indices==i)
        
MESA_SV(d,1) = MESA_diastolic_endoVolumes(d,1) - MESA_systolic_endoVolumes(d,1);
MESA_EF(d,1) = (MESA_SV(d,1)./MESA_diastolic_endoVolumes(d,1))*100;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  CALCULATE ACCURACIES 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:100
% if we class over threshold as MESA ('negative') and under threshold as
% DETERMINE ('positive')
positive = DETERMINE_EF;
negative = MESA_EF;
false_negative(i) = sum(positive>i);
true_negative(i) = sum(negative>i);
true_positive(i) = sum(positive<i);
false_positive(i) = sum(negative<i);
%fraction, not percentage
accuracy(i) = (true_positive + true_negative)/(true_positive + false_positive + false_negative + true_negative);

sensitivity(i) = true_positive(i)/(true_positive(i)+false_negative(i));
specificity(i) = true_negative(i)/(true_negative(i)+false_positive(i));
end
%% plot specificity-sensitivity ROC curves
figure
plot(specificity, sensitivity)
title 'ejection fraction (EF) ROC'
xlabel ' specificity'
ylabel ' sensitivity'

%% plot accuracy versus threshold
figure
plot(accuracy);
%find threshold that gives greatest accuracy
threshold = find(accuracy == max(accuracy));
hold on
plot([threshold threshold],[0.48 0.66], 'g')
plot([0 100],[max(accuracy)  max(accuracy)], 'g')
trial = 55;
plot([trial trial],[0.48 0.66], 'r')
ylabel 'accuracy'
xlabel 'ejection fraction threshold %'
 
%% plot ejection fraction 
figure
hold on
nbins =30;
histogram(DETERMINE_EF, nbins)
histogram(MESA_EF, nbins)
title 'Ejection fractions'
xlabel 'Ejection fraction (%)'
ylabel 'frequency'
hold on
% print('compare ejection fractions','-dpng')
plot([threshold threshold],[0 15], 'g')
legend 'DETERMINE' 'MESA' 'Threshold'

%% plot stroke volume (SV)
figure
hold on
nbins =30;
histogram(DETERMINE_SV*0.001, nbins)
histogram(MESA_SV*0.001, nbins)
legend 'DETERMINE' 'MESA'
title 'Stroke volumes'
xlabel 'Stroke volume (ml)'
ylabel 'frequency'
% print('compare stroke volumes','-dpng')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALCULATE MYOCARDIUM VOLUMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('calculating myocardium volumes')

%load struct containing the triangle file for the myo 'donut' shaped lid
load('C:\Users\jesu2687\Documents\MATLAB\ONBI_short_project_1\myoB_tri.mat') 

% for i = 1:400 %all patients
for i = 1:400;
% Find endo and epi boundary points (B.xyz)
% vtkCleanPolyData(EPI_ED) fix the possible replicated nodes and spurious
% edges.
data(i).diastolic.endo.B = vtkFeatureEdges( vtkCleanPolyData(data(i).diastolic.endo) , 'BoundaryEdgesOn' , [] , 'FeatureEdgesOff' , [] );  %extracting the boundary
data(i).diastolic.endo.B.xyz = data(i).diastolic.endo.B.xyz( [2 1 3:end], : );  %fixing the connectivity.
data(i).diastolic.epi.B = vtkFeatureEdges( vtkCleanPolyData(data(i).diastolic.epi) , 'BoundaryEdgesOn' , [] , 'FeatureEdgesOff' , [] );  %extracting the boundary
data(i).diastolic.epi.B.xyz = data(i).diastolic.epi.B.xyz( [2 1 3:end], : );  %fixing the connectivity.
data(i).systolic.endo.B = vtkFeatureEdges( vtkCleanPolyData(data(i).systolic.endo) , 'BoundaryEdgesOn' , [] , 'FeatureEdgesOff' , [] );  %extracting the boundary
data(i).systolic.endo.B.xyz = data(i).systolic.endo.B.xyz( [2 1 3:end], : );  %fixing the connectivity.
data(i).systolic.epi.B = vtkFeatureEdges( vtkCleanPolyData(data(i).systolic.epi) , 'BoundaryEdgesOn' , [] , 'FeatureEdgesOff' , [] );  %extracting the boundary
data(i).systolic.epi.B.xyz = data(i).systolic.epi.B.xyz( [2 1 3:end], : );  %fixing the connectivity.

%Find full shape boundary points (B.xyz)
% full = full shape without myo lid
data(i).diastolic.full.xyz = [data(i).diastolic.endo.xyz ; data(i).diastolic.epi.xyz ];
data(i).diastolic.full.tri = [data(i).diastolic.endo.tri ; data(i).diastolic.epi.tri + size(data(i).diastolic.endo.xyz,1) ];
data(i).diastolic.full.B = vtkFeatureEdges( vtkCleanPolyData(data(i).diastolic.full) , 'BoundaryEdgesOn' , [] , 'FeatureEdgesOff' , [] );  %extracting the boundary
data(i).diastolic.full.B.xyz = data(i).diastolic.full.B.xyz( [2 1 3:end], : );  %fixing the connectivity.
data(i).systolic.full.xyz = [data(i).systolic.endo.xyz ; data(i).systolic.epi.xyz ];
data(i).systolic.full.tri = [data(i).systolic.endo.tri ; data(i).systolic.epi.tri + size(data(i).systolic.endo.xyz,1) ];
data(i).systolic.full.B = vtkFeatureEdges( vtkCleanPolyData(data(i).systolic.full) , 'BoundaryEdgesOn' , [] , 'FeatureEdgesOff' , [] );  %extracting the boundary
data(i).systolic.full.B.xyz = data(i).systolic.full.B.xyz( [2 1 3:end], : );  %fixing the connectivity.

%join the list of coordinates for endo and epi to be used to make myo lid
data(i).diastolic.myo.B.xyz = [data(i).diastolic.endo.B.xyz ; data(i).diastolic.epi.B.xyz]; 
data(i).systolic.myo.B.xyz = [data(i).systolic.endo.B.xyz ; data(i).systolic.epi.B.xyz]; 

% find nearest points on endo and epi boundaries (identically positioned, but not connected to main shape) and assign them as the
% boundary of the lid.
% first arg = a mesh, second arg = a list of point coordinates.
data(i).diastolic.myo.B.xyz = data(i).diastolic.full.xyz( vtkClosestPoint( data(i).diastolic.full, data(i).diastolic.myo.B.xyz ) , : );
data(i).systolic.myo.B.xyz = data(i).systolic.full.xyz( vtkClosestPoint( data(i).systolic.full , data(i).systolic.myo.B.xyz ) , : );

%Make fully closed myocardium volume by appending epi surface, endo
%surface and myo lid.
data(i).diastolic.myo.xyz = [ data(i).diastolic.endo.xyz ; data(i).diastolic.myo.B.xyz ; data(i).diastolic.epi.xyz ];
data(i).diastolic.myo.tri = [ data(i).diastolic.endo.tri; myoB.tri + size( data(1).diastolic.endo.xyz , 1 ) ; data(i).diastolic.epi.tri + size( data(1).diastolic.endo.xyz , 1 ) + size(data(i).diastolic.myo.B.xyz,1) ];
data(i).systolic.myo.xyz = [ data(i).systolic.endo.xyz ; data(i).systolic.myo.B.xyz ; data(i).systolic.epi.xyz ];
data(i).systolic.myo.tri = [ data(i).systolic.endo.tri; myoB.tri + size( data(1).systolic.endo.xyz , 1 ) ; data(i).systolic.epi.tri + size( data(1).systolic.endo.xyz , 1 ) + size(data(i).systolic.myo.B.xyz,1) ];

%make sure that the normal to each triangle points outwards.
data(i).diastolic.myo = FixNormals(data(i).diastolic.myo );
data(i).systolic.myo = FixNormals(data(i).systolic.myo );

%calculate volume of myocardium.
[data(i).diastolic.myoVolume, data(i).diastolic.myoCenterOfMass] = MeshVolume( data(i).diastolic.myo );
[data(i).systolic.myoVolume, data(i).systolic.myoCenterOfMass] = MeshVolume( data(i).systolic.myo );

% %Compare myo volume with epi volume.
% %transformed_data(i).diastolic.myodifference_volume = prod(diff( BBMesh( transformed_data(i).diastolic.myoB_full ) , 1  , 1 ) ) - transformed_data(i).diastolic.myoVolume ;   %%it shoud be positive!!
% transformed_data(i).diastolic.myodifference_volume =  transformed_data(i).diastolic.epi.volume - transformed_data(i).diastolic.myoVolume ;   %%it shoud be positive!!
% transformed_data(i).systolic.myodifference_volume = transformed_data(i).systolic.epi.volume - transformed_data(i).systolic.myoVolume ;   %%it shoud be positive!!

end

disp('finished calculating myocardium volumes')
%% store volumes
for i = 1:400
     dia_myovolumes(i) = data(i).diastolic.myoVolume;
     sys_myovolumes(i) = data(i).systolic.myoVolume;
end
for i = DETERMINE_indices 
    for d = find(DETERMINE_indices==i)
    DETERMINE_diastolic_myovolumes(d,1) = dia_myovolumes(i);
    DETERMINE_systolic_myovolumes(d,1) =  sys_myovolumes(i);
    end
end

for i = MESA_indices 
    for m = find(MESA_indices==i)
    MESA_diastolic_myovolumes(m,1) = dia_myovolumes(i);
    MESA_systolic_myovolumes(m,1) = sys_myovolumes(i);
    end
end

%% plot systolic myocardium volumes
figure
hold on
nbins = 25;
histogram(DETERMINE_systolic_myovolumes*0.001,nbins)
histogram(MESA_systolic_myovolumes*0.001,nbins)
legend 'DETERMINE' 'MESA'
title 'systolic myocardium volumes'
xlabel 'myocardium volume (ml)'
ylabel 'frequency'
print('compare systolic myocardium volumes','-dpng')

% plot diastolic myocardium volumes
figure
hold on
nbins = 25;
histogram(DETERMINE_diastolic_myovolumes*0.001,nbins)
histogram(MESA_diastolic_myovolumes*0.001,nbins)
legend ' DETERMINE ' ' MESA '
title 'diastolic myocardium volumes'
xlabel 'myocardium volume (ml)'
ylabel 'frequency'
print('compare diastolic myocardium volumes','-dpng')

%% calculate "myocardium ejection fraction" myoEF
% myoSV = diastolic myovolume - systolic myovolume
% myoEF = (myoSV/(diastolic volume))*100
for i = 1:100
    DETERMINE_myoSV(i,1) = DETERMINE_diastolic_myovolumes(i,1) - DETERMINE_systolic_myovolumes(i,1);
    DETERMINE_myoEF(i,1) = (DETERMINE_myoSV(i,1)/DETERMINE_diastolic_myovolumes(i,1))*100;
    
    MESA_myoSV(i,1) = MESA_diastolic_myovolumes(i,1) - MESA_systolic_myovolumes(i,1);
    MESA_myoEF(i,1) = (MESA_myoSV(i,1)/MESA_diastolic_myovolumes(i,1))*100;
end

%% plot myocardium "Stroke volumes"
figure;
hold on
nbins = 25;
histogram(DETERMINE_myoSV*0.001,nbins)
histogram(MESA_myoSV*0.001,nbins)
legend 'DETERMINE' ' MESA'
title 'stroke volumes calculated using myocardium volumes'
xlabel ' "Stroke volume" ml '
ylabel 'frequency'
print('compare stroke volumes calculated from myocardium volumes','-dpng')

%plot myocardium "ejection fractions"
figure;
hold on
nbins = 25;
histogram(DETERMINE_myoEF,nbins)
histogram(MESA_myoEF,nbins)
legend 'DETERMINE' ' MESA'
title 'ejection fractions calculated using myocardium volumes'
xlabel '"Ejection fraction" (%)'
ylabel 'frequency'
print('compare ejection fractions calculated from myocardium volumes','-dpng')
%% myocardium visualisation
close all
%visualise the endo and epi edge points (labelled), with all the other points from
%endo and epi.
figure
%subplot 221
hold on
plot3(data(i).diastolic.myo.B.xyz(:,1),data(i).diastolic.myo.B.xyz(:,2), data(i).diastolic.myo.B.xyz(:,3))
text(data(i).diastolic.myo.B.xyz(:,1) ,  data(i).diastolic.myo.B.xyz(:,2) ,  data(i).diastolic.myo.B.xyz(:,3) , arrayfun( @(id)sprintf('%d',id) , 1:size(data(i).diastolic.myo.B.xyz,1) , 'un',false ) )
plot3(data(i).diastolic.full.xyz(:,1),data(i).diastolic.full.xyz(:,2), data(i).diastolic.full.xyz(:,3),'o')
legend('endo and epi edge points (myo B)', 'all endo and epi points')

%visualise surfaces: endo, epi and myo lid
%cla
figure
%subplot 222
patch('vertices',data(i).diastolic.endo.xyz,'faces',data(i).diastolic.endo.tri,'facecolor','none','EdgeColor','red')
patch('vertices',data(i).diastolic.epi.xyz,'faces',data(i).diastolic.epi.tri,'facecolor','none','EdgeColor','blue')
patch('vertices',data(i).diastolic.myo.B.xyz,'faces',myoB.tri,'facecolor','green')
legend('endo', 'epi', 'myo lid')

% visualise the myocardium mesh (solid)
%cla
figure
%subplot 223
patch('vertices',data(i).diastolic.myo.xyz,'faces',data(i).diastolic.myo.tri,'facecolor','red')
legend('full myocardium')

figure
%subplot 223
patch('vertices',data(i).systolic.myo.xyz,'faces',data(i).systolic.myo.tri,'facecolor','red')
legend('full myocardium')

%visualise center of mass within myocardium mesh
%cla
figure
%subplot 224
patch('vertices',data(i).diastolic.myo.xyz,'faces',data(i).diastolic.myo.tri,'facecolor','g','facealpha',0.1);
hold on;
plot3( data(i).diastolic.myoCenterOfMass(1) ,  data(i).diastolic.myoCenterOfMass(2) ,  data(i).diastolic.myoCenterOfMass(3) , '*r','markers',20 ); hold off
legend('full myocardium', 'myocardium center of mass')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALCULATE MESH AREAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate triangle side lengths
%!!!!! NEED TO CORRECT THIS TO INCLUDE THE LIDS
for i = 1:400 
    for d = find(MESA_indices==i)
       
       MESA_dia_endo_sides = calcTriSides(data(i).diastolic.endo.tri, data(i).diastolic.endo.xyz); 
       MESA_dia_endo_areas(d,1) = calcTriMeshArea(MESA_dia_endo_sides);
          
       MESA_dia_epi_sides = calcTriSides(data(i).diastolic.epi.tri, data(i).diastolic.epi.xyz);
       MESA_dia_epi_areas(d,1) = calcTriMeshArea(MESA_dia_epi_sides);
       
       MESA_sys_endo_sides = calcTriSides(data(i).systolic.endo.tri, data(i).systolic.endo.xyz);
       MESA_sys_endo_areas(d,1) = calcTriMeshArea(MESA_sys_endo_sides);
       
       MESA_sys_epi_sides = calcTriSides(data(i).systolic.epi.tri, data(i).systolic.epi.xyz);
       MESA_sys_epi_areas(d,1) = calcTriMeshArea(MESA_sys_epi_sides);
       
       MESA_dia_myo_sides = calcTriSides(data(i).diastolic.myo.tri, data(i).diastolic.myo.xyz);
       MESA_dia_myo_areas(d,1) = calcTriMeshArea(MESA_dia_myo_sides);
       
       MESA_sys_myo_sides = calcTriSides(data(i).systolic.myo.tri, data(i).systolic.myo.xyz);
       MESA_sys_myo_areas(d,1) = calcTriMeshArea(MESA_sys_myo_sides);
    end
end
for i = 1:400
    for d = find(DETERMINE_indices==i)
       DETERMINE_dia_endo_sides = calcTriSides(data(i).diastolic.endo.tri, data(i).diastolic.endo.xyz); 
       DETERMINE_dia_endo_areas(d,1) = calcTriMeshArea(DETERMINE_dia_endo_sides);
          
       DETERMINE_dia_epi_sides = calcTriSides(data(i).diastolic.epi.tri, data(i).diastolic.epi.xyz);
       DETERMINE_dia_epi_areas(d,1) = calcTriMeshArea(DETERMINE_dia_epi_sides);
       
       DETERMINE_sys_endo_sides = calcTriSides(data(i).systolic.endo.tri, data(i).systolic.endo.xyz);
       DETERMINE_sys_endo_areas(d,1) = calcTriMeshArea(DETERMINE_sys_endo_sides);
       
       DETERMINE_sys_epi_sides = calcTriSides(data(i).systolic.epi.tri, data(i).systolic.epi.xyz);
       DETERMINE_sys_epi_areas(d,1) = calcTriMeshArea(DETERMINE_sys_epi_sides);
       
       DETERMINE_dia_myo_sides = calcTriSides(data(i).diastolic.myo.tri, data(i).diastolic.myo.xyz);
       DETERMINE_dia_myo_areas(d,1) = calcTriMeshArea(DETERMINE_dia_myo_sides);
       
       DETERMINE_sys_myo_sides = calcTriSides(data(i).systolic.myo.tri, data(i).systolic.myo.xyz);
       DETERMINE_sys_myo_areas(d,1) = calcTriMeshArea(DETERMINE_sys_myo_sides);
    end
end

%% plot surface areas
figure;
hold on
nbins = 25;
histogram(DETERMINE_dia_endo_areas,nbins)
histogram(MESA_dia_endo_areas,nbins)
legend 'DETERMINE' ' MESA'
title 'diastolic endocardium surface areas'
xlabel 'surface areas (mm^2)'
ylabel 'frequency'
print('compare diastolic endocardium surface areas','-dpng')

figure;
hold on
nbins = 25;
histogram(DETERMINE_dia_epi_areas,nbins)
histogram(MESA_dia_epi_areas,nbins)
legend 'DETERMINE' ' MESA'
title 'diastolic epicardium surface areas'
xlabel 'surface areas (mm^2)'
ylabel 'frequency'
print('compare diastolic epicardium surface areas','-dpng')

figure;
hold on
nbins = 25;
histogram(DETERMINE_sys_endo_areas,nbins)
histogram(MESA_sys_endo_areas,nbins)
legend 'DETERMINE' ' MESA'
title 'systolic endocardium surface areas'
xlabel 'surface areas (mm^2)'
ylabel 'frequency'
print('compare systolic endocardium surface areas','-dpng')


figure;
hold on
nbins = 25;
histogram(DETERMINE_sys_epi_areas,nbins)
histogram(MESA_sys_epi_areas,nbins)
legend 'DETERMINE' ' MESA'
title 'systolic epicardium surface areas'
xlabel 'surface areas (mm^2)'
ylabel 'frequency'
print('compare systolic epicardium surface areas','-dpng')

figure;
hold on
nbins = 25;
histogram(DETERMINE_dia_myo_areas,nbins)
histogram(MESA_dia_myo_areas,nbins)
legend 'DETERMINE' ' MESA'
title 'diastolic myocardium surface areas'
xlabel 'surface areas (mm^2)'
ylabel 'frequency'
print('compare diastolic myocardium surface areas','-dpng')

figure;
hold on
nbins = 25;
histogram(DETERMINE_sys_myo_areas,nbins)
histogram(MESA_sys_myo_areas,nbins)
legend 'DETERMINE' ' MESA'
title 'systolic myocardium surface areas'
xlabel 'surface areas (mm^2)'
ylabel 'frequency'
print('compare systolic myocardium surface areas','-dpng')

%% calculate surface area to volume ratios
for i =1:100
    DETERMINE_dia_endo_AVratio(i,1) = DETERMINE_dia_endo_areas(i,1)/DETERMINE_diastolic_endoVolumes(i,1);
    DETERMINE_dia_epi_AVratio(i,1) = DETERMINE_dia_epi_areas(i,1)/DETERMINE_diastolic_epiVolumes(i,1);
    DETERMINE_sys_endo_AVratio(i,1) = DETERMINE_sys_endo_areas(i,1)/DETERMINE_systolic_endoVolumes(i,1);
    DETERMINE_sys_epi_AVratio(i,1) = DETERMINE_sys_epi_areas(i,1)/DETERMINE_systolic_epiVolumes(i,1);
    
    MESA_dia_endo_AVratio(i,1) = MESA_dia_endo_areas(i,1)/MESA_diastolic_endoVolumes(i,1);
    MESA_dia_epi_AVratio(i,1) = MESA_dia_epi_areas(i,1)/MESA_diastolic_epiVolumes(i,1);
    MESA_sys_endo_AVratio(i,1) = MESA_sys_endo_areas(i,1)/MESA_systolic_endoVolumes(i,1);
    MESA_sys_epi_AVratio(i,1) = MESA_sys_epi_areas(i,1)/MESA_systolic_epiVolumes(i,1);
    
    MESA_dia_myo_AVratio(i,1) = MESA_dia_myo_areas(i,1)/MESA_diastolic_myovolumes(i,1);
    MESA_sys_myo_AVratio(i,1) = MESA_sys_myo_areas(i,1)/MESA_systolic_myovolumes(i,1);
    
    DETERMINE_dia_myo_AVratio(i,1) = DETERMINE_dia_myo_areas(i,1)/DETERMINE_diastolic_myovolumes(i,1);
    DETERMINE_sys_myo_AVratio(i,1) = DETERMINE_sys_myo_areas(i,1)/DETERMINE_systolic_myovolumes(i,1);
    
    
end

figure;
hold on
nbins = 25;
histogram(DETERMINE_dia_endo_AVratio,nbins)
histogram(MESA_dia_endo_AVratio,nbins)
legend 'DETERMINE' ' MESA'
title 'diastolic endocardium surface area to volume ratio'
xlabel 'area/volume (mm^-1)'
ylabel 'frequency'
print('compare diastolic endocardium surface areas to volume ratios','-dpng')

figure;
hold on
nbins = 25;
histogram(DETERMINE_sys_epi_AVratio,nbins)
histogram(MESA_sys_epi_AVratio,nbins)
legend 'DETERMINE' ' MESA'
title 'systolic endocardium surface area to volume ratio'
xlabel 'area/volume (mm^-1)'
ylabel 'frequency'
print('compare systolic endocardium surface area to volume ratios','-dpng')

figure;
hold on
nbins = 25;
histogram(DETERMINE_sys_endo_AVratio,nbins)
histogram(MESA_sys_endo_AVratio,nbins)
legend 'DETERMINE' ' MESA'
title 'systolic endocardium surface area to volume ratio'
xlabel 'area/volume (mm^-1)'
ylabel 'frequency'
print('compare systolic endocardium surface area to volume ratios','-dpng')

figure;
hold on
nbins = 25;
histogram(DETERMINE_sys_epi_AVratio,nbins)
histogram(MESA_sys_epi_AVratio,nbins)
legend 'DETERMINE' ' MESA'
title 'systolic epicardium surface area to volume ratio'
xlabel 'area/volume (mm^-1)'
ylabel 'frequency'
print('compare systolic epicardium surface area to volume ratios','-dpng')

figure;
hold on
nbins = 25;
histogram(DETERMINE_dia_myo_AVratio,nbins)
histogram(MESA_dia_myo_AVratio,nbins)
legend 'DETERMINE' ' MESA'
title 'diastolic myocardium surface area to volume ratio'
xlabel 'area/volume (mm^-1)'
ylabel 'frequency'
print('compare diastolic myocardium surface areas to volume ratios','-dpng')

%% calculate total areas(heron's forumla)
%!!!!! NEED TO CORRECT THIS TO INCLUDE THE LIDS
% endo_area = calcTriMeshArea(endo_sides);
% epi_area = calcTriMeshArea(epi_sides);
% %% calculate coordinates of the centroids
% %!!!!! NEED TO CORRECT THIS...ALREADY DONE BY 'calcVolume'?
% endo_centroid = mean(endo);
% epi_centroid = mean(epi);
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SUPPORT VECTOR MACHINE (SVM) CLASSIFICATION - VOLUMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot data to perform svm on
hold on
% plot3(DETERMINE_EF, DETERMINE_systolic_endoVolumes,DETERMINE_diastolic_endoVolumes,'o')
% plot3(MESA_EF, MESA_systolic_endoVolumes,MESA_diastolic_endoVolumes,'o')
plot(DETERMINE_EF, DETERMINE_systolic_endoVolumes,'o')
plot(MESA_EF, MESA_systolic_endoVolumes,'o')
hold off

%% train SVM
trainingdata(:,1) = [DETERMINE_EF ; MESA_EF];
trainingdata(:,2) = [DETERMINE_systolic_endoVolumes ; MESA_systolic_endoVolumes];
%must be column vector, with each row corresponding to the value of the 
%corresponding row in trainingdata
classNames(1:100,1) = 'd';
classNames(101:200,1) = 'm';
% names(1:100,2) = 1;
% names(101:200,2) = 2;

% svmStruct = svmtrain(trainingdata,group,'ShowPlot', true);

% SVMModel = fitcsvm(trainingdata, group, 'Standardize', true)
SVMModel = fitcsvm(trainingdata, classNames,'KernelScale','auto','Standardize',true); %'ClassNames',{'d','m'});
classOrder = SVMModel.ClassNames
figure
gscatter(trainingdata(:,1),trainingdata(:,2),classNames)
hold on
sv = SVMModel.SupportVectors;
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('DETERMINE','MESA','Support Vector')
title 'SVM for EF and sys endo volume'
hold off

%% cross-validate the SVM classifier
CVSVMModel = crossval(SVMModel_1);
%calculate classification error
misclass = kfoldLoss(CVSVMModel_1);
misclassification_rate = misclass

%% SVM prediction
[label,score] = predict(SVMModel,newX);

%% SVM: EF and myo EF
% hold on
% % plot3(DETERMINE_EF, DETERMINE_systolic_endoVolumes,DETERMINE_diastolic_endoVolumes,'o')
% % plot3(MESA_EF, MESA_systolic_endoVolumes,MESA_diastolic_endoVolumes,'o')
% plot(DETERMINE_EF, DETERMINE_myoEF,'o')
% plot(MESA_EF, MESA_myoEF,'o')

%train the SVM
trainingdata(:,1) = [DETERMINE_EF ; MESA_EF];
trainingdata(:,2) = [DETERMINE_myoEF ; MESA_myoEF];
names = char(200,1);
names(1:100,1) = 'd';
names(101:200,1) = 'm';
% names(1:100,2) = 1;
% names(101:200,2) = 2;

% svmtrain will be removed from later versions of matlab.
% svmStruct = svmtrain(trainingdata,names,'ShowPlot', true);

% SVMModel = fitcsvm(trainingdata, group, 'Standardize', true)
SVMModel = fitcsvm(trainingdata, names, 'KernelFunction', 'linear' )
classOrder = SVMModel.ClassNames
figure
title 'SVM for EF and myoEF'
gscatter(trainingdata(:,1),trainingdata(:,2),names)
hold on
sv = SVMModel.SupportVectors;
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('DETERMINE','MESA','Support Vector')
% x = 10:80;
% plot(10:80, (0.005*x)+ -7.0407);
hold off


%% cross-validate the SVM
%"Determine the out-of-sample misclassification rate"
CVSVMModel = crossval(SVMModel);
misclassification_rate = kfoldLoss(CVSVMModel)


%% performance curves
% [X,Y] = perfcurve(names,scores,posclass) 

% %Comparing classifiers
% resp(1:200,1:2) = strcmp(names,'d'); % resp = 1, if Y = 'b', or 0 if Y = 'g'
% pred = trainingdata(:,1:2);
% mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
% score_log = mdl.Fitted.Probability; % Probability estimates
% [X,Y,T,AUC] = perfcurve(names,score_svm(:,mdlSVM.ClassNames),'true');
% AUC
% resp = strcmp(names(:,1:2),'b'); 
% pred = trainingdata(:,1:2);
% mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
% score_log = mdl.Fitted.Probability;
% [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(resp,score_svm(:,mdlSVM.ClassNames),'true');

% pred = trainingdata(:,1:2);
% 
% for i = 1:200
%     if names(i,1) == 'm'
%         resp(i,1) = 1
%     else resp(i,1) = 0
%     end
% end
% 
% SVMModel_2 = fitPosterior(SVMModel_2);
% SVMModel_1 = fitPosterior(SVMModel_1);
% [~,scores2] = resubPredict(SVMModel_2);
% [~,scores1] = resubPredict(SVMModel_1);
% [x1,y1,~,auc1] = perfcurve(names,scores1(:,2),1);
% [x2,y2,~,auc2] = perfcurve(resp,scores2(:,2),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROCRUSTES ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is done by concatenating the endo and epi shape vectors to produce
% longer vectors (myo.xyz). Procrustes analysis is then performed on the
% two myo.xyz vectors. Finally, the transformed myo.xyz vectors are split
% to extract transformed endo and epi shape vectors.
disp('starting procrustes analysis')

%store dimensions of the shapes
[shape_nRows , shape_nCols] = size(data(1).diastolic.endo.xyz);

%use the initial data clouds as references (individual)
dia_endo_reference = data(1).diastolic.endo.xyz;
dia_epi_reference = data(1).diastolic.epi.xyz;
sys_endo_reference = data(1).systolic.endo.xyz;
sys_epi_reference = data(1).systolic.epi.xyz;
%make a reference from the endo and epi surfaces (concatenate)
dia_myo_reference = [dia_endo_reference(:) ; dia_epi_reference(:)];
sys_myo_reference = [sys_endo_reference(:)  ; sys_epi_reference(:)];

%initialise the sums of the shapes as zero
% dia_endo_sum = zeros(size(dia_endo_reference));
% dia_epi_sum = zeros(size(dia_epi_reference));
% sys_endo_sum = zeros(size(sys_endo_reference));
% sys_epi_sum = zeros(size(sys_epi_reference));
% (whole shape)
dia_myo_sum = zeros(size(dia_myo_reference));
sys_myo_sum = zeros(size(sys_myo_reference));

% Think of endo and epi as one shape (concatenate).
for i = 1:400
data(i).diastolic.myo.xyz = [data(i).diastolic.endo.xyz ; data(i).diastolic.epi.xyz];
data(i).systolic.myo.xyz = [data(i).systolic.endo.xyz ; data(i).systolic.epi.xyz];
end

%p = number of times procrustes is performed.
for p = 1:2
% iterate so that procrustes is performed on each case (400 patients).
for i = 1:400
% % transform endo and epi (individually)
% [data(i).diastolic.endo.procrustes_d, data(i).diastolic.endo.xyz] = procrustes(dia_endo_reference, data(i).diastolic.endo.xyz(:));
% [data(i).diastolic.epi.procrustes_d, data(i).diastolic.epi.xyz] = procrustes(dia_epi_reference, data(i).diastolic.epi.xyz(:));
% [data(i).systolic.endo.procrustes_d, data(i).systolic.endo.xyz] = procrustes(sys_endo_reference, data(i).systolic.endo.xyz(:));
% [data(i).systolic.epi.procrustes_d, data(i).systolic.epi.xyz] = procrustes(sys_epi_reference, data(i).systolic.epi.xyz(:));

% transform endo and epi as one shape vector
[data(i).diastolic.myo.procrustes_d, data(i).diastolic.myo.xyz] = procrustes(dia_myo_reference, data(i).diastolic.myo.xyz(:));
[data(i).systolic.myo.procrustes_d, data(i).systolic.myo.xyz] = procrustes(sys_myo_reference, data(i).systolic.myo.xyz(:));

%sums for finding new means later on
% dia_endo_sum = data(i).diastolic.endo.xyz + dia_endo_sum;
% dia_epi_sum = data(i).diastolic.epi.xyz + dia_epi_sum;
% sys_endo_sum = data(i).systolic.endo.xyz + sys_endo_sum;
% sys_epi_sum = data(i).systolic.epi.xyz + sys_epi_sum;
dia_myo_sum = data(i).diastolic.myo.xyz + dia_myo_sum;
sys_myo_sum = data(i).systolic.myo.xyz + sys_myo_sum;

end

%calculate means
% dia_endo_mean = dia_endo_sum/400;
% dia_epi_mean = dia_epi_sum/400;
% sys_endo_mean = sys_endo_sum/400;
% sys_epi_mean = sys_epi_sum/400;
dia_myo_mean = dia_myo_sum/400;
sys_myo_mean = sys_myo_sum/400;

%set means as the references for next round of procrustes
% dia_endo_reference = dia_endo_mean;
% dia_epi_reference = dia_epi_mean;
% sys_endo_reference = sys_endo_mean;
% sys_epi_reference = sys_epi_mean;
dia_myo_reference = dia_myo_mean; 
sys_myo_reference = sys_myo_mean;
end

% % reshape from vector to matrix.
% % individual endo and epi shapes.
% dia_endo_mean = reshape(dia_endo_mean,size(data(1).diastolic.endo.xyz));
% dia_epi_mean = reshape(dia_epi_mean,size(data(1).diastolic.endo.xyz));
% sys_endo_mean = reshape(sys_endo_mean,size(data(1).diastolic.endo.xyz));
% sys_epi_mean = reshape(sys_epi_mean,size(data(1).diastolic.endo.xyz));

% % concatenated endo and epi shapes.
% % split the long vectors into vectors that represent the endo and epi
% % shapes then reshape the resulting vectors to matrix form.
dia_myo_reference = reshape(dia_myo_reference, [2*shape_nRows, shape_nCols]);
sys_myo_reference = reshape(sys_myo_reference, [2*shape_nRows, shape_nCols]);
for i = 1:400
% reshape myo shapes from vector to matrix
data(i).diastolic.myo.xyz = reshape(data(i).diastolic.myo.xyz,[2*shape_nRows, shape_nCols]);
data(i).systolic.myo.xyz = reshape(data(i).systolic.myo.xyz,[2*shape_nRows, shape_nCols]);

% extract endo and epi shapes from full shape matrices (data(i).diastolic.myo.xyz)
data(i).diastolic.endo.xyz = data(i).diastolic.myo.xyz(1:shape_nRows, :);
data(i).diastolic.epi.xyz = data(i).diastolic.myo.xyz(shape_nRows+1:2*shape_nRows, :);
data(i).systolic.endo.xyz = data(i).systolic.myo.xyz(1:shape_nRows, :);
data(i).systolic.epi.xyz = data(i).systolic.myo.xyz(shape_nRows+1:2*shape_nRows, :);
end
disp('finished procrustes analysis')

%% Visualise procrustes


disp('visualise procrustes output')

% plotMESH = @(M,varargin)patch('vertices',M.xyz,'faces',M.tri,'edgecolor','k','facecolor','b',varargin{:});

%reference endocardium
%diastolic
figure
plot3(dia_endo_reference(:,1),dia_endo_reference(:,2),dia_endo_reference(:,3),'+')
axis equal; axis tight;
title 'reference endocardium (diastolic)'
%systolic
figure
plot3(sys_endo_reference(:,1),sys_endo_reference(:,2),sys_endo_reference(:,3),'+')
axis equal; axis tight;
title 'reference endocardium (diastolic)'

%reference epicardium
%distolic
figure
hold on
plot3(dia_epi_reference(:,1),dia_epi_reference(:,2),dia_epi_reference(:,3),'+')
axis equal; axis tight;
title 'reference epicardium (diastolic)'
%systolic
figure
plot3(sys_epi_reference(:,1),sys_epi_reference(:,2),sys_epi_reference(:,3),'+')
axis equal; axis tight;
title 'reference epicardium (systolic)'

%reference (whole LV shape from patient 1)
figure
plot3(dia_myo_reference(:,1), dia_myo_reference(:,2), dia_myo_reference(:,3),'o');
title 'reference LV'

%patient i endocardium and epicardium
%diastolic
figure
hold on
plot3(data(i).diastolic.endo.xyz(:,1), data(i).diastolic.endo.xyz(:,2), data(i).diastolic.endo.xyz(:,3),'o'); 
plot3(data(i).diastolic.epi.xyz(:,1), data(i).diastolic.epi.xyz(:,2), data(i).diastolic.epi.xyz(:,3),'o'); 
title 'patient i endo and epi, diastolic'
%systolic
figure
hold on
plot3(data(i).systolic.endo.xyz(:,1), data(i).systolic.endo.xyz(:,2), data(i).systolic.endo.xyz(:,3),'o'); 
plot3(data(i).systolic.epi.xyz(:,1), data(i).systolic.epi.xyz(:,2), data(i).systolic.epi.xyz(:,3),'o');
title 'patient i endo and epi, systolic'

%patient i whole LV shape
%diastolic
figure
hold on
plot3(data(i).diastolic.myo.xyz(:,1), data(i).diastolic.myo.xyz(:,2), data(i).diastolic.myo.xyz(:,3),'o'); 
title 'patient i, whole LV, diastolic'
%systolic
figure
hold on
plot3(data(i).systolic.myo.xyz(:,1), data(i).systolic.myo.xyz(:,2), data(i).systolic.myo.xyz(:,3),'o'); 
title 'patient i, whole LV, systolic'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SHAPE MODELING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('start shape modeling')
%% PCA
% see Cootes tutorial: http://personalpages.manchester.ac.uk/staff/timothy.f.cootes/Models/app_models.pdf

% %built in matlab method for PCA
% coeff = pca(data(1).diastolic.endo.xyz)
% figure
% hold on
% plot3(data(1).diastolic.endo.xyz(:,1), data(1).diastolic.endo.xyz(:,2), data(1).diastolic.endo.xyz(:,3),'o'); 
% plot3(coeff(:,1),coeff(:,2),coeff(:,3))

%% find mean shape and then use it to find the covariance matrix
disp('started calculating covariance and mean shape')
[dia_endo_covariance_matrix, dia_endo_mean_shape, sys_endo_covariance_matrix, sys_endo_mean_shape, sys_myo_covariance_matrix, sys_myo_mean_shape] = calcCovarianceMatrix(data);
disp('finished calculating covariance and mean shape')
%% find eigenvectors of covariance matrix.
%columns of 'dia_endo_eigenvectors' are the eigenvectors.
disp('started calculating eigenvectors of covariance matrix')
[dia_endo_eigenvectors, dia_endo_eigenvalues] = eig(dia_endo_covariance_matrix);
[sys_endo_eigenvectors, sys_endo_eigenvalues] = eig(sys_endo_covariance_matrix);
[sys_myo_eigenvectors, sys_myo_eigenvalues] = eig(sys_myo_covariance_matrix); %full shape (endo and epi)

%************how do I plot these eigenvectors?...*********
%****should I find covariance of x, y and z seperately?...************

% % Each eigenvalue gives the variance of the data about the mean in the
% % direction of the corresponding eigenvector. Compute the total variance
% totalVariance = sum(dia_endo_eigenvalues(:));
% proportion = 1;
% %Choose the first t largest eigenvalues such that
% p = proportion*totalVariance;
% a = dia_endo_eigenvalues/sum(dia_endo_eigenvalues(:));
disp('finished calculating eigenvectors of covariance matrix')
%% sort eigenvalues in descending order
sorted_dia_endo_eigenvalues = sort(dia_endo_eigenvalues(:),'descend');
sorted_sys_endo_eigenvalues = sort(sys_endo_eigenvalues(:),'descend');
sorted_sys_myo_eigenvalues = sort(sys_myo_eigenvalues(:),'descend');
%% find the positions of the greatest eigenvalues
% find the indices of the principle eigenvalue
number_of_eigenvalues = 1; % If we use 1, this is just the principle component
dia_endo_principle_eigenvalues = sorted_dia_endo_eigenvalues(1,1:number_of_eigenvalues);
sys_endo_principle_eigenvalues = sorted_sys_endo_eigenvalues(1,1:number_of_eigenvalues);
sys_myo_principle_eigenvalues = sorted_sys_myo_eigenvalues(1,1:number_of_eigenvalues);
[dia_endo_rows, dia_endo_cols] = find(dia_endo_eigenvalues(dia_endo_principle_eigenvalues));
[sys_endo_rows, sys_endo_cols] = find(sys_endo_eigenvalues(sys_endo_principle_eigenvalues));
[sys_myo_rows, sys_myo_cols] = find(sys_myo_eigenvalues(sys_endo_principle_eigenvalues));
 
%select eigenvectors with greatest eigenvalues
dia_endo_principle_eigenvectors = dia_endo_eigenvectors(:,dia_endo_cols);
sys_endo_principle_eigenvectors = sys_endo_eigenvectors(:,sys_endo_cols);
sys_myo_principle_eigenvectors = sys_myo_eigenvectors(:,sys_myo_cols);

%% Find b values - using +/- 3*sqrt(eigenvalue) as b
% systolic, endocardium
dia_endo_min_b = - 3*sqrt(dia_endo_principle_eigenvalues);
dia_endo_max_b = 3*sqrt(dia_endo_principle_eigenvalues);
sys_endo_min_b = - 3*sqrt(sys_endo_principle_eigenvalues);
sys_endo_max_b = 3*sqrt(sys_endo_principle_eigenvalues);
sys_myo_min_b = - 3*sqrt(sys_myo_principle_eigenvalues);
sys_myo_max_b = 3*sqrt(sys_myo_principle_eigenvalues);

%% (finding b by analysing each of the training shapes)
% for i = 1:400
%     dia_endo_b(i) = (dia_endo_principle_eigenvectors')*(data(i).diastolic.endo.xyz(:) - dia_endo_mean_shape);
%     sys_endo_b(i) = (sys_endo_principle_eigenvectors')*(data(i).systolic.endo.xyz(:) - sys_endo_mean_shape);
% end
% 
% % sys_endo_max_b = max(sys_endo_b);
% % sys_endo_min_b = min(sys_endo_b);
% 
% % plot(b)
% figure
% hold on
% histogram(dia_endo_b,20);
% histogram(sys_endo_b,20);
% legend 'diastolic b' 'systolic b'
% 
% dia_endo_max_b = std(dia_endo_b);
% dia_endo_min_b = -std(dia_endo_b);
% sys_endo_max_b = std(sys_endo_b);
% sys_endo_min_b = -std(sys_endo_b);

%% Calculate new shapes
% mean shape + the sum of each eigenvector times it's value of b
% !!!!!!!!!!!!!!!!!!check that this does what it is meant to...!!!!!!!
%set of the principle eigenvectors to use (eigenvalue_range)
%(can equal the number_of_eigenvectors already extracted, or we can vary it for plotting)
eigenvalue_range = 1:number_of_eigenvalues; 
dia_endo_new_shape_min = dia_endo_mean_shape + dia_endo_principle_eigenvectors(1,eigenvalue_range).*dia_endo_min_b(1,eigenvalue_range);
dia_endo_new_shape_max = dia_endo_mean_shape + dia_endo_principle_eigenvectors(1,eigenvalue_range).*dia_endo_max_b(1,eigenvalue_range);
sys_endo_new_shape_min = sys_endo_mean_shape + sys_endo_principle_eigenvectors(1,eigenvalue_range).*sys_endo_min_b(1,eigenvalue_range);
sys_endo_new_shape_max = sys_endo_mean_shape + sys_endo_principle_eigenvectors(1,eigenvalue_range).*sys_endo_max_b(1,eigenvalue_range);
sys_myo_new_shape_min = sys_myo_mean_shape + sys_myo_principle_eigenvectors(1,eigenvalue_range).*sys_myo_min_b(1,eigenvalue_range);
sys_myo_new_shape_max = sys_myo_mean_shape + sys_myo_principle_eigenvectors(1,eigenvalue_range).*sys_myo_max_b(1,eigenvalue_range);

%% visualise eigenmodes of shape variation - points
dia_endo_new_shape_min = reshape(dia_endo_new_shape_min, [1089 3]);
dia_endo_new_shape_max = reshape(dia_endo_new_shape_max, [1089 3]);
dia_endo_mean_shape = reshape(dia_endo_mean_shape, [1089 3]);
sys_endo_new_shape_min = reshape(sys_endo_new_shape_min, [1089 3]);
sys_endo_new_shape_max = reshape(sys_endo_new_shape_max, [1089 3]);
sys_endo_mean_shape = reshape(sys_endo_mean_shape, [1089 3]);
sys_myo_new_shape_min = reshape(sys_myo_new_shape_min, [1089 3]);
sys_myo_new_shape_max = reshape(sys_myo_new_shape_max, [1089 3]);
sys_myo_mean_shape = reshape(sys_myo_mean_shape, [1089 3]);
figure
title 'PCA - eigenmode visualisation - diastolic endocardium'
hold on
plot3(dia_endo_mean_shape(:,1),dia_endo_mean_shape(:,2),dia_endo_mean_shape(:,3),'g.')
plot3(dia_endo_new_shape_max(:,1),dia_endo_new_shape_max(:,2),dia_endo_new_shape_max(:,3),'ro')
plot3(dia_endo_new_shape_min(:,1),dia_endo_new_shape_min(:,2),dia_endo_new_shape_min(:,3),'bo')
legend 'mean' 'max b' 'min b'

figure
title 'PCA - eigenmode visualisation - systolic endocardium'
hold on
plot3(sys_endo_mean_shape(:,1),sys_endo_mean_shape(:,2),sys_endo_mean_shape(:,3),'g.')
plot3(sys_endo_new_shape_max(:,1),sys_endo_new_shape_max(:,2),sys_endo_new_shape_max(:,3),'ro')
plot3(sys_endo_new_shape_min(:,1),sys_endo_new_shape_min(:,2),sys_endo_new_shape_min(:,3),'bo')
legend 'mean' 'max b' 'min b'

figure
title 'PCA - eigenmode visualisation - systolic myocardium'
hold on
plot3(sys_myo_mean_shape(:,1),sys_myo_mean_shape(:,2),sys_myo_mean_shape(:,3),'g.')
plot3(sys_myo_shape_max(:,1),sys_myo_new_shape_max(:,2),sys_myo_new_shape_max(:,3),'ro')
plot3(sys_myo_new_shape_min(:,1),sys_myo_new_shape_min(:,2),sys_myo_new_shape_min(:,3),'bo')
legend 'mean' 'max b' 'min b'

%% visualise eigenmodes of shape variation - meshes
figure
patch('Vertices',sys_endo_new_shape_max,'Faces',data(1).systolic.endo.tri,'FaceColor','red')
figure
patch('Vertices',sys_endo_new_shape_min,'Faces',data(1).systolic.endo.tri,'FaceColor','blue')

dia_endo_new_shape_min = reshape(dia_endo_mean_shape + dia_endo_principle_eigenvector.*dia_endo_min_b, [1089 3]);
dia_endo_new_shape_max = reshape(dia_endo_mean_shape + dia_endo_principle_eigenvector.*dia_endo_max_b, [1089 3]);
dia_endo_mean_shape = reshape(dia_endo_mean_shape, [1089 3]);
figure 
hold on
plot3(dia_endo_mean_shape(:,1),dia_endo_mean_shape(:,2),dia_endo_mean_shape(:,3),'g.')
plot3(dia_endo_new_shape_max(:,1),dia_endo_new_shape_max(:,2),dia_endo_new_shape_max(:,3),'ro')
plot3(dia_endo_new_shape_min(:,1),dia_endo_new_shape_min(:,2),dia_endo_new_shape_min(:,3),'bo')
title 'dia endo eigenmode variation'
legend 'mean' 'max b' 'min b'

figure
patch('Vertices',dia_endo_new_shape_max,'Faces',data(1).diastolic.endo.tri,'FaceColor','red')
figure
patch('Vertices',dia_endo_new_shape_min,'Faces',data(1).diastolic.endo.tri,'FaceColor','blue')
 
% ICA
%[icaOut] = fastica(dia_endo_covariance_matrix)


disp('finished shape modeling')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SUPPORT VECTOR MACHINES - PDM 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%7
% ??? should I classify in terms of eigenvalue of each case (found by doing PCA on each case) or by b values,
%    calculated by b = (shape - meanshape)*eigenvectors' ??????????????????
trainingdata(:,1) = [DETERMINE_b_1 ; MESA_b_1]; %!!! How to find these variables??? !!!
trainingdata(:,2) = [DETERMINE_b_2 ; MESA_b_2];
names = char(200,1);
names(1:100,1) = 'd'; 
names(101:200,1) = 'm';


% svmtrain will be removed from later versions of matlab.
% svmStruct = svmtrain(trainingdata,names,'ShowPlot', true);

% SVMModel = fitcsvm(trainingdata, group, 'Standardize', true)
SVMModel = fitcsvm(trainingdata, names, 'KernelFunction', 'linear' )
% cross-validation of the SVM
CVSVMModel = crossval(SVMModel);
misclassification_rate = kfoldLoss(CVSVMModel)
