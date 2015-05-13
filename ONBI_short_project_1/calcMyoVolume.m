function[data] = calcMyoVolume(data, myoB)

% for i = 1:400 %all patients
for i = 1:401
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
    
    plot3D(data(i).systolic.epi.B.xyz)
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
    
    
  patch('vertices',data(i).systolic.myo.xyz,'faces',data(i).systolic.myo.tri,'FaceColor','r')
    
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

end