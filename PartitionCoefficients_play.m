% close all
% clear all

[xlsNumbers, xlsText] = xlsread(SpreadsheetName, 'Legend');


[ReferenceRow,ReferenceColumn]= find(strcmp(xlsText,'Reference')==1); 
[LastReferenceRow,LastReferenceColumn]= find(strcmp(xlsText,'LastReference')==1); 
 
% Matrix with element labels
References = xlsText(ReferenceRow+1:LastReferenceRow-1, ReferenceColumn); 
numberReferences = size(References,1); 

[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsText,'MarkerSymbols')) ==1); 
MarkerSymbols_Labels = (xlsText(unique(DRow+1),DColumn)); 
MarkerSymbols = xlsText(ReferenceRow+1:LastReferenceRow-1,DColumn); 

[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsText,'LineWidth')) ==1); 
LineWidth_Labels = (xlsText(unique(DRow+1),DColumn)); 
LineWidth= xlsNumbers(ReferenceRow+1:LastReferenceRow-1,DColumn); 

[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsText,'ColorLine')) ==1); 
ColorsLine_Labels = (xlsText(unique(DRow+1),DColumn)); 
ColorsLine = xlsText(ReferenceRow+1:LastReferenceRow-1,DColumn); 

[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsText,'MarkerFaceColor')) ==1); 
ColorsFace_Labels = (xlsText(unique(DRow+1),DColumn)); 
ColorsFace = xlsText(ReferenceRow+1:LastReferenceRow-1,DColumn); 

[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsText,'MarkerSize')) ==1); 
MarkerSize_Labels = (xlsText(unique(DRow+1),DColumn)); 
MarkerSize = xlsNumbers(ReferenceRow+1:LastReferenceRow-1,DColumn); 

[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsText,'useLabels')) ==1); 
Use_Labels = xlsText(ReferenceRow+1:LastReferenceRow-1,DColumn); 
Use_Labels_indicies = find(strcmp(Use_Labels,'yes'));
