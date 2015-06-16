%% visualise eigenvalue contributions
dia_myo_normalisedEigvalues = sorted_dia_myo_eigenvalues/(sum(sorted_dia_myo_eigenvalues));
sys_myo_normalisedEigvalues = sorted_sys_myo_eigenvalues/(sum(sorted_sys_myo_eigenvalues));
dia_sys_myo_normalisedEigvalues = sorted_dia_sys_myo_eigenvalues/(sum(sorted_dia_sys_myo_eigenvalues));
dia_sys_CS = cumsum(dia_sys_myo_normalisedEigvalues);
dia_CS = cumsum(dia_myo_normalisedEigvalues);
sys_CS = cumsum(sys_myo_normalisedEigvalues);

figure
nEig = 15;
hold on
plot(dia_CS(1:100))
plot(sys_CS(1:100))
plot(1:nEig,(dia_CS(1:nEig)),'o')
% dia_CS(1:nEig)
plot(1:nEig,(sys_CS(1:nEig)),'*')
xlabel 'eigenmode'
ylabel 'contribution'
legend 'diastole' 'systole'
hold off


figure
hold on
plot(dia_sys_CS(1:100))
eigVal = 1:nEig
plot(eigVal,(dia_sys_CS(eigVal)),'o')
xlabel 'eigenmode'
ylabel 'contribution'
legend 'diastole and systole'
hold off

