
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
% clear max_v
% clear min_v
% clear v
shape1 = dia_sys_dEPI2ENDOs_minus(:,visualisingMode1)';
shape_1 = shape1(diaPts)';
dia_v(:,:,1) = shape_1(meridian);

shape2 =dia_sys_dEPI2ENDOs_mean';
shape_2 = shape2(diaPts)';
dia_v(:,:,2) = shape_2(meridian);

shape3 = dia_sys_dEPI2ENDOs_plus(:,visualisingMode1)';
shape_3 = shape3(diaPts)';
dia_v(:,:,3) = shape_3(meridian);

% shape_diff = shape2 - shape1';
% shape_diff = shape_diff(diaPts)';
%  dia_v(:,:,4) = shape_diff(meridian);
 max_v = max(max(sys_v(:,:,:)));
  min_v = min(min(sys_v(:,:,:)));


 
h = figure('name', 'PCA on myocardium thicknesses, diastole')

    set(gca,'visible','off')
%     title (['dia , mode:', num2str(visualisingMode1),' ',num2str(factor2),'std']);
    colormap jet
    tmp_v = dia_v(:,:,1);
    hold on
    surf( X(:,1:11) , Y(:,1:11) , tmp_v([1:end 1],1:11) ,'facecolor','interp','edgecolor','none'); view(2)
     surf( X(:,12:22) , Y(:,12:22) , tmp_v([1:end 1],12:22) ,'facecolor','interp','edgecolor','none'); view(2)
   surf( X(:,23:33) , Y(:,23:33) , tmp_v([1:end 1],23:33) ,'facecolor','interp','edgecolor','none'); view(2)


    axis ([-1 1 -1 1])
    c = colorbar;
    caxis([min(min_v) max(max_v) ])
    axis square
    saveas(h,'ED_minus3std_thickness','pdf')
    
h = figure('name','ED mean')
    tmp_v = dia_v(:,:,2);
    set(gca,'visible','off')
%     title 'dia mean'
    colormap jet
    hold on
      surf( X(:,1:11) , Y(:,1:11) , tmp_v([1:end 1],1:11) ,'facecolor','interp','edgecolor','none'); view(2)
     surf( X(:,12:22) , Y(:,12:22) , tmp_v([1:end 1],12:22) ,'facecolor','interp','edgecolor','none'); view(2)
   surf( X(:,23:33) , Y(:,23:33) , tmp_v([1:end 1],23:33) ,'facecolor','interp','edgecolor','none'); view(2)

   
    axis ([-1 1 -1 1])
    c = colorbar;
    caxis([min(min_v) max(max_v) ])
    axis square   
    saveas(h,'ED_mean_thickness','pdf')
h = figure('name',(['dia , mode:', num2str(visualisingMode1),' ',num2str(factor1),'std']))
    set(gca,'visible','off')
%     title (['dia , mode:', num2str(visualisingMode1),' ',num2str(factor1),'std']);
    colormap jet
    tmp_v = dia_v(:,:,3);
    hold on
       surf( X(:,1:11) , Y(:,1:11) , tmp_v([1:end 1],1:11) ,'facecolor','interp','edgecolor','none'); view(2)
     surf( X(:,12:22) , Y(:,12:22) , tmp_v([1:end 1],12:22) ,'facecolor','interp','edgecolor','none'); view(2)
   surf( X(:,23:33) , Y(:,23:33) , tmp_v([1:end 1],23:33) ,'facecolor','interp','edgecolor','none'); view(2)

   

    axis ([-1 1 -1 1])
    c = colorbar;
    caxis([min(min_v) max(max_v) ])
    axis square  
    saveas(h,'ED_+3std_thickness','pdf')
% figure
%     title 'difference from mean'
%     colormap jet
%     tmp_v = v(:,:,4);
%     hold on
%        surf( X(:,1:11) , Y(:,1:11) , tmp_v([1:end 1],1:11) ,'facecolor','interp','edgecolor','none'); view(2)
%      surf( X(:,12:22) , Y(:,12:22) , tmp_v([1:end 1],12:22) ,'facecolor','interp','edgecolor','none'); view(2)
%    surf( X(:,23:33) , Y(:,23:33) , tmp_v([1:end 1],23:33) ,'facecolor','interp','edgecolor','none'); view(2)
% 
% 
%     axis ([-1 1 -1 1])
%     c = colorbar;
%     caxis([min(min_v) max(max_v) ])
%     axis square    
%   
%  


