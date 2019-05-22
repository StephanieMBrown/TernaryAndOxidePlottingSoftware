function [results] = XPTmeter_BBG2018( DataIn,TormeyData)
%fits,dataX,garnet_modelX,spinel_modelX,plag_modelX

%The process is to:
%(1) first calculate the pressure 
%(2) then using that P calculate T and X
%(3) calculate the X difference to see if the liquid is is EQ with a
%lherzolite 


% 1-SiO2	2-TiO2	3-Al2O3	4-Fe2O3 5-Cr2O3	6-FeO	7-MnO	 8-MgO	9-NiO
% 10-CaO	11-Na2O	12-K2O	13-P2O5		14-Sum	% 15-Mg#liquid	16-Mg# equilibrum olivine	17-%Fractionated 
%18-(1-Mg#) 19-NaK# 20-Ol 21-Cpx 22-Plag 23-Qtz 24-Ox 25-Ap 26-Or 

Elements = { 'SiO2'	'TiO2' 'Al2O3'	'Cr2O3'  'FeO'	'MnO'	'MgO'	'CaO'    'Na2O'	'K2O'	    'P2O5'};
targetElements = {'Temp' 'Pressure' 'SiO2'	'TiO2'	  'Al2O3' 'Cr2O3'	  'FeO'	  'MnO'	  'MgO'	  'CaO' 'Na2O'   'K2O' 'P2O5' 'NiO' 'H2O'};% 16-total 
% 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles   


[A,ElementIndicies4Target] = ismember(targetElements, Elements);
nodata = find(ElementIndicies4Target==0); 
ElementIndicies4Target(ElementIndicies4Target == 0) = max(ElementIndicies4Target); 
data = DataIn(:,ElementIndicies4Target);
%pads rows of NaNs for elements with missing data
data(:,nodata)=[NaN]; 

    
    %calculates the Mg#
    data(:,17) = (data(:,9)./40.311)./((data(:,9)./40.311) + (data(:,7)./71.846));
    
    %NaK#
    data(:,18) =  nansum(data(:,11:12),2)./nansum(data(:,10:12),2);
    
    %CaO Al2O3 ratio
    data(:,19) =  data(:,10)./data(:,5);
  
    %Ca Al ratio
    CaMoles = data(:,10)./56.078; 
    AlMoles = data(:,5 )./101.964.*2; 
    data(:,20) =  CaMoles./AlMoles;
    
    data(:,21) =  1-data(:,17);
    data = [data TormeyData];
    
    
    
Elements = {'Temp' 'Pressure' 'SiO2'	'TiO2'	  'Al2O3' 'Cr2O3'	  'FeO'	  'MnO'	  'MgO'	  'CaO' 'Na2O'   'K2O' 'P2O5' 'NiO' 'H2O' 'total' 'Mg#' 'NaK#' 'CaO/Al2O3 wt%' 'CaO/Al2O3 moles' '1-Mg#' 'Qtz' 'Plag' 'Oliv' 'Cpx' 'Pgarnet' 'Pspinel' 'Pplag'};

%rows are:
% T
% oliv
% cpx
% plag
% qtz
% P

%for T and X(oliv, cpx, plag, qtz) the columns are 
%[P(kbars) 1-Mg# NaK# TiO2] which correlate to
%[NaN 18 19 2]
Variables = {'1-Mg#' 'NaK#' 'TiO2'};
[A,TemperatureIndicies] = ismember(Variables, Elements);

    
    
%for P(kbars) the columns are 
%[oliv 1-Mg# NaK# TiO2] which correlate to
%[20 18 19 2]

Variables = {'Oliv' '1-Mg#' 'NaK#' 'TiO2'};
[A,PressureIndicies] = ismember(Variables, Elements);
onesmatrix = ones(size(data,1),1);

%%
garnet_coefficients = [1320.27862	8.46845	-203.20822	-131.93741	32.94946
0.15178	0.00607	0.24458	-0.21380	0.00061
0.19025	-0.00026	0.07393	-0.11380	-0.01420
0.72723	-0.00844	-0.34329	0.32331	-0.00847
-0.02840	0.00228	-0.00210	-0.39710	0.01803
-13.05664	132.43443	-37.43671	25.53289	0.23271];
%%
spinel_coefficients = [1212.46356	11.96626	-96.89871	-89.35025	2.36698
0.12541	0.00826	0.19702	-0.25988	-0.02334
0.18135	0.00036	0.07063	-0.25490	0.00529
0.51563	-0.00145	-0.13040	0.78183	-0.03502
0.14882	-0.00514	-0.09775	-0.37870	0.02509
-9.71026	99.48609	-23.82566	28.92794	2.61883];

plagioclase_coefficients = [1215.13292	10.57641	-72.53283	-198.17402	23.59003
0.13372	0.00643	0.17128	-0.24883	-0.01182
0.22989	-0.00312	-0.05660	-0.13940	-0.00617
0.38970	0.02018	-0.07470	0.48483	-0.03238
0.22515	-0.01776	-0.00339	-0.22862	0.00851
-18.88186	145.43161	-26.04452	36.38077	1.89916];

%Step 1: calculate P
variableValues = [onesmatrix data(:,PressureIndicies)]; %add in a ones column account for the intercept
garnetPressures = variableValues*garnet_coefficients(end,:)';
spinelPressures = variableValues*spinel_coefficients(end,:)';
plagioclasePressures = variableValues*plagioclase_coefficients(end,:)';

%Step 2 : calculate T and X
variableValues = [onesmatrix garnetPressures data(:,TemperatureIndicies)];
garnetTX= variableValues*garnet_coefficients(1:end-1,:)';

variableValues = [onesmatrix spinelPressures data(:,TemperatureIndicies)];
spinelTX= variableValues*spinel_coefficients(1:end-1,:)';

variableValues = [onesmatrix plagioclasePressures data(:,TemperatureIndicies)];
plagioclaseTX= variableValues*plagioclase_coefficients(1:end-1,:)';


%%
%Step 3 : compare the data to the differet model melt components 

%NOTE: tried using using the AIT distance, but doesn't work becuase Tormey components can be negative 
%Consider making components that don't go negative.  I like the idea of
%basalt tetrahedron components. see file
%'XPTmeter_BBG2018_testingAITdidntwork' 

FittedTargetVariables = {'Qtz' 'Plag' 'Oliv' 'Cpx'}; 
[A,FittedVariablesIndicies] = ismember(FittedTargetVariables, Elements);


ModelVariables = {'T' 'Oliv' 'Cpx' 'Plag' 'Qtz'}; 
[A,ModelVariablesIndicies] = ismember(FittedTargetVariables, ModelVariables);


dataX = data(:,FittedVariablesIndicies);
garnet_modelX = garnetTX(:,ModelVariablesIndicies);
spinel_modelX = spinelTX(:,ModelVariablesIndicies);
plag_modelX = plagioclaseTX(:,ModelVariablesIndicies);

%the same old same old way of fitting
garnetRMSD= sqrt(sum((garnet_modelX-dataX).^2, 2));
spinelRMSD= sqrt(sum((spinel_modelX-dataX).^2, 2));
plagioclaseRMSD= sqrt(sum((plag_modelX-dataX).^2, 2));

fits=[garnetRMSD spinelRMSD plagioclaseRMSD];



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

results.fits = fits;  %contains the fit values in order garnet, spinel, plag
results.dataX = dataX;   %the melt components of the data
results.garnet_modelX = garnet_modelX;  %the melt components of the garnet model
results.spinel_modelX = spinel_modelX; %the melt components of the garnet model
results.plag_modelX = plag_modelX; %the melt components of the garnet model

adiabat = 1.5; 
results.PTTmp = [garnetPressures garnetTX(:,1) garnetTX(:,1) - adiabat.*garnetPressures... 
    spinelPressures spinelTX(:,1) spinelTX(:,1) - adiabat.*spinelPressures... 
    plagioclasePressures plagioclaseTX(:,1) garnetTX(:,1) - adiabat.*plagioclasePressures];



end

