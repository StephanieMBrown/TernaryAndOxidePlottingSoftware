function [CompMatrix] = calculatePrimitiveLiquid(CompMatrix,olivineKD)
%input what is needed for beautifyFunction
%1-SiO2	2-TiO2	3-Al2O3	4-Fe2O3	5-Cr2O3	6-FeO	7-MnO	8-MgO	9-NiO	10-CaO	11-Na2O	12-K2O	13-P2O5


    %1-Temp 2-Pressure
    % 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
    % 13-P2O5 14-NiO 15-H2O 16-total 
    % 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles
    
    
    
    
    
numElements = size(CompMatrix,2); 


for n=1:size(CompMatrix,1)
    CompMatrix(n,numElements+1) = nansum(CompMatrix(n,:));
    
    %using FeO
    CompMatrix(n,numElements+2) = (CompMatrix(n,8)/40.311)./((CompMatrix(n,6)/71.846)+(CompMatrix(n,8)/40.311));
    
    %using FeOT
    %CompMatrix(n,numElements+2) = ((CompMatrix(n,8)+0.899.*CompMatrix(n,4))/40.311)./((CompMatrix(n,6)/71.846)+((CompMatrix(n,8)+0.899.*CompMatrix(n,4))/40.311));
    
    
    CompMatrix(n,numElements+3) = 1/(olivineKD.*(1/ CompMatrix(n,17) - 1)+1);
end

end

%not using FeOT
%     0.6794    0.8796
%     0.5298    0.7953

%only using FeO
%     0.7126    0.8953
%     0.5391    0.8013