function [Ternary ] = XY2Ternary(XY)

x = XY(:,1);
y= XY(:,2);

% x= 0.2598; 
% y = 0.3872; 
% 
% x= .1445;  
% y = 0.3872; 


    A = y./(sqrt(3)/2); 
    CBratio  = ((-x+0.5)./((-sqrt(3)+2.*y).*tan((1/6).*pi)))+0.5;
    
     %x=0.5+(((C./(C+B))-0.5).*2.*((sqrt(3)/2)-y).*tan(pi/6));
    
%     CBratio
%     1-A
    C = CBratio.*(1-A); 
    B = C.*(1./CBratio - 1); 
    
    Ternary = [A B C]; 

end


%code to generate horizontal lines on a ternary plot
% PercentA_1 = [[90:-10:10]' [10:10:90]' zeros(9,1)];
% PercentA_2 = [[90:-10:10]' zeros(9,1) [10:10:90]'];

% GALE(162,:)
% Ternaries2plot = [4 3 1]; 
% testa = GALE(162,Ternaries2plot)./sum(GALE(162,Ternaries2plot))
% test = Ternary2XY(testa)