function th = ta_from_E(E, e)
    %% Calculates the true anomaly [deg] from the eccentric anomaly [deg]
    
    while E > 360
        E = E - 360;
    end
    
    while E < 0
        E = E + 360;
    end
    
    E = E * (pi/180);
   
    theta = 2*atan( sqrt( (1+e)/(1-e) )*tan(E/2) );
    
    theta = theta * (180/pi);
    
    while theta > 360
        theta = theta - 360;
    end
    
    while theta < 0
        theta = theta + 360;
    end
    
    th = theta;
end