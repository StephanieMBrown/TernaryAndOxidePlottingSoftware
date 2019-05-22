function [probeData] = sumMgNumNorm(probeData)

% 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
% 13-P2O5 14-NiO 15-H2O 16-total 17-Mg# 18-NaK 19 - CaO/Al2O3


%    %hydrous
%    datarange = [4:16];

   %anhydrous
   datarange = [3:14];
    
    %normalizes by each row
    for n=1:size(probeData,1)
        probeData(n,datarange) = 100*probeData(n,datarange)./nansum(probeData(n,datarange));
    end

    probeData(:,16) = nansum(probeData(:,datarange),2); %%recalculates total

    %calculates the Mg#
    probeData(:,17) = (probeData(:,9)./40.311)./((probeData(:,9)./40.311) + (probeData(:,7)./71.846));
    
    %NaK#
    probeData(:,18) =  nansum(probeData(:,11:12),2)./nansum(probeData(:,10:12),2);
    
    %CaO Al2O3 ratio
    probeData(:,19) =  probeData(:,10)./probeData(:,5);
  
    %Ca Al ratio
    CaMoles = probeData(:,10)./56.078; 
    AlMoles = probeData(:,5 )./101.964.*2; 
    probeData(:,20) =  CaMoles./AlMoles;

end



