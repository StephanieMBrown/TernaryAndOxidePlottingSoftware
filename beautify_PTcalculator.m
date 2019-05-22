function [Data] = beautify_PTcalculator(DataIn,TormeyData, normalizeon)


%     
%     if strcmp(normalizeon,'normalize') == 1
%         'normalizing to the 4 mineral components ol-cpx-plag-qtz'
%         for i = 1:size(mineralComponents,1)
%             mineralComponents(i,:) = mineralComponents(i,:)./sum(mineralComponents(i,:));
%             mineralComponentsK2O(i,:) = mineralComponentsK2O(i,:)./sum(mineralComponentsK2O(i,:));
%         end
%     else
%         'not normalizing to the 4 mineral components ol-cpx-plag-qtz'
%          for i = 1:size(mineralComponents,1)
%             mineralComponents(i,:) = mineralComponents(i,:)./sum(allMineralComponents(i,:));      
%             allMineralComponents(i,:) = allMineralComponents(i,:)./sum(allMineralComponents(i,:)); 
%         end
%     end


    
    %% THERMOBAROMETRY
    % Data now has columns:
    %1-Temp 2-Pressure
    % 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
    % 13-P2O5 14-NiO 15-H2O 16-total 
    % 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles
% 
%     newColumn = size(Data,2)+1; 
%     Data(:,newColumn) = 1 - Data(:,17); 
%     
    
%               1       2       3         4      5        6     7      8          9         10         11
Elements = { 'SiO2'	'TiO2' 'Al2O3'	'Cr2O3'  'FeO'	'MnO'	'MgO'	'CaO'    'Na2O'	'K2O'	    'P2O5'};
targetElements = {'Temp' 'Pressure' 'SiO2'	'TiO2'	  'Al2O3' 'Cr2O3'	  'FeO'	  'MnO'	  'MgO'	  'CaO' 'Na2O'   'K2O' 'P2O5' 'NiO' 'H2O'};% 16-total 
% 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles   


[A,ElementIndicies4Target] = ismember(targetElements, Elements);
noData = find(ElementIndicies4Target==0); 
ElementIndicies4Target(ElementIndicies4Target == 0) = max(ElementIndicies4Target); 
Data = DataIn(:,ElementIndicies4Target);
%pads rows of NaNs for elements with missing data
Data(:,noData)=[NaN]; 

    
    %calculates the Mg#
    Data(:,17) = (Data(:,9)./40.311)./((Data(:,9)./40.311) + (Data(:,7)./71.846));
    
    %NaK#
    Data(:,18) =  nansum(Data(:,11:12),2)./nansum(Data(:,10:12),2);
    
    %CaO Al2O3 ratio
    Data(:,19) =  Data(:,10)./Data(:,5);
  
    %Ca Al ratio
    CaMoles = Data(:,10)./56.078; 
    AlMoles = Data(:,5 )./101.964.*2; 
    Data(:,20) =  CaMoles./AlMoles;
    
    Data(:,21) =  1-Data(:,17);
    Data = [Data TormeyData];
    
    
    % Data now has columns:
    %1-Temp 2-Pressure
    % 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
    % 13-P2O5 14-NiO 15-H2O 16-total 
    % 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles
    %20 - 1-Mg# 22-Qtz 23-Plag 24-Oliv 25-Cpx
    
    Elements = {'Temp' 'Pressure' 'SiO2'	'TiO2'	  'Al2O3' 'Cr2O3'	  'FeO'	  'MnO'	  'MgO'	  'CaO' 'Na2O'   'K2O' 'P2O5' 'NiO' 'H2O' 'total' 'Mg#' 'NaK#' 'CaO/Al2O3 wt%' 'CaO/Al2O3 moles' '1-Mg#' 'Qtz' 'Plag' 'Oliv' 'Cpx' 'Pgarnet' 'Pspinel' 'Pplag'};

    
    %P estimates using [OLIV 1-Mg# NaK# TiO2] which are columns  
    Variables = {'Oliv' '1-Mg#' 'NaK#' 'TiO2'};
    [A,PressureIndicies] = ismember(Variables, Elements);
    %dry garnet 
    dryGarnetCoeffs_P = [-13.0566446907391,132.434430258845,-37.4367080547515,25.5328882530509,0.232713503090985];
    %dry spinel (check the CMAS thing)
    drySpinelCoeffs_P  =[-9.71026363044471,99.4860910790842,-23.8256623045673,28.9279438000890,2.61882611683507,0.858139896727173];
    % MITCMAS: [-7.76041259326568,92.6534004518102,-23.3872755969731,28.4059882879248,2.41558865222803]
    %dry plag (check the CMAS thing)
    dryPlagCoeffs_P  =[-18.8818619914566,145.431607868403,-26.0445155021203,36.3807700579605,1.89915913750353];
    %MIT [-18.6979432149565,144.113963075143,-23.8882785554324,35.4296869948882,1.39287554969676]
    


    
    
    %dry T [P Mg NaK TiO2]
    %dry garnet 
    Variables = {'Pgarnet' 'Mg#' 'NaK#' 'TiO2'};
    [A,TempIndicies_gar] = ismember(Variables, Elements);
    
    Variables = {'Pspinel' 'Mg#' 'NaK#' 'TiO2'};
    [A,TempIndicies_sp] = ismember(Variables, Elements);
    
     Variables = {'Pplag' 'Mg#' 'NaK#' 'TiO2'};
    [A,TempIndicies_plag] = ismember(Variables, Elements);   
    
    dryGarnetCoeffs_T =[1320.27861822550,8.46845410974507,-203.208218043571,-131.937414842973,32.9494597572262];
    %dry spinel (check the MIT CMAS thing)
    drySpinelCoeffs_T  =[1212.46355565347,11.9662607119053,-96.8987139704998,-89.3502515853267,2.36697958371634];
    %dry plag (check the MIT CMAS thing)
    dryPlagCoeffs_T  =[1215.13292215776,10.5764134674128,-72.5328276026898,-198.174016791852,23.5900328937436];
    
    

    %from Till 2012
%     %[Oliv 1-Mg# NaK# TiO2 K2O]        
%     Till2012_SpinelCoeffs_P  =[-0.862 9.471 -2.838 2.922 0.218 -0.146];
%     Till2012_PlagCoeffs_P =[-1.640 12.94 -2.363 3.510 0.152 -0.176];
%     Till2012_Indicies_P = [20 18 19 2 12];
%     
%     %[P(GPa) 1-Mg# NaK# TiO2 K2O]
%     Till2012_SpinelCoeffs_T  =[1212 119.9 -97.33 -87.76 3.44 4.58];    
%     Till2012_SpinelIndicies_T = [33 18 19 2 12];
%     Till2012_PlagCoeffs_T =[1216 104.4 -72.83 -194.9 24.08 -1.55];    
%     Till2012_PlagIndicies_T = [34 18 19 2 12];

    %Till 2012, but normalized consistenly with this set up (to the 7 tomey
    %components)
    
        
    % Data now has columns:
    %1-Temp 2-Pressure
    % 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
    % 13-P2O5 14-NiO 15-H2O 16-total 
    % 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles
    %20 -(1-Mg#) 21-Qtz 22-Plag 23-Oliv 24-Cpx
    
   
    %[Oliv 1-Mg# NaK# TiO2 K2O]        
    Till2012_SpinelCoeffs_P  =[-9.53969182201873,98.7806388212875,-23.8078199785417,29.0713458639228,2.63670347161260,-0.174335965780883];
    Till2012_PlagCoeffs_P =[-14.0631964046341,114.173556591146,-19.2587951499320,33.1740196557256,1.83652067573695,-2.40266324980688];
    Till2012_Indicies_P = [23 20 18 4 12];
    
    %[P(GPa) 1-Mg# NaK# TiO2 K2O]
    Till2012_SpinelCoeffs_T  =[1211.83460025355,11.9929654781605,-97.3443173610375,-87.7542183921651,3.44527331257112,-4.57953841640202]; 
    Till2012_SpinelIndicies_T = [33 20 18 4 12];
    Till2012_PlagCoeffs_T =[1215.66705174360,10.4365715360928,-72.8374786235354,-194.870095038429,24.0766263825441,-1.54911345704379];   
    Till2012_PlagIndicies_T = [34 20 18 4 12];        


    Mitchell2015_HarzCoeffs_P = [-2.53 0.0535 0.429 -0.453 3.55 6.81 2.40]; %[H2Owt% TiO2 Cr2O3 CPX OL PLAG]
    Mitchell2015_HarzCoeffs_T = [1326 171 -826 -27.6 102]; %[P(GPa) 1-MG# H2Owt% Cr2O3]
    Mitchell2015_HarzCoeffs_H2O = [-16.3 5.28 36.1 8.79 -12 30.6]; %[P(GPa) 1-MG# Plag Ol Qtz]

    for ii = 1:size(Data,1)

    Data(ii,27) = (dryGarnetCoeffs_P (1) + dryGarnetCoeffs_P (2:5)*Data(ii,PressureIndicies)'); %Pressure in GPa           
    Data(ii,28) = (drySpinelCoeffs_P (1) + drySpinelCoeffs_P (2:5)*Data(ii,PressureIndicies)'); %Pressure in GPa
    Data(ii,29) = (dryPlagCoeffs_P (1) + dryPlagCoeffs_P (2:5)*Data(ii,PressureIndicies)'); %Pressure in GPa
    
    Data(ii,30) = dryGarnetCoeffs_T (1) + dryGarnetCoeffs_T (2:5)*Data(ii,TempIndicies_gar)'; %T
    Data(ii,31) = drySpinelCoeffs_T (1) + drySpinelCoeffs_T (2:5)*Data(ii,TempIndicies_sp)'; %T
    Data(ii,32) = dryPlagCoeffs_T (1) + dryPlagCoeffs_T (2:5)*Data(ii,TempIndicies_plag)'; %T    
    
    
    Data(ii,33) = (Till2012_SpinelCoeffs_P (1) + Till2012_SpinelCoeffs_P (2:6)*Data(ii,Till2012_Indicies_P)'); %Pressure in GPa
    Data(ii,34) = (Till2012_PlagCoeffs_P (1) + Till2012_PlagCoeffs_P (2:6)*Data(ii,Till2012_Indicies_P)'); %Pressure in GPa      
    
    Data(ii,35) = (Till2012_SpinelCoeffs_T (1) + Till2012_SpinelCoeffs_T (2:6)*Data(ii,Till2012_SpinelIndicies_T)'); %T
    Data(ii,36) = (Till2012_PlagCoeffs_T (1) + Till2012_PlagCoeffs_T (2:6)*Data(ii,Till2012_PlagIndicies_T)'); %T

    end
    
    
 end



