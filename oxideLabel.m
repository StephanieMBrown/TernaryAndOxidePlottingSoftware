function [Xname,Yname,FigureTitle] = oxideLabel(xOxide,yOxide)


    if xOxide==1
         Xname=sprintf('Temperature (%cC)', char(176)); %'Temperature C';
    elseif xOxide==2
        Xname='Pressure GPa';       
    elseif xOxide==3        
       Xname='SiO_2 wt%';
    elseif xOxide==4
        Xname='TiO_2 wt%';
    elseif xOxide==5
        Xname='Al_2O_3 wt%';
    elseif xOxide==6
        Xname='Cr_2O_3 wt%' ;   
    elseif xOxide==7
        Xname='FeO wt%';
    elseif xOxide==8
        Xname='MnO wt%';
    elseif xOxide==9
        Xname= 'MgO wt%';
    elseif xOxide==10
        Xname='CaO wt%';   
    elseif xOxide==11
        Xname='Na_2O wt%';
    elseif xOxide==12
        Xname='K_2O wt%';
    elseif xOxide==13
        Xname='P_2O_5 wt%';      
     elseif xOxide==14
        Xname='NiO wt%';     
      elseif xOxide==15
        Xname='H_2O';                 
    elseif xOxide==16
        Xname='Sum';
    elseif xOxide==17
        Xname='Mg #';   
    elseif xOxide==18
        Xname='NaK #';       
     elseif xOxide==19
        Xname='CaO / Al_2O_3';        
      elseif xOxide==20
        Xname='Ca / Al moles';          
    end
    
    
    if yOxide==1
         Yname=sprintf('Temperature (%cC)', char(176));
    elseif yOxide==2
        Yname='Pressure GPa';       
    elseif yOxide==3        
       Yname='SiO_2 wt%';
    elseif yOxide==4
        Yname='TiO_2 wt%';
    elseif yOxide==5
        Yname='Al_2O_3 wt%';
    elseif yOxide==6
        Yname='Cr_2O_3 wt%' ;   
    elseif yOxide==7
        Yname='FeO wt%';
    elseif yOxide==8
        Yname='MnO wt%';
    elseif yOxide==9
        Yname= 'MgO wt%';
    elseif yOxide==10
        Yname='CaO wt%';   
    elseif yOxide==11
        Yname='Na_2O wt%';
    elseif yOxide==12
        Yname='K_2O wt%';
    elseif yOxide==13
        Yname='P_2O_5 wt%';      
     elseif yOxide==14
        Yname='NiO wt%';     
      elseif yOxide==15
        Yname='H_2O';                 
    elseif yOxide==16
        Yname='Sum';
    elseif yOxide==17
        Yname='Mg #';   
    elseif yOxide==18
        Yname='NaK #';    
    elseif yOxide==19
        Yname='CaO / Al_2O_3';   
      elseif yOxide==20
        Yname='Ca / Al moles';           
    end

    
    
    FigureTitle = sprintf('%s versus %s' ,Xname,Yname);
        

        


end

%  1     2         3      4      5   6   7   8    9  10   11     12   13
% SiO2	TiO2	Al2O3	Cr2O3	FeO	MnO	MgO	CaO	Na2O K2O P2O5  total Mg#