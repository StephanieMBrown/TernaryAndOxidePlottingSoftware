
close all
clear all

%FOR YOU TO DO in this step: 

    %Save the spreadsheet in the correct format :
    % Note, even if you do not have't T and P for your points, set to 0 not
    % NaN or matlab will read the file in wrong 
    
    %1-Temp 2-Pressure
    % 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
    % 13-P2O5 14-NiO 15-H2O


    %RealLegend={'Seifert1996','Seifert1996LowNa','Brannon1984','Klewin1991'};
    SpreadsheetName= 'DataSpreadsheet_LunarGlassesDelano1986';
    %Do you want to automatically zoom in on all the plotted data?
    %Zoom = 'yes'; 
    Zoom = 'no'; 

    %Do you want to plot the unzoomed, full triangle?
    FullTrangle = 'yes'; 
    %FullTrangle = 'no'; 

    %Do you want contours of composition (the axes) in the full triangle?
    % I will very soon make this also a function in the zoomed triangle too 
    %Contours = 'no'; 
    Contours = 'yes'; 

ColorsHERE
% THEN: go to Step 1-4 and customize the plots 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 0: import the data from the spreadsheet, simultaneously normalize and calculate new parameters (such as Mg#).  

[type, TabNames] = xlsfinfo(SpreadsheetName);

PartitionCoefficients_play
TabNames(strcmp(TabNames,'TraceElementOrder')==1)=[]; 
TabNames=References' ;


targetStrings_Majors = {'Temp','Pressure','SiO2','TiO2','Al2O3', 'Cr2O3','FeO','MnO','MgO','CaO','Na2O','K2O','P2O5','NiO','H2O'}; 

[xlsNumbers, xlsText,xlsRAW] = xlsread(SpreadsheetName, 'TraceElementOrder');
[ElementRow,ElementColumn]= find(strcmp(xlsRAW,'Elements')==1); 
[LastElementRow,LastElementColumn]= find(strcmp(xlsRAW,'LastElement')==1); 
% Matrix with element labels
targetStrings_Trace = xlsRAW(ElementRow+1:LastElementRow-1, ElementColumn)'; 
%get element info
ElementsInfo = (xlsRAW(ElementRow+1:LastElementRow-1,ElementColumn+1)); 
i1 = cellfun(@ischar,ElementsInfo);
sz = cellfun('size',ElementsInfo(~i1),2);
ElementsInfo(i1) = {nan(1,sz(1))};
ElementsInfo = cell2mat(ElementsInfo)'; 

%ElementRatios= {'Th' 'U'; 'Lu' 'Hf'; 'Sm' 'Nd'; 'Lu' 'Sc'; 'Hf' 'Nd'; 'La' 'Sm'; 'Rb' 'Sr'; 'Eu' 'Sm'; 'Eu' 'Gd'; 'Nd' 'Zr'; 'Sm' 'Yb'; 'Zr' 'Y'; 'Nb' 'Y'; 'Gd' 'Yb'}; 
ElementRatios= {'Th' 'U'; 'Lu' 'Hf'; 'Sm' 'Nd'; 'Lu' 'Sc'; 'Hf' 'Nd'; 'La' 'Sm'; 'Rb' 'Sr'; 'Eu' 'Sm'; 'Eu' 'Gd'; 'Nd' 'Zr'; 'Sm' 'Yb'; 'Zr' 'Y'; 'Nb' 'Y'; 'Gd' 'Yb';  'Zr' 'Yb'; 'Zr' 'Hf'; 'Nb' 'Ta'; 'Ba' 'La'; 'Ba' 'Pb'; 'U' 'Pb'}; 

for gg = 1:size(ElementRatios,1)
    for ggg = 1:size(ElementRatios,2)
        ElementRatiosIndex(gg,ggg) =  find(strcmp(targetStrings_Trace,ElementRatios(gg,ggg)));
    end
end

%gets compositions to normalize by
xlsRAW_strings=cellfun(@num2str,xlsRAW,'un',0); 
[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsRAW_strings,'BCX')) ==1); 
TraceElements4Normalization_Labels = (xlsRAW(unique(DRow+1),DColumn)); 
TraceElements4Normalization = (xlsRAW(ElementRow+1:LastElementRow-1,DColumn)); 

%fixes the NaN issue
i1 = cellfun(@ischar,TraceElements4Normalization);
sz = cellfun('size',TraceElements4Normalization(~i1),2);
TraceElements4Normalization(i1) = {nan(1,sz(1))};
TraceElements4Normalization = cell2mat(TraceElements4Normalization)'; 

clear DataRatios
for gg = 1:size(ElementRatios,1)
    DataRatios(:,gg) = TraceElements4Normalization(:,ElementRatiosIndex(gg,1)) ./TraceElements4Normalization(:,ElementRatiosIndex(gg,2)); 
     assignin('base',sprintf('DataRatios_%s','TraceElements4Normalization'), DataRatios); 
%     
%     DataRatios_TraceDMM(:,gg) = TraceElements4Normalization_TraceDMM(:,ElementRatiosIndex(gg,1)) ./TraceElements4Normalization_TraceDMM(:,ElementRatiosIndex(gg,2)); 
%     assignin('base',sprintf('DataRatios_TraceDMM_%s','TraceElements4Normalization'), DataRatios_TraceDMM); 
end


runningTrace=[]; 

for i=1:size(TabNames,2)   
    %reads the names off sheets in a tab and stores them as variables
    %reorderElements_Rows(SpreadsheetName, 'Brannon1984', 'PlotOn', targetStrings_Majors,'FirstMajor','LastMajor',column2unnormalize ); 
    column2unnormalize=[]; 
    [MajorElements, Major_Labels, Major_Colors] = reorderElements_Rows(SpreadsheetName, TabNames{i}, 'PlotOn', targetStrings_Majors,'FirstMajor','LastMajor',column2unnormalize ); 
    [TraceElements, Trace_Labels] = reorderElements_Rows(SpreadsheetName, TabNames{i}, 'PlotOn', targetStrings_Trace,'FirstTrace','LastTrace',column2unnormalize ); 

    Major_Labels =regexprep(Major_Labels,'NaN','');
    %assignin('base', (TabNames{i}),sumMgNumNorm(xlsread('master_data',char(TabNames(i)))));  
    assignin('base', (TabNames{i}),sumMgNumNorm(MajorElements));    

    assignin('base', [TabNames{i},'_Trace'],TraceElements);    
    % if you don't want to normalize use this instead:
     %   assignin('base', (TabNames{i}),data);      
    
    assignin('base', [TabNames{i},'_samples'],Major_Labels);    
    
    %calculates the Tormey components of all the data 
    assignin('base', [TabNames{i},'_Tormey'],TormeyProjection(eval([TabNames{i},'(:,3:14)'])));
    
    runningTrace = [runningTrace; TraceElements];
    
        
    clear DataRatios
for gg = 1:size(ElementRatios,1)
    DataRatios(:,gg) = TraceElements(:,ElementRatiosIndex(gg,1)) ./TraceElements(:,ElementRatiosIndex(gg,2)); 
    assignin('base',sprintf('DataRatios_%s',TabNames{i}), DataRatios); 
end

end


%delete elements that have no data
% TraceElements2Remove = find((all(isnan(runningTrace),1))==1);
% 
% targetStrings_Trace(TraceElements2Remove)=[]; 
% TraceElements4Normalization(:,TraceElements2Remove)=[]; 
% ElementsInfo(:,TraceElements2Remove)=[]; 
% for i=1:size(TabNames,2)   
%     eval([TabNames{i},'_Trace(:,TraceElements2Remove)=[];'] )
% end
% abbreviatedTrace = TraceElements2Remove;
% numberTraceElements = size(targetStrings_Trace,2); 


% Data now has columns:
%1-Temp 2-Pressure
% 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
% 13-P2O5 14-NiO 15-H2O 16-total 
% 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles


%% Step 1: Plot data in 1x2 oxide-oxide space

    
%FOR YOU TO DO in this step: change the code to designate which oxides /
%variables you want to plot

StableIndex =[4]; %x axis according to following legend
Xindex=[7 17]; %y axes according to following legend

% Data now has columns:
%1-Temp 2-Pressure
% 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
% 13-P2O5 14-NiO 15-H2O 16-total 
% 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles

PartitionCoefficients_play
TabNames=References' ;
layerplot_marker = MarkerSymbols; 
layerplot_color = ColorsLine; 
layerplot_color_fill = ColorsFace; 
layerplot_markersize = MarkerSize; 
Labels2Plot = Use_Labels_indicies;    

numcolumns = 2; 
for kk = 1:size(StableIndex,2)
   figure()
    
   numrows = 1;

   set(gcf, 'Units', 'Inches', 'Position',  [2.2639 1.7083 13.8889 8.0694], 'PaperUnits', 'Inches', 'PaperSize', [8.5, 11])
for n = 1:size(Xindex,2)

     yvalue = StableIndex(kk); 
     xvalue = Xindex(n);      

% subaxis: Spacing,SpacingHoriz,SpacingVert 
% Padding,PaddingRight,PaddingLeft,PaddingTop,PaddingBottom 
% Margin,MarginRight,MarginLeft,MarginTop,MarginBottom 
% Holdaxis 

subaxis(numrows,numcolumns,n,'Spacing',.06,'Margin',0.02,'Padding',0,'PaddingLeft',0.05,'PaddingBottom',0.05)
%subplot(numrows,numcolumns,n)
hold on
axis square
    
    for i=1:size(TabNames,2)  

        if ischar(layerplot_color{i})==1
            layerplot_color_here = eval(char(layerplot_color(i)));
        else 
            layerplot_color_here = layerplot_color{i};
         end 
         
        if ischar(layerplot_color_fill{i})==1
            layerplot_color_here_fill = eval(char(layerplot_color_fill(i)));
        else 
            layerplot_color_here_fill = layerplot_color_fill{i};
        end 
           
        plot(eval(sprintf('%s(:,%g)', TabNames{i}, xvalue)),eval(sprintf('%s(:,%g)', TabNames{i}, yvalue)),char(layerplot_marker(i)),...
            'Color',layerplot_color_here,'MarkerFaceColor',layerplot_color_here_fill,'LineWidth',LineWidth(i),'MarkerSize',layerplot_markersize(i)); %mymarkersize)   
    
        
        if ismember(i,Labels2Plot)
        text(eval(sprintf('%s(:,%g)', TabNames{i}, xvalue)),eval(sprintf('%s(:,%g)', TabNames{i}, yvalue)),eval([TabNames{i},'_samples']),...
            'VerticalAlignment','bottom')   
        end

    end
    

[Xtext,Ytext,FigureTitle] = oxideLabel(xvalue,yvalue);
xlabel(Xtext)
ylabel(Ytext)

box on
%grid on
%set(gca, 'Xtick',1500:10:1540)
ax = gca;
ax.XAxis.MinorTick = 'on';
increment = findBestIncrement( ax.XLim(2)- ax.XLim(1),ax.XAxis.TickValues(2) -  ax.XAxis.TickValues(1));
ax.XAxis.MinorTickValues = ax.XLim(1):increment:ax.XLim(2);

ax.YAxis.MinorTick = 'on';
increment = findBestIncrement( ax.YLim(2)- ax.YLim(1),ax.YAxis.TickValues(2) -  ax.YAxis.TickValues(1));
%ax.YAxis.MinorTickValues = [0:1:20];
ax.YAxis.MinorTickValues = ax.YLim(1):increment:ax.YLim(2);

% if n==2
% set(gca, 'Xtick',.4:.05:.7)   
% ax.XAxis.MinorTick = 'on';
% increment = .01; 
% ax.XAxis.MinorTickValues = ax.XLim(1):increment:ax.XLim(2); 
% end

set(gca,'ticklength',2*[0.0200    0.0500])
set(gca,'fontsize', 19,'LineWidth',1)
set(gca,'XColor', 'k')
set(gca,'YColor', 'k')

% OPTION: uncomment for single (non-subplot plots)
% legend(TabNames,'location','best')
% title(FigureTitle)
% FigureTitle = regexprep(FigureTitle,'\_*',''); 
% FigureTitle = regexprep(FigureTitle,'\/','-');
% set(gcf,'name',regexprep(FigureTitle,'\_*',''))  
end

%Use this when you subplot

if exist('RealLegend','var') ==1
    legend(RealLegend,'location','best','AutoUpdate','off','FontSize',10)
else 
    legend(TabNames,'location','best','AutoUpdate','off','FontSize',10)
end
FigureTitle = [Ytext 'Variation Diagrams'];
FigureTitle = regexprep(FigureTitle,'\_*',''); 
FigureTitle = regexprep(FigureTitle,'\/','-');
set(gcf,'name',regexprep(FigureTitle,'\_*',''))  

% for n = 1:size(Indicies,2)
% subplot(numrows,numcolumns,n); 
% axis square
% end   
     
set(gcf,'position',[1.9722 3.6250 13.8889 6.8056]) %the trick here is to resize the way you want, then run the command gcf and copy paste the position matrix 
%I'm tempted have resize options to best fit in a paper (so a column, or a
%whole page, or the top of the page)
end

%% Step 2: Plot data in 6x2 oxide-oxide space
    PartitionCoefficients_play
    TabNames=References' ;
    layerplot_marker = MarkerSymbols; 
    layerplot_color = ColorsLine; 
    layerplot_color_fill = ColorsFace; 
    layerplot_markersize = MarkerSize; 
    Labels2Plot = Use_Labels_indicies;    
%Compares to Mg#, NaK#, Na2O, and SiO2
Indicies_all = [3 5 9 7 10 11
9 7 5 10 11 12
9 7 5 10 4 12
9 7 5 17 4 12];


StableIndex =[17 3 11 18]; 

%1-Temp 2-Pressure
% 3-SiO2	4 -TiO2	  5- Al2O3  6-Cr2O3	  7-FeO	  8-MnO	  9-MgO	  10-CaO	11-Na2O   12-K2O
% 13-P2O5 14-NiO 15-H2O 16-total 
% 17-Mg# 18-NaK 19-CaO/Al2O3 in wt% 20-CaO/Al2O3 in moles


numcolumns = 2; 
for kk = 1:size(StableIndex,2)
   figure()
    

   Indicies = Indicies_all(kk,:); 
   numrows = round(size(Indicies,2)/numcolumns); 
   set(gcf, 'Units', 'Inches', 'Position', [7.6528 0.4028 8.5 11], 'PaperUnits', 'Inches', 'PaperSize', [8.5, 11])
for n = 1:size(Indicies,2)

     xvalue = StableIndex(kk); 
     yvalue = Indicies(n);      

% subaxis: Spacing,SpacingHoriz,SpacingVert 
% Padding,PaddingRight,PaddingLeft,PaddingTop,PaddingBottom 
% Margin,MarginRight,MarginLeft,MarginTop,MarginBottom 
% Holdaxis 

subaxis(numrows,numcolumns,n,'Spacing',.06,'Margin',0.05,'MarginTop',.01,'Padding',0,'PaddingLeft',0.05,'PaddingBottom',0.01)
hold on
axis square
    
    for i=1:size(TabNames,2)  
             
        if ischar(layerplot_color{i})==1
            layerplot_color_here = eval(char(layerplot_color(i)));
        else 
            layerplot_color_here = layerplot_color{i};
         end 
         
        if ischar(layerplot_color_fill{i})==1
            layerplot_color_here_fill = eval(char(layerplot_color_fill(i)));
        else 
            layerplot_color_here_fill = layerplot_color_fill{i};
        end 
           
        plot(eval(sprintf('%s(:,%g)', TabNames{i}, xvalue)),eval(sprintf('%s(:,%g)', TabNames{i}, yvalue)),char(layerplot_marker(i)),...
            'Color',layerplot_color_here,'MarkerFaceColor',layerplot_color_here_fill,'LineWidth',LineWidth(i),'MarkerSize',layerplot_markersize(i))   
    
        
        if ismember(i,Labels2Plot)
        text(eval(sprintf('%s(:,%g)', TabNames{i}, xvalue)),eval(sprintf('%s(:,%g)', TabNames{i}, yvalue)),eval([TabNames{i},'_samples']),...
            'VerticalAlignment','bottom')   
        end
    
    end
    

[Xtext,Ytext,FigureTitle] = oxideLabel(xvalue,yvalue);
xlabel(Xtext)
ylabel(Ytext)

if n==3
if exist('RealLegend','var') ==1
    legend(RealLegend,'autoupdate','off','FontSize',9,'location','best','NumColumns' ,2)
else 
    legend(TabNames,'autoupdate','off','FontSize',9,'location','best','NumColumns' ,2)
end
end

box on
ax = gca;
ax.XAxis.MinorTick = 'on';
increment = findBestIncrement( ax.XLim(2)- ax.XLim(1),ax.XAxis.TickValues(2) -  ax.XAxis.TickValues(1));
ax.XAxis.MinorTickValues = ax.XLim(1):increment:ax.XLim(2);


ax.YAxis.MinorTick = 'on';
increment = findBestIncrement( ax.YLim(2)- ax.YLim(1),ax.YAxis.TickValues(2) -  ax.YAxis.TickValues(1));
ax.YAxis.MinorTickValues = ax.YLim(1):increment:ax.YLim(2);
set(gca,'ticklength',4*get(gca,'ticklength'))
set(gca,'fontsize', 14,'LineWidth',1)
set(gca,'XColor', 'k')
set(gca,'YColor', 'k')

% OPTION: uncomment for single (non-subplot plots)
% legend(TabNames,'location','best')
% title(FigureTitle)
% FigureTitle = regexprep(FigureTitle,'\_*',''); 
% FigureTitle = regexprep(FigureTitle,'\/','-');
% set(gcf,'name',regexprep(FigureTitle,'\_*',''))  
end

FigureTitle = [Xtext ' Variation Diagrams'];
FigureTitle = regexprep(FigureTitle,'\_*',''); 
FigureTitle = regexprep(FigureTitle,'\/','-');
set(gcf,'name',regexprep(FigureTitle,'\_*',''))  

% for n = 1:size(Indicies,2)
% subplot(numrows,numcolumns,n); 
% axis square
% end   
     
%set(gcf,'position',[217 60 729 745]) %the trick here is to resize the way you want, then run the command gcf and copy paste the position matrix 
%I'm tempted have resize options to best fit in a paper (so a column, or a

end

%% Step 3: plot Ternary figures

% Tormey data is output in columns of:
% 1-Quartz
% 2-Plag
% 3-Olivine
% 4-Cpx

%  These plots go counterclockwise :
%    top = a
%    left = b
%    right = c


% 1-Quartz
% 2-Plag
% 3-Olivine
% 4-Cpx
% 5-Oxides
% 6-Or
% 7-Ap


Ternaries2plot = [2 3 1;  4 2 3; 4 3 1]; 
%Ternaries2plot = [4 3 1]; 
Verticies = {'Qtz' 'Plag' 'Oliv' 'Cpx' 'Oxide' 'Or' 'Ap'};
NamesVerticies = {'QTZ' 'PLAG' 'OLIVINE' 'CPX' 'OXIDE' 'ORTHO' 'AP'};


    PartitionCoefficients_play
    TabNames=References' ;
    layerplot_marker = MarkerSymbols; 
    layerplot_color = ColorsLine; 
    layerplot_color_fill = ColorsFace; 
    layerplot_markersize = MarkerSize; 
    Labels2Plot = Use_Labels_indicies;    
    
for numTernaryPlots = 1:size(Ternaries2plot,1)
    
    IndiciesHere = Ternaries2plot(numTernaryPlots,:); 
    NameHere = [NamesVerticies{IndiciesHere(1)},'-',NamesVerticies{IndiciesHere(2)},'-',NamesVerticies{IndiciesHere(3)}];
    
    
% Spacing,SpacingHoriz,SpacingVert 
% Padding,PaddingRight,PaddingLeft,PaddingTop,PaddingBottom 
% Margin,MarginRight,MarginLeft,MarginTop,MarginBottom 
% Holdaxis 

    %subaxis(numrows,numcolumns,positionTern(numTernaryPlots),'Spacing',0,'Margin',0.05,'Padding',0,'PaddingLeft',0.0)

    %if you want to subplot
%     L=[0.05 .45 .05]; 
%     B=[.5 .29 0];
%     W=.52; 
%     H = .52; 
    
%     L=[0.05 .48 0.01]; 
%     B=[.5 .20 0];
%     W=.5; 
%     H = .5; 
    %ax(numTernaryPlots) = axes('Position',[L(numTernaryPlots) B(numTernaryPlots) W H]);
    %ax(numTernaryPlots) = axes('Position',[(numTernaryPlots-1)*1/size(Ternaries2plot,1) 0 1/size(Ternaries2plot,1) 1]) ;

    
    %%if you prefer single plots
    figure()

hold on
for i=1:size(TabNames,2)  
        if ischar(layerplot_color_fill{i})==1
            % if color is somethign like 'r'
            % layerplot_color_here_fill = char(layerplot_color_fill(i));
             layerplot_color_here_fill =eval(char(layerplot_color_fill(i)));% eval(sprintf('''%s''',char(layerplot_color_fill(i))));
        else 
            % if color is [RGB]
            layerplot_color_here_fill =  sprintf('[%s]',num2str(layerplot_color_fill{i}));
        end 
        
         
         if ischar(layerplot_color{i})==1
            layerplot_color_here = eval(char(layerplot_color(i)));
            %stringlabel = ['char(layerplot_marker(',num2str(i),')),''Color'',''',layerplot_color_here,''',''MarkerFaceColor'',''',layerplot_color_here,''',''MarkerSize'',mymarkersize'];        
            %stringlabel = sprintf('''%s'',''Color'',''%s'',''MarkerFaceColor'',%s,''MarkerSize'',%g', layerplot_marker{i},layerplot_color_here,layerplot_color_here_fill,mymarkersize);
            stringlabel = sprintf('''%s'',''Color'',[%s],''MarkerFaceColor'',[%s],''MarkerSize'',%g', layerplot_marker{i},num2str(layerplot_color_here),num2str(layerplot_color_here_fill),layerplot_markersize(i)); 
        else 
            layerplot_color_here = layerplot_color{i};
            %stringlabel = ['char(layerplot_marker(',num2str(i),')),''Color'',[',num2str(layerplot_color_here),'],''MarkerFaceColor'',[',num2str(layerplot_color_here),'],''MarkerSize'',mymarkersize'];
            stringlabel = sprintf('''%s'',''Color'',[%s],''MarkerFaceColor'',%s,''MarkerSize'',%g', layerplot_marker{i},num2str(layerplot_color_here),num2str(layerplot_color_here_fill),layerplot_markersize(i));
         end
         
   
%GenericTernaryPlotter5(eval([TabNames{i},'_Tormey']), IndiciesHere, Verticies,stringlabel,[],[],'no',Fs',IA_last);
h = GenericTernaryPlotter5(eval([TabNames{i},'_Tormey']), IndiciesHere, Verticies,stringlabel,[],[],'no');

%plots labels
    if ismember(i,Labels2Plot)
        GenericTernaryPlotter5(eval([TabNames{i},'_Tormey']), IndiciesHere, Verticies,stringlabel,eval([TabNames{i},'_samples']),[],'no');
    end

end



if i == size(TabNames,2)
    
   
if numTernaryPlots == 1
if exist('RealLegend','var') ==1
    legend(RealLegend,'location','best','AutoUpdate','off');
else 
    legend(TabNames,'location','best','AutoUpdate','off');
end
end


%to zoom in on the data:
if strcmp(Zoom, 'yes') ==1
GenericTernaryPlotter5_zoom(NaN.*eval([TabNames{i},'_Tormey']),IndiciesHere, Verticies,stringlabel,[],[],'yes'); %'no','yes','yesContour'
end


if strcmp(FullTrangle, 'yes') ==1 && strcmp(Contours, 'yes') ==1
GenericTernaryPlotter5(eval([TabNames{i},'_Tormey']), IndiciesHere, Verticies,stringlabel,[],[],'yesContour');
end 

if strcmp(FullTrangle, 'yes') ==1 && strcmp(Contours, 'yes') ==0
GenericTernaryPlotter5(eval([TabNames{i},'_Tormey']), IndiciesHere, Verticies,stringlabel,[],[],'yes');
end 

set(gca,'XColor', 'k')
set(gca,'YColor', 'k')
set(gcf,'name',[NameHere ' Ternary'])  
end
end


%set(gcf,'Position',[105 38 1007 641])
%suptitle([name,'\_',num2str(PINC),'kbars\_ZoomedTernaries'])



%% Step 4: plot Trace Element Space


for j = 1:size(TraceElements4Normalization,1)
figure()
hold on
normalizationLabel = TraceElements4Normalization_Labels{j};  
normalizationColumn =  find(strcmp(TraceElements4Normalization_Labels,normalizationLabel)); 
mymarkersize=5;
linewidth=.5;
    
      for i=1:size(TabNames,2)    
        if ischar(layerplot_color{i})==1
            layerplot_color_here = char(layerplot_color(i));
        else 
            layerplot_color_here = layerplot_color{i};
         end 
         
        if ischar(layerplot_color_fill{i})==1
            layerplot_color_here_fill = char(layerplot_color_fill(i));
        else 
            layerplot_color_here_fill = layerplot_color_fill{i};
        end 
         
        xarray = repmat([1:size(TraceElements4Normalization,2)],size(eval([TabNames{i},'_Trace()']),1),1);
        yarray = bsxfun(@rdivide,(eval([TabNames{i},'_Trace()'])),TraceElements4Normalization(normalizationColumn,:));
        plot(xarray',yarray','o-k','Color',eval(layerplot_color_here),'MarkerFaceColor',eval(layerplot_color_here_fill),'LineWidth',linewidth,'MarkerSize',mymarkersize)  
      end
        




axis([1 size(TraceElements4Normalization,2) 10^-1 10^3])
set(gca, 'Xtick',[1:size(TraceElements4Normalization,2)])
set(gca,'XTickLabel',targetStrings_Trace)
set(gca,'yscale','log')
hline(1)
box on
grid on
set(gcf,'Position',[114 219 973 420])
FigureTitle = sprintf('Trace Elements normalized to %s',normalizationLabel); 
title(FigureTitle)
set(gcf,'name',FigureTitle)
set(gca,'ticklength',1*[0.0200    0.0500])
set(gca,'fontsize', 15,'LineWidth',1)
set(gca,'XColor', 'k')
set(gca,'YColor', 'k')

end

%% Step 5
savefigs('','exampleSavedFigures')