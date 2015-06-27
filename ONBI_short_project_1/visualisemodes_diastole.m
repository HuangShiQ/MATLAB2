septumInd = [226 ;227 ;228 ;229 ;230 ;231; 232 ;233 ;234 ;498; 499;

500; 501; 502 ;503 ;504 ;505 ;762;763 ;764; 765; 766;

767 ;768 ;769]

% subplot 332
stage = 'diastole';
diaPts = 1:2178;
sysPts = 2179:4356;
Pts = diaPts;
visualisingMode = 13
%  visualisingMode2 = 13
for visualisingMode = [visualisingMode]'
    for nStd = [3;-3]'
h = figure('name',[stage,'__mode:',num2str(visualisingMode),'_nstd',num2str(nStd)])


factor = nStd
dia_sys_myo_new_shape_plus(:,visualisingMode) = dia_sys_myo_mean(:) + principle_dia_sys_myo_eigenvectors(:,visualisingMode)*(factor)*dia_sys_myo_max_b(visualisingMode,1);
dia_sys = reshape(dia_sys_myo_new_shape_plus(:,visualisingMode), [2*2178 , 3]);
dia = dia_sys(Pts,:);
% axis tight


% axis square
         x =[-50 ; 80];
          y = [-30 ; 90];
       z  =[-80; 40];
       axis([x(1) x(2) y(1) y(2) z(1) z(2)])
  title (['Mode ', num2str(visualisingMode),' ',num2str(factor),'std.' ])
% tri = data(1).diastolic.full.tri
xlabel 'x', ylabel 'y', zlabel 'z'
septumPointSize = 40;
plot3(dia(septumInd,1),dia(septumInd,2),dia(septumInd,3),'k.','markersize',septumPointSize)
patch('vertices', dia, 'faces', data(1).diastolic.full.tri, 'facecolor', 'r', 'edgecolor','none','facealpha', '0.4','FaceLighting','gouraud', 'clipping','off')
set(gca,'Visible','off','CameraViewAngle',9.1799,'CameraPositionMode','manual','CameraPosition',[1100.5323187362375; -139.9354297831031;-85.0713511792822])
hold on

%     plot3D(dia)
% for a = 50:360
%     a
% %     for b= 1:20
%         b
%         pause(0.1)
camroll(-40)
%     end
% end
 camlight('headlight')

  filename = ([stage,'_mode',num2str(visualisingMode),'_std',num2str(nStd),'.pdf'])
saveas(h,filename,'pdf')
    end
end
%%
print -depsc diastole_mode13_std-3.eps
print -depsc diastole_mode13_std+3.eps
print -depsc systole_mode13_std-3.eps
print -depsc systole_mode13_std+3.eps
%%

% mean shape 
h = figure('name',[stage,'_mean'])
set(gca,'Visible','off')
hold on
shape = reshape(dia_sys_myo_mean(:), [2*2178 , 3]);
shape = shape(Pts,:)
plot3(dia(septumInd,1),dia(septumInd,2),dia(septumInd,3),'k.','markersize',septumPointSize)

patch('vertices', shape, 'faces', data(1).diastolic.full.tri, 'facecolor', 'r', 'facealpha', '0.4', 'edgecolor', 'none','FaceLighting','gouraud', 'clipping','on')
set(gca,'Visible','off')
set(gca,'Visible','off','CameraViewAngle',9.1799,'CameraPositionMode','manual','CameraPosition',[1050.5323187362375; -139.9354297831031;-85.0713511792822])

%     plot3D(dia)


camroll(-40)
camlight('headlight')
% axis ([x(1) x(2) y(1) y(2) z(1) z(2)])

filename = ([stage,'_mean.png'])
saveas(h,filename,'png')
% hgexport(h,filename)
%%
print -depsc diastole_mean.eps
print -depsc systole_mean.eps

   

%%
subplot 332
figure
set(gca,'Visible','off')
factor = nStd
dia_sys_myo_new_shape_plus(:,visualisingMode2) = dia_sys_myo_mean(:) + principle_dia_sys_myo_eigenvectors(:,visualisingMode2)*(factor)*dia_sys_myo_max_b(visualisingMode2,1);
dia_sys = reshape(dia_sys_myo_new_shape_plus(:,visualisingMode2), [2*2178 , 3]);
dia = dia_sys(1:2178,:);
%         x = [-70 ; 40];
%         y = [-65 ; 35];
%         z = [-110 ; 40];
title (['Mode ', num2str(visualisingMode2),', ',num2str(factor),'std.' ])
% tri = data(1).diastolic.full.tri
xlabel 'x', ylabel 'y', zlabel 'z'

patch('vertices', dia, 'faces', data(1).diastolic.full.tri, 'facecolor', 'r', 'facealpha', '0.4', 'edgecolor', 'none','FaceLighting','gouraud', 'clipping','off')
camlight('right')
%     plot3D(dia)
view(225, 40)
axis ([x(1) x(2) y(1) y(2) z(1) z(2)])

subplot 334
factor = -nStd
dia_sys_myo_new_shape_minus(:,visualisingMode1) = dia_sys_myo_mean(:) + principle_dia_sys_myo_eigenvectors(:,visualisingMode1)*(factor)*dia_sys_myo_max_b(visualisingMode1,1);
shape = reshape(dia_sys_myo_new_shape_minus(:,visualisingMode1), [2*2178 , 3]);
shape = shape(1:2178,:)
patch('vertices', shape, 'faces', data(1).diastolic.full.tri, 'facecolor', 'r', 'facealpha', '0.4', 'edgecolor', 'none','FaceLighting','gouraud', 'clipping','off')
camlight('right')
%     plot3D(dia)
title (['Mode ', num2str(visualisingMode1),', ',num2str(factor),'std.' ])
view(225, 40)
axis ([x(1) x(2) y(1) y(2) z(1) z(2)])

subplot 335
shape = reshape(dia_sys_myo_mean(:), [2*2178 , 3]);
shape = shape(1:2178,:)
patch('vertices', shape, 'faces', data(1).diastolic.full.tri, 'facecolor', 'r', 'facealpha', '0.4', 'edgecolor', 'none','FaceLighting','gouraud', 'clipping','off')
camlight('right')
%     plot3D(dia)
title (['mean' ])
view(225, 40)
axis ([x(1) x(2) y(1) y(2) z(1) z(2)])



subplot 336
factor = nStd
dia_sys_myo_new_shape_plus(:,visualisingMode1) = dia_sys_myo_mean(:) + principle_dia_sys_myo_eigenvectors(:,visualisingMode1)*factor*dia_sys_myo_max_b(visualisingMode1,1);
shape = reshape(dia_sys_myo_new_shape_plus(:,visualisingMode1), [2*2178 , 3]);
dia = shape(1:2178,:);
%         x = [-70 ; 40];
%         y = [-65 ; 35];
%         z = [-110 ; 40];
title (['Mode ', num2str(visualisingMode1),', ',num2str(factor),'std.' ])
xlabel 'x', ylabel 'y', zlabel 'z'
%      plot3D(dia)
patch('vertices', dia, 'faces', data(1).diastolic.full.tri, 'facecolor', 'r', 'facealpha', '0.4', 'edgecolor', 'none','FaceLighting','gouraud',  'clipping','off')
camlight('right')
view(225, 40)
axis ([x(1) x(2) y(1) y(2) z(1) z(2)])

subplot 338
factor = -nStd
dia_sys_myo_new_shape_minus(:,visualisingMode2) = dia_sys_myo_mean(:) + principle_dia_sys_myo_eigenvectors(:,visualisingMode2)*factor*dia_sys_myo_max_b(visualisingMode2,1);
shape = reshape(dia_sys_myo_new_shape_minus(:,visualisingMode2), [2*2178 , 3]);
dia = shape(1:2178,:);
%         x = [-70 ; 40];
%         y = [-65 ; 35];
%         z = [-110 ; 40];
title (['Mode ', num2str(visualisingMode2),', ',num2str(factor),'std.' ])
xlabel 'x', ylabel 'y', zlabel 'z'
%      plot3D(dia)
patch('vertices', dia, 'faces', data(1).diastolic.full.tri, 'facecolor', 'r', 'facealpha', '0.4', 'edgecolor', 'none','FaceLighting','gouraud',  'clipping','off')
camlight('right')
view(225, 40)
axis ([x(1) x(2) y(1) y(2) z(1) z(2)])