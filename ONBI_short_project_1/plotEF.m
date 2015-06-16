function plotEF(data)

EF_figure = figure;
hold on
nBins = 30;
histogram(cell2mat({data((data(1).MESA_indices)).ejectionFraction}),nBins)
histogram(cell2mat({data((data(1).DETERMINE_indices)).ejectionFraction}),nBins)

xlabel ('Ejection Fraction (%)')
ylabel 'frequency'
xlim([0 100])
legend 'MESA' 'DETERMINE'
set(gca,'FontSize',22);
saveas(EF_figure,'Ejection_fraction_histograms','fig')

EF_figure = figure;
hold on
nBins = 30;
histogram(cell2mat({data((data(1).TEST_indices)).ejectionFraction}),nBins)
xlabel ('Ejection Fraction (%)')
ylabel 'frequency'
xlim([0 100])
legend 'TEST data'
set(gca,'FontSize',22);
saveas(EF_figure,'TEST_data__Ejection_fraction_histograms','fig')



end