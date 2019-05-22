function [plot_handle] = GenericTernaryPlotter5_zoom(Data, IndiciesHere, Verticies,symbolcolortype,pointlabels,importantpressure,triangleon,Fpointlabels,Findex)



vara = Data(:,IndiciesHere(1));
varb = Data(:,IndiciesHere(2));
varc = Data(:,IndiciesHere(3));

alabel = Verticies{IndiciesHere(1)};
blabel = Verticies{IndiciesHere(2)};
clabel = Verticies{IndiciesHere(3)};

Colors


%2) Normalizes data so A + B + C = 1 (just in case)
A = vara./(vara+varb+varc);
B = varb./(vara+varb+varc);
C = varc./(vara+varb+varc);

%4) Removes axes and background
%set(gca,'visible','off');

    
%5) Plots data on the ternary diagram

     y=A.*(sqrt(3)/2);
     x=0.5+(((C./(C+B))-0.5).*2.*(0.866-y).*tan(pi/6));
     eval(['plot_handle = plot(x,y,',symbolcolortype,');']) 
     %eval(['plot(x,y,',symbolcolortype,');']) 
     %plot_handle = gcf; 
     axis equal     
     hold on 
     
     
  %3)  Plots a triangle with apices at (0,0); (1,0); (0.5, .866)
   % figure()
   

  

%      if nargin > 8
%          scatter(x(plotover),y(plotover),5,symbolcolortype2,'filled')    
%      end
     
%      if  nargin > 7
%          here = find(pointlabels == importantpressure);
%           scatter(x(here),y(here),30,symbolcolortype2,'filled')  
%      end
         

%      if  nargin > 7
%      labels = pointlabels;
%      text(x,y,labels,'VerticalAlignment','bottom')
%      else
%      labels = cellstr(num2str([1:size(x,1)]'));
%      end
     
     

     
     if  nargin > 7
     labels = cellstr(num2str([(pointlabels)]'));
     %GarSpi = find(pointlabels==23);
     %SpiPlag = find(pointlabels==9);
     text(x(pointlabels),y(pointlabels),labels,'FontWeight','bold')
     %text(x(SpiPlag),y(SpiPlag),labels(SpiPlag),'FontWeight','bold')
     else
     labels = cellstr(num2str([1:size(x,1)]'));
     end
    
     %labels = cellstr(num2str([1:size(x,1)]') );         
     %text(x,y,labels)
     %text(x(1:30:end),y(1:30:end),labels(1:30:end))
     
    
     
     if  nargin > 11
          labels = Fpointlabels;  
          
%          if ischar(Fpointlabels)==1
%            labels = Fpointlabels;  
%         else 
%             labels = cellstr(num2str([(Fpointlabels)]',2));
%          end 

            if ischar(Fpointlabels(1))==0
                clear labels
                labels = cellstr(num2str([(Fpointlabels)]',2));
            end
                   
          text(x(Findex),y(Findex),labels,'FontWeight','normal','FontSize',8)
          %text(x(Findex)+.001,y(Findex),labels,'FontWeight','normal','FontSize',6)
    end
     
    
   if strfind(triangleon, 'yes') == 1
%     x_tri=[0,1,0.5,0];
%     y_tri=[0,0,sqrt(3)/2,0];
%plot(x_tri,y_tri,'k','LineWidth',2);
    
%This is a really messy way of finding the smallest ternary plot that will
%plot all the data.  It finds the lower right corner (C) and finds the  top
%apex by finding the intersection of the lines(A) and then calcualtes the
%length of each side.  

%collect all the plotted data
h = gcf;
axesObjs = get(h, 'Children'); 
dataObjs = get(axesObjs, 'Children');

if iscell(dataObjs)==1
    objTypes = get(dataObjs{2}, 'Type');
    [hummm] = find(strcmp(objTypes,'line')==1); 
    xdata = []; 
    ydata = []; 
    for i = 1:size(hummm,1)
    xdata = [xdata dataObjs{2}(hummm(i),:).XData];
    ydata = [ydata dataObjs{2}(hummm(i),:).YData];
    end

else 
    objTypes = get(dataObjs, 'Type');
    [hummm] = find(strcmp(objTypes,'line')==1); 
    xdata = []; 
    ydata = []; 
    for i = 1:size(hummm,1)
    xdata = [xdata dataObjs(hummm(i),:).XData];
    ydata = [ydata dataObjs(hummm(i),:).YData];
    end

end

AllData = [xdata' ydata']; 
% finds extrema of the data
[AllMin AllDataMinIndex]=( min(AllData));
[AllMax AllDataMaxIndex]=( max(AllData));
%finds the point that has the least amount of component C, this point
%projected towards the C corner constrains the triangle
AllDataTernary = XY2Ternary(AllData); 
[lowestC,lowestCindex] = min(AllDataTernary(:,3));

%find the C corner
toAdd = (AllData(:,2)-AllMin(2))./sqrt(3);
[cx,cx_index] = max(AllData(:,1)+toAdd); %Corner = [test1 AllMin(2)];
cy = AllMin(2);

%calculate the intersection of the line
kkk= lowestCindex; 
mx = AllData(kkk,1);
my = AllData(kkk,2) ;
cxa2 = (cy - my + sqrt(3).*mx + sqrt(3).*cx)/(2*sqrt(3));
cya2 =sqrt(3).*(cxa2 - mx)+my;
dx =cxa2;
dy = cya2;

%calcualte the length of the side
Length = sqrt((cx - dx).^2+(cy-dy).^2); 
x = Length/2; 

%calcualte all the corners
cxa = cx - x; 
cya = cy + x.*sqrt(3); 
cxb = cx-2.*x; 
cyb = cy; 
      

    x_tri=[cxb cxa cx cxb];
    y_tri=[cyb cya cy cyb];
    plot(x_tri,y_tri,'k','LineWidth',2);
     
    %Annotations for the vertices of the triangle
            BcornerTernary = XY2Ternary([cxb cyb]);
            str1= {[blabel,'(' num2str(BcornerTernary(2),2),')']};       %Left Corner
            %text(cxb+.01, cyb+.01, str1)
            text(cxb, cyb, str1,'VerticalAlignment','top');
            
            CcornerTernary = XY2Ternary([cx cy]);
            str2= {[clabel,'(' num2str(CcornerTernary(3),2),')']};       %Right Corner
            %text(cx-.01, cy+.01, str2)
            text(cx, cy, str2,'HorizontalAlignment','right','VerticalAlignment','top');
            
            AcornerTernary = XY2Ternary([cxa cya]);
            str3= {[alabel,'(' num2str(AcornerTernary(1),2),')']};       %Right Corner
            %text(cxa-.01, cya+.01, str3,'HorizontalAlignment','center')
            text(cxa, cya, str3,'HorizontalAlignment','center','VerticalAlignment','bottom');

    
    %%
    
% % %     Xmin = axes4zoom(1); 
% % %     Xmax = axes4zoom(2); 
% % %     Ymin  = axes4zoom(3); 
% % %     Ymax = axes4zoom(4); 
% % %     
% % %     Aprime = XY2Ternary([(Xmax - Xmin)./2, Ymax]); 
% % %     Aprime2 = XY2Ternary([Xmin+((Xmax - Xmin)./2), Ymax]); 
% % %     Bprime = XY2Ternary([Xmin,Ymin]); 
% % %     Cprime = XY2Ternary([Xmax, Ymin]); 
% % %     
% % %     axes4zoom
% % %     Aprime
% % %     Bprime
% % %     Cprime
% % %     
% % %     Aprime_XY = Ternary2XY(Aprime); 
% % %     Aprime2_XY = Ternary2XY(Aprime2); 
% % %     Bprime_XY = Ternary2XY(Bprime); 
% % %     Cprime_XY = Ternary2XY(Cprime); 
% % %     
% % %     plot(Aprime_XY(1), Aprime_XY(2),'k*','MarkerSize',20)
% % %     plot(Aprime2_XY(1), Aprime2_XY(2),'r*','MarkerSize',20)
% % %     plot(Bprime_XY(1), Bprime_XY(2),'k*','MarkerSize',20)
% % %     plot(Cprime_XY(1), Cprime_XY(2),'k*','MarkerSize',20)
    
    return
    
    LeftPoint_ternary = XY2Ternary([axes4zoom(1)   axes4zoom(3)] ) ;
    RightPoint_ternary = XY2Ternary([axes4zoom(2)   axes4zoom(3)] ) ;
    

    minA = fix(LeftPoint_ternary(1)*10)/10; 
    maxB = fix(RightPoint_ternary(2)*10)/10;
    numberLines = abs(minA-maxB)*10; 
    
    minA =minA.*100; 
    maxB = maxB.*100; 
    
%     PercentA1_Ternary = [minA 1-(minA+maxB)];
%     PercentA2_Ternary = [minA maxB 1-(minA+maxB)] ;   

%     PercentA1_Ternary = [[100:-10:0]' [0:10:100]' zeros(11,1)];
%     PercentA2_Ternary = [[100:-10:0]' zeros(11,1) [0:10:100]'] ;  

    PercentA1_Ternary = [[minA:-10:0]' [0:10:minA]' zeros(numberLines+2,1)];
    PercentA2_Ternary = [[100:-10:0]' zeros(11,1) [0:10:100]'] ;   
    
    PercentA1_XY = Ternary2XY(PercentA1_Ternary);
    PercentA2_XY = Ternary2XY(PercentA2_Ternary); 
    
 %   indicies2keep = find(PercentA1_XY(:,2)>axes4zoom(3) & PercentA1_XY(:,2)<axes4zoom(4));
%     if indicies2keep(1) ~=0
%         indicies2keep = [indicies2keep(1)-1; indicies2keep];
%     end
%     
%     if indicies2keep(end) ~=11
%         indicies2keep = [indicies2keep; indicies2keep(end)+1];
%     end

    PercentA1_XY = PercentA1_XY(indicies2keep,:);
    PercentA2_XY = PercentA2_XY(indicies2keep,:); 
    
    PercentB1_Ternary = [[0:10:100]' [100:-10:0]'  zeros(11,1)];
    PercentB2_Ternary = [zeros(11,1) [100:-10:0]'  [0:10:100]']; 
    
    

     
    
    
    PercentB1_XY = flipud(Ternary2XY(PercentB1_Ternary));
    PercentB2_XY = flipud(Ternary2XY(PercentB2_Ternary));
    
    
    PercentB1_XY =  PercentB1_XY(indicies2keep,:);
    PercentB2_XY =  PercentB2_XY(indicies2keep,:);
    
    PercentC1_Ternary = [[0:10:100]' zeros(11,1) [100:-10:0]'];
    PercentC2_Ternary = [zeros(11,1) [0:10:100]' [100:-10:0]'];    
    PercentC1_XY = flipud(Ternary2XY(PercentC1_Ternary)); 
    PercentC2_XY = flipud(Ternary2XY(PercentC2_Ternary));
    PercentC1_XY =  PercentC1_XY(indicies2keep,:);
    PercentC2_XY =  PercentC2_XY(indicies2keep,:);   
    
    for j = 1:size(PercentA1_XY,1)       
        a=plot([PercentA1_XY(j,1) PercentA2_XY(j,1)] , [PercentA1_XY(j,2) PercentA2_XY(j,2)] , '-','Color','r');
        b=plot([PercentB1_XY(j,1) PercentB2_XY(j,1)] , [PercentB1_XY(j,2) PercentB2_XY(j,2)] , '-','Color','b');
        c = plot([PercentC1_XY(j,1) PercentC2_XY(j,1)] , [PercentC1_XY(j,2) PercentC2_XY(j,2)] , '-','Color',grey2);
        uistack(a,'bottom');
         uistack(b,'bottom');
%         uistack(c,'bottom');
        labelsDOWN = cellstr(num2str([90:-10:10]'))';
        labelsUP= cellstr(num2str([10:10:90]'))';
%         text(PercentA1_XY(j,1)-.01, PercentA1_XY(j,2), labelsDOWN(j),'HorizontalAlignment','right','rotation',0);
%         %PercentB2_XY(j,2)
%         text(PercentB2_XY(j,1) - .015, -.02, labelsUP(j),'HorizontalAlignment','center','VerticalAlignment','top','Color','r','rotation',60)
%         text(PercentC1_XY(j,1) + .015, PercentC1_XY(j,2), labelsDOWN(j),'HorizontalAlignment','left','VerticalAlignment','middle','Color','b','rotation',60)
%         
        text(PercentA1_XY(j,1)-.01, PercentA1_XY(j,2), labelsDOWN(j),'HorizontalAlignment','right','rotation',0);
        text(0.2, 0.5, sprintf('%% %s',alabel),'HorizontalAlignment','right','rotation',60);
        
  
        %PercentB2_XY(j,2)
        text(PercentB2_XY(j,1) + .015, -.02, labelsDOWN(j),'HorizontalAlignment','center','VerticalAlignment','top','Color','r','rotation',-60)
        text(0.5, -0.06, sprintf('%% %s',blabel), 'HorizontalAlignment','center','rotation',0);
        
        text(PercentC1_XY(j,1) + .01, PercentC1_XY(j,2)+.005, labelsDOWN(j),'HorizontalAlignment','left','VerticalAlignment','middle','Color','b','rotation',60)
        text(0.85, 0.4, sprintf('%% %s',clabel),'HorizontalAlignment','right','rotation',-60);
    end
    end

    %%
    
    if strfind(triangleon, 'yesContour') == 1
    PercentA1_Ternary = [[90:-10:10]' [10:10:90]' zeros(9,1)];
    PercentA2_Ternary = [[90:-10:10]' zeros(9,1) [10:10:90]'];    
    PercentA1_XY = Ternary2XY(PercentA1_Ternary); 
    PercentA2_XY = Ternary2XY(PercentA2_Ternary);
    
    PercentB1_Ternary = [[10:10:90]' [90:-10:10]'  zeros(9,1)];
    PercentB2_Ternary = [zeros(9,1) [90:-10:10]'  [10:10:90]'];    
    PercentB1_XY = Ternary2XY(PercentB1_Ternary); 
    PercentB2_XY = Ternary2XY(PercentB2_Ternary);
    
    PercentC1_Ternary = [[10:10:90]' zeros(9,1) [90:-10:10]'];
    PercentC2_Ternary = [zeros(9,1) [10:10:90]' [90:-10:10]'];    
    PercentC1_XY = Ternary2XY(PercentC1_Ternary); 
    PercentC2_XY = Ternary2XY(PercentC2_Ternary);
    
    
    for j = 1:size(PercentA1_XY,1)       
        a=plot([PercentA1_XY(j,1) PercentA2_XY(j,1)] , [PercentA1_XY(j,2) PercentA2_XY(j,2)] , '-','Color',grey2);
        b=plot([PercentB1_XY(j,1) PercentB2_XY(j,1)] , [PercentB1_XY(j,2) PercentB2_XY(j,2)] , '-','Color',grey2);
        c = plot([PercentC1_XY(j,1) PercentC2_XY(j,1)] , [PercentC1_XY(j,2) PercentC2_XY(j,2)] , '-','Color',grey2);
        uistack(a,'bottom');
        uistack(b,'bottom');
        uistack(c,'bottom');
        labelsDOWN = cellstr(num2str([90:-10:10]'))';
        labelsUP= cellstr(num2str([10:10:90]'))';
%         text(PercentA1_XY(j,1)-.01, PercentA1_XY(j,2), labelsDOWN(j),'HorizontalAlignment','right','rotation',0);
%         %PercentB2_XY(j,2)
%         text(PercentB2_XY(j,1) - .015, -.02, labelsUP(j),'HorizontalAlignment','center','VerticalAlignment','top','Color','r','rotation',60)
%         text(PercentC1_XY(j,1) + .015, PercentC1_XY(j,2), labelsDOWN(j),'HorizontalAlignment','left','VerticalAlignment','middle','Color','b','rotation',60)
%         
        text(PercentA1_XY(j,1)-.01, PercentA1_XY(j,2), labelsDOWN(j),'HorizontalAlignment','right','rotation',0);
        text(0.2, 0.5, sprintf('%% %s',alabel),'HorizontalAlignment','right','rotation',60);
        
  
        %PercentB2_XY(j,2)
        text(PercentB2_XY(j,1) + .015, -.02, labelsDOWN(j),'HorizontalAlignment','center','VerticalAlignment','top','Color','r','rotation',-60)
        text(0.5, -0.06, sprintf('%% %s',blabel), 'HorizontalAlignment','center','rotation',0);
        
        text(PercentC1_XY(j,1) + .01, PercentC1_XY(j,2)+.005, labelsDOWN(j),'HorizontalAlignment','left','VerticalAlignment','middle','Color','b','rotation',60)
        text(0.85, 0.4, sprintf('%% %s',clabel),'HorizontalAlignment','right','rotation',-60);
    end
    end


     
end