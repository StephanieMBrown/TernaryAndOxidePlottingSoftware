function [ResultsMatrix] = TormeyProjection(Data)
%% Tormey Projection script 

Data(isnan(Data)) = 0;

% Read data into a matrix with columns 1. SiO2 2.TiO2 3. Al2O3 4.Cr2O3
% 5. FeO 6. MnO 7. MgO 8. CaO 9. Na2O 10. K2O 11. P2O5 12. Fe2O3
if size(Data,2)<12
Data(:,12) = Data(:,11);
Data(:,12) = [0];
end

Data = bsxfun(@times, Data,sum(Data,2)); 

%1.SiO2 2.TiO2 3.Al2O3 4.Cr2O3 5.FeO 6.MnO 7.MgO 8.CaO 9.Na2O 10.K2O 11.P2O5 12.Fe2O3
AtomicMass = [60.085 79.899	101.961	151.9902	71.846	70.9374	40.311	56.079	61.979	94.203	283.89 159.69];
CationUnits = [1	1	2	2	1	1	1	1	2	2	2	2]; 


%Calcualted using inv(compositional matrix)
BasisVector = [1	0.5	-0.25	0.5	-0.5	0	-0.5	-1.5	-2.75	-2.75	2.5	0
0	0	0.5	0	0	0	0	0	0.5	-0.5	0	0
0	-0.5	0.25	-0.5	0.5	0	0.5	-0.5	-0.25	-0.25	0.83333	0
0	0	-0.5	0	0	0	0	1	0.5	0.5	-1.66667	0
0	1	0	1	0	0	0	0	0	0	0	0.5
0	0	0	0	0	0	0	0	0	1	0	0
0	0	0	0	0	0	0	0	0	0	0.33333	0];
BasisVector(isnan(BasisVector)) = 0;

% BasisVector_Grove1982=[1	1	-0.25	0.5	-0.5	0	-0.5	-1.5	-2.75	-2.75	0	0
% 0	0	0.5	0	0	0	0	0	0.5	-0.5	0	0
% 0	-1	0.25	-0.5	0.5	0	0.5	-0.5	-0.25	-0.25	0	0
% 0	0	-0.5	0	0	0	0	1	0.5	0.5	0	0
% 0	0	0	0	0	0	0	0	0	1	0	0
% 0	1	0	1	0	0	0	0	0	0	0	0];
% BasisVector_Grove1982(isnan(BasisVector_Grove1982)) = 0;

OxygenUnits = ...
[1
4
2
3
1.5
4
6]; 

% OxygenUnits_Grove1982 = ...
% [1
% 4
% 2
% 3
% 4
% 1.5]; 



for n=1:size(Data,1)
     inMoles = Data(n,:)./AtomicMass.*CationUnits;

     MineralComponents = BasisVector*inMoles'.*OxygenUnits; 
     MineralComponents = MineralComponents./nansum(MineralComponents,1); 
     ResultsMatrix(n,:) = MineralComponents'; 
     
%      MineralComponents_Grove1982 = BasisVector_Grove1982*inMoles'.*OxygenUnits_Grove1982;
%      MineralComponents_Grove1982 = MineralComponents_Grove1982./nansum(MineralComponents_Grove1982,1); 
%      ResultsMatrix_Grove1982(n,:) = MineralComponents_Grove1982'; 
end
    
% 1-Quartz
% 2-Plag
% 3-Olivine
% 4-Cpx
% 5-Oxides
% 6-Or
% 7-Ap

%renormalize to the 4 goodies
IndiciesToKeep = [1 2 3 4 5 6 7];
ResultsMatrix = ResultsMatrix(:,IndiciesToKeep); 
%ResultsMatrix = bsxfun(@rdivide, ResultsMatrix,sum(ResultsMatrix,2)); 

% IndiciesToKeep = [1 2 3 4];
% ResultsMatrix_Grove1982 = ResultsMatrix_Grove1982(:,IndiciesToKeep); 
% ResultsMatrix_Grove1982 = bsxfun(@rdivide, ResultsMatrix_Grove1982,sum(ResultsMatrix_Grove1982,2)); 






%         ResultsMatrix(a,1) = Olivine;
%         ResultsMatrix(a,2) = Clinopyroxene;
%         ResultsMatrix(a,3) = Quartz;
%         ResultsMatrix(a,4) = Plagioclase;
% 
% end
%         A = ResultsMatrix(:,2);
%         B = ResultsMatrix(:,1);
%         C = ResultsMatrix(:,4);
%         D = ResultsMatrix(:,3);
%         
%         x=C+0.5.*A+0.5.*D;  
%         y=(sqrt(3)/2).*A;
%         z=(sqrt(3)/4).*A+(sqrt(3)/2).*D;
%         
% TetrahedronCoordinates =[x y z];
% % [TetrahedronCoordinates] = ThreeDimTernaryPlotter(ResultsMatrix(:,2), ResultsMatrix(:,1),ResultsMatrix(:,4), ResultsMatrix(:,3),'Cpx','Ol','Plag','Qz',nincrements,'k',0);
end
