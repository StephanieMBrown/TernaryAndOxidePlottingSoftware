
function [liquidCompPost] = crystallizeFUNCTION_lastliquid_targetFo(liqCompIn, phaseProportions,percentIncrement,targetFoContent,olivineKD)



% the possible phases to crystallize or melt are:
% [olivine opx pigeonite augite plagioclase garnet amphibole ilmenite magnetite] 






Elements = {'Temp' 'Pressure' 'SiO2'	'TiO2'	  'Al2O3' 'Cr2O3'	  'FeO'	  'MnO'	  'MgO'	  'CaO' 'Na2O'   'K2O' 'P2O5' 'NiO' 'H2O'};% 16-total 
% 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles

%            1       2       3         4      5        6     7      8          9         10         11
targetElements = { 'SiO2'	'TiO2' 'Al2O3'	'Cr2O3'  'FeO'	'MnO'	'MgO'	'CaO'    'Na2O'	'K2O'	    'P2O5'};


[A,ElementIndicies4Target] = ismember(targetElements, Elements);
liqComp = liqCompIn(:,ElementIndicies4Target);


liqComp = 100*liqComp/nansum(liqComp); %%normalizes the liquid composition
numElements = size(liqComp,2);
%disp(['The sum of the phases is: ' num2str(sum(phaseProportions))])

%% STEP 1: change inputs/outputs for your needs.
%%%  For example, if you want to save the olivine composition too, just change the fucntion to
%%% [liquidCompPost,F,olivine] = crystallizeFUNCTION(liqComp, phaseProportions, percent,percentIncrement)



%% STEP 2: check KDs
% For now we are using these set KDs. Change them to your liking.  
% In the future we could have a parameterized value that calculates within 
% the routine based on the liquid comp (or T and P). 
%%%     oliv   opx  pig/augite  plag  amphibole garnet[FeMg  SiMg]   
%%%      1      2           3         4          5                   6       7       
KDs = [olivineKD  0.27      0.23      6.0       0.35             0.48   0.8];

%% STEP 3: define any composition-invariant phases
%            1       2       3         4      5        6     7      8          9         10         11
%          SiO2	TiO2 Al2O3	Cr2O3  FeO	MnO	MgO	CaO	    Na2O	K2O	    P2O5
%%magnetite and ilmenite comps are already defined.  You can set to known comp for any
%%mineal that is not included above
magnetiteComp = [0   7.8  2.7 0   87.9  0   1.6  0   0  0   0]; %%This is the default in the fortran code, change this for your comp!
ilmeniteComp = [0 45 0.5 0 50 0.5 4 0 0 0 0]; %%This is some real comp from Ben's expts, change!
%%% pure ilmenite FeTiO3 = [0 52.65 0 0 47.35 0 0 0 0 0 0];

%%% end of things to change 
 




%% Now calculate crystallization:

%%% the liquid composition matrix initially saves the original liq comp in
%%% the first row, edit line 60 (**) to change this
%liquidCompPost(1,:) = liqComp; %% (**): change here if you don't want to save the initial liq in the derivative liquid comp matrix
n =1; % i and n will be different if the percentIncrmenet is not = 1
Increment = percentIncrement/100;
F(1) = 1;
liquidCompPost(1,:) = addMgNum_LiqAndSolid(liqComp,KDs(1)); 


while liquidCompPost(n,numElements+3) < targetFoContent

    %%% for each increment of fractional crystallization, a routine is called
    %%% to calculate the equlibrium mineral composition (and save it in a
    %%% matrix) based on the transient liquid composition and the Kd matrix.  
    %%% If you want to control the mineral composition more,
    %%% change the Kd matrix or the mineral routine. 
    %%% The only reason why I dictate the Kd here is so that it's easy
    %%% to change the Kd and test sensitivity from the main routine. 

    olivine(n,:) = fractionateOlivine(liquidCompPost(n,1:numElements),KDs(1));
    opx(n,:) = fractionateOpx(liquidCompPost(n,1:numElements),KDs(2));
    pigeonite(n,:) = fractionatePIG(liquidCompPost(n,1:numElements),KDs(3));
    augite(n,:) = fractionateAugite(liquidCompPost(n,1:numElements),KDs(3));
    plagioclase(n,:) = fractionatePlagioclase(liquidCompPost(n,1:numElements),KDs(4));
    amphibole(n,:) = fractionateAmphibole(liquidCompPost(n,1:numElements),KDs(5));
    garnet(n,:) = fractionateGarnet(liquidCompPost(n,1:numElements),KDs(6),KDs(7));
    
    %%% uses input compositions, can change later to make it liquid
    %%% comp, T,P, fO2 dependent if useful
    ilmenite(n,:) = ilmeniteComp;
    magnetite(n,:) = magnetiteComp;
    
    %%% now combine the mineral data into a matrix 
    %%% each row is a mineral composition.  If you add minerals,
    %%% make sure to change it here.
    %%% [olivine opx  pigeonite augite plagioclase garnet amphibole ilmenite magnetite] 
    clearvars temp
    temp = [olivine(n,:); opx(n,:); pigeonite(n,:); augite(n,:); plagioclase(n,:); garnet(n,:); amphibole(n,:); ilmenite(n,:); magnetite(n,:)];
    solidphases(n,:) = phaseProportions*temp; %%multiples each mineral times its proportion, saves it in a new matrix
    
    %%% the new liquid compostiion is calculated by removing an increment of
    %%% solid material. 
 
        liquidCompPost(n+1,1:numElements) = liquidCompPost(n,1:numElements) - (Increment*(solidphases(n,:))); 
        liquidCompPost(n+1,1:numElements) = 100*liquidCompPost(n+1,1:numElements)./nansum(liquidCompPost(n+1,1:numElements)); %%normalizes the liquid composition
        liquidCompPost(n+1,:) = addMgNum_LiqAndSolid(liquidCompPost(n+1,1:numElements),KDs(1));
        F(n+1) = (1-Increment)^n;
        
        
        
        
        n=n+1;
end

%add on the % crystallized 
liquidCompPost(:,numElements+4) = (1-F)*100;

if n >1
%%% converts solid phases to positive values to offset more addition than
%%% fractionation
solidphases = abs(solidphases);

%%% tacks on a new column with Mg# for each compositional matrix.  Could
%%% make this also calc NaK#s, etc...
%liqComp= addMgNum(liqComp);
%liqComp= addMgNum(olivine);
%liquidCompPost= addMgNum(liquidCompPost);
solidphases= addMgNum(solidphases);
olivine= addMgNum(olivine);
opx= addMgNum(opx);
pigeonite= addMgNum(pigeonite);
augite= addMgNum(augite);
plagioclase= addMgNum(plagioclase);
amphibole= addMgNum(amphibole);
garnet= addMgNum(garnet);
ilmenite= addMgNum(ilmenite);
magnetite= addMgNum(magnetite);
end


% display('The total liquid remaining after each iteration in % is :')
% disp(F*100)

[A,ElementIndicies4Target_out] = ismember(Elements,targetElements);

end

