function [plot_handle] = GenericTernaryPlotter5(Data, IndiciesHere, Verticies,symbolcolortype,pointlabels,importantpressure,triangleon,Fpointlabels,Findex)

vara = Data(:,IndiciesHere(1));
varb = Data(:,IndiciesHere(2));
varc = Data(:,IndiciesHere(3));

alabel = Verticies{IndiciesHere(1)};
blabel = Verticies{IndiciesHere(2)};
clabel = Verticies{IndiciesHere(3)};

ColorsHERE

%2) Normalizes data so A + B + C = 1 (just in case)
A = vara./(vara+varb+varc);
B = varb./(vara+varb+varc);
C = varc./(vara+varb+varc);

%4) Removes axes and background
set(gca,'visible','off');

    
%5) Plots data on the ternary diagram

     y=A.*(sqrt(3)/2);
     x=0.5+(((C./(C+B))-0.5).*2.*(0.866-y).*tan(pi/6));

     eval(['plot_handle = plot(x,y,',symbolcolortype,');']) 
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
     
                %one day figure this out:
                % https://stackoverflow.com/questions/22804326/marker-size-unit-proportionnal-to-the-axis-values
                test = regexp(symbolcolortype,'''MarkerSize'',\d+','match'); 
                test = (regexp(test,'\d+')); %extracting the markersize could be cleaned up
                space2add = test{1}./2; 
     
 % if  isempty(pointlabels) == 0 %nargin > 7
 if isnumeric(pointlabels) == 1
     labels = cellstr(num2str([(pointlabels)]'));
     labels = regexprep(labels,'NaN','');
     text(x(pointlabels),y(pointlabels),labels,'FontWeight','bold')
 else
         labels = pointlabels;  
%      labels = cellstr(num2str([1:size(x,1)]'));
%      labels = regexprep(labels,'NaN',''); 
     %text(x,y-space2add,labels,'FontWeight','normal','VerticalAlignment','top','HorizontalAlignment','center');
      text(x,y,labels,'FontWeight','normal','VerticalAlignment','top','HorizontalAlignment','right');
 end

    
     %labels = cellstr(num2str([1:size(x,1)]') );         
     %text(x,y,labels)
     %text(x(1:30:end),y(1:30:end),labels(1:30:end))
     
    if  nargin > 7
          labels = Fpointlabels;  
          
%          if ischar(Fpointlabels)==1
%            labels = Fpointlabels;  
%         else 
%             labels = cellstr(num2str([(Fpointlabels)]',2));
%          end 

            if ischar(Fpointlabels(1))==0
                clear labels
                labels = cellstr(num2str([(Fpointlabels)]',2));
                labels = regexprep(labels,'NaN',''); 
            end
                   
          text(x(Findex),y(Findex),labels,'FontWeight','normal','FontSize',8)
          %text(x(Findex)+.001,y(Findex),labels,'FontWeight','normal','FontSize',6)
    end
     
    
    
   if strfind(triangleon, 'yes') == 1
    x_tri=[0,1,0.5,0];
    y_tri=[0,0,sqrt(3)/2,0];
    plot(x_tri,y_tri,'k','LineWidth',1.5);
    %Annotations for the vertices of the triangle
    
            %Top Corner
            text(0.5,sqrt(3)/2, {alabel},'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',12);
               
            %Left Corner
            text(0, 0, {blabel},'VerticalAlignment','top','HorizontalAlignment','right','FontSize',12);
            
            %Right Corner
            text(1,0,{clabel},'HorizontalAlignment','left','VerticalAlignment','top','FontSize',12);


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
        %text(0.2, 0.5, sprintf('%% %s',alabel),'HorizontalAlignment','right','rotation',60);
        
  
        %PercentB2_XY(j,2)
        text(PercentB2_XY(j,1) + .015, -.02, labelsDOWN(j),'HorizontalAlignment','center','VerticalAlignment','top','Color','r','rotation',-60)
        %text(0.5, -0.06, sprintf('%% %s',blabel), 'HorizontalAlignment','center','rotation',0);
        
        text(PercentC1_XY(j,1) + .01, PercentC1_XY(j,2)+.005, labelsDOWN(j),'HorizontalAlignment','left','VerticalAlignment','middle','Color','b','rotation',60)
        %text(0.85, 0.4, sprintf('%% %s',clabel),'HorizontalAlignment','right','rotation',-60);
    end
    

        text(0.2, 0.5, sprintf('%% %s',alabel),'HorizontalAlignment','right','rotation',60);
        text(0.5, -0.06, sprintf('%% %s',blabel), 'HorizontalAlignment','center','rotation',0);
        text(0.85, 0.4, sprintf('%% %s',clabel),'HorizontalAlignment','right','rotation',-60);
        
    end
   end

     
end