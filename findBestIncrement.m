

function[increment] = findBestIncrement(range,majorincrement)

if range <0.5
    increment = .01; 
else if range < 2
    increment = .05; 
else if range < 10
        increment = 0.5;
else if range < 100
        increment = 1;
else
        increment = 50;        
    end
    end
    end
end
    

    if round(majorincrement,3) == 0.4
        increment = 0.1; 
    else if round(majorincrement,3) == 0.1 
            increment = .02;   
    else if round(majorincrement,3) == 1 
            increment = .5; 
            
    else if round(majorincrement,3) == 10 
     increment = 2; 
        else if round(majorincrement,3) == 5
     increment = 1;  
            end
        end
        end
       end
    end


    if round(majorincrement,3) == round(increment,3)

        increment = increment./2; 
    end

            
end

