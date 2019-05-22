function [ XY ] = Ternary2XY( Ternary )
    %normalize 
    Ternary = bsxfun(@rdivide, Ternary,nansum(Ternary,2)); 
    %counterclockwise 
    A = Ternary(:,1); %Top corner
    B = Ternary(:,2); %Left corner 
    C = Ternary(:,3); %Right Corner corner 
    
     y=A.*(sqrt(3)/2);
     x=0.5+(((C./(C+B))-0.5).*2.*((sqrt(3)/2)-y).*tan(pi/6));
     x(isnan(x)) =0.5; 

     XY = [x y]; 

end


%code to generate horizontal lines on a ternary plot
% PercentA_1 = [[90:-10:10]' [10:10:90]' zeros(9,1)];
% PercentA_2 = [[90:-10:10]' zeros(9,1) [10:10:90]'];