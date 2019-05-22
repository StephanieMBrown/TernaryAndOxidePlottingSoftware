function [] = GenericTernaryPlotter4(vara,varb,varc,alabel,blabel,clabel,symbolcolortype,pointlabels,importantpressure,triangleon,Fpointlabels,Findex,symbolcolortype_labels)
   Colors
%    top = a
%    left = b
%    right = c
%Ternary Diagrams!
%Alexandra Andrews & Ben Mandler, March 2012

% Plots any data in a ternary diagram.

%%%%%%%%%%%%%%%% NOTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This currently also plots the Kinzler & Grove OPALM point for 692Ja.


%2) Normalizes data so A + B + C = 1 (just in case)
A = vara./(vara+varb+varc);
B = varb./(vara+varb+varc);
C = varc./(vara+varb+varc);

%4) Removes axes and background

set(gca,'visible','off');
    
%5) Plots data on the ternary diagram

     y=A.*(sqrt(3)/2);
     x=0.5+(((C./(C+B))-0.5).*2.*(0.866-y).*tan(pi/6));
%      scatter(x,y,5,symbolcolortype,'filled')
%      hold on
     

     eval(['plot(x,y,',symbolcolortype,')'])
     axis equal     
     hold on 
     
     
  %3)  Plots a triangle with apices at (0,0); (1,0); (0.5, .866)
   % figure()
   
   if strcmp(triangleon, 'yes') == 1
    x_tri=[0,1,0.5,0];
    y_tri=[0,0,sqrt(3)/2,0];
    plot(x_tri,y_tri,'k','LineWidth',2);
    %Annotations for the vertices of the triangle
            str1= {blabel};       %Left Corner
            text(0-0.025, 0-0.02, str1)
            str2={clabel};        %Right Corner
            text(1+0.01,0-0.02,str2)
            str3={alabel};       %Top Corner
            text(0.5-0.005,sqrt(3)/2+0.025, str3)
    %title('Ternary Diagram')

   end

  

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
     
    if  nargin > 12
           labels = Fpointlabels;  
           %text(x(Findex),y(Findex),labels,'FontWeight','bold','FontSize',8)
           %eval(['plot(x,y,',symbolcolortype,')'])
           eval(['text(x(Findex),y(Findex),labels,',symbolcolortype_labels,')'])

           
    else if nargin > 10
          labels = Fpointlabels;  
          
%          if ischar(Fpointlabels)==1
%            labels = Fpointlabels;  
%         else 
%             labels = cellstr(num2str([(Fpointlabels)]',2));
%          end 

   
          %text(x(Findex)+.01,y(Findex),labels,'FontWeight','normal','FontSize',7)
           text(x(Findex),y(Findex),labels,'FontWeight','bold','FontSize',8)
         
    end
     


     
end