load THICKNESS
% EPI  -> struct containing the geometry of the mean epicardium (at
% END_DIASTOLE), the bulleye transform and the definition of the 17
% segments.
%
load EPI.mat
% ED_thick -> END_DIASTOLE thickness. Each column corresponds to a subject (in the order given by
% "Labels.csv"). First 100 columns are DETERMINE, from 101 to 200 are MESA.
% Each row in correspondence with the coordinates specified by EPI.xyz as
% well as EPI.bull (1098 coordinates but only 1025 are non repeated).
%
% ES_thick -> END_SYSTOLE thickness.

% To check the assignment of 17 segment convention I use the info given in
% webpage about localization of nodes.
middle_of_the_septum_ids = [234,233,232,231,230,229,228,227,226,505,504,503,502,501,500,499,498,769,768,767,766,765,764,763,762];

cmap = rand(17,3);
figure; patch('vertices',EPIj.xyz,'faces',EPIj.tri,'facecolor','interp','cdata',EPIj.xyz17); colormap( cmap ); colorbar; axis('equal'); view(3);
        line( EPIj.xyz(middle_of_the_septum_ids,1) , EPIj.xyz(middle_of_the_septum_ids,2) , EPIj.xyz(middle_of_the_septum_ids,3) ,'linewidth',4,'color','k');

figure; patch('vertices',EPIj.bull,'faces',EPIj.tri,'facecolor','interp','cdata',EPIj.xyz17); colormap( cmap ); colorbar; axis('equal');
        line( EPIj.bull(middle_of_the_septum_ids,1) , EPIj.bull(middle_of_the_septum_ids,2) , EPIj.bull(middle_of_the_septum_ids,3) ,'linewidth',4,'color','k');

figure;
subplot(211); patch('vertices',EPIj.xyz ,'faces',EPIj.tri,'facecolor','interp','cdata',ED_thick(:,1),'edgecolor','none'); colormap( autumn ); colorbar; axis('equal'); view(3);
subplot(212); patch('vertices',EPIj.bull,'faces',EPIj.tri,'facecolor','interp','cdata',ED_thick(:,1),'edgecolor','none'); colormap( autumn ); colorbar; axis('equal');
        
       
%% PCA analysis of  'ratio_thickness'
ratio_thickness = ED_thick ./ ES_thick;
da
% As the ratios are by definition positive numbers, I consider that it is
% better to perform the analysis in the LOG space. Anyway, if you prefer
% you can perform the analisis as Cartesian variables by removing the
% functions log and exp in the following.
LRT  = log( ratio_thickness );      %Log of Ratio of Thickness
mLRT = mean( LRT , 2 );             %mean of LRT, exp( mLRT ) correspond to the geometric mean of the original ratios!
resLRT = bsxfun(@minus,LRT,mLRT);   %residues of each column with respect to the mean.

[U,S,V] = svd( resLRT , 'econ' );
S = diag(S)/sqrt(size(S,1)-1);      %S are the std along each coordinate
pcaCoordsLRT = U.' * resLRT;        %pca coordinates of each subject
                                    %each column of pcaCoordsLRT corresponds
                                    %to the 200 coordinates (only 199 of them
                                    %are non-zero as can be checked by
                                    %S(200)).
%you can check!!
[ std( pcaCoordsLRT( 1,:) ) , S( 1) ]
[ std( pcaCoordsLRT(17,:) ) , S(17) ]

%with pcaCoords, each instance 's' is reconstructed as:
% exp( mLRT + U * pcaCoordsLRT(:,s) )
% compare by yourself:
[ exp( mLRT + U * pcaCoordsLRT(:,s) ) , ratio_thickness(:,s) ]

%in general
max(abs( exp( bsxfun(@plus , mLRT , U*pcaCoordsLRT ) ) - ratio_thickness ))

%or by considering only 115 pca modes:
max(abs( exp( bsxfun(@plus , mLRT , U(:,1:115) * pcaCoordsLRT(1:115,:) ) ) - ratio_thickness ))

%reconstruction behaviour by truncated modes
figure; hold on;
for m = 1:199
  err = max(abs( exp( bsxfun(@plus , mLRT , U(:,1:m) * pcaCoordsLRT(1:m,:) ) ) - ratio_thickness ));
  plot( m , err , '.' );
  pause;
end
hold off; set(gca,'yscale','log');


%interesting, the first pca Coord has apparently "as much info" about label
%class as the ejection fraction.
figure;hold on
plot( 1:100   , pcaCoordsLRT(1,1:100)   , 'ob' )
plot( 101:200 , pcaCoordsLRT(1,101:200) , 'or' )
hold off

%%
figure; hold on
histogram(pcaCoordsLRT(1,1:100))
histogram(pcaCoordsLRT(1,101:200))
legend 'DETERMINE' ' MESA'
sum(pcaCoordsLRT(1,1:100)< 0 )
sum(pcaCoordsLRT(1,101:200)> 0 )
%%
%You can consider to evaluate the classification performance of the
%20 first pcaCoords. Consider:
pcaCoordsLRT( 1:20 , : )
%where the 100 first columns correspond the DETERMINE while the second
%hundreds correspond the MESA.

%Finally, you can repeat this test using the original ratios instead of
%they logarithms. However in this case results can change if you use
% ED_THICK./ES_THICK  or the reciprocal ratio ES_THICK./ED_THICK.
% Try it yourself!!


%% On the other hand you can use the standard convention of the 17 segments.
% It can be performed by averaging along the nodes belonging to each
% segment. Again I prefer to consider the analysis on the log of the
% ratio, to avoid the dependence on the order of the ratio. In this case
% each averaging corresponds to the "geometric mean" along the nodes of the
% segment.

LRT_on_segments = [];
for s = 1:17
  LRT_on_segments(s,:) = mean( LRT( EPI.xyz17 == s ,:) , 1 );
end
% obtaining 17 rows and 200 columns.
%You can evaluate the classification performance these 17 features.

%As a double check, after a quick evaluation, I found that segments number
% 3, 8, 10, 11, 12, 13, 14 and 15 are "well" correlated with the label
% class.

% I don't understand why those segments have information about the clinical
% label but we can discuss about it.


