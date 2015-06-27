function plotROC(specificity, sensitivity)
%plot specificity-sensitivity ROC curves
% figure
plot(specificity, sensitivity,'-','linewidth',5)

% title 'ejection fraction (EF) ROC'
xlabel ' specificity'
ylabel ' sensitivity'
end
