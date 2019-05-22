function [allMSPs,transitionIndicies] = calculate_allMSPcomps_BBG2018( data,plag2spinel,spinel2garnet,shallowP,deepP,TemperatureIndicies)
%The process is to:
%(1) first calculate the pressure 
%(2) then using that P calculate T and X
%(3) calculate the X difference to see if the liquid is is EQ with a
%lherzolite 


% 1-SiO2	2-TiO2	3-Al2O3	4-Fe2O3 5-Cr2O3	6-FeO	7-MnO	 8-MgO	9-NiO
% 10-CaO	11-Na2O	12-K2O	13-P2O5		14-Sum	% 15-Mg#liquid	16-Mg# equilibrum olivine	17-%Fractionated 
%18-(1-Mg#) 19-NaK# 20-Ol 21-Cpx 22-Plag 23-Qtz 24-Ox 25-Ap 26-Or 


%rows are:
% T
% oliv
% cpx
% plag
% qtz
% P

%for T and X(oliv, cpx, plag, qtz) the columns are 
%[P(kbars) 1-Mg# NaK# TiO2] which correlate to
%[XX 18 19 2]

FittedTargetVariables = {'P' 'T' 'Qtz' 'Plag' 'Oliv' 'Cpx'}; 
ModelVariables = {'P' 'T' 'Oliv' 'Cpx' 'Plag' 'Qtz' 'P'}; 
[A,ModelVariablesIndicies] = ismember(FittedTargetVariables, ModelVariables);


%%
garnet_coefficients = [1320.27862	8.46845	-203.20822	-131.93741	32.94946
0.15178	0.00607	0.24458	-0.21380	0.00061
0.19025	-0.00026	0.07393	-0.11380	-0.01420
0.72723	-0.00844	-0.34329	0.32331	-0.00847
-0.02840	0.00228	-0.00210	-0.39710	0.01803];
%%
spinel_coefficients = [1212.46356	11.96626	-96.89871	-89.35025	2.36698
0.12541	0.00826	0.19702	-0.25988	-0.02334
0.18135	0.00036	0.07063	-0.25490	0.00529
0.51563	-0.00145	-0.13040	0.78183	-0.03502
0.14882	-0.00514	-0.09775	-0.37870	0.02509];

plagioclase_coefficients = [1215.13292	10.57641	-72.53283	-198.17402	23.59003
0.13372	0.00643	0.17128	-0.24883	-0.01182
0.22989	-0.00312	-0.05660	-0.13940	-0.00617
0.38970	0.02018	-0.07470	0.48483	-0.03238
0.22515	-0.01776	-0.00339	-0.22862	0.00851];


%delete elements that have no data
data(data==0) = NaN;
Rows2Keep =  find((~all(isnan(data),2))==1); 

data = data(Rows2Keep,:); 

for i = 1:size(data,1)

%variableValues = [onesmatrix data(:,PressureIndicies)]; %add in a ones column account for the intercept



pressures = deepP:-1:shallowP;

garnetPressures =pressures(find(pressures>spinel2garnet(i)));
spinelPressures = pressures(find(pressures<=spinel2garnet(i) & pressures > plag2spinel(i)));
plagioclasePressures = pressures(find(pressures<=plag2spinel(i)));


% garnetPressures = deepP:-1:spinel2garnet(i);
% spinelPressures = spinel2garnet(i):-1:plag2spinel(i);
% plagioclasePressures = plag2spinel(i):-1:shallowP;

%Step 2 : calculate T and X

onesmatrix = ones(size(garnetPressures,2),1);
variableValues = [onesmatrix garnetPressures' repmat(data(i,TemperatureIndicies),size(onesmatrix,1),1)];
garnetTX= [garnetPressures' variableValues*garnet_coefficients'];

onesmatrix = ones(size(spinelPressures,2),1);
variableValues = [onesmatrix spinelPressures' repmat(data(i,TemperatureIndicies),size(onesmatrix,1),1)];
spinelTX= [spinelPressures' variableValues*spinel_coefficients'];

onesmatrix = ones(size(plagioclasePressures,2),1);
variableValues = [onesmatrix plagioclasePressures' repmat(data(i,TemperatureIndicies),size(onesmatrix,1),1)];
plagioclaseTX= [plagioclasePressures' variableValues*plagioclase_coefficients'];

singleDataPointResults = [garnetTX; spinelTX; plagioclaseTX]; 



allMSPs(:,:,i) = singleDataPointResults(:,ModelVariablesIndicies); 

%I'm sure there must be a better way to do this, just need to keep track of
%indicies bracketing each stablity zone
transitionIndicies_temp = [1 size(garnetPressures,2) size(garnetPressures,2)+1];
transitionIndicies_temp=[transitionIndicies_temp transitionIndicies_temp(end)+size(spinelPressures,2)-1];
transitionIndicies_temp=[transitionIndicies_temp transitionIndicies_temp(end)+1  size(plagioclasePressures,2)+transitionIndicies_temp(end)];

transitionIndicies(i,:) = transitionIndicies_temp; 


% for p = 1:size(spinelPressures,2)
% variableValues = [onesmatrix spinelPressures(p)];
% spinelTX(p,:)= [spinelPressures(p) variableValues*spinel_coefficients(1:end-1,:)'];
% end
% 
% for p = 1:size(plagioclasePressures,2)
% variableValues = [onesmatrix plagioclasePressures(p)];
% plagioclaseTX(p,:)= [plagioclasePressures(p) variableValues*plagioclase_coefficients(1:end-1,:)'];
% end

%test = [garnetTX; spinelTX; plagioclaseTX];


end





%%
% modelX_normalized = bsxfun(@rdivide,modelX,nansum(modelX,2));
% dataX_normalized = bsxfun(@rdivide,dataX,nansum(dataX,2));
% NRMSD= sqrt(sum((modelX_normalized-dataX_normalized).^2, 2));
%  fits = [RMSD,NRMSD] ;
% figure(); hold on; plot(NRMSD,RMSD,'*k')
% xlabel('NRSMD')
% ylabel('RMSD')

%%
%mat2clip(dataX)



end

