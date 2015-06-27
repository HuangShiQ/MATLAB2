
diaPts = [1 :1089];
sysPts = [1090: 2178];



R     = linspace( 0 , 1    , size( meridian , 2 )   );
THETA = linspace( 0 , 2*pi , size( meridian , 1 )+1 );
X     = bsxfun( @times , R , cos(THETA).' );
Y     = bsxfun( @times , R , sin(THETA).' );

%%
factor1=nStd
dia_sys_dEPI2ENDOs_plus(:,visualisingMode1) = dia_sys_dEPI2ENDOs_mean(:) + principle_dia_sys_dEPI2ENDOs_eigenvectors(:,visualisingMode1)*(factor1)*dia_sys_dEPI2ENDOs_max_b(visualisingMode1);
factor2=-nStd
dia_sys_dEPI2ENDOs_minus(:,visualisingMode1) = dia_sys_dEPI2ENDOs_mean(:) + principle_dia_sys_dEPI2ENDOs_eigenvectors(:,visualisingMode1)*(factor2)*dia_sys_dEPI2ENDOs_max_b(visualisingMode1);
visualisingMode1

clear shape

shape1 = dia_sys_dEPI2ENDOs_minus(:,visualisingMode1)';
shape_1 = shape1(sysPts)';
v(:,:,1) = shape_1(meridian);

shape2 =dia_sys_dEPI2ENDOs_mean';
shape_2 = shape2(sysPts)';
v(:,:,2) = shape_2(meridian);

shape3 = dia_sys_dEPI2ENDOs_plus(:,visualisingMode1)';
shape_3 = shape3(sysPts)';
v(:,:,3) = shape_3(meridian);

shape_diff = shape2 - shape1';
shape_diff = shape_diff(sysPts)';
v(:,:,4) = shape_diff(meridian);
max_v = max(max(v(:,:,:)));
min_v = min(min(v(:,:,:)));


 
figure('name', 'PCA on myocardium thicknesses, systole')
subplot 221
    title (['systole , mode:', num2str(visualisingMode1),' ',num2str(factor2),'std']);
    colormap jet
    tmp_v = v(:,:,1);
    surf( X , Y , tmp_v([1:end 1],:) ,'facecolor','interp'); view(2)
    axis ([-1 1 -1 1])
    c = colorbar;
    caxis([min(min_v) max(max_v) ])
    axis square
 subplot 222
    tmp_v = v(:,:,2);
    title 'systole mean'
    colormap jet
    surf( X , Y , tmp_v([1:end 1],:) ,'facecolor','interp'); view(2)
    axis ([-1 1 -1 1])
    c = colorbar;
    caxis([min(min_v) max(max_v) ])
    axis square   
subplot 223
    title (['systole , mode:', num2str(visualisingMode1),' ',num2str(factor1),'std']);
    colormap jet
    tmp_v = v(:,:,3);
    surf( X , Y , tmp_v([1:end 1],:) ,'facecolor','interp'); view(2)
    axis ([-1 1 -1 1])
    c = colorbar;
    caxis([min(min_v) max(max_v) ])
    axis square    
subplot 224
    title 'difference from mean'
    colormap jet
    tmp_v = v(:,:,4);
    surf( X , Y , tmp_v([1:end 1],:) ,'facecolor','interp'); view(2)
    axis ([-1 1 -1 1])
    c = colorbar;
    caxis([min(min_v) max(max_v) ])
    axis square    
  
 


