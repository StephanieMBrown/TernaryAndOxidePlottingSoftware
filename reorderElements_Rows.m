function [newlyOrderedElements, DLabels, DColors,WGP] = reorderElements_Rows(SpreadsheetName, TabName, targetDataLabel, targetElements,FirstElement,LastElement,column2unnormalize )

%orderElements('TraceElements', 'Niu2009', Elements)
%reads in data in the wrong order and reorders it 
%%
% 
%  targetDataLabel = 'PlotOn'; 
%  SpreadsheetName = SpreadsheetName; %XLSFileName;
%  TabName= 'UTh_georock'; %'Gakkel'; %char(sheetLabels(i)); 
% % 
% %  targetElements = targetStrings_Trace; 
% % FirstElement = 'FirstTrace';
% % LastElement = 'LastTrace'; 
% % 
% % 
%  targetStrings_Majors = {'Temp','Pressure','SiO2','TiO2','Al2O3', 'Cr2O3','FeO','MnO','MgO','CaO','Na2O','K2O','P2O5','NiO','H2O'};  
%  targetElements = targetStrings_Majors; 
% FirstElement = 'FirstMajor';
% LastElement = 'LastMajor'; 



targetElements = upper(targetElements); 



[xlsNumbers, xlsText,xlsRAW] = xlsread(SpreadsheetName, TabName);
[ElementRow,ElementColumn]= find(strcmp(xlsRAW,FirstElement)==1); 
[LastElementRow,LastElementColumn]= find(strcmp(xlsRAW,LastElement)==1); 
Elements = xlsRAW(ElementRow+1, ElementColumn:LastElementColumn); 
Elements = upper(Elements); 

%mat2clip(Elements)


%Finds MELTS
xlsRAW_strings=cellfun(@num2str,xlsRAW,'un',0); 
[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsRAW_strings,targetDataLabel)) ==1); 


[LabelRow,LabelColumn]= find(strcmp(xlsRAW_strings,'Label')==1); 
[ColorRow,ColorColumn]= find(strcmp(xlsRAW_strings,'Color')==1); 

DLabels = (xlsRAW_strings(unique(DRow),LabelColumn)); 
DColors = xlsRAW_strings(unique(DRow),ColorColumn); 

[WGPRow,WGPColumn]=find(strcmp(xlsRAW_strings,'Garnet%')==1); 

if isempty(WGPRow)==1
    WGP=[]; 
else 
WGP = cell2mat(xlsRAW(DRow, WGPColumn)); 
end



% test = xlsRAW(DRow,ElementColumn:LastElementColumn);
% % numind = cellfun(@isnumeric, test);
% % test(numind) = {'0'};
% DData = cell2mat(test); 
DData = (xlsRAW(DRow,ElementColumn:LastElementColumn)); 
i1 = cellfun(@ischar,DData);
sz = cellfun('size',DData(~i1),2);
DData(i1) = {nan(1,sz(1))};
DData = cell2mat(DData); 


 Fe2O3Tcolumn = find(strcmp('FE2O3T',Elements)); 
 Fe2O3column = find(strcmp('FE2O3',Elements)); 
 FeOTcolumn = find(strcmp('FEOT',Elements)); 

 if any(FeOTcolumn)
     FeOTdata = DData(:,FeOTcolumn); 
 end
 
  if any(Fe2O3Tcolumn)
     Fe2O3data = nansum(DData(:,[Fe2O3Tcolumn Fe2O3column]),2);
  else
     Fe2O3data = DData(:,Fe2O3column);
  end

 if any(Fe2O3column)
 FeOcolumn = find(strcmp('FEO',Elements)); 
 FeOTsummedhere=nansum([DData(:,FeOcolumn) 0.899.*Fe2O3data],2);
 end
 
if any(FeOTcolumn) && any(Fe2O3column)
DData(:,FeOcolumn) = max(FeOTdata, FeOTsummedhere); 
else if any(FeOTcolumn)
DData(:,FeOcolumn) = FeOTdata; 
else if any(Fe2O3column)
DData(:,FeOcolumn) =FeOTsummedhere;
end
end
end
 
 
[A,ElementIndicies4Target] = ismember(targetElements, Elements);
noData = find(ElementIndicies4Target==0); 

ElementIndicies4Target(ElementIndicies4Target == 0) = max(ElementIndicies4Target); 

% targetElements
% Elements
% ElementIndicies4Target
% size(DData)
newlyOrderedElements = DData(:,ElementIndicies4Target);

%pads rows of NaNs for elements with missing data
newlyOrderedElements(:,noData)=[NaN]; 

%unnormalizes data, if neccessary
if any(column2unnormalize)
allexceptcolumns = 1:size(newlyOrderedElements,2); 
allexceptcolumns(column2unnormalize)=[]; 
newlyOrderedElements_unnormalized = bsxfun(@times, newlyOrderedElements(:,allexceptcolumns),newlyOrderedElements(:,column2unnormalize));
newlyOrderedElements(:,allexceptcolumns) = newlyOrderedElements_unnormalized; 
end


%mat2clip(newlyOrderedElements_unnormalized)



% DataLabels_BC = regexprep(xlsText(unique(Row_BC),Column_BC),'BC_',''); 
% Data_BC = xlsNumbers(ElementRow+1:LastElementRow-1,Column_BC); 
% Colors_BC = xlsText(unique(Row_BC-1),Column_BC);
end

